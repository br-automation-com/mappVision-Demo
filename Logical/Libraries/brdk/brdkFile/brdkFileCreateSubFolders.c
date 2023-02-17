#include <brdkFile_func.h>

void brdkFileCreateSubFolders(struct brdkFileCreateSubFolders* inst) {
	brdk_file_create_subfold_int_typ* this = (brdk_file_create_subfold_int_typ*)&inst->internal;	

	switch(this->state) {

		case 0:
			if(inst->enable) {
				this->DirCreate_0.pDevice 	= (unsigned long)inst->fileDevice;
				this->DirCreate_0.pName 	= (unsigned long)this->tmpPath;
				brdkStrMemSet((unsigned long)&this->tmpPath,0,sizeof(this->tmpPath));
				brdkStrReplace((unsigned long)inst->path,(unsigned long)"/",(unsigned long)"\\");	/* replace all / with \ */
				this->pathPos = 0;
				if(inst->path[0] == 0x5c) this->pathPos = 1;
				this->tmpPathPos = 0;
				while(inst->path[this->pathPos] != 0) {
					this->DirCreate_0.enable 			= true;
					if(inst->path[this->pathPos] == 0x5c) {
						this->tmpPath[this->tmpPathPos++] 	= inst->path[this->pathPos++];
						break;
					}
					else this->tmpPath[this->tmpPathPos++] = inst->path[this->pathPos++];
				}
				if(this->DirCreate_0.enable) {
					DirCreate(&this->DirCreate_0);
					this->state = 10;
				}
				else {
					inst->done = true;
					this->state = 100;
				}
			}
			break;

		case 10:
			brdkStrCpy((unsigned long)inst->description,(unsigned long)"creates the needed folders");
			DirCreate(&this->DirCreate_0);
			if(this->DirCreate_0.status != ERR_FUB_BUSY) {
				if(this->DirCreate_0.status == ERR_OK || this->DirCreate_0.status == fiERR_DIR_ALREADY_EXIST) {
					this->DirCreate_0.enable 	= false;
					DirCreate(&this->DirCreate_0);
					while(inst->path[this->pathPos] != 0) {
						this->DirCreate_0.enable 			= true;
						if(inst->path[this->pathPos] == 0x5c) {
							this->tmpPath[this->tmpPathPos++] 	= inst->path[this->pathPos++];
							break;
						}
						else {
							this->tmpPath[this->tmpPathPos++] 	= inst->path[this->pathPos++];
							this->DirCreate_0.enable 			= true;
						}
					}
					if(this->DirCreate_0.enable) DirCreate(&this->DirCreate_0);
					else {
						inst->done = true;
						this->state = 100;
					}
				}
				else {
					brdkStrCpy((unsigned long)inst->description,(unsigned long)"error calling DirCreate. Check fb for error codes.");
					inst->status = this->DirCreate_0.status;
					this->state = 100;
				}
			}
			break;

		case 100:
			if(inst->status == ERR_OK) brdkStrCpy((unsigned long)inst->description,(unsigned long)"done. Flip and set enable to restart");
			if(!inst->enable) {
				inst->done 				= false;
				inst->status 			= 0;
				inst->description[0] 	= 0;
				this->state 			= 0;
			}
			break;

	}
}
