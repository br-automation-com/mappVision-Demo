
TYPE
	brdkViBase_hw_in_common_typ : 	STRUCT  (*B&R common hardware input structure from device*)
		hardwareVariant : UDINT; (*The hardware variant of the module can be read from this data point.*)
		moduleId : UDINT; (*The module hardware ID used to determine the type of device that can be read from this register. This is also listed in the respective technical data as the "B&R ID code". In addition, a serial number is printed on each module; the module hardware ID corresponds to the first four positions of this serial number.*)
		firmwareVersion : UDINT; (*The firmware version of the module can be read from this data point. 
The last two positions correspond to the number after the decimal point.
Example: 345 corresponds to version 3.45.*)
		serialNumber : UDINT; (*The module's unique serial number can be read from this register. This 7-digit serial number is printed in decimal form on the module's housing*)
		moduleOk : BOOL; (*Status bit that indicates whether the module is physically present and configured. Detection takes place via the Fieldbus connection.*)
	END_STRUCT;
	brdkViBase_2d_typ : 	STRUCT  (*2D vector information.*)
		y : LREAL; (*Y-coordinate.*)
		x : LREAL; (*X-coordinate.*)
	END_STRUCT;
	brdkViBase_3d_typ : 	STRUCT  (*3D vector information.*)
		y : LREAL; (*Y-coordinate.*)
		z : LREAL; (*Z-coordinate.*)
		x : LREAL; (*X-coordinate.*)
	END_STRUCT;
	brdkViBase_angle_enum : 
		( (*Angle enumeration type.*)
		BRDKVIBASE_ANGLE_X, (*X-angle*)
		BRDKVIBASE_ANGLE_Y, (*Y-angle*)
		BRDKVIBASE_ANGLE_Z (*Z-angle*)
		);
	brdkViBase_cam_recipe_typ : 	STRUCT 
		gainLevel : USINT; (*Sets a gain factor*)
		focus : UINT; (*Sets the focus from "MOD" to "Infinity", Unit depends on the selected one in the vision application file (um, mm, raw)*)
		exposureTime : UDINT; (*Sets the integration time of the sensor in microseconds*)
		flashColorStr : STRING[4]; (*Selects LED colors of the onboard LED lighting. The constants BRDKVIBASE_LED_xxx can be used to set the color*)
		flashColor : USINT; (*Selects LED colors of the onboard LED lighting. The constants BRDKVIBASE_LED_xxx can be used to set the color*)
		flashSegment : USINT; (*Enables/Disables LED segments. Binary patter for enable each of the four segments 0000 = all off, 1111 = all on*)
		chromaticLock : BOOL; (*Enables/Disables ChromaticLock*)
		IRFilter : BOOL;
		statusColor : USINT;
	END_STRUCT;
	brdkViBase_getCameraInfo_int_typ : 	STRUCT 
		diagGetNumInfo_0 : DiagGetNumInfo;
		diagGetStrInfo_0 : DiagGetStrInfo;
		diagCreateInfo_0 : DiagCreateInfo;
		index : UDINT;
		path : STRING[256];
		state : USINT;
		diagDisposeInfo_0 : DiagDisposeInfo;
	END_STRUCT;
	brdkViBase_lightInfo_typ : 	STRUCT 
		LED_color : BRDKVIBASE_LED_COLOR_ENM;
		LED_lens : BRDKVIBASE_LED_LENS_ENM;
		size : BRDKVIBASE_LIGHT_SIZE_ENM;
		front : BRDKVIBASE_FRONT_ENM;
		orderNr : {REDUND_UNREPLICABLE} STRING[20];
	END_STRUCT;
	brdkViBase_camInfo_typ : 	STRUCT 
		LED_color : BRDKVIBASE_LED_COLOR_ENM;
		LED_lens : BRDKVIBASE_LED_LENS_ENM;
		cpu : BRDKVIBASE_CPU_ENM;
		lens : BRDKVIBASE_LENS_ENM;
		sensor : BRDKVIBASE_SENSOR_TYPE_ENM;
		pixelConfiguration : BRDKVIBASE_PX_CONFIG_ENM;
		front : BRDKVIBASE_FRONT_ENM;
		orderNr : {REDUND_UNREPLICABLE} STRING[20];
		distance : REAL;
	END_STRUCT;
	brdkViBase_opticInfo_typ : 	STRUCT 
		sensor : brdkViBase_cam_info_sensor_typ;
		lens : brdkViBase_cam_info_lens_typ;
	END_STRUCT;
	BRDKVIBASE_PX_CONFIG_ENM : 
		(
		BRDKVIBASE_PX_CONFIG_STANDARD := 0,
		BRDKVIBASE_PX_CONFIG_BINNING := 1,
		BRDKVIBASE_PX_CONFIG_SUBSAMPLING := 2
		);
	BRDKVIBASE_LIGHT_SIZE_ENM : 
		(
		BRDKVIBASE_LIGHT_SIZE_BACK_1X1 := 1,
		BRDKVIBASE_LIGHT_SIZE_BACK_1X2 := 2,
		BRDKVIBASE_LIGHT_SIZE_BACK_1X3 := 3,
		BRDKVIBASE_LIGHT_SIZE_BACK_1X4 := 4,
		BRDKVIBASE_LIGHT_SIZE_BACK_2X2 := 5,
		BRDKVIBASE_LIGHT_SIZE_BACK_2X3 := 6,
		BRDKVIBASE_LIGHT_SIZE_BAR_1X1 := 7,
		BRDKVIBASE_LIGHT_SIZE_BAR_1X2 := 8,
		BRDKVIBASE_LIGHT_SIZE_BAR_1X3 := 9,
		BRDKVIBASE_LIGHT_SIZE_BAR_1X4 := 10,
		BRDKVIBASE_LIGHT_SIZE_RING_4 := 11,
		BRDKVIBASE_LIGHT_SIZE_RING_6 := 12,
		BRDKVIBASE_LIGHT_SIZE_RING_8 := 13
		);
	BRDKVIBASE_FRONT_ENM : 
		(
		BRDKVIBASE_FRONT_0_CMOUNT := 0,
		BRDKVIBASE_FRONT_1_GLASS_ANTI := 1,
		BRDKVIBASE_FRONT_2_GLASS_POL := 2,
		BRDKVIBASE_FRONT_3_GLASS_DIFFUSE := 3,
		BRDKVIBASE_FRONT_B_PLASTIC_ANTI := 4,
		BRDKVIBASE_FRONT_C_PLASTIC_POL := 5,
		BRDKVIBASE_FRONT_D_PLASTIC_DIFF := 6,
		BRDKVIBASE_FRONT_E_PLASTIC_TELE := 7,
		BRDKVIBASE_FRONT_A_PLASTIC := 8
		);
	BRDKVIBASE_CPU_ENM : 
		(
		BRDKVIBASE_CPU_1_DUAL := 0,
		BRDKVIBASE_CPU_2_QUAD := 1
		);
	BRDKVIBASE_SENSOR_TYPE_ENM : 
		(
		BRDKVIBASE_SENSOR_1_3_MP := 0,
		BRDKVIBASE_SENSOR_1_3_MP_LINE := 1,
		BRDKVIBASE_SENSOR_3_5_MP := 2,
		BRDKVIBASE_SENSOR_5_3_MP_LINE := 3
		);
	BRDKVIBASE_LED_LENS_ENM : 
		(
		BRDKVIBASE_LED_LENS_0_NONE := 0,
		BRDKVIBASE_LED_LENS_1_WIDE := 1,
		BRDKVIBASE_LED_LENS_2_STANDARD := 2,
		BRDKVIBASE_LED_LENS_3_WIDE := 3
		);
	BRDKVIBASE_LENS_ENM : 
		(
		BRDKVIBASE_LENS_C_MOUNT := 0,
		BRDKVIBASE_LENS_4_6 := 1,
		BRDKVIBASE_LENS_6_0 := 2,
		BRDKVIBASE_LENS_8_0 := 3,
		BRDKVIBASE_LENS_12_0 := 4,
		BRDKVIBASE_LENS_12_0_MACRO := 5,
		BRDKVIBASE_LENS_16_0 := 6,
		BRDKVIBASE_LENS_25_0 := 7
		);
	BRDKVIBASE_LED_COLOR_ENM : 
		(
		BRDKVIBASE_LED_COLOR_0_NONE := 0,
		BRDKVIBASE_LED_COLOR_3_BLUE := 1,
		BRDKVIBASE_LED_COLOR_8_RED := 2,
		BRDKVIBASE_LED_COLOR_A_UV := 3,
		BRDKVIBASE_LED_COLOR_D_IR := 4,
		BRDKVIBASE_LED_COLOR_F_W := 5,
		BRDKVIBASE_LED_COLOR_H_IRW := 6,
		BRDKVIBASE_LED_COLOR_Q_RGBL := 7,
		BRDKVIBASE_LED_COLOR_R_RBIRW := 8
		);
	brdkViBase_cam_info_lens_typ : 	STRUCT 
		focalLength_mm : REAL;
		maxObjectDist_mm : REAL;
		minObjectDist_mm : REAL;
		aperture : REAL;
		validDistance : BOOL;
		distanceLens_mm : REAL;
		circleOfConfusion_mm : REAL;
		hyperFocalDistance_mm : REAL;
		depthOfFieldNearPos_mm : REAL;
		depthOfFieldFarPos_mm : REAL;
		depthOfField_mm : REAL;
		fieldOfView_X_mm : REAL;
		fieldOfView_Y_mm : REAL;
		resolution_mmPerPx : REAL;
	END_STRUCT;
	brdkViBase_cam_info_sensor_typ : 	STRUCT 
		maxHeightPx : UDINT;
		maxWidthPx : UDINT;
		pixelSize_um : REAL;
	END_STRUCT;
