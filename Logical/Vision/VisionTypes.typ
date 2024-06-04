(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*General vision structures*)

TYPE
	typVisionMain : 	STRUCT 
		CMD : typVisionCommand;
		CFG : typVisionConfig;
		DAT : typVisionData;
		FCT : typVisionFunction;
		DIA : typVisionDiag;
		OPT : typVisionOptics;
		HW : typVisionHW;
	END_STRUCT;
	typVisionCommand : 	STRUCT 
		ImageTrigger : BOOL;
		ImageTriggerReset : BOOL;
		AutoSetupStartStop : BOOL;
		VaSwitchApplication : BOOL;
		SaveDiagData : BOOL;
		ReadCameraInfo : BOOL;
	END_STRUCT;
	typVisionConfig : 	STRUCT 
		VisionFunction : enumVisionFunction;
		PowerlinkNode : USINT;
		DataStructure : UDINT;
		ComponentLink : ViComponentType;
		ResolutionWidth_X : UINT; (*Nr of sensor pixels in x direction (width). Is always bigger than height*)
		ResolutionHeight_Y : UINT; (*Nr of sensor pixels in y direction (height). Is always smaller than width*)
	END_STRUCT;
	typVisionFunction : 	STRUCT 
		ApplicationName : STRING[40];
		Status : DINT;
	END_STRUCT;
	typVisionDiag : 	STRUCT 
		DiagName : STRING[80] := 'diag.tgz';
		Status : DINT;
	END_STRUCT;
	typVisionData : 	STRUCT 
		Enable : BOOL := FALSE;
		MaxItemCnt : USINT := 10;
		NettimeDelay : DINT;
		Timeout : UINT := 5000;
		Gain : USINT;
		Focus : UINT;
		Exposure : UDINT;
		FlashColor : USINT := 1;
		FlashSegment : USINT := 15;
		LedColor : USINT;
		IRFilter : BOOL;
		OffsetROIX : DINT;
		OffsetROIY : DINT;
		OffsetROIRotationCenterX : DINT;
		OffsetROIRotationCenterY : DINT;
		OffsetROIOrientation : INT;
		ChromaticLock : BOOL;
		Alignment : USINT;
		AutoSetupGain : USINT;
		AutoSetupFocus : UINT;
		AutoSetupExposure : UDINT;
		AcquisitionAcceptedCnt : USINT;
		AcquisitionCompletedCnt : USINT;
		AcquisitionFailedCnt : USINT;
		LightWarningCnt : USINT;
		ImageProcessingError : UINT;
		ImageProcessingActive : BOOL;
		ImageNettime : DINT;
		ProcessingTimeCamera : UINT;
		ProcessingTimeFunction : UINT;
		ResultCnt : USINT;
		CockpitIsActive : BOOL;
		Status : UDINT;
		StatusText : STRING[30];
		Active : BOOL;
	END_STRUCT;
	typVisionOptics : 	STRUCT 
		OrderNr : STRING[40];
		Binning : BOOL;
		ResolutionX : INT;
		ResolutionY : INT;
		Lens : USINT;
		Sensor : USINT;
		ValidDistance : BOOL;
		Distance_mm : LREAL;
		DistanceLens_mm : LREAL;
		HyperFocalDistance_mm : LREAL;
		PixelSize_um : LREAL;
		PixelSizeBinning_um : LREAL;
		FocalLength_mm : LREAL;
		MinObjectDist_mm : LREAL;
		MaxObjectDist_mm : LREAL;
		Aperture : LREAL;
		CircleOfConfusion_mm : LREAL;
		DepthOfFieldNearPos_mm : LREAL;
		DepthOfFieldFarPos_mm : LREAL;
		DepthOfField_mm : LREAL;
		FieldOfView_X_mm : LREAL;
		FieldOfView_Y_mm : LREAL;
		Resolution_mmPerPx : LREAL;
	END_STRUCT;
	typVisionHW : 	STRUCT 
		Connected : BOOL;
		Ready : BOOL;
		DigitalInput01 : BOOL;
		DigitalOutput01 : BOOL;
		DigitalOutputStatus01 : BOOL;
		DigitalOutput02 : BOOL;
		DigitalOutputStatus02 : BOOL;
		SerialNumber : UDINT;
		ID : UDINT;
		Variant : UDINT;
		Firmware : UDINT;
		Undervoltage : BOOL;
		Temperature : SINT;
	END_STRUCT;
	enumVisionFunction : 
		(
		enumFunctionNone,
		enumBlob,
		enumCoderReader,
		enumMatch,
		enumMeasurement,
		enumOCR,
		enumPixelCounter
		);
