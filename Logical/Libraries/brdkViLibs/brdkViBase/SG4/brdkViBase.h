/* Automation Studio generated header file */
/* Do not edit ! */
/* brdkViBase 1.00.5 */

#ifndef _BRDKVIBASE_
#define _BRDKVIBASE_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _brdkViBase_VERSION
#define _brdkViBase_VERSION 1.00.5
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "astime.h"
		#include "standard.h"
		#include "AsIODiag.h"
#endif
#ifdef _SG4
		#include "astime.h"
		#include "standard.h"
		#include "AsIODiag.h"
#endif
#ifdef _SGC
		#include "astime.h"
		#include "standard.h"
		#include "AsIODiag.h"
#endif


/* Constants */
#ifdef _REPLACE_CONST
 #define BRDKVIBASE_CAM_IMG_ERR_INVALID 64U
 #define BRDKVIBASE_CAM_IMG_ERR_FILE 32U
 #define BRDKVIBASE_CAM_IMG_ERR_VF 16U
 #define BRDKVIBASE_CAM_IMG_ERR_LIB 8U
 #define BRDKVIBASE_CAM_IMG_ERR_RUNTIME 4U
 #define BRDKVIBASE_CAM_IMG_ERR_OS_X 2U
 #define BRDKVIBASE_CAM_IMG_ERR_OS 1U
 #define BRDKVIBASE_CAM_LED_SEG_NONE 0U
 #define BRDKVIBASE_CAM_LED_SEG_ALL 15U
 #define BRDKVIBASE_CAM_STATUS_RED 1U
 #define BRDKVIBASE_CAM_STATUS_BLUE 3U
 #define BRDKVIBASE_CAM_STATUS_GREEN 2U
 #define BRDKVIBASE_CAM_STATUS_NONE 0U
 #define BRDKVIBASE_CAM_LED_RED 1U
 #define BRDKVIBASE_CAM_LED_BLUE 3U
 #define BRDKVIBASE_CAM_LED_GREEN 2U
 #define BRDKVIBASE_CAM_LED_NONE 0U
 #define BRDKVIBASE_CAM_LED_LIME 4U
 #define BRDKVIBASE_CAM_LED_WHITE 99U
 #define BRDKVIBASE_CAM_LED_UV 0U
 #define BRDKVIBASE_CAM_LED_IR 100U
 #define BRDKVIBASE_ERR_INVALID_POINT 3104U
#else
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_IMG_ERR_INVALID;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_IMG_ERR_FILE;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_IMG_ERR_VF;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_IMG_ERR_LIB;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_IMG_ERR_RUNTIME;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_IMG_ERR_OS_X;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_IMG_ERR_OS;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_LED_SEG_NONE;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_LED_SEG_ALL;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_STATUS_RED;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_STATUS_BLUE;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_STATUS_GREEN;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_STATUS_NONE;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_LED_RED;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_LED_BLUE;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_LED_GREEN;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_LED_NONE;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_LED_LIME;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_LED_WHITE;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_LED_UV;
 _GLOBAL_CONST unsigned char BRDKVIBASE_CAM_LED_IR;
 _GLOBAL_CONST unsigned short BRDKVIBASE_ERR_INVALID_POINT;
#endif




/* Datatypes and datatypes of function blocks */
typedef enum brdkViBase_angle_enum
{	BRDKVIBASE_ANGLE_X,
	BRDKVIBASE_ANGLE_Y,
	BRDKVIBASE_ANGLE_Z
} brdkViBase_angle_enum;

typedef enum BRDKVIBASE_PX_CONFIG_ENM
{	BRDKVIBASE_PX_CONFIG_STANDARD = 0,
	BRDKVIBASE_PX_CONFIG_BINNING = 1,
	BRDKVIBASE_PX_CONFIG_SUBSAMPLING = 2
} BRDKVIBASE_PX_CONFIG_ENM;

typedef enum BRDKVIBASE_CPU_ENM
{	BRDKVIBASE_CPU_1_DUAL = 0,
	BRDKVIBASE_CPU_2_QUAD = 1
} BRDKVIBASE_CPU_ENM;

typedef enum BRDKVIBASE_SENSOR_TYPE_ENM
{	BRDKVIBASE_SENSOR_1_3_MP = 0,
	BRDKVIBASE_SENSOR_1_3_MP_LINE = 1,
	BRDKVIBASE_SENSOR_3_5_MP = 2,
	BRDKVIBASE_SENSOR_5_3_MP_LINE = 3
} BRDKVIBASE_SENSOR_TYPE_ENM;

typedef enum BRDKVIBASE_LED_LENS_ENM
{	BRDKVIBASE_LED_LENS_0_NONE = 0,
	BRDKVIBASE_LED_LENS_1_WIDE = 1,
	BRDKVIBASE_LED_LENS_2_STANDARD = 2,
	BRDKVIBASE_LED_LENS_3_WIDE = 3
} BRDKVIBASE_LED_LENS_ENM;