END_TYPE

(*Hw for camera *)

TYPE
	brdkViBase_cam_hw_out_typ : 	STRUCT  (*Camera hardware output structure to device*)
		par : brdkViBase_cam_hw_out_par_typ; (*Hardware output parameters to the device*)
		cmd : brdkViBase_cam_hw_out_cmd_typ; (*Hardware out commands to the device*)
	END_STRUCT;
	brdkViBase_cam_hw_out_cmd_typ : 	STRUCT  (*Camera hardware command structure to device*)
		imageAcquisition : BOOL; (*Enables/Disables the trigger for the image acquisition*)
		resetAcquisiton : BOOL; (*Cancels an image acquisition triggered by NetTime*)
		searchAcquisitonSettings : BOOL; (*Enables/Disables search for focus and integration time of the sensor*)
		digitalOutput : BOOL; (*Selects the mode of operation of the digital output*)
	END_STRUCT;
	brdkViBase_cam_hw_out_par_typ : 	STRUCT  (*Camera hardware parameter structure to device*)
		statusLED : USINT; (*Selects the mode and color of the LED status indicator bars. Constants BRDKVIBASE_STATUS_xxx can be used to set the color*)
		gainLevel : USINT; (*Sets a gain factor*)
		focus : UINT; (*Sets the focus from "MOD" to "Infinity", Unit depends on the selected one in the vision application file (um, mm, raw)*)
		exposureTime : UDINT; (*Sets the integration time of the sensor in microseconds*)
		flashColor : USINT; (*Selects LED colors of the onboard LED lighting. The constants BRDKVIBASE_LED_xxx can be used to set the color*)
		flashSegment : USINT; (*Enables/Disables LED segments. Binary patter for enable each of the four segments 0000 = all off, 1111 = all on*)
		chromaticLock : BOOL; (*Enables/Disables ChromaticLock*)
		IRFilter : BOOL; (*Enables/Disables the infrared filter*)
		delayNetTime : DINT; (*Sets Delay or NetTime for the trigger in microseconds*)
		cyclicLineScanPeriod : DINT; (*Time between 2 image acquisitions in dynamic line sensor operation.*)
		cyclicLineScanNettime : DINT; (*Specifies the NetTime for dynamic line sensor mode.*)
	END_STRUCT;
	brdkViBase_cam_hw_in_status_typ : 	STRUCT  (*Camera hardware status input structure from device*)
		sensorTemperature : SINT; (*Current camera temperature in °C*)
		lightWarningCnt : USINT; (*Counter for errors or warnings that have occurred related to lighting.*)
		cameraStatus : UDINT; (*This parameter specifies the status of the camera.*)
		acceptedAcquisitionCnt : USINT; (*Counter for accepted image acquisitions*)
		completedAcquisitionCnt : USINT; (*Counter for performed image acquisitions*)
		failedAcquisitionCnt : USINT; (*Counter for failed image acquisitions*)
		undervoltageError : BOOL; (*Power supply alarm*)
		imageAcquisitionReady : BOOL; (*Camera availability status*)
		imageProcessingActive : BOOL; (*Status of image processing execution *)
		digitalOutputStatus : BOOL; (*Status of digital output 01*)
		cameraProcessingTime : UINT; (*Processing time in milliseconds*)
		imageProcessingError : UINT; (*Bit pattern for displaying errors and warnings that occurred during image processing.*)
		imageNettime : DINT; (*NetTime of the image in microseconds*)
		digitalInput : BOOL; (*Status digital input (trigger input)*)
		gainLevel : USINT; (*Current GainLevel*)
		focus : UINT; (*Current focus setting from "MOD" to "Infinity", Unit depends on the selected one in the vision application file (um, mm, raw)*)
		exposureTime : UDINT; (*Current integration time of the sensor in microseconds *)
	END_STRUCT;
	brdkViBase_cam_hw_in_typ : 	STRUCT  (*Camera hardware input structure from device*)
		common : brdkViBase_hw_in_common_typ; (*B&R Hardware common inputs from device*)
		status : brdkViBase_cam_hw_in_status_typ; (*Camera hardware status inputs from device*)
	END_STRUCT;
	brdkViBase_cam_hw_typ : 	STRUCT  (*Camera hardware structure*)
		in : brdkViBase_cam_hw_in_typ; (*Camera hardware inputs from device*)
		out : brdkViBase_cam_hw_out_typ; (*Camera hardware outputs to device*)
	END_STRUCT;
