
#include <bur/plctypes.h>
#ifdef __cplusplus
	extern "C"
	{
#endif
	#include "brdkViBase.h"
#ifdef __cplusplus
	};
#endif
/* TODO: Add your comment here */

#define DISTANCE_FRONTGLASS_LENS_MM 15

plcbit brdkViBase_calcOpticInfo(struct brdkViBase_camInfo_typ* camInfo, struct brdkViBase_opticInfo_typ* opticInfo)
{
	float pixelSize_pxConf_um = 0;
	

	// -----------------------------------------------------------------------------------------------------------
	// Set sensor parameter
	switch(camInfo->sensor){
		case	BRDKVIBASE_SENSOR_1_3_MP:
		case	BRDKVIBASE_SENSOR_1_3_MP_LINE:
						
			opticInfo->sensor.pixelSize_um			= 4.8;
			opticInfo->sensor.maxWidthPx			= 1280;
			opticInfo->sensor.maxHeightPx			= 1024;
			break;
		case		BRDKVIBASE_SENSOR_3_5_MP:
			opticInfo->sensor.pixelSize_um			= 3.2;
			opticInfo->sensor.maxWidthPx			= 2112;
			opticInfo->sensor.maxHeightPx			= 1664;
			break;
		case	BRDKVIBASE_SENSOR_5_3_MP_LINE:
			opticInfo->sensor.pixelSize_um		= 3.2;
			opticInfo->sensor.maxWidthPx		= 2592;
			opticInfo->sensor.maxHeightPx		= 2048;
			break;
		default:
			return;
	}
	
	// -----------------------------------------------------------------------------------------------------------
	// Set lens parameter
	switch(camInfo->lens){
		case BRDKVIBASE_LENS_4_6:
			opticInfo->lens.focalLength_mm		= 4.6;
			opticInfo->lens.minObjectDist_mm	= 25;
			opticInfo->lens.maxObjectDist_mm	= 65550;
			opticInfo->lens.aperture			= 3.5;
			break; 
		case BRDKVIBASE_LENS_6_0:
			opticInfo->lens.focalLength_mm		= 6.0;
			opticInfo->lens.minObjectDist_mm	= 50;
			opticInfo->lens.maxObjectDist_mm	= 65550;
			opticInfo->lens.aperture			= 3.5;
			break; 
		case BRDKVIBASE_LENS_8_0:
			opticInfo->lens.focalLength_mm		= 8.0;
			opticInfo->lens.minObjectDist_mm	= 50;
			opticInfo->lens.maxObjectDist_mm	= 65500;
			opticInfo->lens.aperture			= 3.5;
			break; 
		case BRDKVIBASE_LENS_12_0:
			opticInfo->lens.focalLength_mm		= 12.0;
			opticInfo->lens.minObjectDist_mm	= 75;
			opticInfo->lens.maxObjectDist_mm	= 5000;
			opticInfo->lens.aperture			= 4.0;
			break; 
		case BRDKVIBASE_LENS_16_0:
			opticInfo->lens.focalLength_mm		= 16.0;
			opticInfo->lens.minObjectDist_mm	= 100;
			opticInfo->lens.maxObjectDist_mm	= 1500;
			opticInfo->lens.aperture			= 4.0;
			break;
		case BRDKVIBASE_LENS_25_0:
			opticInfo->lens.focalLength_mm		= 25.0;
			opticInfo->lens.minObjectDist_mm	= 250;
			opticInfo->lens.maxObjectDist_mm	= 1500;
			opticInfo->lens.aperture			= 4.0;
			break; 
		case BRDKVIBASE_LENS_12_0_MACRO:
			opticInfo->lens.focalLength_mm		= 12.0;
			opticInfo->lens.minObjectDist_mm	= 35;
			opticInfo->lens.maxObjectDist_mm	= 65;
			opticInfo->lens.aperture			= 4.0;
			break;
		default:
			return;
	}
					
	opticInfo->lens.validDistance = camInfo->distance >= opticInfo->lens.minObjectDist_mm && camInfo->distance <= opticInfo->lens.maxObjectDist_mm;
	if(opticInfo->lens.validDistance){
		opticInfo->lens.distanceLens_mm = camInfo->distance + DISTANCE_FRONTGLASS_LENS_MM; // The lens is 15mm behind the front glass
		if(camInfo->pixelConfiguration > 0){
			pixelSize_pxConf_um =  opticInfo->sensor.pixelSize_um*2;
		}else{
			pixelSize_pxConf_um = opticInfo->sensor.pixelSize_um;
		}
						
		opticInfo->lens.circleOfConfusion_mm = pixelSize_pxConf_um  * 0.00141421356237309504880168872421;
//				
		opticInfo->lens.hyperFocalDistance_mm		= (opticInfo->lens.focalLength_mm * opticInfo->lens.focalLength_mm) / (opticInfo->lens.aperture * opticInfo->lens.circleOfConfusion_mm) + opticInfo->lens.focalLength_mm;
		opticInfo->lens.depthOfFieldNearPos_mm		= opticInfo->lens.distanceLens_mm * (opticInfo->lens.hyperFocalDistance_mm - opticInfo->lens.focalLength_mm) / (opticInfo->lens.hyperFocalDistance_mm + opticInfo->lens.distanceLens_mm - 2 * opticInfo->lens.focalLength_mm) - DISTANCE_FRONTGLASS_LENS_MM;
		if(opticInfo->lens.distanceLens_mm < opticInfo->lens.hyperFocalDistance_mm){
			opticInfo->lens.depthOfFieldFarPos_mm	= opticInfo->lens.distanceLens_mm * (opticInfo->lens.hyperFocalDistance_mm - opticInfo->lens.focalLength_mm) / (opticInfo->lens.hyperFocalDistance_mm - opticInfo->lens.distanceLens_mm) - DISTANCE_FRONTGLASS_LENS_MM;
			opticInfo->lens.depthOfField_mm			= opticInfo->lens.depthOfFieldFarPos_mm - opticInfo->lens.depthOfFieldNearPos_mm;
		}else{
			opticInfo->lens.depthOfFieldFarPos_mm	= -1; // Means "infinite"
			opticInfo->lens.depthOfField_mm			= -1; // Means "infinite"
		}
		opticInfo->lens.fieldOfView_X_mm			= pixelSize_pxConf_um / 1000 * opticInfo->sensor.maxWidthPx *(opticInfo->lens.distanceLens_mm /opticInfo->lens.focalLength_mm - 1.0);
		opticInfo->lens.fieldOfView_Y_mm			= pixelSize_pxConf_um / 1000 * opticInfo->sensor.maxHeightPx *(opticInfo->lens.distanceLens_mm / opticInfo->lens.focalLength_mm - 1.0);
		opticInfo->lens.resolution_mmPerPx			= opticInfo->lens.fieldOfView_X_mm / opticInfo->sensor.maxWidthPx;
	}else{
		opticInfo->lens.distanceLens_mm				= 0;
		opticInfo->lens.circleOfConfusion_mm		= 0;
		opticInfo->lens.hyperFocalDistance_mm		= 0;
		opticInfo->lens.depthOfFieldNearPos_mm		= 0;
		opticInfo->lens.depthOfFieldFarPos_mm		= 0;
		opticInfo->lens.depthOfField_mm				= 0;
		opticInfo->lens.fieldOfView_X_mm			= 0;
		opticInfo->lens.fieldOfView_Y_mm			= 0;
		opticInfo->lens.resolution_mmPerPx			= 0;
	}

}