typedef enum BRDKVIBASE_LENS_ENM
{	BRDKVIBASE_LENS_C_MOUNT = 0,
	BRDKVIBASE_LENS_4_6 = 1,
	BRDKVIBASE_LENS_6_0 = 2,
	BRDKVIBASE_LENS_8_0 = 3,
	BRDKVIBASE_LENS_12_0 = 4,
	BRDKVIBASE_LENS_12_0_MACRO = 5,
	BRDKVIBASE_LENS_16_0 = 6,
	BRDKVIBASE_LENS_25_0 = 7
} BRDKVIBASE_LENS_ENM;

typedef enum BRDKVIBASE_LED_COLOR_ENM
{	BRDKVIBASE_LED_COLOR_0_NONE = 0,
	BRDKVIBASE_LED_COLOR_3_BLUE = 1,
	BRDKVIBASE_LED_COLOR_8_RED = 2,
	BRDKVIBASE_LED_COLOR_A_UV = 3,
	BRDKVIBASE_LED_COLOR_D_IR = 4,
	BRDKVIBASE_LED_COLOR_F_W = 5,
	BRDKVIBASE_LED_COLOR_Q_RGBL = 6,
	BRDKVIBASE_LED_COLOR_R_RBIRW = 7
} BRDKVIBASE_LED_COLOR_ENM;

typedef struct brdkViBase_hw_in_common_typ
{	unsigned long hardwareVariant;
	unsigned long moduleId;
	unsigned long firmwareVersion;
	unsigned long serialNumber;
	plcbit moduleOk;
} brdkViBase_hw_in_common_typ;

typedef struct brdkViBase_2d_typ
{	double y;
	double x;
} brdkViBase_2d_typ;

typedef struct brdkViBase_3d_typ
{	double y;
	double z;
	double x;
} brdkViBase_3d_typ;

typedef struct brdkViBase_cam_recipe_typ
{	unsigned char gainLevel;
	unsigned short focus;
	unsigned long exposureTime;
	unsigned char flashColor;
	unsigned char flashSegment;
	plcbit chromaticLock;
} brdkViBase_cam_recipe_typ;

typedef struct brdkViBase_getCameraInfo_int_typ
{	struct DiagGetNumInfo diagGetNumInfo_0;
	struct DiagGetStrInfo diagGetStrInfo_0;
	struct DiagCreateInfo diagCreateInfo_0;
	unsigned long index;
	plcstring path[257];
	unsigned char state;
	struct DiagDisposeInfo diagDisposeInfo_0;
} brdkViBase_getCameraInfo_int_typ;

typedef struct brdkViBase_camInfo_typ
{	enum BRDKVIBASE_LED_COLOR_ENM LED_color;
	enum BRDKVIBASE_LED_LENS_ENM LED_lens;
	enum BRDKVIBASE_CPU_ENM cpu;
	enum BRDKVIBASE_LENS_ENM lens;
	enum BRDKVIBASE_SENSOR_TYPE_ENM sensor;
	enum BRDKVIBASE_PX_CONFIG_ENM pixelConfiguration;
	plcstring orderNr[21];
	float distance;
} brdkViBase_camInfo_typ;

typedef struct brdkViBase_cam_info_sensor_typ
{	unsigned long maxHeightPx;
	unsigned long maxWidthPx;
	float pixelSize_um;
} brdkViBase_cam_info_sensor_typ;

typedef struct brdkViBase_cam_info_lens_typ
{	float focalLength_mm;
	float maxObjectDist_mm;
	float minObjectDist_mm;
	float aperture;
	plcbit validDistance;
	float distanceLens_mm;
	float circleOfConfusion_mm;
	float hyperFocalDistance_mm;
	float depthOfFieldNearPos_mm;
	float depthOfFieldFarPos_mm;
	float depthOfField_mm;
	float fieldOfView_X_mm;
	float fieldOfView_Y_mm;
	float resolution_mmPerPx;
} brdkViBase_cam_info_lens_typ;

typedef struct brdkViBase_opticInfo_typ
{	struct brdkViBase_cam_info_sensor_typ sensor;
	struct brdkViBase_cam_info_lens_typ lens;
} brdkViBase_opticInfo_typ;

typedef struct brdkViBase_cam_hw_out_par_typ
{	unsigned char statusLED;
	unsigned char gainLevel;
	unsigned short focus;
	unsigned long exposureTime;
	unsigned char flashColor;
	unsigned char flashSegment;
	plcbit chromaticLock;
	plcbit IRFilter;
	signed long delayNetTime;
	signed long cyclicLineScanPeriod;
	signed long cyclicLineScanNettime;
} brdkViBase_cam_hw_out_par_typ;

typedef struct brdkViBase_cam_hw_out_cmd_typ
{	plcbit imageAcquisition;
	plcbit resetAcquisiton;
	plcbit searchAcquisitonSettings;
	plcbit digitalOutput;
} brdkViBase_cam_hw_out_cmd_typ;

typedef struct brdkViBase_cam_hw_out_typ
{	struct brdkViBase_cam_hw_out_par_typ par;
	struct brdkViBase_cam_hw_out_cmd_typ cmd;
} brdkViBase_cam_hw_out_typ;

