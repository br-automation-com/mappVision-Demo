#include <brdkFile_func.h>

void brdkFileWrite(struct brdkFileWrite* inst) {
	brdk_file_write_internal_typ* this = (brdk_file_write_internal_typ*)&inst->internal;

	switch(this->state) {
	
		case 0:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"waiting for FB to be enabled.");
			if(inst->enable) {
				brdkStrCpy((unsigned long)inst->description,(unsigned long)"fb busy.");
				this->FileCreate_0.enable 	= true;
				this->FileCreate_0.pDevice 	= (unsigned long)&inst->fileDevice;
				this->FileCreate_0.pFile 	= (unsigned long)&inst->fileName;
				FileCreate(&this->FileCreate_0);
				this->state 				= 10;
			}
			inst->done					= false;
			break;

		case 10:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"waiting for FileCreate to be done.");
			FileCreate(&this->FileCreate_0);
			switch(this->FileCreate_0.status) {

				case 0:	/* ERR_OK */
					this->FileWrite_0.enable 	= true;
					this->FileWrite_0.ident 	= this->FileCreate_0.ident;
					this->FileWrite_0.offset 	= 0;
					this->FileWrite_0.pSrc 		= inst->pData;
					this->FileWrite_0.len 		= inst->dataLength != 0 ? inst->dataLength : brdkStrLen(inst->pData);
					this->FileCreate_0.enable 	= false;
					FileCreate(&this->FileCreate_0);
					FileWrite(&this->FileWrite_0);
					this->state 				= 40;					
					break;


				case 20705: /* fiERR_EXIST  */
					if(!inst->overwrite) {
						this->FileOpen_0.enable 	= true;
						this->FileOpen_0.pDevice 	= (unsigned long)&inst->fileDevice;
						this->FileOpen_0.pFile 		= (unsigned long)&inst->fileName;
						this->FileOpen_0.mode 		= fiWRITE_ONLY;
						FileOpen(&this->FileOpen_0);
						this->state 				= 20;
					}
					else {
						this->FileDelete_0.enable 	= true;
						this->FileDelete_0.pDevice 	= (unsigned long)&inst->fileDevice;
						this->FileDelete_0.pName 	= (unsigned long)&inst->fileName;
						FileDelete(&this->FileDelete_0);
						this->state = 30;
					}
					break;

				case 65535: break;	/* ERR_FUB_BUSY */

				default:
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error FileCreate. check status. Flip enable to reset fb.");
					inst->status 				= this->FileCreate_0.status;
					this->FileCreate_0.enable 	= false;
					FileCreate(&this->FileCreate_0);
					this->state 				= 60;
					break;

			}
			break;

		case 20:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"waiting for FileOpen to be done.");
			FileOpen(&this->FileOpen_0);
			switch(this->FileOpen_0.status) {

				case 0:	/* ERR_OK */
					this->FileWrite_0.enable 	= true;
					this->FileWrite_0.ident 	= this->FileOpen_0.ident;
					this->FileWrite_0.offset 	= this->FileOpen_0.filelen;
					this->FileWrite_0.pSrc 		= inst->pData;
					this->FileWrite_0.len 		= inst->dataLength != 0 ? inst->dataLength : brdkStrLen(inst->pData);
					this->FileOpen_0.enable = false;
					FileOpen(&this->FileOpen_0);
					FileWrite(&this->FileWrite_0);
					this->state 				= 40;
					break;

				case 65535: break;	/* ERR_FUB_BUSY */

				default:
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error FileOpen. check status. Flip enable to reset fb.");
					inst->status 				= this->FileOpen_0.status;
					this->FileOpen_0.enable = false;
					FileOpen(&this->FileOpen_0);
					this->state 				= 60;
					break;

			}
			break;

		case 30:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"waiting for FileDelete to be done.");
			FileDelete(&this->FileDelete_0);
			switch(this->FileDelete_0.status) {
				
				case 0:	case 20708: /* ERR_OK - fiERR_FILE_NOT_FOUND */
					this->FileDelete_0.enable = false;
					FileDelete(&this->FileDelete_0);
					this->FileCreate_0.enable 	= true;
					this->FileCreate_0.pDevice 	= (unsigned long)&inst->fileDevice;
					this->FileCreate_0.pFile 	= (unsigned long)&inst->fileName;
					FileCreate(&this->FileCreate_0);
					this->state 				= 10;
					break;

				case 65535: break;	/* ERR_FUB_BUSY */

				default:
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error FileDelete. check status. Flip enable to reset fb.");
					inst->status 				= this->FileDelete_0.status;
					this->FileDelete_0.enable = false;
					FileDelete(&this->FileDelete_0);
					this->state 				= 60;
					break;

			}
			break;

		case 40:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"waiting for FileWrite to be done.");
			FileWrite(&this->FileWrite_0);
			switch(this->FileWrite_0.status) {
				
				case 0:	/* ERR_OK */
					this->FileWrite_0.enable 	= false;
					FileWrite(&this->FileWrite_0);
					this->FileClose_0.enable 	= true;
					this->FileClose_0.ident 	= this->FileWrite_0.ident;
					FileClose(&this->FileClose_0);
					this->state 				= 50;
					break;

				case 65535: break;	/* ERR_FUB_BUSY */

				default:
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error FileWrite. check status. Flip enable to reset fb.");
					inst->status 				= this->FileWrite_0.status;
					this->FileWrite_0.enable 	= false;
					FileWrite(&this->FileWrite_0);
					this->state 				= 60;
					break;

			}
			break;

		case 50:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"waiting for FileClose to be done.");
			FileClose(&this->FileClose_0);
			switch(this->FileClose_0.status) {
				
				case 0:	case 20721: /* ERR_OK - fiERR_FILE_NOT_OPENED */
					this->FileClose_0.enable 	= false;
					FileClose(&this->FileClose_0);
					inst->done					= true;
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"fb done. Flip enable and set to start fb again.");
					this->state 				= 60;
					break;

				case 65535: break;	/* ERR_FUB_BUSY */

				default:
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error FileClose. check status. Flip enable to reset fb.");
					inst->status 				= this->FileClose_0.status;
					this->FileClose_0.enable 	= false;
					FileClose(&this->FileClose_0);
					this->state 				= 60;
					break;

			}
			break;

		case 60:
			if(!inst->enable) {
				inst->done		= false;
				inst->status	= 0;
				this->state 	= 0;
			}
			break;

	}

}