END_TYPE

(*hw for light*)

TYPE
	brdkViBase_light_hw_out_typ : 	STRUCT  (*Light hardware output structure to device*)
		cmd : brdkViBase_light_hw_out_cmd_typ; (*Light hardware output commands to device*)
		par : brdkViBase_light_hw_out_par_typ; (*Light hardware output parameters to device*)
	END_STRUCT;
	brdkViBase_light_hw_status_typ : 	STRUCT  (*Light hardware status structure from device*)
		ready : BOOL; (*Lighting unit availability status*)
		status : UDINT; (*This parameter specifies the status of the lighting unit.*)
		acceptedFlashCnt : USINT; (*Counter for accepted lighting jobs*)
		completedFlashCnt : USINT; (*Counter for executed lighting jobs*)
		failedFlashCnt : USINT; (*Counter for failed lighting jobs*)
		LightWarningCnt : USINT; (*Counter for errors or warnings that have occurred related to lighting.*)
		sensorTemperatureLedBoard : SINT;
		sensorTemperatureControllerBoard : SINT; (*Current lighting unit temperature in °C*)
	END_STRUCT;
	brdkViBase_light_hw_in_typ : 	STRUCT  (*Light hardware input structure from device*)
		common : brdkViBase_hw_in_common_typ; (*B&R hardware common inputs from device*)
		status : brdkViBase_light_hw_status_typ; (*Light hardware status inputs from device*)
	END_STRUCT;
	brdkViBase_light_hw_typ : 	STRUCT  (*Light hardware structure*)
		in : brdkViBase_light_hw_in_typ; (*Light hardware inputs from device*)
		out : brdkViBase_light_hw_out_typ; (*Light hardware outputs to device*)
	END_STRUCT;
	brdkViBase_light_hw_out_cmd_typ : 	STRUCT  (*Light hardware output commands to device*)
		flashTrigger : BOOL; (*Enables/Disables the trigger for the lighting job*)
		resetFlashTrigger : BOOL; (*Canceling a lighting job triggered by NetTime*)
	END_STRUCT;
	brdkViBase_light_hw_out_par_typ : 	STRUCT  (*Light hardware parameter output structure to device*)
		flashColor : USINT; (*Select LED colors of the LED lighting
 Constant BRDKVIBASE_LED_xxx can be used to set the color*)
		exposureTime : UDINT; (*Sets the exposure time in µs*)
		flashAngle : UINT; (*Only for Lightbar. Position of the stepper motor in degree 0 to 135*)
		flashSegments : USINT; (*Only for Lightbar. Enables/Disables LED segments*)
		cyclicLineScanPeriod : DINT; (*Time between 2 flashes in dynamic line sensor operation.*)
		cyclicLineScanNettime : DINT; (*Specifies the NetTime for dynamic line sensor mode.*)
		nettime : DINT; (*Sets the NetTime for the trigger in µs*)
	END_STRUCT;