typedef struct brdkViBase_cam_hw_in_status_typ
{	signed char sensorTemperature;
	unsigned char lightWarningCnt;
	unsigned long cameraStatus;
	unsigned char acceptedAcquisitionCnt;
	unsigned char completedAcquisitionCnt;
	unsigned char failedAcquisitionCnt;
	plcbit undervoltageError;
	plcbit imageAcquisitionReady;
	plcbit imageProcessingActive;
	plcbit digitalOutputStatus;
	unsigned short cameraProcessingTime;
	unsigned short imageProcessingError;
	signed long imageNettime;
	plcbit digitalInput;
	unsigned char gainLevel;
	unsigned short focus;
	unsigned long exposureTime;
} brdkViBase_cam_hw_in_status_typ;

typedef struct brdkViBase_cam_hw_in_typ
{	struct brdkViBase_hw_in_common_typ common;
	struct brdkViBase_cam_hw_in_status_typ status;
} brdkViBase_cam_hw_in_typ;

typedef struct brdkViBase_cam_hw_typ
{	struct brdkViBase_cam_hw_in_typ in;
	struct brdkViBase_cam_hw_out_typ out;
} brdkViBase_cam_hw_typ;

typedef struct brdkViBase_light_hw_out_cmd_typ
{	plcbit flashTrigger;
	plcbit resetFlashTrigger;
} brdkViBase_light_hw_out_cmd_typ;

typedef struct brdkViBase_light_hw_out_par_typ
{	unsigned char flashColor;
	unsigned long exposureTime;
	unsigned char flashAngle;
	unsigned char flashSegments;
	signed long cyclicLineScanPeriod;
	signed long cyclicLineScanNettime;
	signed long nettime;
} brdkViBase_light_hw_out_par_typ;

typedef struct brdkViBase_light_hw_out_typ
{	struct brdkViBase_light_hw_out_cmd_typ cmd;
	struct brdkViBase_light_hw_out_par_typ par;
} brdkViBase_light_hw_out_typ;

typedef struct brdkViBase_light_hw_status_typ
{	plcbit ready;
	unsigned long status;
	unsigned char acceptedFlashCnt;
	unsigned char completedFlashCnt;
	unsigned char failedFlashCnt;
	unsigned char LightWarningCnt;
	signed char sensorTemperature;
} brdkViBase_light_hw_status_typ;

typedef struct brdkViBase_light_hw_in_typ
{	struct brdkViBase_hw_in_common_typ common;
	struct brdkViBase_light_hw_status_typ status;
} brdkViBase_light_hw_in_typ;

typedef struct brdkViBase_light_hw_typ
{	struct brdkViBase_light_hw_in_typ in;
	struct brdkViBase_light_hw_out_typ out;
} brdkViBase_light_hw_typ;

typedef struct brdkviBase_hw_vf_out_offset_typ
{	signed long x;
	signed long y;
	signed short orientation;
	signed long rotCenterX;
	signed long rotCenterY;
} brdkviBase_hw_vf_out_offset_typ;

typedef struct brdkViBase_hw_vf_in_common_typ
{	unsigned char numResults;
	unsigned short functionProcessingTime;
} brdkViBase_hw_vf_in_common_typ;

typedef struct brdkViBase_hw_vf_out_common_typ
{	plcbit enable;
	unsigned char numSearchMax;
	unsigned char alignment;
	struct brdkviBase_hw_vf_out_offset_typ offsetROI;
} brdkViBase_hw_vf_out_common_typ;

typedef struct brdkViBase_hw_blob_out_typ
{	plcbit regionFeatures;
	plcbit enhancedBlobInformation;
	struct brdkViBase_hw_vf_out_common_typ common;
} brdkViBase_hw_blob_out_typ;

typedef struct brdkViBase_hw_blob_in_typ
{	unsigned char modelNumber;
	unsigned char meanGreyValue;
	plcbit clipped;
	unsigned long area;
	unsigned long length;
	unsigned long width;
	signed long xMin;
	signed long xMax;
	signed long yMin;
	signed long yMax;
	unsigned char circularity;
	unsigned char rectangularity;
	unsigned short anisometry;
	signed long innterCirclePositionX;
	signed long innterCirclePositionY;
	unsigned long innterCircleRadius;
	signed long positionX;
	signed long positionY;
	signed short orientation;
	signed long rotCenterX;
	signed long rotCenterY;
} brdkViBase_hw_blob_in_typ;

typedef struct brdkViBase_hw_blob_1_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_blob_in_typ results;
} brdkViBase_hw_blob_1_in_typ;

typedef struct brdkViBase_hw_blob_1_typ
{	struct brdkViBase_hw_blob_1_in_typ in;
	struct brdkViBase_hw_blob_out_typ out;
} brdkViBase_hw_blob_1_typ;

typedef struct brdkViBase_hw_blob_10_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_blob_in_typ results[10];
} brdkViBase_hw_blob_10_in_typ;

typedef struct brdkViBase_hw_blob_10_typ
{	struct brdkViBase_hw_blob_10_in_typ in;
	struct brdkViBase_hw_blob_out_typ out;
} brdkViBase_hw_blob_10_typ;

typedef struct brdkViBase_hw_blob_50_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_blob_in_typ results[50];
} brdkViBase_hw_blob_50_in_typ;

typedef struct brdkViBase_hw_blob_50_typ
{	struct brdkViBase_hw_blob_10_in_typ in;
	struct brdkViBase_hw_blob_out_typ out;
} brdkViBase_hw_blob_50_typ;

