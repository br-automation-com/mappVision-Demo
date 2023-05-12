(*Local data structure*)

TYPE
	local_axisTrig_typ : 	STRUCT 
		nettimeLastCycle_us : DINT;
		powerlinkCycle_us : DINT;
		axisPositionNow : REAL;
		triggerPosDelta : REAL;
		triggerTimeDelta : DINT; (*In us*)
	END_STRUCT;
	local_vaList_typ : 	STRUCT 
	END_STRUCT;
	local_typ : 	STRUCT 
		path : STRING[100];
		brdkViBase_imgTrigger_0 : brdkViBase_imgTrigger;
		brdkViBase_getCameraInfo_0 : brdkViBase_getCameraInfo;
		mappView : {REDUND_UNREPLICABLE} brdkViImg_mappView;
		viBaseSaveDiagData_0 : ViBaseSaveDiagData;
		fileDelete : FileDelete;
		visionDiagFileDevice : STRING[10];
		viBaseLoadApplication_0 : ViBaseLoadApplication;
		axisTrig : local_axisTrig_typ;
		brdkFileWrite : brdkFileWrite;
		dtNow : DTStructure;
		DTGetTime_0 : DTGetTime;
		tmp2D : brdkViBase_2d_typ;
		strElemId : STRING[80];
		oldIntElemID : USINT;
		elemId : STRING[80];
		tmpAngle : LREAL;
		strStyle : STRING[240];
		mpRecipeRegVar : MpRecipeRegParSync;
		recipePVName : STRING[100];
		getVaList : ViBaseListApplication;
		tmpFileName : STRING[255];
		saveState : USINT;
		ioTrigger : R_TRIG;
		user : user_local_typ;
		currentTriggerNum : UINT;
		repetitiveTriggerTON : TON;
	END_STRUCT;
END_TYPE

(*Hardware*)

TYPE
	hw_io_in_typ : 	STRUCT 
		nettime : DINT;
		commonTrigger : BOOL;
		individualTrigger : BOOL;
	END_STRUCT;
	hw_io_typ : 	STRUCT 
		in : hw_io_in_typ;
	END_STRUCT;
	hw_typ : 	STRUCT 
		camera : brdkViBase_cam_hw_typ;
		VF : hw_VF_typ;
		lights : ARRAY[START_IDX..MAX_NUM_LIGHTS]OF brdkViBase_light_hw_typ;
		io : hw_io_typ;
		user : user_hw_typ;
	END_STRUCT;
	hw_VF_typ : 	STRUCT 
		codeReader : brdkViBase_hw_cr_10_typ;
		pixelCnt : brdkViBase_hw_pxCnt_10_typ;
		measurement : brdkViBase_hw_meas_10_typ;
		matching : brdkViBase_hw_match_10_typ;
		ocr : brdkViBase_hw_OCR_10_typ;
		blob : brdkViBase_hw_blob_10_typ;
	END_STRUCT;
END_TYPE

(*HMI*)

TYPE
	hmi_typ : 	STRUCT 
		in : hmi_in_typ;
		out : hmi_out_typ;
		user : user_hmi_typ;
	END_STRUCT;
END_TYPE

(*HMI output*)

