(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*General vision structures*)

TYPE
	typVisionMain : 	STRUCT 
		CMD : typVisionCommand;
		CFG : typVisionConfig;
		STA : typVisionStatus;
		HW : typVisionHW;
	END_STRUCT;
	typVisionCommand : 	STRUCT 
		ImageTrigger : BOOL;
		ImageTriggerReset : BOOL;
		AutoSetupStartStop : BOOL;
		AutoSetupTransfer : BOOL;
		BrowserReload : BOOL;
	END_STRUCT;
	typVisionConfig : 	STRUCT 
		VisionFunction : enumVisionFunction;
		PowerlinkNode : USINT;
		DataStructure : UDINT;
		Enable : USINT := 1;
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
	END_STRUCT;
	typVisionStatus : 	STRUCT 
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
		enumMatch,
		enumCoderReader,
		enumOCR,
		enumMeasurement
		);
END_TYPE

(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*General Light structures*)

TYPE
	typLightMain : 	STRUCT 
		CMD : typLightCommand;
		CFG : typLightConfig;
		STA : typLightStatus;
		HW : typLightHW;
	END_STRUCT;
	typLightCommand : 	STRUCT 
		FlashTrigger : BOOL;
		FlashTriggerReset : BOOL;
	END_STRUCT;
	typLightConfig : 	STRUCT 
		LightType : enumLightType;
		PowerlinkNode : USINT;
		Enable : USINT := 1;
		FlashColor : USINT := 99;
		Exposure : UDINT := 200;
		NettimeDelay : DINT;
	END_STRUCT;
	typLightStatus : 	STRUCT 
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
		Temperature : SINT;
	END_STRUCT;
	enumLightType : 
		(
		enumLightNone,
		enumBacklight,
		enumBarlight
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
		Activate : BOOL := TRUE;
	END_STRUCT;
	typNettimeConfig : 	STRUCT 
		AxisPeriod : LREAL := 360; (*Units when period repeats*)
		PowerlinkDelay : USINT := 4; (*Number of powerlink cycles the trigger has to be send ahead*)
		AxisPositionTrigger : LREAL := 0; (*Position in the period where trigger is fired*)
	END_STRUCT;
	typNettimeData : 	STRUCT 
		PowerlinkCycle : DINT; (*Powerlink cycle time in microseconds*)
		NettimeNext : DINT; (*Calculated nettime for next trigger*)
		NettimeDelta : DINT; (*Difference between current nettime and calculated nettime*)
		AxisPosition : LREAL; (*Current axis position*)
		AxisVelocity : LREAL; (*Current axis position*)
		AxisPositionDelta : LREAL; (*Units when next trigger position is reached*)
		AxisTimeDelta : DINT; (*Time when next trigger position is reached*)
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
		STA : typVisionImageStatus;
		DATA : typVisionImageData;
	END_STRUCT;
	typVisionImageCommand : 	STRUCT 
		Save : BOOL;
		Refresh : BOOL;
		Delete : BOOL;
		Download : BOOL;
		ResetError : BOOL;
		DeleteDir : BOOL;
		CreateDir : BOOL;
	END_STRUCT;
	typVisionImageConfig : 	STRUCT 
		FileDevice : STRING[80];
		DirName : STRING[80];
		CameraIP : STRING[80];
		ConvertCycles : UDINT;
		Format : USINT; (*0: jpg. 1: bmp*)
		QualityJPG : USINT;
		UploadBmpJpg : BOOL;
		UploadSVG : BOOL;
	END_STRUCT;
	typVisionImageStatus : 	STRUCT 
		Status : UINT;
	END_STRUCT;
	typVisionImageData : 	STRUCT 
		Images : ARRAY[0..19]OF STRING[80];
		Crosshair : ARRAY[1..MAX_NUM_RESULTS]OF typVisionImageDataCrosshair;
	END_STRUCT;
	typVisionImageDataCrosshair : 	STRUCT 
		CrosshairX : REAL;
		CrosshairY : REAL;
		CrosshairRotate : REAL;
		Text : STRING[1000];
	END_STRUCT;
END_TYPE

(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*Code reader structures*)

TYPE
	typCodeReaderMain : 	STRUCT 
		CFG : typCodeReaderConfig;
		DATA : typCodeReaderData;
	END_STRUCT;
	typCodeReaderConfig : 	STRUCT 
		CodeType : USINT;
		GradingEnable : USINT;
		RobustnessEnable : USINT;
		ParameterMode : USINT;
		ParameterOptimization : USINT;
	END_STRUCT;
	typCodeReaderData : 	STRUCT 
		BarcodeText : ARRAY[1..MAX_NUM_RESULTS]OF STRING[100];
		BarcodeType : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		PositionX : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		PositionY : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		Orientation : ARRAY[1..MAX_NUM_RESULTS]OF INT;
		Grading : ARRAY[1..MAX_NUM_RESULTS]OF SINT;
		EnhancedGrading : ARRAY[1..23]OF USINT;
	END_STRUCT;
END_TYPE

(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*Blob function structures*)

TYPE
	typBlobMain : 	STRUCT 
		CFG : typBlobConfig;
		DATA : typBlobData;
	END_STRUCT;
	typBlobConfig : 	STRUCT 
		RegionalFeature : USINT;
	END_STRUCT;
	typBlobData : 	STRUCT 
		ModelNumber : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		Clipped : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		Area : ARRAY[1..MAX_NUM_RESULTS]OF UDINT;
		PositionX : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		PositionY : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		Orientation : ARRAY[1..MAX_NUM_RESULTS]OF INT;
		MeanGrayValue : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		Length : ARRAY[1..MAX_NUM_RESULTS]OF UDINT;
		Width : ARRAY[1..MAX_NUM_RESULTS]OF UDINT;
	END_STRUCT;
END_TYPE

(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*Match function structures*)

TYPE
	typMatchMain : 	STRUCT 
		CFG : typMatchConfig;
		DATA : typMatchData;
	END_STRUCT;
	typMatchConfig : 	STRUCT 
		MinScore : USINT := 70;
		MaxOverlap : USINT;
	END_STRUCT;
	typMatchData : 	STRUCT 
		ModelNumber : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		Score : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		PositionX : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		PositionY : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		Orientation : ARRAY[1..MAX_NUM_RESULTS]OF INT;
		Scale : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		RotCenterX : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		RotCenterY : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
	END_STRUCT;
END_TYPE

(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*OCR function structures*)

TYPE
	typOCRMain : 	STRUCT 
		CFG : typOCRConfig;
		DATA : typOCRData;
	END_STRUCT;
	typOCRConfig : 	STRUCT 
		ParameterMode : USINT;
		Grading : BOOL;
	END_STRUCT;
	typOCRData : 	STRUCT 
		Text : ARRAY[1..MAX_NUM_RESULTS]OF STRING[50];
		Grading : ARRAY[1..MAX_NUM_RESULTS]OF USINT;
		PositionX : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		PositionY : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
		Orientation : ARRAY[1..MAX_NUM_RESULTS]OF INT;
	END_STRUCT;
END_TYPE

(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*MT function structures*)

TYPE
	typMTMain : 	STRUCT 
		CFG : typMTConfig;
		DATA : typMTData;
	END_STRUCT;
	typMTConfig : 	STRUCT 
		UseResultAsXY : BOOL;
		ParameterMode : USINT;
	END_STRUCT;
	typMTData : 	STRUCT 
		Result : ARRAY[1..MAX_NUM_RESULTS]OF DINT;
	END_STRUCT;
END_TYPE
