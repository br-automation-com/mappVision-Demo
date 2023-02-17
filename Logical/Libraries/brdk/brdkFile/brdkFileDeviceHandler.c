#include <brdkFile_func.h>

#define BR_TG_VENDOR_ID 1615
#define BR_TG_PRODUCT_ID 1001

void brdkFileDeviceHandler(struct brdkFileDeviceHandler* inst) {
	brdk_file_dev_handler_int_typ* this = (brdk_file_dev_handler_int_typ*)&inst->internal;		/* pointer to the internal structure */
	brdk_file_dev_handler_setup_typ* setup = (brdk_file_dev_handler_setup_typ*)&inst->setup;	/* pointer to the setup structure */
	brdk_file_dev_handler_sim_typ* sim = (brdk_file_dev_handler_sim_typ*)&inst->simulation;		/* pointer to the simulation structure */
	char tmpStr[200];

	if(inst->enable) {

		/* check weither the controller is beeing simulated and watch the usb status */
		if(!DiagCpuIsSimulated()) {
			if(!this->UsbNodeGet_0.enable) this->UsbNodeListGet_0.enable = true;
			this->UsbNodeListGet_0.pBuffer					= (unsigned long)&this->nodeId;
			this->UsbNodeListGet_0.bufferSize 				= sizeof(this->nodeId);
			this->UsbNodeListGet_0.filterInterfaceClass 	= asusb_CLASS_MASS_STORAGE;
			this->UsbNodeListGet_0.filterInterfaceSubClass 	= asusb_SUBCLASS_SCSI_COMMAND_SET;
			UsbNodeListGet(&this->UsbNodeListGet_0);
			if(this->UsbNodeListGet_0.status == asusbERR_USB_NOTFOUND) {
				this->nodeIdx = 0;
				this->usbOK = false;
			}
		
			this->UsbNodeGet_0.enable 		= true;
			this->UsbNodeGet_0.nodeId 		= this->nodeId[this->nodeIdx];
			this->UsbNodeGet_0.pBuffer 		= (unsigned long)&this->usbNode;
			this->UsbNodeGet_0.bufferSize 	= sizeof(this->usbNode);
			UsbNodeGet(&this->UsbNodeGet_0);
			if(this->UsbNodeGet_0.status == ERR_OK) {
				if(this->usbNode.vendorId == BR_TG_VENDOR_ID && this->usbNode.productId == BR_TG_PRODUCT_ID) {
					this->UsbNodeGet_0.enable 		= false;
					UsbNodeGet(&this->UsbNodeGet_0);
					this->nodeIdx++;
				}
				else this->usbOK = true;
			}
			else if(this->UsbNodeGet_0.status == asusbERR_USB_NOTFOUND) {
				this->UsbNodeListGet_0.enable = true;	
				this->nodeIdx = 0;		
				this->usbOK = false;
			}
			if(this->oldNodeId != this->UsbNodeGet_0.nodeId) this->usbOK = false;
			this->oldNodeId = this->UsbNodeGet_0.nodeId;
		}
		else {
			/* look for USB root folder */
			if(this->DirInfo_0.pDevice != 0) {
				this->DirInfo_0.enable 	= true;
				this->DirInfo_0.pPath 	= (unsigned long)"";
				DirInfo(&this->DirInfo_0);
				switch(this->DirInfo_0.status) {
					case 0: this->usbOK = true; break;
					case 20723: this->usbOK = false; break;
					default: break;
				}
			}
		}
		if(setup->usbOverrule) inst->useUSB = this->usbOK;	/* USB stick will overrule */
	}
	else {
		this->usbOK 					= false;
		this->nodeIdx 					= 0;
		this->DirInfo_0.enable 			= false;
		DirInfo(&this->DirInfo_0);
		this->UsbNodeGet_0.enable 		= false;
		UsbNodeGet(&this->UsbNodeGet_0);
		this->UsbNodeListGet_0.enable 	= false;
		UsbNodeListGet(&this->UsbNodeListGet_0);
	}

	/* drive handler */
	switch(this->driveState) {

		case 0:
			if(inst->enable) {
				if(!DiagCpuIsSimulated()) {	/* check if the controller is simulated */
					if((inst->useUSB && this->usbOK) || !inst->useUSB) {
						this->driveReady = true;
						if(!inst->useUSB) getDrive(setup->plcDrive,this->drive);
						else brdkStrCpy((unsigned long)this->drive,(unsigned long)this->usbNode.ifName);
						this->driveState = 499;
					}
				}
				else {
					this->DevLink_0.enable 	= true;
					this->DevLink_0.pDevice = (unsigned long)"INTUSB";
					this->DevLink_0.pParam 	= buildParameterString(getDrive(sim->pcUSBDrive,this->drive),(char*)&"",(char*)&this->deviceParam);
					this->driveState 		= 100;
				}
			}
			break;

		case 100:	/* create a file device for finding an attached usb flash */
			DevLink(&this->DevLink_0);
			if(this->DevLink_0.status != ERR_FUB_BUSY) {
				if(this->DevLink_0.status == ERR_OK || this->DevLink_0.status == fiERR_DEVICE_ALREADY_EXIST) {
					this->DirInfo_0.pDevice = this->DevLink_0.pDevice;
					this->DevLink_0.enable 	= false;
					DevLink(&this->DevLink_0);
					this->driveState 		= 110;
				}
				else {
					inst->status = this->DevLink_0.status;
					this->DevLink_0.enable 	= false;
					DevLink(&this->DevLink_0);
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling DevLink. Flip enable to reset fb.");
					this->driveState = 900;
				}
			}
			break;

		case 110:	/* wait for DirInfo to have been call once. Fb is call above */
			switch(this->DirInfo_0.status) {

				case 0: case 20723:
					if(!inst->useUSB) {
						getDrive(sim->pcHDDrive,this->drive);
						brdkStrCat((unsigned long)this->drive,(unsigned long)sim->pcRootFolder);
					}
					else getDrive(sim->pcUSBDrive,this->drive);
					this->driveState = 499;
					this->driveReady = true;
					break;

				case 65534: case 65535: break;

				default:
					inst->status 			= this->DirInfo_0.status;
					this->DirInfo_0.enable 	= false;
					DirInfo(&this->DirInfo_0);
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling DirInfo. Flip enable to reset fb.");
					this->driveReady = false;
					this->driveState = 900;
					break;

			}
			break;

		case 499:	/* waiting for file devices to be ready */
			if(!inst->enable) {
				this->driveReady = false;
				this->driveState = 900;
			}
			else if(inst->ready) this->driveState = 500;
			break;

		case 500:	/* check if USB status changes */
			if(!inst->enable) {
				this->driveReady = false;
				this->driveState = 900;
			}
			else if((this->oldUseUSB != inst->useUSB) || (inst->useUSB && (this->oldUSBok != this->usbOK))) {	/* usb must be used and the ok status has changed */	
				this->driveReady = false;
				if(inst->useUSB && !this->usbOK) brdkStrCpy((unsigned long)inst->description,(unsigned long)"USB not ready. Turn off useUSB command.");	
				else this->driveState = 510;
			}
			this->oldUseUSB = inst->useUSB;
			this->oldUSBok 	= this->usbOK;
			this->oldNodeId = this->UsbNodeGet_0.nodeId;
			break;

		case 510:	/* select the new drive */
			if(!DiagCpuIsSimulated()) {	/* check if the controller is simulated */
				if(!inst->useUSB) getDrive(setup->plcDrive,this->drive);
				else brdkStrCpy((unsigned long)this->drive,(unsigned long)this->usbNode.ifName);
			}
			else {
				if(!inst->useUSB) {
					getDrive(sim->pcHDDrive,this->drive);
					brdkStrCat((unsigned long)this->drive,(unsigned long)sim->pcRootFolder);
				}
				else getDrive(sim->pcUSBDrive,this->drive);
			}
			this->driveReady = true;
			this->driveState = 499;
			break;

		case 900:	/* error state */
			this->driveReady = false;
			if(!inst->enable) {
				inst->status 		= 0;
				this->driveState 	= 0;
			}
			break;

	}

	/* file device handler */
	switch(this->fileState) {
		
		case 0:	/* wait for a drive */
			if(inst->enable) {
				if(this->driveReady) {
					this->DevLink_0.enable 	= true;
					
					this->DevLink_0.pDevice = (unsigned long)&inst->setup.rootFileDeviceName;
					this->DevLink_0.pParam 	= buildParameterString((char*)&this->drive,(char*)&"",(char*)&this->deviceParam);
					this->fileState 		= 10;
				}
			}
			else {
				inst->ready = false;
			}	
			break;

		case 10:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"creates a devlink for the drive root");
			DevLink(&this->DevLink_0);
			if(this->DevLink_0.status != ERR_FUB_BUSY) {
				if(this->DevLink_0.status == ERR_OK) {
					
					brdkStrCpy((unsigned long)inst->availableDevices[0],this->DevLink_0.pDevice);
					this->activeHandles[0] = this->DevLink_0.handle;
					this->DevLink_0.enable 	= false;
					DevLink(&this->DevLink_0);
					this->fileIdx = 0;
					if(setup->fileDevices[this->fileIdx].name[0] != 0 && setup->fileDevices[this->fileIdx].path[0] != 0) {
						brdkStrCpy((unsigned long)this->brdkFileCreateSubFolders_0.path,(unsigned long)setup->fileDevices[this->fileIdx].path);
						brdkStrCpy((unsigned long)this->brdkFileCreateSubFolders_0.fileDevice,this->DevLink_0.pDevice);
						this->brdkFileCreateSubFolders_0.enable = true;
						brdkFileCreateSubFolders(&this->brdkFileCreateSubFolders_0);
						this->fileState = 20;
					}
					else this->fileState = 100;
				}
				else if(this->DevLink_0.status == fiERR_DEVICE_ALREADY_EXIST) {
					if(this->DevLink_0.handle != 0) {
						inst->status = this->DevLink_0.status;
						this->DevLink_0.enable 	= false;
						DevLink(&this->DevLink_0);
						brdkStrCpy((unsigned long)inst->description,(unsigned long)"Device ");
						brdkStrCat((unsigned long)inst->description,this->DevLink_0.pDevice);
						brdkStrCat((unsigned long)inst->description,(unsigned long)" already exists. Reboot controller to kill the old device.");	
						this->fileState = 900;
					}
					else {
						this->DevUnlink_0.enable = true;
						this->DevUnlink_0.handle = this->DevLink_0.handle;
						this->DevLink_0.enable 	= false;
						DevLink(&this->DevLink_0);
						this->fileState = 40;
					}
				} 
				else {
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling DevLink. Flip enable to reset fb.");			
					inst->status 			= this->DevLink_0.status;
					this->DevLink_0.enable 	= false;
					DevLink(&this->DevLink_0);
					this->fileState 		= 900;
				}
			}
			break;

		case 20:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"creates the needed folders");
			brdkFileCreateSubFolders(&this->brdkFileCreateSubFolders_0);
			if(this->brdkFileCreateSubFolders_0.done) {
				this->brdkFileCreateSubFolders_0.enable = false;
				brdkFileCreateSubFolders(&this->brdkFileCreateSubFolders_0);
				this->fileIdx++;
				if(setup->fileDevices[this->fileIdx].name[0] != 0 && setup->fileDevices[this->fileIdx].path[0] != 0) {
					this->brdkFileCreateSubFolders_0.enable = true;	
					brdkStrCpy((unsigned long)this->brdkFileCreateSubFolders_0.path,(unsigned long)setup->fileDevices[this->fileIdx].path);
					brdkFileCreateSubFolders(&this->brdkFileCreateSubFolders_0);		
				}
				else {
					this->fileIdx = 0;
					this->DevLink_0.enable 	= true;
					this->DevLink_0.pDevice = (unsigned long)setup->fileDevices[this->fileIdx].name;
					this->DevLink_0.pParam 	= buildParameterString((char*)&this->drive,(char*)&setup->fileDevices[this->fileIdx].path,(char*)&this->deviceParam);
					this->fileState = 30;
				}
			}
			else if(this->brdkFileCreateSubFolders_0.status == fiERR_FILE_DEVICE) {
				if(DiagCpuIsSimulated()) {
					this->DevUnlink_0.enable 	= true;
					this->DevUnlink_0.handle 	= this->activeHandles[0];
					this->activeHandles[0] 		= 0;
					DevUnlink(&this->DevUnlink_0);
					this->brdkFileCreateSubFolders_0.enable = false;
					brdkFileCreateSubFolders(&this->brdkFileCreateSubFolders_0);
					this->fileState 			= 200;
				}
				else {
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling brdkFileCreateSubFolders. Flip enable to reset fb.");			
					inst->status 				= this->brdkFileCreateSubFolders_0.status;
					this->brdkFileCreateSubFolders_0.enable = false;
					brdkFileCreateSubFolders(&this->brdkFileCreateSubFolders_0);
					this->fileState 			= 900;	
				}
			}
			else if(this->brdkFileCreateSubFolders_0.status != ERR_FUB_BUSY) brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling brdkFileCreateSubFolders. Check fb for error codes.");
			break;

		case 30:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"creates the needed file devices");
			DevLink(&this->DevLink_0);
			if(this->DevLink_0.status != ERR_FUB_BUSY) {
				if(this->DevLink_0.status == ERR_OK) {
					brdkStrCpy((unsigned long)inst->availableDevices[this->fileIdx+1],this->DevLink_0.pDevice);
					this->activeHandles[this->fileIdx+1] = this->DevLink_0.handle;
					this->DevLink_0.enable 	= false;
					DevLink(&this->DevLink_0);
					this->fileIdx++;
					if(setup->fileDevices[this->fileIdx].name[0] != 0 && setup->fileDevices[this->fileIdx].path[0] != 0) {
						this->DevLink_0.enable 	= true;
						this->DevLink_0.pDevice = (unsigned long)setup->fileDevices[this->fileIdx].name;
						this->DevLink_0.pParam 	= buildParameterString((char*)&this->drive,(char*)&setup->fileDevices[this->fileIdx].path,(char*)&this->deviceParam);
					}
					else {
						inst->ready = true;
						brdkStrCpy((unsigned long)inst->description,(unsigned long)"all file devices are ready to use");
						this->fileState = 100;
					}
				}
				else {
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling DevLink. Flip enable to reset fb.");			
					inst->status 			= this->DevLink_0.status;
					this->DevLink_0.enable 	= false;
					DevLink(&this->DevLink_0);
					this->fileState 		= 900;
				}
			}
			break;

		case 40:
			DevUnlink(&this->DevUnlink_0);
			if(this->DevUnlink_0.status != ERR_FUB_BUSY) {
				if(this->DevUnlink_0.status == ERR_OK) {
					this->DevUnlink_0.enable = false;
					DevUnlink(&this->DevUnlink_0);
					this->DevLink_0.enable 	= true;
					this->DevLink_0.pDevice = (unsigned long)&inst->setup.rootFileDeviceName;
					this->DevLink_0.pParam 	= buildParameterString((char*)&this->drive,(char*)&"",(char*)&this->deviceParam);
					this->fileState 		= 10;
				}
				else {
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling DevUnlink. Flip enable to reset fb.");			
					inst->status 				= this->DevUnlink_0.status;
					this->DevUnlink_0.enable 	= false;
					DevUnlink(&this->DevUnlink_0);
					this->fileState 			= 900;
				}
			}
			break;

		case 100:	/* wait for interuption */
			if(!inst->enable) {
				inst->ready 	= false;
				this->fileState = 900;
			}
			if(!this->driveReady) {
				inst->ready = false;
				if(this->activeHandles[0] != 0) {
					this->fileIdx = 0;
					this->DevUnlink_0.enable 	= true;
					this->DevUnlink_0.handle 	= this->activeHandles[this->fileIdx];
					this->fileState 			= 110;
				}
				else this->fileState = 0;
			}
			break;

		case 110:	/* unlink file devices */
			DevUnlink(&this->DevUnlink_0);
			if(this->DevUnlink_0.status != ERR_FUB_BUSY) {
				if(this->DevUnlink_0.status == ERR_OK) {
					brdkStrCpy((unsigned long)inst->availableDevices[this->fileIdx],(unsigned long)"");
					this->activeHandles[this->fileIdx] = 0;
					this->fileIdx++;
					this->DevUnlink_0.enable = false;
					DevUnlink(&this->DevUnlink_0);
					if(this->activeHandles[this->fileIdx] != 0) {
						this->DevUnlink_0.enable = true;
						this->DevUnlink_0.handle = this->activeHandles[this->fileIdx];
					}
					else this->fileState = 0;
				}
				else {
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling DevUnlink. Flip enable to reset fb.");			
					inst->status 				= this->DevUnlink_0.status;
					this->DevUnlink_0.enable 	= false;
					DevUnlink(&this->DevUnlink_0);
					this->fileState 			= 900;
				}
			}
			break;

		case 200:
			DevUnlink(&this->DevUnlink_0);
			if(this->DevUnlink_0.status != ERR_FUB_BUSY) {
				if(this->DevUnlink_0.status == ERR_OK) {
					this->DevUnlink_0.enable = false;
					DevUnlink(&this->DevUnlink_0);
					this->DevLink_0.enable 	= true;
					this->DevLink_0.pDevice = (unsigned long)"tmpRoot";
					this->DevLink_0.pParam 	= buildParameterString(getDrive(sim->pcHDDrive,tmpStr),(char*)&"",(char*)&this->deviceParam);
					this->fileState 		= 210;
				}
				else {
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling DevUnlink. Flip enable to reset fb.");			
					inst->status 				= this->DevUnlink_0.status;
					this->DevUnlink_0.enable 	= false;
					DevUnlink(&this->DevUnlink_0);
					this->fileState 			= 900;
				}
			}
			break;

		case 210:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"creates a file devive for sim root folder");
			DevLink(&this->DevLink_0);
			if(this->DevLink_0.status != ERR_FUB_BUSY) {
				if(this->DevLink_0.status == ERR_OK) {
					this->DevUnlink_0.handle 	= this->DevLink_0.handle;
					this->DevLink_0.enable 		= false;
					DevLink(&this->DevLink_0);
					this->brdkFileCreateSubFolders_0.enable = true;
					brdkStrCpy((unsigned long)this->brdkFileCreateSubFolders_0.path,(unsigned long)sim->pcRootFolder);
					brdkStrCpy((unsigned long)this->brdkFileCreateSubFolders_0.fileDevice,this->DevLink_0.pDevice);
					brdkFileCreateSubFolders(&this->brdkFileCreateSubFolders_0);
					this->fileState 			= 220;
				}
				else {
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling DevLink. Flip enable to reset fb.");			
					inst->status 				= this->DevLink_0.status;
					this->DevLink_0.enable 		= false;
					DevLink(&this->DevLink_0);
					this->fileState 			= 900;
				}
			}
			break;

		case 220:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"creates the needed folders");
			brdkFileCreateSubFolders(&this->brdkFileCreateSubFolders_0);
			if(this->brdkFileCreateSubFolders_0.done) {
				this->brdkFileCreateSubFolders_0.enable = false;
				brdkFileCreateSubFolders(&this->brdkFileCreateSubFolders_0);
				this->DevUnlink_0.enable 	= true;
				this->fileState				= 230;
			}
			else if(this->brdkFileCreateSubFolders_0.status != ERR_FUB_BUSY) {
				brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling brdkFileCreateSubFolders. Flip enable to reset fb.");			
				inst->status 				= this->brdkFileCreateSubFolders_0.status;
				this->brdkFileCreateSubFolders_0.enable = false;
				brdkFileCreateSubFolders(&this->brdkFileCreateSubFolders_0);
				this->fileState 			= 900;
			}
			break;

		case 230:
			DevUnlink(&this->DevUnlink_0);
			if(this->DevUnlink_0.status != ERR_FUB_BUSY) {
				if(this->DevUnlink_0.status == ERR_OK) {
					this->DevUnlink_0.enable = false;
					DevUnlink(&this->DevUnlink_0);
					this->fileState 			= 0;
				}
				else {
					inst->status 				= this->DevUnlink_0.status;
					this->DevUnlink_0.enable 	= false;
					DevUnlink(&this->DevUnlink_0);
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling DevUnlink. Flip enable to reset fb.");
					this->fileState 			= 900;
				}
			}
			break;

		case 900: /* error state */
			if(!inst->enable) {
				inst->status 	= 0;
				this->fileState = 0;
			}
			break;

	}

}