END_TYPE

(*hw for vision function*)

TYPE
	brdkviBase_hw_vf_out_offset_typ : 	STRUCT  (*Offset ROI outputs for vision functions*)
		x : DINT; (*Offset of the ROI in the x-direction in 1/100 pixel increments.*)
		y : DINT; (*Offset of the ROI in the y-direction in increments of 1/100 pixel.*)
		orientation : INT; (*Offset to orient the ROI from -179.99° to +180° in 1/100 degree steps*)
		rotCenterX : DINT; (*Offset to orient the ROI from -179.99° to +180° in 1/100 degree steps*)
		rotCenterY : DINT; (*Offset of the rotation center in the y-direction in increments of 1/100 pixel.*)
	END_STRUCT;
	brdkViBase_hw_vf_in_common_typ : 	STRUCT  (*Common vision function hardware input structure from device*)
		numResults : USINT; (*Number of results found*)
		functionProcessingTime : UINT; (*Processing time of the visual function in microseconds*)
	END_STRUCT;
	brdkViBase_hw_vf_out_common_typ : 	STRUCT  (*vision function hardware output structure to device*)
		enable : BOOL; (*Enables/Disables the function*)
		numSearchMax : USINT := 10; (*Maximum number of codes to search*)
		alignment : USINT; (*0 = "None" 
1 = "SetReference"
2 = "GenerateAlignmentData" *)
		offsetROI : brdkviBase_hw_vf_out_offset_typ; (*Offset ROI parameters*)
	END_STRUCT;
END_TYPE

(*VF BLOB*)