TYPE
	hmi_out_typ : 	STRUCT 
		svgOverlay : STRING[10000];
		wsPort : UINT;
		lights : ARRAY[START_IDX..MAX_NUM_LIGHTS]OF hmi_out_lights_typ;
		camera : hmi_out_camera_typ;
		VF : hmi_out_vf_typ;
		tableVF : hmi_out_vf_table_typ;
		vaList : hmi_out_vaList_typ;
		usedVF : hmi_out_usedVF_typ;
	END_STRUCT;
	hmi_out_vf_typ : 	STRUCT 
		processingTime : UDINT;
		numResults : USINT;
		match : brdkViBase_hmi_match_in_typ;
		measurement : brdkViBase_hw_meas_in_typ;
		codeReader : brdkViBase_hmi_cr_in_typ;
		ocr : brdkViBase_hmi_OCR_in_typ;
		pixelCnt : brdkViBase_hmi_pxCnt_in_typ;
		blob : brdkViBase_hmi_blob_in_typ;
	END_STRUCT;
	hmi_out_lights_typ : 	STRUCT 
		status : brdkViBase_light_hw_status_typ;
		common : brdkViBase_hw_in_common_typ;
		simulated : BOOL;
		connectedText : STRING[20];
		connected : BOOL;
		statusText : STRING[50];
		lightType : USINT;
		plNodeNr : USINT;
	END_STRUCT;
	hmi_out_camera_typ : 	STRUCT 
		simulated : BOOL;
		connectedText : STRING[20];
		connected : BOOL;
		mappVisionActive : BOOL;
		processing : BOOL;
		ready : BOOL;
		statusText : STRING[50];
		plNodeNr : USINT;
		visionFunction : STRING[20];
		processingTime : UDINT;
		opticInfo : brdkViBase_opticInfo_typ;
		common : brdkViBase_hw_in_common_typ;
		hw : brdkViBase_cam_hw_in_status_typ;
		vaLoad : DINT;
		saveDiagStatus : DINT;
		flashLightOptions : ARRAY[0..4]OF STRING[100];
	END_STRUCT;
	hmi_out_vaList_typ : 	STRUCT 
		list : ARRAY[0..99]OF ViBaseFormatPlainTextType;
		length : {REDUND_UNREPLICABLE} UINT;
		lastError : DINT;
	END_STRUCT;
	hmi_out_usedVF_typ : 	STRUCT 
		pixelCounter : BOOL;
		measurement : BOOL;
		matching : BOOL;
		codeReader : BOOL;
		OCR : BOOL;
		BLOB : BOOL;
	END_STRUCT;
	hmi_out_vf_table_cr_typ : 	STRUCT  (*Code reader structures*)
		BarcodeText : ARRAY[START_IDX..MAX_NUM_RESULTS]OF STRING[101];
		BarcodeType : ARRAY[START_IDX..MAX_NUM_RESULTS]OF USINT;
		PositionX : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		PositionY : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		Orientation : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		Grading : ARRAY[START_IDX..MAX_NUM_RESULTS]OF SINT;
	END_STRUCT;
	hmi_out_vf_table_blob_typ : 	STRUCT  (*Blob function structures*)
		ModelNumber : ARRAY[START_IDX..MAX_NUM_RESULTS]OF USINT;
		Clipped : ARRAY[START_IDX..MAX_NUM_RESULTS]OF BOOL;
		Area : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		PositionX : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		PositionY : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		Orientation : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		MeanGrayValue : ARRAY[START_IDX..MAX_NUM_RESULTS]OF USINT;
		Length : ARRAY[START_IDX..MAX_NUM_RESULTS]OF UDINT;
		Width : ARRAY[START_IDX..MAX_NUM_RESULTS]OF UDINT;
	END_STRUCT;
	hmi_out_vf_match_typ : 	STRUCT  (*Match function structures*)
		ModelNumber : ARRAY[START_IDX..MAX_NUM_RESULTS]OF USINT;
		Score : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		PositionX : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		PositionY : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		Orientation : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		Scale : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		RotCenterX : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		RotCenterY : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
	END_STRUCT;
	hmi_out_vf_table_ocr_typ : 	STRUCT  (*OCR function structures*)
		Text : ARRAY[START_IDX..MAX_NUM_RESULTS]OF STRING[51];
		Grading : ARRAY[START_IDX..MAX_NUM_RESULTS]OF USINT;
		PositionX : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		PositionY : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		Orientation : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
	END_STRUCT;
	hmi_out_vf_table_pxCnt_typ : 	STRUCT  (*OCR function structures*)
		ModelNumber : ARRAY[START_IDX..MAX_NUM_RESULTS]OF USINT;
		NumPixels : ARRAY[START_IDX..MAX_NUM_RESULTS]OF UDINT;
		MinGray : ARRAY[START_IDX..MAX_NUM_RESULTS]OF USINT;
		MaxGray : ARRAY[START_IDX..MAX_NUM_RESULTS]OF USINT;
		MeanGray : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		DeviationGray : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		MedianGray : ARRAY[START_IDX..MAX_NUM_RESULTS]OF USINT;
		ModelArea : ARRAY[START_IDX..MAX_NUM_RESULTS]OF UDINT;
		NumConnectedComponents : ARRAY[START_IDX..MAX_NUM_RESULTS]OF UINT;
		PositionX : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
		PositionY : ARRAY[START_IDX..MAX_NUM_RESULTS]OF REAL;
	END_STRUCT;
	hmi_out_vf_table_meas_typ : 	STRUCT  (*MT function structures*)
		Result : ARRAY[START_IDX..MAX_NUM_RESULTS]OF DINT;
	END_STRUCT;
	hmi_out_vf_table_typ : 	STRUCT 
		match : hmi_out_vf_match_typ;
		ocr : hmi_out_vf_table_ocr_typ;
		measurement : hmi_out_vf_table_meas_typ;
		pixelCnt : hmi_out_vf_table_pxCnt_typ;
		blob : hmi_out_vf_table_blob_typ;
		codeReader : hmi_out_vf_table_cr_typ;
		tableNum : ARRAY[0..MAX_NUM_RESULTS]OF USINT;
	END_STRUCT;
END_TYPE

(*HMI Input*)

