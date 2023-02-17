
FUNCTION brdkViBase_distance : LREAL (*Calculate the distance between two points.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		x1 : LREAL; (*Point 1 x*)
		y1 : LREAL; (*Point 1 y*)
		x2 : LREAL; (*Point 2 x*)
		y2 : LREAL; (*Point 2 y*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_random : INT (*Get a random number between min and max.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		min : INT; (*Min value*)
		max : INT; (*Max value*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_initRand : BOOL (*Initialize rand function.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		seed : UDINT; (*seed*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_deg2rad : LREAL (* Function to convert degrees to radians. Return angle in radians.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		deg : LREAL; (*Input degree.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_rad2deg : LREAL (*Function to convert radian to degree. Return angle in degrees.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rad : LREAL; (*Input radian.*)
	END_VAR
END_FUNCTION

FUNCTION_BLOCK brdkViBase_imgTrigger (*Function block to handle triggering of new image on a camera*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pCameraHw : REFERENCE TO brdkViBase_cam_hw_typ; (*Pointer to a brdkViBase Camera hardware stucture*)
		numLights : USINT; (*Number of lights used for this camera, if more than 1 then pLightHw need to be an array*)
		pLightHw : REFERENCE TO brdkViBase_light_hw_typ; (*Pointer to a brdkViBase light hardware structure, can also be an array of these structures*)
		searchAcquisitonSettings : BOOL; (*Start the search acquisition settings routine is done*)
		useCamColorForLight : BOOL; (*If true then the camera flash color is also used as flash color  on the lights*)
		useCamExpTimeForLight : BOOL; (*If true then the camera exposure time is also used as exposure time on the lights*)
		trigger : BOOL; (*Trigger a new image, is automatically reset*)
		delayNettime : DINT; (*Sets Delay or NetTime for the trigger in microseconds, is used in same cycle as trigger is true*)
		simulate : brdkViBase_imgTrigger_sim_typ; (*Simulation data structure, for configuring simulation of the function block*)
	END_VAR
	VAR_OUTPUT
		newImage : BOOL; (*New image results are ready, only high one cycle*)
		searchAcquisitonSettingsDone : BOOL; (*The search acquisition settings routine is done *)
		ready : BOOL; (*All devices are ready to receive a new trigger request*)
		hwError : BOOL; (*One or more devices are not present (moduleOk = false)*)
		busy : BOOL; (*Busy is true from image trigger to image result is returned*)
		imageResultCnt : UDINT; (*Number received image results*)
		triggerCnt : UDINT; (*Number of image acquisitions that have been accepted*)
	END_VAR
	VAR
		internal : brdkViBase_imgTrigger_local_typ;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION brdkViBase_LEDIntensity : UDINT (*Function to correct the LED intensity (exposure time) between different flash LED colors*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		LEDLenseType : USINT; (*LED type 1, 2 or 3*)
		distance : UINT; (*Distance to the object in mm *)
		exposureTime : UDINT; (*exposure time of the fromColor*)
		fromColor : USINT; (*Flash LED color to convert from*)
		toColor : USINT; (*Flash LED color to convert to*)
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION brdkViBase_dtStructToString : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		date : DATE_AND_TIME;
		format : STRING[20];
		pStr : UDINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION brdkViBase_CamStatusToString : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		status : UDINT;
		pString : UDINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION_BLOCK brdkViBase_getCameraInfo (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		execute : BOOL;
		errorReset : BOOL;
		pDevicePath : UDINT;
		distance : REAL;
		pInfo : REFERENCE TO brdkViBase_camInfo_typ;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR
		internal : brdkViBase_getCameraInfo_int_typ;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION brdkViBase_calcOpticInfo : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		camInfo : brdkViBase_camInfo_typ;
	END_VAR
	VAR_IN_OUT
		opticInfo : brdkViBase_opticInfo_typ;
	END_VAR
END_FUNCTION