TYPE
	brdkViBase_hmi_blob_in_typ : 	STRUCT  (*BLOB hardware structure for a result*)
		modelNumber : USINT; (*ModelNumber of the found blob*)
		meanGreyValue : USINT; (*Arithmetic mean of grayscale values for the blob*)
		clipped : BOOL; (* Edge contact detection *)
		area : REAL; (* Size (area) in pixels in increments of 1/100 pixel*)
		length : UDINT; (* Length of the found blob*)
		width : UDINT; (* Width of the found blob. Is always the longer of the two sides*)
		xMin : DINT; (* Extreme value in the column direction
Minimum column position of the BLOB area*)
		xMax : DINT; (*Extreme value in the column direction
Maximum column position of the BLOB area*)
		yMin : DINT; (*Extreme value in the line direction
Minimum line position of the BLOB area*)
		yMax : DINT; (*Extreme value in the line direction
Maximum line position of the BLOB area*)
		circularity : USINT; (*Circularity of the found blob in %*)
		rectangularity : USINT; (*Rectangularity of the found blob in %*)
		anisometry : UINT; (*Anisometry of the found blob*)
		innterCirclePositionX : REAL; (*Output of position X of the center point of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		innterCirclePositionY : REAL; (*Output of position Y of the center point of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		innterCircleRadius : UDINT; (*Output of the radius of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		positionX : REAL; (*X-position (of the found blob) in the image in increments of 1/100 pixel*)
		positionY : REAL; (*Y-position (of the found blob) in the image in increments of 1/100 pixel*)
		orientation : REAL; (*-179.99° to +180° in increments of 1/100 degree*)
		rotCenterX : REAL; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps*)
		rotCenterY : REAL; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps*)
	END_STRUCT;
	brdkViBase_hw_blob_out_typ : 	STRUCT  (*BLOB hardware output structure*)
		regionFeatures : BOOL; (*Enables the geometric exclusion procedure *)
		enhancedBlobInformation : BOOL; (*0 = Additional information is transferred (default).
1 = Additional information is not transferred.
Means an increase of FunctionProcessingTime *)
		common : brdkViBase_hw_vf_out_common_typ; (*Common vision function output*)
	END_STRUCT;
	brdkViBase_hw_blob_in_typ : 	STRUCT  (*BLOB hardware structure for a result*)
		modelNumber : USINT; (*ModelNumber of the found blob*)
		meanGreyValue : USINT; (*Arithmetic mean of grayscale values for the blob*)
		clipped : BOOL; (* Edge contact detection *)
		area : UDINT; (* Size (area) in pixels in increments of 1/100 pixel*)
		length : UDINT; (* Length of the found blob*)
		width : UDINT; (* Width of the found blob. Is always the longer of the two sides*)
		xMin : DINT; (* Extreme value in the column direction
Minimum column position of the BLOB area*)
		xMax : DINT; (*Extreme value in the column direction
Maximum column position of the BLOB area*)
		yMin : DINT; (*Extreme value in the line direction
Minimum line position of the BLOB area*)
		yMax : DINT; (*Extreme value in the line direction
Maximum line position of the BLOB area*)
		circularity : USINT; (*Circularity of the found blob in %*)
		rectangularity : USINT; (*Rectangularity of the found blob in %*)
		anisometry : UINT; (*Anisometry of the found blob*)
		innterCirclePositionX : DINT; (*Output of position X of the center point of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		innterCirclePositionY : DINT; (*Output of position Y of the center point of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		innterCircleRadius : UDINT; (*Output of the radius of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		positionX : DINT; (*X-position (of the found blob) in the image in increments of 1/100 pixel*)
		positionY : DINT; (*Y-position (of the found blob) in the image in increments of 1/100 pixel*)
		orientation : INT; (*-179.99° to +180° in increments of 1/100 degree*)
		rotCenterX : DINT; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps*)
		rotCenterY : DINT; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps*)
	END_STRUCT;
	brdkViBase_hw_blob_10_in_typ : 	STRUCT  (*BLOB hardware input structure for 10 BLOB result*)
		common : brdkViBase_hw_vf_in_common_typ;
		results : ARRAY[0..9]OF brdkViBase_hw_blob_in_typ;
	END_STRUCT;
	brdkViBase_hw_blob_10_typ : 	STRUCT  (*BLOB hardware structure for 10 BLOB result*)
		in : brdkViBase_hw_blob_10_in_typ;
		out : brdkViBase_hw_blob_out_typ;
	END_STRUCT;
END_TYPE

(*VF match*)

TYPE
	brdkViBase_hmi_match_in_typ : 	STRUCT  (*Matching hardware structure for a result*)
		modelNumber : USINT; (*ID/Number of the learned model (which matches the hit)*)
		score : REAL; (*Grade (quality score) of the Matching result concerning the model in the range of values from 0.0 to 1.0. In 1/100*)
		scale : REAL; (*For shape-based Matching. Scaling factor from 0.01 to 2.55 in increments of 0.01.*)
		positionX : REAL; (*X-position (of the found object) in the image in increments of 1/100 pixel*)
		positionY : REAL; (*Y-position (of the found object) in the image in increments of 1/100 pixel*)
		orientation : REAL; (*-179.99° to +180° in increments of 1/100 degree*)
		rotCenterX : REAL; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps.*)
		rotCenterY : REAL; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps.*)
	END_STRUCT;
	brdkViBase_hw_match_out_typ : 	STRUCT  (*Matching hardware output structure*)
		timeout : UINT; (*Time limit for the search time in increments of 1 ms. 0 = no timeout*)
		minScore : USINT; (*Minimum grade in percent as to whether a found object is accepted as a match.*)
		maxOverlap : USINT; (*Maximum degree of overlap in percent that found objects are permitted to have.*)
		common : brdkViBase_hw_vf_out_common_typ; (*Common vision function output*)
	END_STRUCT;
	brdkViBase_hw_match_in_typ : 	STRUCT  (*Matching hardware structure for a result*)
		modelNumber : USINT; (*ID/Number of the learned model (which matches the hit)*)
		score : USINT; (*Grade (quality score) of the Matching result concerning the model in the range of values from 0.0 to 1.0. In 1/100*)
		scale : USINT; (*For shape-based Matching. Scaling factor from 0.01 to 2.55 in increments of 0.01.*)
		positionX : DINT; (*X-position (of the found object) in the image in increments of 1/100 pixel*)
		positionY : DINT; (*Y-position (of the found object) in the image in increments of 1/100 pixel*)
		orientation : INT; (*-179.99° to +180° in increments of 1/100 degree*)
		rotCenterX : DINT; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps.*)
		rotCenterY : DINT; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps.*)
	END_STRUCT;
	brdkViBase_hw_match_10_in_typ : 	STRUCT  (*Matching hardware input structure for 10 results*)
		common : brdkViBase_hw_vf_in_common_typ;
		results : ARRAY[0..9]OF brdkViBase_hw_match_in_typ;
	END_STRUCT;
	brdkViBase_hw_match_10_typ : 	STRUCT  (*Matching hardware structure for 10 results*)
		in : brdkViBase_hw_match_10_in_typ;
		out : brdkViBase_hw_match_out_typ;
	END_STRUCT;
END_TYPE

(*VF OCR [50]*)

