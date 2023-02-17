#include <brdkFile_func.h>

void brdkFileRead(struct brdkFileRead* inst) {
	brdk_file_read_internal_typ* this = (brdk_file_read_internal_typ*)&inst->internal;

	switch(this->state) {
	
		case 0:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"waiting for FB to be enabled.");
			if(inst->enable) {
				inst->bytesread = 0;
				if(inst->dataLength > 0) {
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"fb busy.");
					this->FileOpen_0.enable 	= true;
					this->FileOpen_0.pDevice 	= (unsigned long)&inst->fileDevice;
					this->FileOpen_0.pFile 		= (unsigned long)&inst->fileName;
					this->FileOpen_0.mode 		= fiREAD_ONLY;
					FileOpen(&this->FileOpen_0);
					this->state 				= 10;
				}
				else {
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"datalength = 0. Set dataLength to buffer size. Flip enable to reset fb.");
					this->state 				= 40;
				}
			}
			inst->done					= false;
			break;

		case 10:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"waiting for FileOpen to be done.");
			FileOpen(&this->FileOpen_0);
			switch(this->FileOpen_0.status) {

				case 0:	/* ERR_OK */
					this->FileReadEx_0.enable 	= true;
					this->FileReadEx_0.ident 		= this->FileOpen_0.ident;
					this->FileReadEx_0.offset 	= 0;
					this->FileReadEx_0.pDest 		= inst->pData;
					this->FileReadEx_0.len 		= inst->dataLength;
					this->FileOpen_0.enable 	= false;
					FileOpen(&this->FileOpen_0);
					FileReadEx(&this->FileReadEx_0);
					this->state 				= 20;					
					break;

				case 65535: break;	/* ERR_FUB_BUSY */

				default:
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error FileOpen. check status. Flip enable to reset fb.");
					inst->status 				= this->FileOpen_0.status;
					this->FileOpen_0.enable 	= false;
					FileOpen(&this->FileOpen_0);
					this->state 				= 40;
					break;

			}
			break;

		case 20:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"waiting for FileRead to be done.");
			FileReadEx(&this->FileReadEx_0);
			switch(this->FileReadEx_0.status) {
				
				case 0:	/* ERR_OK */
					inst->bytesread = this->FileReadEx_0.bytesread;
					this->FileReadEx_0.enable 	= false;
					FileReadEx(&this->FileReadEx_0);
					this->FileClose_0.enable 	= true;
					this->FileClose_0.ident 	= this->FileReadEx_0.ident;
					FileClose(&this->FileClose_0);
					this->state 				= 30;
					break;

				case 65535: break;	/* ERR_FUB_BUSY */

				default:
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error FileClose. check status. Flip enable to reset fb.");
					inst->status 				= this->FileReadEx_0.status;
					this->FileReadEx_0.enable 	= false;
					FileRead(&this->FileReadEx_0);
					this->state 				= 40;
					break;

			}
			break;

		case 30:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"waiting for FileClose to be done.");
			FileClose(&this->FileClose_0);
			switch(this->FileClose_0.status) {
				
				case 0:	case 20721: /* ERR_OK - fiERR_FILE_NOT_OPENED */
					this->FileClose_0.enable 	= false;
					FileClose(&this->FileClose_0);
					inst->done					= true;
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"fb done. Flip enable and set to start fb again.");
					this->state 				= 40;
					break;

				case 65535: break;	/* ERR_FUB_BUSY */

				default:
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error FileClose. check status. Flip enable to reset fb.");
					inst->status 				= this->FileClose_0.status;
					this->FileClose_0.enable 	= false;
					FileClose(&this->FileClose_0);
					this->state 				= 40;
					break;

			}
			break;

		case 40:
			if(!inst->enable) {
				inst->done					= false;
				inst->status				= 0;
				this->state 				= 0;
			}
			break;

	}

}