typedef struct brdkViBase_hw_blob_100_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_blob_in_typ results[100];
} brdkViBase_hw_blob_100_in_typ;

typedef struct brdkViBase_hw_blob_100_typ
{	struct brdkViBase_hw_blob_100_in_typ in;
	struct brdkViBase_hw_blob_out_typ out;
} brdkViBase_hw_blob_100_typ;

typedef struct brdkViBase_hw_blob_150_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_blob_in_typ results[150];
} brdkViBase_hw_blob_150_in_typ;

typedef struct brdkViBase_hw_blob_150_typ
{	struct brdkViBase_hw_blob_150_in_typ in;
	struct brdkViBase_hw_blob_out_typ out;
} brdkViBase_hw_blob_150_typ;

typedef struct brdkViBase_hw_blob_200_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_blob_in_typ results[200];
} brdkViBase_hw_blob_200_in_typ;

typedef struct brdkViBase_hw_blob_200_typ
{	struct brdkViBase_hw_blob_200_in_typ in;
	struct brdkViBase_hw_blob_out_typ out;
} brdkViBase_hw_blob_200_typ;

typedef struct brdkViBase_hw_blob_250_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_blob_in_typ results[250];
} brdkViBase_hw_blob_250_in_typ;

typedef struct brdkViBase_hw_blob_250_typ
{	struct brdkViBase_hw_blob_250_in_typ in;
	struct brdkViBase_hw_blob_out_typ out;
} brdkViBase_hw_blob_250_typ;

typedef struct brdkViBase_hw_match_out_typ
{	unsigned short timeout;
	unsigned char minScore;
	unsigned char maxOverlap;
	struct brdkViBase_hw_vf_out_common_typ common;
} brdkViBase_hw_match_out_typ;

typedef struct brdkViBase_hw_match_in_typ
{	unsigned char modelNumber;
	unsigned char score;
	unsigned char scale;
	signed long positionX;
	signed long positionY;
	signed short orientation;
	signed long rotCenterX;
	signed long rotCenterY;
} brdkViBase_hw_match_in_typ;

typedef struct brdkViBase_hw_match_1_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_match_in_typ results;
} brdkViBase_hw_match_1_in_typ;

typedef struct brdkViBase_hw_match_1_typ
{	struct brdkViBase_hw_match_1_in_typ in;
	struct brdkViBase_hw_match_out_typ out;
} brdkViBase_hw_match_1_typ;

typedef struct brdkViBase_hw_match_10_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_match_in_typ results[10];
} brdkViBase_hw_match_10_in_typ;

typedef struct brdkViBase_hw_match_10_typ
{	struct brdkViBase_hw_match_10_in_typ in;
	struct brdkViBase_hw_match_out_typ out;
} brdkViBase_hw_match_10_typ;

typedef struct brdkViBase_hw_match_50_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_match_in_typ results[50];
} brdkViBase_hw_match_50_in_typ;

typedef struct brdkViBase_hw_match_50_typ
{	struct brdkViBase_hw_match_50_in_typ in;
	struct brdkViBase_hw_match_out_typ out;
} brdkViBase_hw_match_50_typ;

typedef struct brdkViBase_hw_match_100_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_match_in_typ results[100];
} brdkViBase_hw_match_100_in_typ;

typedef struct brdkViBase_hw_match_100_typ
{	struct brdkViBase_hw_match_100_in_typ in;
	struct brdkViBase_hw_match_out_typ out;
} brdkViBase_hw_match_100_typ;

typedef struct brdkViBase_hw_match_150_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_match_in_typ results[150];
} brdkViBase_hw_match_150_in_typ;

typedef struct brdkViBase_hw_match_150_typ
{	struct brdkViBase_hw_match_150_in_typ in;
	struct brdkViBase_hw_match_out_typ out;
} brdkViBase_hw_match_150_typ;

typedef struct brdkViBase_hw_match_200_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_match_in_typ results[200];
} brdkViBase_hw_match_200_in_typ;

typedef struct brdkViBase_hw_match_200_typ
{	struct brdkViBase_hw_match_200_in_typ in;
	struct brdkViBase_hw_match_out_typ out;
} brdkViBase_hw_match_200_typ;

typedef struct brdkViBase_hw_match_250_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_match_in_typ results[250];
} brdkViBase_hw_match_250_in_typ;

typedef struct brdkViBase_hw_match_250_typ
{	struct brdkViBase_hw_match_250_in_typ in;
	struct brdkViBase_hw_match_out_typ out;
} brdkViBase_hw_match_250_typ;

typedef struct brdkViBase_hw_OCR_out_typ
{	unsigned short timeout;
	unsigned char parameterMode;
	plcbit grading;
	struct brdkViBase_hw_vf_out_common_typ common;
} brdkViBase_hw_OCR_out_typ;

typedef struct brdkViBase_hw_OCR_in_typ
{	unsigned char data[50];
	unsigned char gradingValue;
	signed long positionX;
	signed long positionY;
	signed short orientation;
} brdkViBase_hw_OCR_in_typ;