TYPE
	brdkViBase_hmi_OCR_in_typ : 	STRUCT  (*OCR hardware input structure for a result with length 50*)
		data : STRING[50]; (*A tuple of classification results, e.g. ["2", "6", "1", "2"], size 50*)
		gradingValue : REAL; (*Probability for all segmented characters (minimum confidence of all characters in a line)*)
		positionX : REAL; (*X-position (of the found string) in the image in increments of 1/100 pixel*)
		positionY : REAL; (*Y-position (of the found string) in the image in increments of 1/100 pixel*)
		orientation : REAL; (*-179.99° to +180° in increments of 1/100 degree*)
	END_STRUCT;
	brdkViBase_hw_OCR_out_typ : 	STRUCT  (*OCR hardware output structure*)
		timeout : UINT; (*Time limit for the search time in increments of 1 ms. 0 = no timeout*)
		parameterMode : USINT; (*Selects predefined parameter sets*)
		grading : BOOL; (*Enables/Disables quality grading of the characters read.*)
		common : brdkViBase_hw_vf_out_common_typ; (*Common vision function output*)
	END_STRUCT;
	brdkViBase_hw_OCR_in_typ : 	STRUCT  (*OCR hardware input structure for a result with length 50*)
		data : ARRAY[0..50]OF USINT; (*A tuple of classification results, e.g. ["2", "6", "1", "2"], size 50*)
		gradingValue : USINT; (*Probability for all segmented characters (minimum confidence of all characters in a line)*)
		positionX : DINT; (*X-position (of the found string) in the image in increments of 1/100 pixel*)
		positionY : DINT; (*Y-position (of the found string) in the image in increments of 1/100 pixel*)
		orientation : INT; (*-179.99° to +180° in increments of 1/100 degree*)
	END_STRUCT;
	brdkViBase_hw_OCR_10_in_typ : 	STRUCT  (*OCR hardware input structure for 10 results*)
		common : brdkViBase_hw_vf_in_common_typ;
		results : ARRAY[0..9]OF brdkViBase_hw_OCR_in_typ;
	END_STRUCT;
	brdkViBase_hw_OCR_10_typ : 	STRUCT  (*OCR hardware structure for 10 results*)
		in : brdkViBase_hw_OCR_10_in_typ;
		out : brdkViBase_hw_OCR_out_typ;
	END_STRUCT;
END_TYPE

(*VF PX*)

TYPE
	brdkViBase_hmi_pxCnt_in_typ : 	STRUCT  (*PX counter hardware input structure for a result*)
		modelNumber : USINT; (*Model number of the result found*)
		numPixels : UDINT; (*Number of pixels that correspond to the configuration in the model*)
		minGray : USINT; (*Lowest grayscale value in the result*)
		maxGray : USINT; (*Highest grayscale value in the result*)
		meanGray : REAL; (*Arithmetic mean value of the grayscale values of the result*)
		deviationGray : REAL; (*Standard deviation of the grayscale values of the result*)
		medianGray : USINT; (*Median of the grayscale values of the result*)
		modelArea : UDINT; (*Size (area) of the model in pixels*)
		numConnectedComponents : UINT; (*Number of non-contiguous areas of the result*)
		positionX : REAL; (*X-position (center point) in the image in increments of 1/100 pixel*)
		positionY : REAL; (*Y-position (center point) in the image in increments of 1/100 pixel*)
	END_STRUCT;
	brdkViBase_hw_pxCnt_out_typ : 	STRUCT  (*PX counter hardware output structure*)
		enhancedPXInformation : BOOL; (*Enables/Disables transfer of additional information.
Has an influence on the processing time of the vision function.*)
		common : brdkViBase_hw_vf_out_common_typ; (*Common vision function output*)
	END_STRUCT;
	brdkViBase_hw_pxCnt_in_typ : 	STRUCT  (*PX counter hardware input structure for a result*)
		modelNumber : USINT; (*Model number of the result found*)
		numPixels : UDINT; (*Number of pixels that correspond to the configuration in the model*)
		minGray : USINT; (*Lowest grayscale value in the result*)
		maxGray : USINT; (*Highest grayscale value in the result*)
		meanGray : UINT; (*Arithmetic mean value of the grayscale values of the result*)
		deviationGray : UINT; (*Standard deviation of the grayscale values of the result*)
		medianGray : USINT; (*Median of the grayscale values of the result*)
		modelArea : UDINT; (*Size (area) of the model in pixels*)
		numConnectedComponents : UINT; (*Number of non-contiguous areas of the result*)
		positionX : DINT; (*X-position (center point) in the image in increments of 1/100 pixel*)
		positionY : DINT; (*Y-position (center point) in the image in increments of 1/100 pixel*)
	END_STRUCT;
	brdkViBase_hw_pxCnt_10_in_typ : 	STRUCT  (*PX counter hardware input structure for 10 results*)
		common : brdkViBase_hw_vf_in_common_typ;
		results : ARRAY[0..9]OF brdkViBase_hw_pxCnt_in_typ;
	END_STRUCT;
	brdkViBase_hw_pxCnt_10_typ : 	STRUCT  (*PX counter hardware structure for 10 results*)
		in : brdkViBase_hw_pxCnt_10_in_typ;
		out : brdkViBase_hw_pxCnt_out_typ;
	END_STRUCT;
END_TYPE

(*VF mes*)

