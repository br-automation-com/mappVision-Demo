
TYPE
	local_typ : 	STRUCT 
		brdkFileDevUsb : brdkFileDeviceHandler;
		brdkFileDev : brdkFileDeviceHandler;
		mpFileManUI : MpFileManagerUI;
		mpFileUISetup : MpFileManagerUISetupType;
		mappView : brdkViImg_mappView;
		lastFileName : STRING[255];
		brdkFileRead : brdkFileRead;
		fileName : STRING[255];
		fileType : STRING[5];
		delayTon : TON;
		setIdx : BOOL;
	END_STRUCT;
	hmi_in_cmd_typ : 	STRUCT 
		deleteAllImages : BOOL;
		selectedIdx : UINT;
		download : BOOL;
	END_STRUCT;
	hmi_in_typ : 	STRUCT 
		cmd : hmi_in_cmd_typ;
	END_STRUCT;
	hmi_out_typ : 	STRUCT 
		enableDeleteAllImageBtn : BOOL;
		fileNames : ARRAY[0..FILES_LIST_SIZE]OF STRING[255];
		loadFileStatus : STRING[200];
		img : STRING[8000000];
		svg : STRING[1000000];
		downloadSrc : STRING[500];
	END_STRUCT;
	hmi_typ : 	STRUCT 
		in : hmi_in_typ;
		out : hmi_out_typ;
		mpFile : MpFileManagerUIConnectType;
	END_STRUCT;
END_TYPE
