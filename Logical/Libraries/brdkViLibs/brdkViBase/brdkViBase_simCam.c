
#include <bur/plctypes.h>
#ifdef __cplusplus
	extern "C"
	{
#endif
#include "brdkViBase.h"
#ifdef __cplusplus
	};
#endif

#define COMPARE_NETTIME(nettime, triggerTime) \
    (nettime > 0 && triggerTime < 0) ? 0 : (nettime >= triggerTime)


/* TODO: Add your comment here */
void brdkViBase_simCam(struct brdkViBase_simCam* inst)
{
	if(inst->pCamHw == 0){
		inst->status = BRDKVIBASE_ERR_INVALID_POINT;
		return;
	}
	
	brdkViBase_cam_hw_typ *camHw = inst->pCamHw;
	brdkViBase_simCam_internal_typ* this = &inst->internal;
	static unsigned long processingStartTime = 0;
	static unsigned short processingTime = 0;

	switch (this->state) {
		case 30:
			
			camHw->in.status.imageProcessingActive = 1;
			camHw->in.status.completedAcquisitionCnt++;
			this->imgCnt++;
			this->state = 0;
		
		case 0:
		
			camHw->in.status.imageAcquisitionReady = 1;
			camHw->in.status.cameraStatus = 0x0;
			
			
			if(!camHw->out.cmd.searchAcquisitonSettings){
				camHw->in.status.exposureTime = camHw->out.par.exposureTime;
				camHw->in.status.gainLevel = camHw->out.par.gainLevel;
				this->searchDone = 0;
			}
			
			
			// Set ready to true if image acquisition has been triggered
			if (camHw->out.cmd.imageAcquisition) {
				this->state = 10;
				this->triggerNettime = inst->nettime;
				camHw->in.status.imageAcquisitionReady = 0;
				camHw->in.status.acceptedAcquisitionCnt++;
				camHw->in.status.cameraStatus = 0x3;
			
			}else if(camHw->out.cmd.searchAcquisitonSettings && !this->searchDone){
				camHw->in.status.imageAcquisitionReady = 0;
				camHw->in.status.cameraStatus = 0x10;
				
				this->state = 100;
				this->cnt = 0;
			
			}else if(!camHw->out.cmd.searchAcquisitonSettings){
				if(camHw->out.par.focus != camHw->in.status.focus){
					camHw->in.status.imageAcquisitionReady = 0;
					camHw->in.status.cameraStatus = 0x80;
				
					this->state = 150;
					this->cnt = 0;
				}
			}
			break;
		
		case 10:
			
			// trigger conf = 0 is time delay, so we wait delay nettime since trigger time
			if(inst->triggerConf == 0){
				if(COMPARE_NETTIME(inst->nettime,this->triggerNettime+camHw->out.par.delayNetTime)){
					this->state = 30;
					camHw->in.status.cameraStatus = 0x5;
			
				}
			// trigger conf = 1 is nettime trigger, so netime need to be above delayNetime
			}else if(COMPARE_NETTIME(inst->nettime,camHw->out.par.delayNetTime)){
				this->state = 30;
				camHw->in.status.cameraStatus = 0x5;
			}
			
			break;
		
		case 100: // auto focus
			camHw->in.status.imageAcquisitionReady = 0	;
			camHw->in.status.cameraStatus = 0x10;
			camHw->in.status.focus = brdkViBase_random(0,2500); 
			camHw->in.status.exposureTime = brdkViBase_random(0,2500);
			if(this->cnt++ > 19){
				this->state = 0;
				this->searchDone = 1;
			}
			break;
			
		case 150: // set focus
			camHw->in.status.imageAcquisitionReady = 0;
			camHw->in.status.cameraStatus = 0x80;
			camHw->in.status.focus = brdkViBase_random(camHw->in.status.focus, camHw->out.par.focus-1);
			
			if(this->cnt++ > 4 ){
				this->state = 0;
				camHw->in.status.focus = camHw->out.par.focus;
			}
			
			break;
	}
	
	
	switch(this->procState){
		case 0:
			if(this->imgCnt > 0){
				this->imgCnt--;
				this->procNettime = inst->nettime+ inst->cameraProcessingTime + brdkViBase_random(-10,10);
				this->procState = 10;
			}else{
				camHw->in.status.imageProcessingActive = 0;
			}
		break;			
	
		case 10:
			if(COMPARE_NETTIME(inst->nettime,this->procNettime)){
				camHw->in.status.cameraProcessingTime = inst->cameraProcessingTime + brdkViBase_random(-10,10);	
				camHw->in.status.imageProcessingActive = 0;
				this->procState = 0;
			}
		break;
		
	}
}


