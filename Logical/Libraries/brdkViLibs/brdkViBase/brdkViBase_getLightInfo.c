
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
void brdkViBase_getLightInfo(struct brdkViBase_getLightInfo* inst)
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
			if(inst->pluggedModule){
			this->diagCreateInfo_0.infoKind		= asdiagPLUGGED;
			}else{
			this->diagCreateInfo_0.infoKind		= asdiagCONFIGURED;
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
			if(inst->pluggedModule){
				this->diagGetStrInfo_0.infoCode		= asdiagPLUGGED_MODULE;
			}else{
				this->diagGetStrInfo_0.infoCode		= asdiagCONFIG_MODULE;
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
				
				// Letter for light type back or light bar
				switch(inst->pInfo->orderNr[3]){
					case 0x42:  // ASCII 'B'
						switch(inst->pInfo->orderNr[4]){
							case 0x31:   // ASCII '1'
								switch(inst->pInfo->orderNr[5]){
									case 0x31:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_BACK_1X1; break; // ASCII '1'
				
									case 0x32:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_BACK_1X2; break;// ASCII '2'
								
									case 0x33:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_BACK_1X3; break; // ASCII '3'
				
									case 0x34:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_BACK_1X4; break;// ASCII '4'
				
								}
								break;
							case 0x32:  // ASCII '2'
								switch(inst->pInfo->orderNr[5]){
									case 0x32:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_BACK_2X2; break; // ASCII '2'
				
									case 0x33:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_BACK_2X3; break;// ASCII '2'
				
								}
								break;
						}
						break;
					
					case 0x4C:  // ASCII 'L'
						switch(inst->pInfo->orderNr[4]){
							case 0x31:   // ASCII '1'
								switch(inst->pInfo->orderNr[5]){
									case 0x31:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_BAR_1X1; break; // ASCII '1'
									case 0x32:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_BAR_1X2; break;// ASCII '2'
									case 0x33:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_BAR_1X3; break; // ASCII '3'
									case 0x34:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_BAR_1X4; break;// ASCII '4'
								}
								break;
							case 0x52:  // ASCII 'R'
								switch(inst->pInfo->orderNr[5]){
									case 0x34:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_RING_4; break; // ASCII '4'
									case 0x36:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_RING_6; break;// ASCII '6'
									case 0x38:  inst->pInfo->size = BRDKVIBASE_LIGHT_SIZE_RING_8; break; // ASCII '8'
							
								}
								break;
						}
						break;
				}
			
			
			
			
				// Letter for LED Color
				switch(inst->pInfo->orderNr[6]){ 
					case 0x33:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_3_BLUE; break;// ASCII '3'
					case 0x38:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_8_RED; break;// ASCII '8'
					case 0x44:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_D_IR; break;// ASCII 'D'
					case 0x46:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_F_W; break;// ASCII 'F'
					case 0x48:  inst->pInfo->LED_color = BRDKVIBASE_LED_COLOR_H_IRW; break;// ASCII 'H'
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
			
			
				// second letter for optics
				switch(inst->pInfo->orderNr[12]){
					case 0x41:  inst->pInfo->front = BRDKVIBASE_FRONT_A_PLASTIC;  break;// ASCII 'A' 
					case 0x43:  inst->pInfo->front = BRDKVIBASE_FRONT_C_PLASTIC_POL; 	break;// ASCII 'C'
					case 0x44:  inst->pInfo->front = BRDKVIBASE_FRONT_D_PLASTIC_DIFF; 	break;// ASCII 'D'
					case 0x45:  inst->pInfo->front = BRDKVIBASE_FRONT_E_PLASTIC_TELE; 	break;// ASCII 'E'
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