END_TYPE

(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*General Light structures*)

TYPE
	typLightMain : 	STRUCT 
		CMD : typLightCommand;
		CFG : typLightConfig;
		DAT : typLightData;
		HW : typLightHW;
	END_STRUCT;
	typLightCommand : 	STRUCT 
		FlashTrigger : BOOL;
		FlashTriggerReset : BOOL;
	END_STRUCT;
	typLightConfig : 	STRUCT 
		LightType : enumLightType;
		PowerlinkNode : USINT;
	END_STRUCT;
	typLightData : 	STRUCT 
		Enable : USINT := 1;
		FlashColor : USINT := 1;
		FlashSegment : UINT := 15;
		Exposure : UDINT := 200;
		SetAngle : UINT;
		Timeout : UINT := 5000;
		NettimeDelay : DINT;
		FlashAcceptedCnt : USINT;
		FlashCompletedCnt : USINT;
		FlashFailedCnt : USINT;
		Status : UDINT;
	END_STRUCT;
	typLightHW : 	STRUCT 
		Connected : BOOL;
		Ready : BOOL;
		SerialNumber : UDINT;
		ID : UDINT;
		Variant : UDINT;
		Firmware : UDINT;
		TemperatureLED : SINT;
		TemperatureControllerBoard : SINT;
		WarningCnt : USINT;
	END_STRUCT;
	enumLightType : 
		(
		enumLightNone,
		enumBacklight,
		enumLightbar
		);
END_TYPE

(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*General nettime structures*)

TYPE
	typVisionNettime : 	STRUCT 
		CMD : typNettimeCommand;
		CFG : typNettimeConfig;
		DAT : typNettimeData;
	END_STRUCT;
	typNettimeCommand : 	STRUCT 
		Activate : BOOL;
	END_STRUCT;
	typNettimeConfig : 	STRUCT 
		AxisPeriod : LREAL; (*Units when period repeats*)
		AxisPositionTrigger : LREAL; (*Position in the period where trigger is fired*)
		AxisPositionDelay_Cycles : LREAL; (*Delay in PLK cycles for the read position from drive*)
		VisionPreTrigger_Cycles : DINT; (*Number of powerlink cycles the trigger has to be send ahead*)
	END_STRUCT;
	typNettimeData : 	STRUCT 
		NettimeNext_us : DINT; (*Calculated nettime for next trigger*)
		NettimeDelta_us : DINT; (*Difference between current nettime and calculated nettime for the camera trigger*)
		AxisPosition : LREAL; (*Current axis position*)
		AxisVelocity : LREAL; (*Current axis position*)
		AxisInVelocity : BOOL; (*Indicates that the axis is moving at speed*)
		Overflow : DINT; (*Counts up when a trigger could not be set on time*)
	END_STRUCT;
END_TYPE

(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*Image upload structures*)

