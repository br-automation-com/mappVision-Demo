
FUNCTION brdkViBase_calcOpticInfo : BOOL (*Function to calculate optic information*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		camInfo : brdkViBase_camInfo_typ; (*BrdkVibase Camera hardware datastructure*)
	END_VAR
	VAR_IN_OUT
		opticInfo : brdkViBase_opticInfo_typ; (*BrdkViBase optic information datastructure*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_camStatusToString : BOOL (*Function to convert camera status to string*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		status : UDINT; (*Camera status number*)
		pString : UDINT; (*Pointer to string where number written to*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_deg2rad : LREAL (* Function to convert degrees to radians. Return angle in radians.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		deg : LREAL; (*Input degree.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_distance : LREAL (*Calculate the distance between two points.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		x1 : LREAL; (*Point 1 x*)
		y1 : LREAL; (*Point 1 y*)
		x2 : LREAL; (*Point 2 x*)
		y2 : LREAL; (*Point 2 y*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_dateTimeToString : BOOL (*Function to convert at DateTimte to a string, given a format string*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		date : DATE_AND_TIME; (*DateTime value*)
		format : STRING[20] := '%d-%m-%Y'; (*Format string, default '%d-%m-%Y'*)
		pStr : UDINT; (*Pointer to string where date is appended*)
	END_VAR
END_FUNCTION

FUNCTION_BLOCK brdkViBase_getLightInfo (*Function block to extract the light product number from the IO address*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		execute : BOOL; (*When TRUE the extraction is started, is automatically reset to FALSE*)
		errorReset : BOOL; (*Reset function block in case of error*)
		pDevicePath : UDINT; (*Pointer to string with Device path e.g. "IF3.ST1"*)
		pluggedModule : BOOL; (*If true then the plugged module information is extracted, if false its the configued module information that is used*)
		pInfo : REFERENCE TO brdkViBase_lightInfo_typ; (*Pointer to brdkViBase camera hardware datastructure where information is written to*)
	END_VAR
	VAR_OUTPUT
		status : UINT; (*Status for the function block*)
	END_VAR
	VAR
		internal : brdkViBase_getCameraInfo_int_typ;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK brdkViBase_getCameraInfo (*Function block to extract the camera product number from the IO address*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		execute : BOOL; (*When TRUE the extraction is started, is automatically reset to FALSE*)
		errorReset : BOOL; (*Reset function block in case of error*)
		pDevicePath : UDINT; (*Pointer to string with Device path e.g. "IF3.ST1"*)
		pluggedModule : BOOL; (*If true then the plugged module information is extracted, if false its the configued module information that is used*)
		pInfo : REFERENCE TO brdkViBase_camInfo_typ; (*Pointer to brdkViBase camera hardware datastructure where information is written to*)
	END_VAR
	VAR_OUTPUT
		status : UINT; (*Status for the function block*)
	END_VAR
	VAR
		internal : brdkViBase_getCameraInfo_int_typ;
	END_VAR
END_FUNCTION_BLOCK

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

FUNCTION brdkViBase_initRand : BOOL (*Initialize rand function.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		seed : UDINT; (*seed*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_LEDIntensity : UDINT (*Function to correct the LED intensity (exposure time) between different flash LED colors*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		LEDLenseType : USINT; (*LED type 1, 2 or 3*)
		distance : UINT; (*Distance to the object in mm *)
		exposureTime : UDINT; (*exposure time of the fromColor*)
		fromColor : USINT; (*Flash LED color to convert from*)
		toColor : USINT; (*Flash LED color to convert to*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_rad2deg : LREAL (*Function to convert radian to degree. Return angle in degrees.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rad : LREAL; (*Input radian.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_random : INT (*Get a random number between min and max.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		min : INT; (*Min value*)
		max : INT; (*Max value*)
	END_VAR
END_FUNCTION

FUNCTION_BLOCK brdkViBase_simCam (*Function block to simulate a camera's hardware inputs to the PLC based on the outputs to the camera*)
	VAR_INPUT
		pCamHw : REFERENCE TO brdkViBase_cam_hw_typ; (*Pointer the brdkViBase camera hardware datastructures*)
		triggerConf : USINT; (*Trigger configuration, 0 = Delay, 1= Nettime*)
		cameraProcessingTime : DINT; (*Camera procssing time which is used for simulating image processing*)
		nettime : DINT; (*Current nettime of the PLC*)
	END_VAR
	VAR_OUTPUT
		status : UINT; (*Function block status*)
	END_VAR
	VAR
		internal : brdkViBase_simCam_internal_typ;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION brdkViBase_blob_hw2hmi : BOOL (*Function to convert BLOB hw structure to hmi structure*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		hw : brdkViBase_hw_blob_in_typ; (*BLOB Hw result structure*)
	END_VAR
	VAR_IN_OUT
		hmi : brdkViBase_hmi_blob_in_typ; (*BLOB hmi result structure*)
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION brdkViBase_cr_hw2hmi : BOOL (*Function to convert Code Reader  hw structure to hmi structure*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		hw : brdkViBase_hw_cr_in_typ; (*Code reader Hw result structure*)
	END_VAR
	VAR_IN_OUT
		hmi : brdkViBase_hmi_cr_in_typ; (*Code reader hmi result structure*)
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION brdkViBase_ocr_hw2hmi : BOOL (*Function to convert OCR hw structure to hmi structure*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		hw : brdkViBase_hw_OCR_in_typ; (*OCR Hw result structure*)
	END_VAR
	VAR_IN_OUT
		hmi : brdkViBase_hmi_OCR_in_typ; (*OCR hmi result structure*)
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION brdkViBase_match_hw2hmi : BOOL (*Function to convert matching hw structure to hmi structure*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		hw : brdkViBase_hw_match_in_typ; (*Matching Hw result structure*)
	END_VAR
	VAR_IN_OUT
		hmi : brdkViBase_hmi_match_in_typ; (*Matching hmi result structure*)
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION brdkViBase_meas_hw2hmi : BOOL (*Function to convert measurement hw structure to hmi structure*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		hw : brdkViBase_hw_meas_in_typ; (*Measurement Hw result structure*)
	END_VAR
	VAR_IN_OUT
		hmi : brdkViBase_hmi_meas_in_typ; (*Measurement hmi result structure*)
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION brdkViBase_pxCnt_hw2hmi : BOOL (*Function to convert pixel counter hw structure to hmi structure*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		hw : brdkViBase_hw_pxCnt_in_typ; (*Pixel counter Hw result structure*)
	END_VAR
	VAR_IN_OUT
		hmi : brdkViBase_hmi_pxCnt_in_typ; (*Pixel counter hmi result structure*)
	END_VAR
END_FUNCTION