typedef struct brdkViBase_hw_OCR_1_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_OCR_in_typ results;
} brdkViBase_hw_OCR_1_in_typ;

typedef struct brdkViBase_hw_OCR_1_typ
{	struct brdkViBase_hw_OCR_1_in_typ in;
	struct brdkViBase_hw_OCR_out_typ out;
} brdkViBase_hw_OCR_1_typ;

typedef struct brdkViBase_hw_OCR_10_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_OCR_in_typ results[10];
} brdkViBase_hw_OCR_10_in_typ;

typedef struct brdkViBase_hw_OCR_10_typ
{	struct brdkViBase_hw_OCR_10_in_typ in;
	struct brdkViBase_hw_OCR_out_typ out;
} brdkViBase_hw_OCR_10_typ;

typedef struct brdkViBase_hw_OCR_50_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_OCR_in_typ results[50];
} brdkViBase_hw_OCR_50_in_typ;

typedef struct brdkViBase_hw_OCR_50_typ
{	struct brdkViBase_hw_OCR_50_in_typ in;
	struct brdkViBase_hw_OCR_out_typ out;
} brdkViBase_hw_OCR_50_typ;

typedef struct brdkViBase_hw_OCR_100_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_OCR_in_typ results[100];
} brdkViBase_hw_OCR_100_in_typ;

typedef struct brdkViBase_hw_OCR_100_typ
{	struct brdkViBase_hw_OCR_100_in_typ in;
	struct brdkViBase_hw_OCR_out_typ out;
} brdkViBase_hw_OCR_100_typ;

typedef struct brdkViBase_hw_OCR_150_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_OCR_in_typ results[150];
} brdkViBase_hw_OCR_150_in_typ;

typedef struct brdkViBase_hw_OCR_150_typ
{	struct brdkViBase_hw_OCR_150_in_typ in;
	struct brdkViBase_hw_OCR_out_typ out;
} brdkViBase_hw_OCR_150_typ;

typedef struct brdkViBase_hw_OCR_200_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_OCR_in_typ results[200];
} brdkViBase_hw_OCR_200_in_typ;

typedef struct brdkViBase_hw_OCR_200_typ
{	struct brdkViBase_hw_OCR_200_in_typ in;
	struct brdkViBase_hw_OCR_out_typ out;
} brdkViBase_hw_OCR_200_typ;

typedef struct brdkViBase_hw_OCR_250_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_OCR_in_typ results[250];
} brdkViBase_hw_OCR_250_in_typ;

typedef struct brdkViBase_hw_OCR_250_typ
{	struct brdkViBase_hw_OCR_250_in_typ in;
	struct brdkViBase_hw_OCR_out_typ out;
} brdkViBase_hw_OCR_250_typ;

typedef struct brdkViBase_hw_pxCnt_out_typ
{	plcbit enhancedPXInformation;
	struct brdkViBase_hw_vf_out_common_typ common;
} brdkViBase_hw_pxCnt_out_typ;

typedef struct brdkViBase_hw_pxCnt_in_typ
{	unsigned char modelNumber;
	unsigned long numPixels;
	unsigned char minGray;
	unsigned char maxGray;
	unsigned short meanGray;
	unsigned short deviationGray;
	unsigned char medianGray;
	unsigned long modelArea;
	unsigned short numConnectedComponents;
	signed long positionX;
	signed long positionY;
} brdkViBase_hw_pxCnt_in_typ;

typedef struct brdkViBase_hw_pxCnt_1_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_pxCnt_in_typ results;
} brdkViBase_hw_pxCnt_1_in_typ;

typedef struct brdkViBase_hw_pxCnt_1_typ
{	struct brdkViBase_hw_pxCnt_1_in_typ in;
	struct brdkViBase_hw_pxCnt_out_typ out;
} brdkViBase_hw_pxCnt_1_typ;

typedef struct brdkViBase_hw_pxCnt_10_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_pxCnt_in_typ results[10];
} brdkViBase_hw_pxCnt_10_in_typ;

typedef struct brdkViBase_hw_pxCnt_10_typ
{	struct brdkViBase_hw_pxCnt_10_in_typ in;
	struct brdkViBase_hw_pxCnt_out_typ out;
} brdkViBase_hw_pxCnt_10_typ;

typedef struct brdkViBase_hw_pxCnt_50_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_pxCnt_in_typ results[50];
} brdkViBase_hw_pxCnt_50_in_typ;

typedef struct brdkViBase_hw_pxCnt_50_typ
{	struct brdkViBase_hw_pxCnt_50_in_typ in;
	struct brdkViBase_hw_pxCnt_out_typ out;
} brdkViBase_hw_pxCnt_50_typ;

typedef struct brdkViBase_hw_pxCnt_100_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_pxCnt_in_typ results[100];
} brdkViBase_hw_pxCnt_100_in_typ;

typedef struct brdkViBase_hw_pxCnt_100_typ
{	struct brdkViBase_hw_pxCnt_100_in_typ in;
	struct brdkViBase_hw_pxCnt_out_typ out;
} brdkViBase_hw_pxCnt_100_typ;

typedef struct brdkViBase_hw_pxCnt_150_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_pxCnt_in_typ results[150];
} brdkViBase_hw_pxCnt_150_in_typ;

