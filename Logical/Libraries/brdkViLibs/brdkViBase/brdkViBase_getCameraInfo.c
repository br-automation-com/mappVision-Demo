
#include <bur/plctypes.h>
#ifdef __cplusplus
	extern "C"
	{
#endif
#include "brdkViBase.h"
#include <math.h>
#ifdef __cplusplus
	};
#endif

#define TRUE 1
#define FALSE 0
/* TODO: Add your comment here */
void brdkViBase_getCameraInfo(struct brdkViBase_getCameraInfo* inst)
{
	brdkViBase_getCameraInfo_int_typ* this = &inst->internal;
	char* pChar;

	switch(this->state){ 
		// -----------------------------------------------------------------------------------------------------------
		// Wait
		case 0: 
			if( inst->execute) {
				inst->execute = FALSE;
				inst->pInfo->orderNr[0] = 0;
				this->index = 0;
				inst->status = ERR_FUB_BUSY;
				this->state	= 1;
			}
			break;
		// -----------------------------------------------------------------------------------------------------------
		// Create DiagInformation
		case 1: 
			this->diagCreateInfo_0.enable			= TRUE;
			if(DiagCpuIsSimulated()){
			this->diagCreateInfo_0.infoKind		= asdiagCONFIGURED;
			}else{
			this->diagCreateInfo_0.infoKind		= asdiagPLUGGED;
			}
		
			DiagCreateInfo(&this->diagCreateInfo_0);
			if( this->diagCreateInfo_0.status == 0 ) {
				this->state = 2;
			}else if( this->diagCreateInfo_0.status != ERR_FUB_BUSY ) {
				inst->status =this->diagCreateInfo_0.status;
				this->state = 90;
			}
			break;
		
		// -----------------------------------------------------------------------------------------------------------
		// Read HW-ID and compare with selected camera
		case 2: 
			this->diagGetStrInfo_0.enable		= TRUE;
			this->diagGetStrInfo_0.ident		= this->diagCreateInfo_0.ident;
			this->diagGetStrInfo_0.index		= this->index;
			this->diagGetStrInfo_0.infoCode		= asdiagPATH;
			this->diagGetStrInfo_0.pBuffer		= (UDINT)&this->path;
			this->diagGetStrInfo_0.bufferLen	= sizeof(this->path) - 1;
			DiagGetStrInfo(&this->diagGetStrInfo_0);
			
			if( this->diagGetStrInfo_0.status == 0 ) {
				if(brsstrcmp(this->diagGetStrInfo_0.pBuffer,inst->pDevicePath) == 0) {
					this->state = 5;
				}else{
					this->index = this->index + 1;
					if( this->index >= this->diagCreateInfo_0.nrEntries ) {
						inst->status = asdiagERR_INDEX;
						this->state = 91;
					}
				}
			}else if( this->diagGetStrInfo_0.status != ERR_FUB_BUSY ) {
				inst->status =this->diagGetStrInfo_0.status;
				this->state = 93;
			}
			break;
					
		// -----------------------------------------------------------------------------------------------------------
		// Read ordernumber
		case 5: 
			this->diagGetStrInfo_0.enable		= TRUE;
			this->diagGetStrInfo_0.ident		= this->diagCreateInfo_0.ident;
			this->diagGetStrInfo_0.index		= this->index;
			if(DiagCpuIsSimulated()){
				this->diagGetStrInfo_0.infoCode		= asdiagCONFIG_MODULE;
			}else{
				this->diagGetStrInfo_0.infoCode		= asdiagPLUGGED_MODULE;
			}
			this->diagGetStrInfo_0.pBuffer		= (UDINT)&inst->pInfo->orderNr;
			this->diagGetStrInfo_0.bufferLen	= sizeof(inst->pInfo->orderNr) - 1;
			DiagGetStrInfo(&this->diagGetStrInfo_0);
			
			if( this->diagGetStrInfo_0.status == 0 ) {
				this->state = 10;
			}else if( this->diagGetStrInfo_0.status != ERR_FUB_BUSY ) {
				inst->status =this->diagGetStrInfo_0.status;
				this->state = 93;
			}
			break;
						
		// -----------------------------------------------------------------------------------------------------------
		// Release info function block
		case 10:
			this->diagDisposeInfo_0.enable		= TRUE;
			this->diagDisposeInfo_0.ident			= this->diagCreateInfo_0.ident;
			DiagDisposeInfo(&this->diagDisposeInfo_0);
			if( this->diagDisposeInfo_0.status == 0 ) {
				this->state = 20;
			}else if( this->diagDisposeInfo_0.status != ERR_FUB_BUSY ) {
				inst->status =this->diagDisposeInfo_0.status;
				this->state = 94;
			}
			break;
		// -----------------------------------------------------------------------------------------------------------
		// Get the info to the actual camara
		case 20: 
			if( brsstrlen(&inst->pInfo->orderNr) == 18 ) {
				
				// Letter for CPU cors
				switch(inst->pInfo->orderNr[4]){
					case 0x31:  inst->pInfo->cpu = BRDKVIBASE_CPU_1_DUAL; break; // ASCII '1'
					case 0x32:  inst->pInfo->cpu = BRDKVIBASE_CPU_2_QUAD; break;// ASCII '2'
					default:
						this->state = 95;
				}
			
				// Letter for LED Color
				switch(inst->pInfo->orderNr[6]){ 
					case 0x30:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_0_NONE; break; // ASCII '0'
					case 0x33:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_3_BLUE; break;// ASCII '3'
					case 0x38:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_8_RED; break;// ASCII '8'
					case 0x41:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_A_UV; break;// ASCII 'A'
					case 0x44:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_D_IR; break;// ASCII 'D'
					case 0x46:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_F_W; break;// ASCII 'F'
					case 0x51:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_Q_RGBL; break;// ASCII 'Q'
					case 0x52:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_R_RBIRW; break;// ASCII 'R'
					default:
						this->state = 95;
				}
			
			
				// Letter for LED lens
				switch(inst->pInfo->orderNr[7]){ 
					case 0x30:  inst->pInfo->LED_lens = BRDKVIBASE_LED_LENS_0_NONE; break; // ASCII '0'
					case 0x31:  inst->pInfo->LED_lens = BRDKVIBASE_LED_LENS_1_WIDE; break; // ASCII '1'
					case 0x32:  inst->pInfo->LED_lens = BRDKVIBASE_LED_LENS_2_STANDARD; break; // ASCII '2'
					case 0x33:  inst->pInfo->LED_lens = BRDKVIBASE_LED_LENS_3_WIDE; break;// ASCII '3'
					default:
						this->state = 95;
				}
			
			
				// Letter for Sensor
				switch(inst->pInfo->orderNr[8]){
					case 0x31:  inst->pInfo->sensor = BRDKVIBASE_SENSOR_1_3_MP; break; // ASCII '1'
					case 0x32:  inst->pInfo->sensor = BRDKVIBASE_SENSOR_1_3_MP_LINE; break; // ASCII '2'
					case 0x34:  inst->pInfo->sensor = BRDKVIBASE_SENSOR_3_5_MP; break;// ASCII '4'
					case 0x35:  inst->pInfo->sensor = BRDKVIBASE_SENSOR_1_3_MP_LINE; break;// ASCII '5'
					default:
						this->state = 95;
				}
				// first letter for optics (0 or M)
				switch(inst->pInfo->orderNr[10]){
					case 0x30:  inst->pInfo->lens = BRDKVIBASE_LENS_C_MOUNT; break;// ASCII '0'
					case 0x4D:  inst->pInfo->lens = BRDKVIBASE_LENS_12_0_MACRO;  break;// ASCII 'M'
					default:
						this->state = 96;
				}
				// second letter for optics
				switch(inst->pInfo->orderNr[11]){
					case 0x30:  inst->pInfo->lens = BRDKVIBASE_LENS_C_MOUNT;  break;// ASCII '0' // no optics
					case 0x32:  inst->pInfo->lens = BRDKVIBASE_LENS_4_6;  break;// ASCII '2'
					case 0x33:  inst->pInfo->lens = BRDKVIBASE_LENS_6_0;  break;// ASCII '3'
					case 0x34:  inst->pInfo->lens = BRDKVIBASE_LENS_8_0;  break;// ASCII '4'
					case 0x35: // ASCII '5'
						if( inst->pInfo->lens == BRDKVIBASE_LENS_12_0_MACRO ) {
							// do noting, already selected
						}else{
							inst->pInfo->lens = BRDKVIBASE_LENS_12_0;
						}
						break;
					case 0x36:  inst->pInfo->lens = BRDKVIBASE_LENS_16_0;  break;// ASCII '6'
					case 0x37:  inst->pInfo->lens = BRDKVIBASE_LENS_25_0;  break;// ASCII '7'
					default:
						this->state = 97;
				}
			
						
				inst->status = ERR_OK;
				this->state = 0;
			}else{
				this->state = 98;
			}
			break;
		default: // auto reset errors
			//inst->status = FALSE;
			if(inst->errorReset){
				inst->errorReset = 0;
				inst->status = ERR_OK;
				this->state = 0;
			}
	}	
}
