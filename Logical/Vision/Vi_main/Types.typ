
TYPE
	local_axisTrig_typ : 	STRUCT 
		nettimeLastCycle_us : DINT;
		powerlinkCycle_us : DINT;
		axisPositionNow : REAL;
		triggerPosDelta : REAL;
		triggerTimeDelta : DINT; (*In us*)
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
	END_STRUCT;
	hmi_typ : 	STRUCT 
		in : hmi_in_typ;
		out : hmi_out_typ;
	END_STRUCT;
	hmi_out_vf_typ : 	STRUCT 
		processingTime : UDINT;
		numResults : USINT;
		crData : ARRAY[0..9]OF STRING[240];
		match : typMatchMain;
		measurement : typMTMain;
		codeReader : typCodeReaderMain;
		ocr : typOCRMain;
		pixelCnt : typPixelMain;
		blob : typBlobMain;
		ocrData : ARRAY[0..9]OF STRING[240];
	END_STRUCT;
	hmi_out_lights_typ : 	STRUCT 
		status : brdkViBase_light_hw_status_typ;
		common : brdkViBase_hw_in_common_typ;
		simulated : BOOL;
		connectedText : STRING[20];
		connected : BOOL;
		mappVisionActive : BOOL;
		processing : BOOL;
		ready : BOOL;
		statusText : STRING[50];
		lightType : STRING[20];
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
	END_STRUCT;
	hmi_out_typ : 	STRUCT 
		svgOverlay : STRING[10000];
		wsPort : UINT;
		lights : ARRAY[START_IDX..NUM_LIGHTS]OF hmi_out_lights_typ;
		camera : hmi_out_camera_typ;
		VF : hmi_out_vf_typ;
		status : DINT;
	END_STRUCT;
	hmi_in_cmd_flashSegment_typ : 	STRUCT 
		top : BOOL := TRUE;
		bottom : BOOL := TRUE;
		right : BOOL := TRUE;
		left : BOOL := TRUE;
	END_STRUCT;
	hmi_in_cmd_typ : 	STRUCT 
		lights : ARRAY[START_IDX..NUM_LIGHTS]OF brdkViBase_light_hw_out_cmd_typ;
		flashSegment : hmi_in_cmd_flashSegment_typ;
		repetitiveTrigger : BOOL; (*Enable Repetitive trigger*)
		trigger : BOOL; (*Trigger a image*)
		autoSearch : BOOL; (*Start auto Search of exposure and focus for camra*)
		resetInfo : BOOL; (*Reset optic info to the current camera*)
		saveDiagnositc : BOOL; (*Save vision diagnostic *)
		loadVA : BOOL; (*Load Vision application*)
		saveImage : BOOL;
		intElemId : USINT := 1;
		elemId : STRING[80];
		click : BOOL;
		y : REAL;
		x : REAL;
		shapeSelector : ARRAY[0..2]OF STRING[100] := ['{"value":"1", "text":"Rectangle"}','{"value":"2", "text":"Circle"}','{"value":"3", "text":"Triangle"}'];
		strokeColorSelector : ARRAY[0..5]OF STRING[100] := ['{"value":";stroke:black", "text":"Black"}','{"value":";stroke:white", "text":"White"}','{"value":";stroke:red", "text":"Red"}','{"value":";stroke:green", "text":"Green"}','{"value":";stroke:blue", "text":"Blue"}','{"value":";stroke:yellow", "text":"Yellow"}'];
		fillColorSelector : ARRAY[0..5]OF STRING[100] := ['{"value":"fill:black", "text":"Black"}','{"value":"fill:white", "text":"White"}','{"value":"fill:red", "text":"Red"}','{"value":"fill:green", "text":"Green"}','{"value":"fill:blue", "text":"Blue"}','{"value":"fill:yellow", "text":"Yellow"}'];
		draw : hmi_in_cmd_draw_typ;
	END_STRUCT;
	hmi_in_cmd_draw_typ : 	STRUCT 
		intShape : INT; (*0 = rectangle, 1 = circle, 2 = triangle*)
		radius : REAL := 60;
		width : REAL := 80;
		length : REAL := 80;
		invRotation : REAL;
		rotation : REAL;
		strFillColor : STRING[80];
		strStrokeColor : STRING[80];
		strStrokeWidth : STRING[80];
		strFillOpac : STRING[80];
		strStrokeOpac : STRING[80];
		intStrokeWidth : INT := 6;
		realFillOpac : REAL := 0;
		realStrokeOpac : REAL := 1;
		strStyleHighlight : STRING[240];
		strStyle : STRING[240];
	END_STRUCT;
	hmi_in_typ : 	STRUCT 
		cmd : hmi_in_cmd_typ;
		recipe : recipe_typ;
		cameraInfo : brdkViBase_camInfo_typ;
		diagnosticFilename : STRING[50];
		vaName : STRING[50];
		lightNum : USINT := 1;
	END_STRUCT;
	hw_io_in_typ : 	STRUCT 
		nettime : DINT;
	END_STRUCT;
	hw_io_typ : 	STRUCT 
		in : hw_io_in_typ;
	END_STRUCT;
	hw_typ : 	STRUCT 
		camera : brdkViBase_cam_hw_typ;
		VF : hw_VF_typ;
		lights : ARRAY[START_IDX..NUM_LIGHTS]OF brdkViBase_light_hw_typ;
		io : hw_io_typ;
	END_STRUCT;
	hw_VF_typ : 	STRUCT 
		codeReader : brdkViBase_hw_cr_10_typ;
		pixelCnt : brdkViBase_hw_pxCnt_10_typ;
		measurement : brdkViBase_hw_mes_10_typ;
		matching : brdkViBase_hw_match_10_typ;
		ocr : brdkViBase_hw_OCR_10_typ;
		blob : brdkViBase_hw_blob_10_typ;
	END_STRUCT;
	recipe_typ : 	STRUCT 
		lights : ARRAY[START_IDX..NUM_LIGHTS]OF brdkViBase_light_hw_out_par_typ;
		cam : brdkViBase_cam_recipe_typ;
		BLOB : brdkViBase_hw_blob_out_typ;
		CR : brdkViBase_hw_cr_out_typ;
		match : brdkViBase_hw_match_out_typ;
		meassurement : brdkViBase_hw_mes_out_typ;
		OCR : brdkViBase_hw_OCR_out_typ;
		pxCnt : brdkViBase_hw_pxCnt_out_typ;
	END_STRUCT;
	common_recipe_typ : 	STRUCT 
		jpegQuality : USINT;
		imageFormat : BRDKVIIMG_IMG_TYPE;
		visionPreTriggerCycles : DINT := 0;
		enableAxisTrigger : BOOL;
	END_STRUCT;
END_TYPE