typedef struct brdkViBase_hw_pxCnt_150_typ
{	struct brdkViBase_hw_pxCnt_150_in_typ in;
	struct brdkViBase_hw_pxCnt_out_typ out;
} brdkViBase_hw_pxCnt_150_typ;

typedef struct brdkViBase_hw_pxCnt_200_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_pxCnt_in_typ results[200];
} brdkViBase_hw_pxCnt_200_in_typ;

typedef struct brdkViBase_hw_pxCnt_200_typ
{	struct brdkViBase_hw_pxCnt_200_in_typ in;
	struct brdkViBase_hw_pxCnt_out_typ out;
} brdkViBase_hw_pxCnt_200_typ;

typedef struct brdkViBase_hw_pxCnt_250_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_pxCnt_in_typ results[250];
} brdkViBase_hw_pxCnt_250_in_typ;

typedef struct brdkViBase_hw_pxCnt_250_typ
{	struct brdkViBase_hw_pxCnt_250_in_typ in;
	struct brdkViBase_hw_pxCnt_out_typ out;
} brdkViBase_hw_pxCnt_250_typ;

typedef struct brdkViBase_hw_mes_out_typ
{	struct brdkViBase_hw_vf_out_common_typ common;
} brdkViBase_hw_mes_out_typ;

typedef struct brdkViBase_hw_mes_in_typ
{	signed long result;
} brdkViBase_hw_mes_in_typ;

typedef struct brdkViBase_hw_mes_1_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_mes_in_typ results;
} brdkViBase_hw_mes_1_in_typ;

typedef struct brdkViBase_hw_mes_1_typ
{	struct brdkViBase_hw_mes_1_in_typ in;
	struct brdkViBase_hw_mes_out_typ out;
} brdkViBase_hw_mes_1_typ;

typedef struct brdkViBase_hw_mes_10_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_mes_in_typ results[10];
} brdkViBase_hw_mes_10_in_typ;

typedef struct brdkViBase_hw_mes_10_typ
{	struct brdkViBase_hw_mes_10_in_typ in;
	struct brdkViBase_hw_mes_out_typ out;
} brdkViBase_hw_mes_10_typ;

typedef struct brdkViBase_hw_mes_50_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_mes_in_typ results[50];
} brdkViBase_hw_mes_50_in_typ;

typedef struct brdkViBase_hw_mes_50_typ
{	struct brdkViBase_hw_mes_50_in_typ in;
	struct brdkViBase_hw_mes_out_typ out;
} brdkViBase_hw_mes_50_typ;

typedef struct brdkViBase_hw_mes_100_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_mes_in_typ results[100];
} brdkViBase_hw_mes_100_in_typ;

typedef struct brdkViBase_hw_mes_100_typ
{	struct brdkViBase_hw_mes_100_in_typ in;
	struct brdkViBase_hw_mes_out_typ out;
} brdkViBase_hw_mes_100_typ;

typedef struct brdkViBase_hw_mes_150_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_mes_in_typ results[150];
} brdkViBase_hw_mes_150_in_typ;

typedef struct brdkViBase_hw_mes_150_typ
{	struct brdkViBase_hw_mes_150_in_typ in;
	struct brdkViBase_hw_mes_out_typ out;
} brdkViBase_hw_mes_150_typ;

typedef struct brdkViBase_hw_mes_200_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_mes_in_typ results[200];
} brdkViBase_hw_mes_200_in_typ;

typedef struct brdkViBase_hw_mes_200_typ
{	struct brdkViBase_hw_mes_200_in_typ in;
	struct brdkViBase_hw_mes_out_typ out;
} brdkViBase_hw_mes_200_typ;

typedef struct brdkViBase_hw_mes_250_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_mes_in_typ results[250];
} brdkViBase_hw_mes_250_in_typ;

typedef struct brdkViBase_hw_mes_250_typ
{	struct brdkViBase_hw_mes_250_in_typ in;
	struct brdkViBase_hw_mes_out_typ out;
} brdkViBase_hw_mes_250_typ;

typedef struct brdkViBase_hw_cr_out_typ
{	unsigned short timeout;
	unsigned char parameterOptimization;
	unsigned char parameterMode;
	plcbit codeGrading;
	unsigned char symbolType;
	plcbit enableRobustness;
	struct brdkViBase_hw_vf_out_common_typ common;
} brdkViBase_hw_cr_out_typ;

typedef struct brdkViBase_hw_cr_in_typ
{	unsigned char data[50];
	unsigned char symbolType;
	plcbit gradingValue;
	plcstring enhancedGradingInformation[24];
	signed long positionX;
	signed long positionY;
	signed short orientation;
	signed long rotCenterX;
	signed long rotCenterY;
} brdkViBase_hw_cr_in_typ;

typedef struct brdkViBase_hw_cr_1_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_cr_in_typ results;
} brdkViBase_hw_cr_1_in_typ;

typedef struct brdkViBase_hw_cr_1_typ
{	struct brdkViBase_hw_cr_1_in_typ in;
	struct brdkViBase_hw_cr_out_typ out;
} brdkViBase_hw_cr_1_typ;

typedef struct brdkViBase_hw_cr_10_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_cr_in_typ results[10];
} brdkViBase_hw_cr_10_in_typ;