TYPE
	hmi_in_typ : 	STRUCT 
		cmd : hmi_in_cmd_typ;
		recipe : recipe_typ;
		cameraInfo : brdkViBase_camInfo_typ;
		diagnosticFilename : STRING[50];
		vaName : STRING[50];
		lightNum : USINT := 1;
	END_STRUCT;
	hmi_in_cmd_flashSegment_typ : 	STRUCT 
		top : BOOL := TRUE;
		bottom : BOOL := TRUE;
		right : BOOL := TRUE;
		left : BOOL := TRUE;
	END_STRUCT;
	hmi_in_cmd_vaList_typ : 	STRUCT 
		refresh : BOOL;
		selectedIndex : UINT;
		load : BOOL;
	END_STRUCT;
	hmi_in_cmd_typ : 	STRUCT 
		lights : ARRAY[START_IDX..MAX_NUM_LIGHTS]OF brdkViBase_light_hw_out_cmd_typ;
		flashSegment : hmi_in_cmd_flashSegment_typ;
		trigger : BOOL; (*Trigger a image*)
		autoSearch : BOOL; (*Start auto Search of exposure and focus for camra*)
		resetInfo : BOOL; (*Reset optic info to the current camera*)
		saveDiagnositc : BOOL; (*Save vision diagnostic *)
		saveImage : BOOL;
		intElemId : USINT := 1;
		elemId : STRING[80];
		click : BOOL;
		y : REAL;
		x : REAL;
		vaList : hmi_in_cmd_vaList_typ;
		resultTabIndex : USINT;
	END_STRUCT;
	hmi_in_recipe_draw_typ : 	STRUCT 
		intShape : INT := 0; (*0 = None, 1=  rectangle, 2 = circle, 3 = triangle*)
		radius : REAL := 60;
		width : REAL := 80;
		length : REAL := 80;
		rotation : REAL := 0;
		fillColor : STRING[80] := ' fill: green;';
		activeStrokeColor : STRING[80] := ' stroke: orange;';
		strokeColor : STRING[80] := ' stroke: green;';
		strokeWidth : INT := 5;
		strokeOpac : REAL := 1;
		fillOpac : REAL := 0.3;
	END_STRUCT;
END_TYPE

(*Recipe data structure (saved to file and included in the HMI input data structure for access from HMI)*)

TYPE
	recipe_typ : 	STRUCT 
		lights : ARRAY[START_IDX..MAX_NUM_LIGHTS]OF brdkViBase_light_hw_out_par_typ;
		cam : brdkViBase_cam_recipe_typ;
		BLOB : brdkViBase_hw_blob_out_typ;
		CR : brdkViBase_hw_cr_out_typ := (symbolType:=0);
		match : brdkViBase_hw_match_out_typ;
		meassurement : brdkViBase_hw_meas_out_typ;
		OCR : brdkViBase_hw_OCR_out_typ;
		pxCnt : brdkViBase_hw_pxCnt_out_typ;
		useCamExpTimeForLight : BOOL := TRUE;
		useCamLedColorForLight : BOOL := TRUE;
		ioTriggerDelay : DINT := 100;
		enableIoTrigger : BOOL := FALSE;
		multiCaptureNum : UINT := 1;
		showOnlyLastImage : BOOL := FALSE;
		draw : hmi_in_recipe_draw_typ;
		enableAxisTrigger : BOOL := FALSE;
		repetitiveTriggerInterval : UDINT := 1000;
		repetitiveTrigger : BOOL := FALSE;
		CRTypeStr : STRING[20] := '0';
		user : user_recipe_typ;
	END_STRUCT;
	common_recipe_typ : 	STRUCT 
		jpegQuality : USINT := 50;
		imageFormat : BRDKVIIMG_IMG_TYPE := BRDKVIIMG_IMG_TYPE_JPEG;
		visionPreTriggerCycles : DINT := 12;
		enableAxisTrigger : BOOL;
		saveAllImages : BOOL;
		saveSvg : BOOL;
		saveImage : BOOL;
		user : user_common_recipe_typ;
	END_STRUCT;
END_TYPE

(*Common HMI*)

TYPE
	common_hmi_in_cmd_typ : 	STRUCT 
		deleteAllImage : BOOL;
		refreshVAlist : BOOL;
	END_STRUCT;
	common_hmi_in_typ : 	STRUCT 
		recipe : common_recipe_typ;
		cmd : common_hmi_in_cmd_typ;
		dataFilePostName : STRING[255];
	END_STRUCT;
	common_hmi_out_typ : 	STRUCT 
		tmp : USINT;
	END_STRUCT;
	common_hmi_typ : 	STRUCT 
		out : common_hmi_out_typ;
		in : common_hmi_in_typ;
		user : user_commonHmi_typ;
	END_STRUCT;
END_TYPE
