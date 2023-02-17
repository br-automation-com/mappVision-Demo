
#include <bur/plctypes.h>
#ifdef __cplusplus
	extern "C"
	{
#endif
	#include "brdkViBase.h"
#ifdef __cplusplus
	};
#endif
/* Function block to handle triggering af new images */
void brdkViBase_imgTrigger(struct brdkViBase_imgTrigger* inst)
{
	BOOL lightReady = 1;
	BOOL lightHwOk = 1;
	BOOL trigger = 0;
	BOOL resetTrigger = 0;
	
	
	brdkViBase_cam_hw_typ* pCam = (brdkViBase_cam_hw_typ*) inst->pCameraHw;
	brdkViBase_light_hw_typ* pLight;
	
	if(!pCam->in.common.moduleOk && !inst->simulate.enable){
		inst->internal.oldAccCnt = 0;
		inst->internal.oldNettime = 0;
	}
	
	if(inst->numLights > 0){
		for(int i = 0; i < inst->numLights; i++){
	
			if(!inst->pLightHw[i].in.common.moduleOk){
				if(!inst->simulate.alwaysSimulateNonePresentLights){
					lightHwOk = 0;
					lightReady = 0;		
				}
			}else{
				if(!inst->pLightHw[i].in.status.ready){
					lightReady = 0;
				}
			}
			
			if(inst->useCamColorForLight)
				inst->pLightHw[i].out.par.flashColor = pCam->out.par.flashColor;
			
			if(inst->useCamExpTimeForLight)
				inst->pLightHw[i].out.par.exposureTime = pCam->out.par.exposureTime;
			
		}
	}
	
	// Check for hw error and all devices are ready
	if(inst->simulate.enable){
		inst->hwError = 0;
		inst->ready = !inst->internal.triggerActive;
	}else{
		inst->hwError = !lightHwOk || (!pCam->in.common.moduleOk && !inst->simulate.alwaysSimulateNonePresentCamera);
		inst->ready = !inst->hwError && (pCam->in.status.imageAcquisitionReady  || (!pCam->in.common.moduleOk && inst->simulate.alwaysSimulateNonePresentCamera))   && lightReady && !inst->internal.triggerActive;
	}
	

	
	if(inst->internal.triggerActive && inst->simulate.enable){
		inst->internal.oldAccCnt++; // increment old acctped cnt such that its not equl to camera count 
		//(old is used as camera is conenct to hardware which is always 0 for simulation)	
	}
	
	
	// check if auto focus is done and the input command is cleared, then reset
	if(!inst->searchAcquisitonSettings && inst->searchAcquisitonSettingsDone){
		pCam->out.cmd.searchAcquisitonSettings = 0;
		inst->searchAcquisitonSettingsDone = 0;				
	}
				
	// Nomal trigger or run auto focus sequence
	switch(inst->internal.state){
		case 0: //default
			
			if(inst->ready){
				
				if(inst->trigger){
					inst->internal.triggerActive = 1;
					inst->trigger = 0;
					inst->busy = 1;
					pCam->out.cmd.imageAcquisition = 1;
					pCam->out.par.delayNetTime = inst->delayNettime;
					
					if(inst->numLights > 0 ){
						for(int i = 0; i < inst->numLights; i++){
							inst->pLightHw[i].out.cmd.flashTrigger = 1;
							inst->pLightHw[i].out.par.nettime = inst->delayNettime;
				
						}
					}
				}else if(inst->searchAcquisitonSettings){
				
					pCam->out.cmd.searchAcquisitonSettings = 1;
					pCam->out.cmd.imageAcquisition = 1;
					
					inst->internal.state = 10;
			
				}
			}
			
		break;
		
		case 10: // Auto focus start
				if(!inst->ready){
					inst->internal.state = 20;
				}
				
		break;
		
		case 20: // Auto focus done
	
			if(inst->ready){
				inst->searchAcquisitonSettingsDone = 1;
				inst->internal.state = 0;
			}
			
		break;
	}
		
	
	// check if camera has accepted our trigger
	if((inst->internal.oldAccCnt != pCam->in.status.acceptedAcquisitionCnt)){
		
		inst->internal.triggerActive = 0;
		inst->triggerCnt += 1;
		inst->internal.waitForImage = 1;
		pCam->out.cmd.imageAcquisition = 0;
		for(int i = 0;i < inst->numLights; i++){
			inst->pLightHw[i].out.cmd.flashTrigger = 0;
		}
	}
	
	inst->internal.simDelay.IN = (inst->simulate.enable || (!pCam->in.common.moduleOk && inst->simulate.alwaysSimulateNonePresentCamera)) && inst->internal.waitForImage;
	inst->internal.simDelay.PT = inst->simulate.imgProcessingDelay;
	TON(&inst->internal.simDelay);
	
	// Check for new image result
	if(inst->internal.oldNettime  != pCam->in.status.imageNettime || inst->internal.simDelay.Q){
		inst->internal.waitForImage = 0;
		inst->busy = 0;
		inst->newImage = 1;
		inst->imageResultCnt += 1;
	}else{
		inst->newImage = 0;
	}
	
	inst->internal.oldAccCnt = pCam->in.status.acceptedAcquisitionCnt;
	inst->internal.oldNettime = pCam->in.status.imageNettime;
	
}