typedef struct brdkViBase_hw_cr_10_typ
{	struct brdkViBase_hw_cr_10_in_typ in;
	struct brdkViBase_hw_cr_out_typ out;
} brdkViBase_hw_cr_10_typ;

typedef struct brdkViBase_hw_cr_50_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_cr_in_typ results[50];
} brdkViBase_hw_cr_50_in_typ;

typedef struct brdkViBase_hw_cr_50_typ
{	struct brdkViBase_hw_cr_50_in_typ in;
	struct brdkViBase_hw_cr_out_typ out;
} brdkViBase_hw_cr_50_typ;

typedef struct brdkViBase_hw_cr_100_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_cr_in_typ results[100];
} brdkViBase_hw_cr_100_in_typ;

typedef struct brdkViBase_hw_cr_100_typ
{	struct brdkViBase_hw_cr_100_in_typ in;
	struct brdkViBase_hw_cr_out_typ out;
} brdkViBase_hw_cr_100_typ;

typedef struct brdkViBase_hw_cr_150_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_cr_in_typ results[150];
} brdkViBase_hw_cr_150_in_typ;

typedef struct brdkViBase_hw_cr_150_typ
{	struct brdkViBase_hw_cr_150_in_typ in;
	struct brdkViBase_hw_cr_out_typ out;
} brdkViBase_hw_cr_150_typ;

typedef struct brdkViBase_hw_cr_200_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_cr_in_typ results[200];
} brdkViBase_hw_cr_200_in_typ;

typedef struct brdkViBase_hw_cr_200_typ
{	struct brdkViBase_hw_cr_200_in_typ in;
	struct brdkViBase_hw_cr_out_typ out;
} brdkViBase_hw_cr_200_typ;

typedef struct brdkViBase_hw_cr_250_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_cr_in_typ results[250];
} brdkViBase_hw_cr_250_in_typ;

typedef struct brdkViBase_hw_cr_250_typ
{	struct brdkViBase_hw_cr_250_in_typ in;
	struct brdkViBase_hw_cr_out_typ out;
} brdkViBase_hw_cr_250_typ;

typedef struct brdkViBase_hw_subBlob_out_typ
{	plcbit regionFeatures;
	plcbit enhancedBlobInformation;
	struct brdkViBase_hw_vf_out_common_typ common;
} brdkViBase_hw_subBlob_out_typ;

typedef struct brdkViBase_hw_subBlob_in_typ
{	unsigned char modelNumber;
	unsigned char meanGreyValue;
	plcbit clipped;
	unsigned long area;
	unsigned long length;
	unsigned long width;
	signed long xMin;
	signed long xMax;
	signed long yMin;
	signed long yMax;
	unsigned char circularity;
	unsigned char rectangularity;
	unsigned short anisometry;
	signed long innterCirclePositionX;
	signed long innterCirclePositionY;
	unsigned long innterCircleRadius;
	signed long positionX;
	signed long positionY;
	signed short orientation;
	signed long rotCenterX;
	signed long rotCenterY;
} brdkViBase_hw_subBlob_in_typ;

typedef struct brdkViBase_hw_subBlob_1_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_subBlob_in_typ results;
} brdkViBase_hw_subBlob_1_in_typ;

typedef struct brdkViBase_hw_subBlob_1_typ
{	struct brdkViBase_hw_subBlob_1_in_typ in;
	struct brdkViBase_hw_subBlob_out_typ out;
} brdkViBase_hw_subBlob_1_typ;

typedef struct brdkViBase_hw_subBlob_10_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_subBlob_in_typ results[10];
} brdkViBase_hw_subBlob_10_in_typ;

typedef struct brdkViBase_hw_subBlob_10_typ
{	struct brdkViBase_hw_subBlob_10_in_typ in;
	struct brdkViBase_hw_subBlob_out_typ out;
} brdkViBase_hw_subBlob_10_typ;

typedef struct brdkViBase_hw_subBlob_50_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_subBlob_in_typ results[50];
} brdkViBase_hw_subBlob_50_in_typ;

typedef struct brdkViBase_hw_subBlob_50_typ
{	struct brdkViBase_hw_subBlob_50_in_typ in;
	struct brdkViBase_hw_subBlob_out_typ out;
} brdkViBase_hw_subBlob_50_typ;

typedef struct brdkViBase_hw_subBlob_100_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_subBlob_in_typ results[100];
} brdkViBase_hw_subBlob_100_in_typ;

typedef struct brdkViBase_hw_subBlob_100_typ
{	struct brdkViBase_hw_subBlob_100_in_typ in;
	struct brdkViBase_hw_subBlob_out_typ out;
} brdkViBase_hw_subBlob_100_typ;

typedef struct brdkViBase_hw_subBlob_150_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_subBlob_in_typ results[150];
} brdkViBase_hw_subBlob_150_in_typ;

typedef struct brdkViBase_hw_subBlob_150_typ
{	struct brdkViBase_hw_subBlob_150_in_typ in;
	struct brdkViBase_hw_subBlob_out_typ out;
} brdkViBase_hw_subBlob_150_typ;