TYPE
	brdkViBase_hmi_meas_in_typ : 	STRUCT  (*Measurement hardware input structure for a result*)
		result : DINT; (*Measurement values. Depending on the operator, it is possible to return angle, orientation, length or distance values, or a combination of any of these in an array.*)
	END_STRUCT;
	brdkViBase_hw_meas_out_typ : 	STRUCT  (*Measurement hardware output structure*)
		common : brdkViBase_hw_vf_out_common_typ; (*Common vision function output*)
	END_STRUCT;
	brdkViBase_hw_meas_in_typ : 	STRUCT  (*Measurement hardware input structure for a result*)
		result : DINT; (*Measurement values. Depending on the operator, it is possible to return angle, orientation, length or distance values, or a combination of any of these in an array.*)
	END_STRUCT;
	brdkViBase_hw_meas_10_in_typ : 	STRUCT  (*Measurement hardware input structure for 10 results*)
		common : brdkViBase_hw_vf_in_common_typ;
		results : ARRAY[0..9]OF brdkViBase_hw_meas_in_typ;
	END_STRUCT;
	brdkViBase_hw_meas_10_typ : 	STRUCT  (*Measurement hardware structure for 10 results*)
		in : brdkViBase_hw_meas_10_in_typ;
		out : brdkViBase_hw_meas_out_typ;
	END_STRUCT;
END_TYPE

(*VF cr [50]*)

TYPE
	brdkViBase_hmi_cr_in_typ : 	STRUCT  (*Code Reader hardware input structure for a result*)
		data : STRING[100]; (*Returns the content of the found code as array OCTET.  Size 50*)
		symbolTypeStr : STRING[20]; (*Symbol type of codes found.*)
		symbolType : USINT; (*Symbol type of codes found.*)
		gradingValue : SINT; (*Evaluation of the codes in terms of quality*)
		enhancedGradingInformation : STRING[23]; (*Output of extended grading information from which the general GradingValue assessment parameter is composed.*)
		positionX : REAL; (*X-position (of the found code) in the image in increments of 1/100 pixel.*)
		positionY : REAL; (*Y-position (of the found code) in the image in increments of 1/100 pixel.*)
		orientation : REAL; (*179.99° to +180° in increments of 1/100 degree*)
		rotCenterX : REAL; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps.*)
		rotCenterY : REAL; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps.*)
	END_STRUCT;
	brdkViBase_hw_cr_out_typ : 	STRUCT  (*Code reader hardware output structure*)
		timeout : UINT; (*Time limit for the search time in increments of 1 ms. 0 = no timeout*)
		parameterOptimization : USINT; (*Automatically enables, disables or resets taught-in parameters*)
		parameterMode : USINT; (*Selects predefined parameter sets*)
		codeGrading : BOOL; (*Enables/Disables quality grading of the codes read.*)
		symbolType : USINT; (*Selects the code type to be searched for*)
		enableRobustness : BOOL; (*Enables/Disables robustness for the search of the selected code type*)
		common : brdkViBase_hw_vf_out_common_typ; (*Common vision function output*)
	END_STRUCT;
	brdkViBase_hw_cr_in_typ : 	STRUCT  (*Code Reader hardware input structure for a result*)
		data : ARRAY[0..100]OF USINT; (*Returns the content of the found code as array OCTET.  Size 50*)
		symbolType : USINT; (*Symbol type of codes found.*)
		gradingValue : SINT; (*Evaluation of the codes in terms of quality*)
		enhancedGradingInformation : STRING[23]; (*Output of extended grading information from which the general GradingValue assessment parameter is composed.*)
		positionX : DINT; (*X-position (of the found code) in the image in increments of 1/100 pixel.*)
		positionY : DINT; (*Y-position (of the found code) in the image in increments of 1/100 pixel.*)
		orientation : INT; (*179.99° to +180° in increments of 1/100 degree*)
		rotCenterX : DINT; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps.*)
		rotCenterY : DINT; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps.*)
	END_STRUCT;
	brdkViBase_hw_cr_10_in_typ : 	STRUCT  (*Code reader hardware input structure for 10 results*)
		common : brdkViBase_hw_vf_in_common_typ;
		results : ARRAY[0..9]OF brdkViBase_hw_cr_in_typ;
	END_STRUCT;
	brdkViBase_hw_cr_10_typ : 	STRUCT  (*Code reader hardware structure for 10 results*)
		in : brdkViBase_hw_cr_10_in_typ;
		out : brdkViBase_hw_cr_out_typ;
	END_STRUCT;
END_TYPE

(*VF sub*)