TYPE
	typVisionImage : 	STRUCT 
		CMD : typVisionImageCommand;
		CFG : typVisionImageConfig;
		DAT : typVisionImageData;
	END_STRUCT;
	typVisionImageCommand : 	STRUCT 
		CreateDir : BOOL;
		DeleteDir : BOOL;
		DeleteImage : BOOL;
		Refresh : BOOL;
		SaveImage : BOOL;
		ResetError : BOOL;
		RefreshCrosshair : BOOL;
	END_STRUCT;
	typVisionImageConfig : 	STRUCT 
		FileDevice : STRING[80];
		DirName : STRING[80];
		ComponentLink : ViComponentType;
		Format : ViBaseImageTypeEnum; (*0: bmp. 1: jpg*)
		QualityJPG : USINT;
		UploadBmpJpg : BOOL;
		UploadSVG : BOOL;
		MainPageQualityJPG : USINT; (*quality of the jpg image on the main page. min:0, max:100, good value: 30*)
		ImageRotation_deg : UINT; (*rotation of the whole image, steps in degree. Only values 0, 90. 180, 270 make sense*)
	END_STRUCT;
	typVisionImageData : 	STRUCT 
		Images : ARRAY[0..19]OF STRING[80];
		Crosshair : ARRAY[1..MAX_NUM_RESULTS]OF typVisionImageDataCrosshair;
		Status : DINT;
		VisionDisabled : BOOL;
	END_STRUCT;
	typVisionImageDataCrosshair : 	STRUCT 
		CrosshairX : REAL;
		CrosshairY : REAL;
		CrosshairRotate : REAL;
		Text : STRING[1000];
	END_STRUCT;
END_TYPE

(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*Vision specific structures*)

TYPE
	typCodeReaderMain : 	STRUCT  (*Code reader structures*)
		CodeType : USINT;
		GradingEnable : BOOL;
		RobustnessEnable : BOOL;
		ParameterMode : USINT;
		ParameterOptimization : USINT;
		BarcodeText : ARRAY[1..MAX_NUM_RESULTS]OF STRING[100];
		BarcodeType : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		PositionX : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		PositionY : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		Orientation : ARRAY[1..MAX_NUM_RESULTS]OF INT;
		Grading : ARRAY[1..MAX_NUM_RESULTS]OF SINT;
		EnhancedGrading : ARRAY[1..23]OF USINT;
	END_STRUCT;
	typBlobMain : 	STRUCT  (*Blob function structures*)
		RegionalFeature : BOOL;
		EnhancedBlobInformation : BOOL := FALSE;
		ModelNumber : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		Clipped : ARRAY[1..MAX_NUM_RESULTS]OF BOOL;
		Area : ARRAY[1..MAX_NUM_RESULTS]OF UDINT;
		PositionX : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		PositionY : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		Orientation : ARRAY[1..MAX_NUM_RESULTS]OF INT;
		MeanGrayValue : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		Length : ARRAY[1..MAX_NUM_RESULTS]OF UDINT;
		Width : ARRAY[1..MAX_NUM_RESULTS]OF UDINT;
	END_STRUCT;
	typMatchMain : 	STRUCT  (*Match function structures*)
		MinScore : USINT := 70;
		MaxOverlap : USINT;
		ModelNumber : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		Score : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		PositionX : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		PositionY : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		Orientation : ARRAY[1..MAX_NUM_RESULTS]OF INT;
		Scale : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		RotCenterX : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		RotCenterY : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
	END_STRUCT;
	typOCRMain : 	STRUCT  (*OCR function structures*)
		ParameterMode : USINT;
		GradingEnable : BOOL;
		Text : ARRAY[1..MAX_NUM_RESULTS]OF STRING[50];
		Grading : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		PositionX : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		PositionY : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		Orientation : ARRAY[1..MAX_NUM_RESULTS]OF INT;
	END_STRUCT;
	typPixelMain : 	STRUCT  (*OCR function structures*)
		EnhancedPixelCounterInformation : BOOL := FALSE;
		ModelNumber : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		NumPixels : ARRAY[1..MAX_NUM_RESULTS]OF UDINT;
		MinGray : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		MaxGray : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		MeanGray : ARRAY[1..MAX_NUM_RESULTS]OF UINT;
		DeviationGray : ARRAY[1..MAX_NUM_RESULTS]OF UINT;
		MedianGray : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		ModelArea : ARRAY[1..MAX_NUM_RESULTS]OF UDINT;
		NumConnectedComponents : ARRAY[1..MAX_NUM_RESULTS]OF UINT;
		PositionX : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		PositionY : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
	END_STRUCT;
	typMTMain : 	STRUCT  (*MT function structures*)
		UseResultAsXY : BOOL;
		ParameterMode : USINT;
		Result : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
	END_STRUCT;
END_TYPE