typedef struct brdkViBase_hw_subBlob_200_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_subBlob_in_typ results[200];
} brdkViBase_hw_subBlob_200_in_typ;

typedef struct brdkViBase_hw_subBlob_200_typ
{	struct brdkViBase_hw_subBlob_200_in_typ in;
	struct brdkViBase_hw_subBlob_out_typ out;
} brdkViBase_hw_subBlob_200_typ;

typedef struct brdkViBase_hw_subBlob_250_in_typ
{	struct brdkViBase_hw_vf_in_common_typ common;
	struct brdkViBase_hw_subBlob_in_typ results[250];
} brdkViBase_hw_subBlob_250_in_typ;

typedef struct brdkViBase_hw_subBlob_250_typ
{	struct brdkViBase_hw_subBlob_250_in_typ in;
	struct brdkViBase_hw_subBlob_out_typ out;
} brdkViBase_hw_subBlob_250_typ;

typedef struct brdkViBase_imgTrigger_sim_typ
{	plcbit enable;
	plctime imgProcessingDelay;
	plcbit alwaysSimulateNonePresentCamera;
	plcbit alwaysSimulateNonePresentLights;
} brdkViBase_imgTrigger_sim_typ;

typedef struct brdkViBase_imgTrigger_local_typ
{	unsigned char state;
	signed long oldNettime;
	unsigned char oldAccCnt;
	plcbit initDone;
	plcbit triggerActive;
	struct TON simDelay;
	plcbit waitForImage;
} brdkViBase_imgTrigger_local_typ;

typedef struct brdkViBase_simCam_internal_typ
{	unsigned char imgCnt;
	unsigned char cnt;
	signed long procNettime;
	signed long triggerNettime;
	unsigned char procState;
	unsigned char state;
	plcbit searchDone;
} brdkViBase_simCam_internal_typ;

typedef struct brdkViBase_getCameraInfo
{
	/* VAR_INPUT (analog) */
	unsigned long pDevicePath;
	struct brdkViBase_camInfo_typ* pInfo;
	/* VAR_OUTPUT (analog) */
	unsigned short status;
	/* VAR (analog) */
	struct brdkViBase_getCameraInfo_int_typ internal;
	/* VAR_INPUT (digital) */
	plcbit execute;
	plcbit errorReset;
} brdkViBase_getCameraInfo_typ;

typedef struct brdkViBase_imgTrigger
{
	/* VAR_INPUT (analog) */
	struct brdkViBase_cam_hw_typ* pCameraHw;
	unsigned char numLights;
	struct brdkViBase_light_hw_typ* pLightHw;
	signed long delayNettime;
	struct brdkViBase_imgTrigger_sim_typ simulate;
	/* VAR_OUTPUT (analog) */
	unsigned long imageResultCnt;
	unsigned long triggerCnt;
	/* VAR (analog) */
	struct brdkViBase_imgTrigger_local_typ internal;
	/* VAR_INPUT (digital) */
	plcbit searchAcquisitonSettings;
	plcbit useCamColorForLight;
	plcbit useCamExpTimeForLight;
	plcbit trigger;
	/* VAR_OUTPUT (digital) */
	plcbit newImage;
	plcbit searchAcquisitonSettingsDone;
	plcbit ready;
	plcbit hwError;
	plcbit busy;
} brdkViBase_imgTrigger_typ;

typedef struct brdkViBase_simCam
{
	/* VAR_INPUT (analog) */
	struct brdkViBase_cam_hw_typ* pCamHw;
	unsigned char triggerConf;
	signed long cameraProcessingTime;
	signed long nettime;
	/* VAR_OUTPUT (analog) */
	unsigned short status;
	/* VAR (analog) */
	struct brdkViBase_simCam_internal_typ internal;
} brdkViBase_simCam_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void brdkViBase_getCameraInfo(struct brdkViBase_getCameraInfo* inst);
_BUR_PUBLIC void brdkViBase_imgTrigger(struct brdkViBase_imgTrigger* inst);
_BUR_PUBLIC void brdkViBase_simCam(struct brdkViBase_simCam* inst);
_BUR_PUBLIC plcbit brdkViBase_calcOpticInfo(struct brdkViBase_camInfo_typ* camInfo, struct brdkViBase_opticInfo_typ* opticInfo);
_BUR_PUBLIC plcbit brdkViBase_camStatusToString(unsigned long status, unsigned long pString);
_BUR_PUBLIC double brdkViBase_deg2rad(double deg);
_BUR_PUBLIC double brdkViBase_distance(double x1, double y1, double x2, double y2);
_BUR_PUBLIC plcbit brdkViBase_dateTimeToString(plcdt date, plcstring* format, unsigned long pStr);
_BUR_PUBLIC plcbit brdkViBase_initRand(unsigned long seed);
_BUR_PUBLIC unsigned long brdkViBase_LEDIntensity(unsigned char LEDLenseType, unsigned short distance, unsigned long exposureTime, unsigned char fromColor, unsigned char toColor);
_BUR_PUBLIC double brdkViBase_rad2deg(double rad);
_BUR_PUBLIC signed short brdkViBase_random(signed short min, signed short max);


#ifdef __cplusplus
};
#endif
#endif /* _BRDKVIBASE_ */

