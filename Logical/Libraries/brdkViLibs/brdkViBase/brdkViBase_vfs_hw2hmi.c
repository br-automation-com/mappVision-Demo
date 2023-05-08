
#include <bur/plctypes.h>
#ifdef __cplusplus
	extern "C"
	{
#endif
	#include "brdkViBase.h"
#ifdef __cplusplus
	};
#endif

#include <string.h>

/* Function to convert BLOB hw structure to hmi structrue */
plcbit brdkViBase_blob_hw2hmi(struct brdkViBase_hw_blob_in_typ* hw, struct brdkViBase_hmi_blob_in_typ* hmi)
{
	hmi->anisometry = hw->anisometry;
	hmi->area = hw->area;
	hmi->circularity = hw->circularity;
	hmi->clipped = hw->clipped;
	hmi->innterCirclePositionX = hw->innterCirclePositionX / 100.0;
	hmi->innterCirclePositionY = hw->innterCirclePositionY / 100.0;
	hmi->innterCircleRadius = hw->innterCircleRadius  / 100.0;
	hmi->length = hw->length;
	hmi->meanGreyValue = hw->meanGreyValue;
	hmi->modelNumber = hw->modelNumber;
	hmi->orientation = hw->orientation  / 100.0;
	hmi->positionX = hw->positionX  / 100.0;
	hmi->positionY = hw->positionY  / 100.0;
	hmi->rectangularity = hw->rectangularity;
	hmi->rotCenterX = hw->rotCenterX  / 100.0;
	hmi->rotCenterY = hw->rotCenterY  / 100.0;
	hmi->width = hw->width;
	hmi->xMax = hw->xMax;
	hmi->xMin = hw->xMin;
	hmi->yMax = hw->yMax;
	hmi->yMin = hw->yMin;
	return 1;
}


plcbit brdkViBase_cr_hw2hmi(struct brdkViBase_hw_cr_in_typ* hw, struct brdkViBase_hmi_cr_in_typ* hmi)
{
	hmi->gradingValue = hw->gradingValue;
	strcpy(&hmi->data,&hw->data);
	hmi->symbolType = hw->symbolType;
	itoa(hw->symbolType, hmi->symbolTypeStr, 10);
	
	hmi->orientation = hw->orientation  / 100.0;
	hmi->positionX = hw->positionX  / 100.0;
	hmi->positionY = hw->positionY  / 100.0;
	hmi->rotCenterX = hw->rotCenterX  / 100.0;
	hmi->rotCenterY = hw->rotCenterY  / 100.0;
	return 1;
}

plcbit brdkViBase_match_hw2hmi(struct brdkViBase_hw_match_in_typ* hw, struct brdkViBase_hmi_match_in_typ* hmi)
{
	hmi->modelNumber = hw->modelNumber;
	hmi->scale = hw->scale /100.0;
	hmi->score = hw->score /100.0;
	hmi->orientation = hw->orientation  / 100.0;
	hmi->positionX = hw->positionX  / 100.0;
	hmi->positionY = hw->positionY  / 100.0;
	hmi->rotCenterX = hw->rotCenterX  / 100.0;
	hmi->rotCenterY = hw->rotCenterY  / 100.0;
	return 1;
}

plcbit brdkViBase_meas_hw2hmi(struct brdkViBase_hw_meas_in_typ* hw, struct brdkViBase_hmi_meas_in_typ* hmi)
{
	hmi->result = hw->result;
	return 1;
	
}

plcbit brdkViBase_ocr_hw2hmi(struct brdkViBase_hw_OCR_in_typ* hw, struct brdkViBase_hmi_OCR_in_typ* hmi)
{
	strcpy(&hmi->data,&hw->data);
	hmi->gradingValue = hw->gradingValue;
	hmi->orientation = hw->orientation  / 100.0;
	hmi->positionX = hw->positionX  / 100.0;
	hmi->positionY = hw->positionY  / 100.0;
	return 1;
}

plcbit brdkViBase_pxCnt_hw2hmi(struct brdkViBase_hw_pxCnt_in_typ* hw, struct brdkViBase_hmi_pxCnt_in_typ* hmi)
{
	hmi->modelNumber = hw->modelNumber;
	hmi->deviationGray = hw->deviationGray /100.0;
	hmi->meanGray = hw->meanGray /100.0;
	hmi->maxGray = hw->maxGray;
	hmi->minGray = hw->minGray ;
	hmi->numConnectedComponents = hw->numConnectedComponents;
	hmi->modelArea = hw->modelArea;
	hmi->numPixels = hw->numPixels;
	hmi->medianGray = hw->medianGray;
	hmi->positionX = hw->positionX  / 100.0;
	hmi->positionY = hw->positionY  / 100.0;
	return 1;
}






