#include <bur/plctypes.h>
#include <string.h>
#ifdef __cplusplus
	extern "C"
	{
#endif

	#include "brdkUSB.h"

#ifdef __cplusplus
	};
#endif

#define true 1
#define false 0

/* Converts an UDINT into a STRING type */
static unsigned char brdkUSBuditoa(unsigned long Value, char* pString) {
	int i, j=0;
	pString[0] = 0;
	if (Value > 0) {
		while (Value > 0) {
			j++;
			for(i=j; i > 0 ; i--) {
				pString[i] =pString[i-1];
			}
			pString[0] = (Value % 10) + 48;			/* ASCII 48-57 = 0..9 */
			Value = (Value / 10);
		}
	}
	else {
		pString[0] = 48;								/* adds just a zero char  */
		pString[1] = 0;								/* ends the string  */
		j = 1;
	}
	return j;
}

void brdkUSBConnect(struct brdkUSBConnect* inst) {
	brdk_usb_connect_internal_typ* this = &inst->internal;
	int i;
	char tmp[2];

	/* get list of all connected usb nodes */
	this->UsbNodeListGet_0.enable 					= true;
	this->UsbNodeListGet_0.pBuffer					= (UDINT)&this->nodeIdBuffer;
	this->UsbNodeListGet_0.bufferSize 				= sizeof(this->nodeIdBuffer);
	this->UsbNodeListGet_0.filterInterfaceClass 	= asusb_CLASS_MASS_STORAGE;
	this->UsbNodeListGet_0.filterInterfaceSubClass 	= 0;
	UsbNodeListGet(&this->UsbNodeListGet_0);
	if(this->UsbNodeListGet_0.status == ERR_OK) {
		if(this->oldCnt != this->UsbNodeListGet_0.listNodes && this->UsbNodeListGet_0.listNodes > 0) {
			/* find an avaible node index */
			if(this->oldCnt < this->UsbNodeListGet_0.listNodes) {
				for(i=0; i<= BRDK_USB_MAX_DEVICES; i++) {
					if(this->node[i].UsbNodeGet_0.nodeId == 0) {
						this->node[i].UsbNodeGet_0.nodeId = this->nodeIdBuffer[this->UsbNodeListGet_0.listNodes-1];
						break;
					}
				}
			}
		}
	}
	else if(inst->simulateMount && !this->simulationMountActivated) {
	/* find an avaible node index */
		for(i=0; i<= BRDK_USB_MAX_DEVICES; i++) {
			if(this->node[i].UsbNodeGet_0.nodeId == 0) {
				this->node[i].UsbNodeGet_0.nodeId = 4294967295LL;
				this->simulationMountActivated = true;
				break;
			}
		}
	}
	this->oldCnt = this->UsbNodeListGet_0.listNodes;

	/* state machine for all usb nodes */
	for(i=0; i<= BRDK_USB_MAX_DEVICES; i++) {

		switch(this->node[i].state) {

			case 0: /* wait for id */
				if(this->node[i].UsbNodeGet_0.nodeId != 0) {
					this->node[i].UsbNodeGet_0.enable 		= (this->node[i].UsbNodeGet_0.nodeId < 4294967294LL);
					this->node[i].UsbNodeGet_0.pBuffer 		= (UDINT)&this->node[i].infoBuffer;
					this->node[i].UsbNodeGet_0.bufferSize 	= sizeof(usbNode_typ);
					UsbNodeGet(&this->node[i].UsbNodeGet_0);
					this->node[i].state 					= 10;				
				}
				break;

			case 10:	/* get usb node info (interface name) */
				UsbNodeGet(&this->node[i].UsbNodeGet_0);
				switch(this->node[i].UsbNodeGet_0.status) {
	
					case ERR_OK:
						/* filter B&R technology guard from list */
						if(this->node[i].infoBuffer.vendorId == 1615 && this->node[i].infoBuffer.productId == 1001) this->node[i].state = 70;
						else {
							strcpy(this->node[i].device,"USB");
							brdkUSBuditoa(i,tmp);
							strcat(this->node[i].device,tmp);
							this->node[i].DevLink_0.pDevice = (UDINT)&this->node[i].device;
							strcpy(this->node[i].param, "/DEVICE=");  		
							strcat(this->node[i].param, this->node[i].infoBuffer.ifName);
							this->node[i].DevLink_0.pParam = (UDINT)&this->node[i].param;
							this->node[i].DevLink_0.enable = true;
							this->node[i].state = 20;
						}
						break;

					case asusbERR_USB_NOTFOUND:
						this->node[i].UsbNodeGet_0.nodeId = 0;
						memset(&this->node[i].infoBuffer,0,sizeof(usbNode_typ));
						this->node[i].state = 0;
						break;

					case ERR_FUB_ENABLE_FALSE:
						strcpy(this->node[i].device,"USB");
						brdkUSBuditoa(i,tmp);
						strcat(this->node[i].device,tmp);
						this->node[i].DevLink_0.pDevice = (UDINT)&this->node[i].device;
						strcpy(this->node[i].param, "/DEVICE=C:\\USB");  		
						this->node[i].DevLink_0.pParam = (UDINT)&this->node[i].param;
						this->node[i].DevLink_0.enable = true;
						this->node[i].state = 20;	
						break;

				}
				break;

			case 20:	/* create device link */
				DevLink(&this->node[i].DevLink_0);
				switch(this->node[i].DevLink_0.status) {		
		
					case ERR_OK:
						strcpy(inst->node[i].device,this->node[i].device);
						this->node[i].state = 40;
						break;

					
					case fiERR_DEVICE_ALREADY_EXIST:
						this->node[i].DevUnlink_0.enable 	= 1;
						this->node[i].DevUnlink_0.handle 	= this->node[i].DevLink_0.handle;
						this->node[i].state 				= 30;
						break;
				}
				break;

			case 30:	/* unlink device link */
				DevUnlink(&this->node[i].DevUnlink_0);
				switch(this->node[i].DevUnlink_0.status ) {

					case ERR_OK: case fiERR_DEVICE_INVALID_HANDLE:
						this->node[i].DevUnlink_0.enable 	= 0;
						DevUnlink(&this->node[i].DevUnlink_0);
						this->node[i].DevLink_0.enable 		= 0;
						DevLink(&this->node[i].DevLink_0);
						this->node[i].DevLink_0.enable 		= 1;
						this->node[i].devLinkFailCnt++;
						brdkUSBuditoa(this->node[i].devLinkFailCnt,tmp);
						strcat(this->node[i].device,tmp);
						this->node[i].DevLink_0.pDevice 	= (UDINT)&this->node[i].device;
						this->node[i].state					= 20;
						break;

				}
				break;

			case 40:	/* usb node ready - monitor node */
				UsbNodeGet(&this->node[i].UsbNodeGet_0);
				switch(this->node[i].UsbNodeGet_0.status) {
	
					case ERR_OK:
						if(inst->updateMemInfo || inst->node[i].totalMemory == 0) {
							this->node[i].DevMemInfo_0.enable = true;
							this->node[i].DevMemInfo_0.pDevice = this->node[i].DevLink_0.pDevice;
							this->node[i].state = 50;
						}
						break;

					case asusbERR_USB_NOTFOUND:
						strcpy(inst->node[i].device,"");
						this->node[i].DevUnlink_0.enable 	= true;
						this->node[i].DevUnlink_0.handle 	= this->node[i].DevLink_0.handle;
						this->node[i].state = 60;
						break;

					case ERR_FUB_ENABLE_FALSE:
						if(!inst->simulateMount && this->simulationMountActivated) {
							strcpy(inst->node[i].device,"");
							this->node[i].DevUnlink_0.enable 	= true;
							this->node[i].DevUnlink_0.handle 	= this->node[i].DevLink_0.handle;
							this->simulationMountActivated 		= false;
							this->node[i].state = 60;	
						}
						break;

				}
				break;

			case 50:	/* read meminfo */
				DevMemInfo(&this->node[i].DevMemInfo_0);
				switch(this->node[i].DevMemInfo_0.status) {
					
					case ERR_OK:
						inst->node[i].freeMemory 	= this->node[i].DevMemInfo_0.freemem/1048576;	/* output must be in mb */
						inst->node[i].totalMemory 	= this->node[i].DevMemInfo_0.memsize/1048576;	/* output must be in mb */
						this->node[i].state 		= 40;
						break;
					
					case fiERR_DETMEMINFO: case fiERR_DEVICE_MANAGER:
						inst->node[i].freeMemory 	= -1;	/* output must be in mb */
						inst->node[i].totalMemory 	= -1;	/* output must be in mb */
						this->node[i].state 		= 40;
						break;

					case ERR_FUB_BUSY: break;
					default: this->node[i].state = 40; break;
				}
				break;


			case 60:	/* unlink device */
				DevUnlink(&this->node[i].DevUnlink_0);
				switch(this->node[i].DevUnlink_0.status ) {

					case ERR_OK: case fiERR_DEVICE_INVALID_HANDLE:
						this->node[i].DevUnlink_0.enable 	= false;
						DevUnlink(&this->node[i].DevUnlink_0);
						this->node[i].DevLink_0.enable 		= false;
						DevLink(&this->node[i].DevLink_0);
						this->node[i].UsbNodeGet_0.nodeId = 0;
						memset(&this->node[i].infoBuffer,0,sizeof(usbNode_typ));
						inst->node[i].freeMemory 	= 0;
						inst->node[i].totalMemory 	= 0;
						this->node[i].state = 0;
						break;

				}
				break;


			case 70:	/* B&R technology guard state */
				UsbNodeGet(&this->node[i].UsbNodeGet_0);
				switch(this->node[i].UsbNodeGet_0.status) {
	
					case ERR_OK: break;

					case asusbERR_USB_NOTFOUND:
						this->node[i].UsbNodeGet_0.nodeId = 0;
						memset(&this->node[i].infoBuffer,0,sizeof(usbNode_typ));
						this->node[i].state = 0;
						break;

				}
				break;

			case 1000:	/* simulate usb device */
				
				break;


		}
	}

	/* output status */ 
	for(i=0; i<= BRDK_USB_MAX_DEVICES; i++) {
		if(inst->node[i].device[0] != 0) {
			inst->status = BRDK_USB_STATUS_FB_READY;
			break;
		}
		else inst->status = BRDK_USB_STATUS_NO_USB_DEV_FOUND;
	}

	inst->updateMemInfo = 0;	/* reset update command */

}
