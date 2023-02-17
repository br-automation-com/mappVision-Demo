
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
	END_STRUCT;
	hmi_typ : 	STRUCT 
		in : hmi_in_typ;
		out : hmi_out_typ;
	END_STRUCT;
	hmi_out_vf_typ : 	STRUCT 
		processingTime : UDINT;
		numResults : USINT;
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
		camera : hmi_out_camera_typ;
		VF : hmi_out_vf_typ;
		status : DINT;
	END_STRUCT;
	hmi_in_cmd_typ : 	STRUCT 
		repetitiveTrigger : BOOL; (*Enable Repetitive trigger*)
		trigger : BOOL; (*Trigger a image*)
		autoSearch : BOOL; (*Start auto Search of exposure and focus for camra*)
		resetInfo : BOOL; (*Reset optic info to the current camera*)
		saveDiagnositc : BOOL; (*Save vision diagnostic *)
		loadVA : BOOL; (*Load Vision application*)
		saveImage : BOOL;
	END_STRUCT;
	hmi_in_typ : 	STRUCT 
		cmd : hmi_in_cmd_typ;
		recipe : recipe_typ;
		cameraInfo : brdkViBase_camInfo_typ;
		diagnosticFilename : STRING[50];
		vaName : STRING[50];
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
		lights : ARRAY[START_IDX..9]OF brdkViBase_light_hw_typ;
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