TYPE
	brdkViBase_hmi_subBlob_in_typ : 	STRUCT  (*Subpixel BLOB hardware structure for a result*)
		modelNumber : USINT; (*ModelNumber of the found blob*)
		meanGreyValue : USINT; (*Arithmetic mean of grayscale values for the blob*)
		clipped : BOOL; (* Edge contact detection *)
		area : REAL; (* Size (area) in pixels in increments of 1/100 pixel*)
		length : REAL; (* Length of the found blob*)
		width : UDINT; (* Width of the found blob. Is always the longer of the two sides*)
		xMin : DINT; (* Extreme value in the column direction
Minimum column position of the BLOB area*)
		xMax : DINT; (*Extreme value in the column direction
Maximum column position of the BLOB area*)
		yMin : DINT; (*Extreme value in the line direction
Minimum line position of the BLOB area*)
		yMax : DINT; (*Extreme value in the line direction
Maximum line position of the BLOB area*)
		circularity : USINT; (*Circularity of the found blob in %*)
		rectangularity : USINT; (*Rectangularity of the found blob in %*)
		anisometry : UINT; (*Anisometry of the found blob*)
		innterCirclePositionX : DINT; (*Output of position X of the center point of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		innterCirclePositionY : DINT; (*Output of position Y of the center point of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		innterCircleRadius : UDINT; (*Output of the radius of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		positionX : DINT; (*X-position (of the found blob) in the image in increments of 1/100 pixel*)
		positionY : DINT; (*Y-position (of the found blob) in the image in increments of 1/100 pixel*)
		orientation : INT; (*-179.99° to +180° in increments of 1/100 degree*)
		rotCenterX : DINT; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps*)
		rotCenterY : DINT; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps*)
	END_STRUCT;
	brdkViBase_hw_subBlob_out_typ : 	STRUCT  (*Subpixel BLOB hardware output structure *)
		regionFeatures : BOOL; (*Enables the geometric exclusion procedure *)
		enhancedBlobInformation : BOOL; (*0 = Additional information is transferred (default).
1 = Additional information is not transferred.
Means an increase of FunctionProcessingTime *)
		common : brdkViBase_hw_vf_out_common_typ; (*Common vision function output*)
	END_STRUCT;
	brdkViBase_hw_subBlob_in_typ : 	STRUCT  (*Subpixel BLOB hardware structure for a result*)
		modelNumber : USINT; (*ModelNumber of the found blob*)
		meanGreyValue : USINT; (*Arithmetic mean of grayscale values for the blob*)
		clipped : BOOL; (* Edge contact detection *)
		area : UDINT; (* Size (area) in pixels in increments of 1/100 pixel*)
		length : UDINT; (* Length of the found blob*)
		width : UDINT; (* Width of the found blob. Is always the longer of the two sides*)
		xMin : DINT; (* Extreme value in the column direction
Minimum column position of the BLOB area*)
		xMax : DINT; (*Extreme value in the column direction
Maximum column position of the BLOB area*)
		yMin : DINT; (*Extreme value in the line direction
Minimum line position of the BLOB area*)
		yMax : DINT; (*Extreme value in the line direction
Maximum line position of the BLOB area*)
		circularity : USINT; (*Circularity of the found blob in %*)
		rectangularity : USINT; (*Rectangularity of the found blob in %*)
		anisometry : UINT; (*Anisometry of the found blob*)
		innterCirclePositionX : DINT; (*Output of position X of the center point of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		innterCirclePositionY : DINT; (*Output of position Y of the center point of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		innterCircleRadius : UDINT; (*Output of the radius of the inner circle of the found blob determined by the algorithm in 1/100 pixels.*)
		positionX : DINT; (*X-position (of the found blob) in the image in increments of 1/100 pixel*)
		positionY : DINT; (*Y-position (of the found blob) in the image in increments of 1/100 pixel*)
		orientation : INT; (*-179.99° to +180° in increments of 1/100 degree*)
		rotCenterX : DINT; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps*)
		rotCenterY : DINT; (*The value deviating from the specified taught-in Alignment model is output here. In 1/100 pixel steps*)
	END_STRUCT;
	brdkViBase_hw_subBlob_10_in_typ : 	STRUCT  (*Subpixel BLOB hardware input structure for 10 results*)
		common : brdkViBase_hw_vf_in_common_typ;
		results : ARRAY[0..9]OF brdkViBase_hw_subBlob_in_typ;
	END_STRUCT;
	brdkViBase_hw_subBlob_10_typ : 	STRUCT  (*Subpixel BLOB hardware structure for 10 results*)
		in : brdkViBase_hw_subBlob_10_in_typ;
		out : brdkViBase_hw_subBlob_out_typ;
	END_STRUCT;
	brdkViBase_imgTrigger_sim_typ : 	STRUCT 
		enable : BOOL; (*Enable simulation, the FB will not wait for actual hardware feedback through IOs*)
		imgProcessingDelay : TIME; (*Delay time for simulating image processing on camera*)
		alwaysSimulateNonePresentCamera : BOOL; (*If TRUE then non present devices (moduleOk = FALSE) will always be simulation no matter what value enable has*)
		alwaysSimulateNonePresentLights : BOOL; (*If TRUE then non present devices (moduleOk = FALSE) will always be simulation no matter what value enable has*)
	END_STRUCT;
	brdkViBase_imgTrigger_local_typ : 	STRUCT 
		state : USINT;
		oldNettime : DINT;
		oldAccCnt : USINT;
		initDone : BOOL;
		triggerActive : BOOL;
		simDelay : TON;
		waitForImage : BOOL;
	END_STRUCT;
	brdkViBase_simCam_internal_typ : 	STRUCT 
		imgCnt : USINT;
		cnt : USINT;
		procNettime : DINT;
		triggerNettime : DINT;
		procState : USINT;
		state : USINT;
		searchDone : BOOL;
	END_STRUCT;
END_TYPE
