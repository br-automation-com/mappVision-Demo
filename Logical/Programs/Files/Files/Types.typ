
TYPE
	local_typ : 	STRUCT 
		brdkFileDevUsb : brdkFileDeviceHandler;
		brdkFileDev : brdkFileDeviceHandler;
		mpFileManUI : MpFileManagerUI;
		mpFileUISetup : MpFileManagerUISetupType;
		mpFileManConf : MpFileManagerConfig;
		mpFileConfig : MpFileManagerConfigType;
	END_STRUCT;
	hmi_in_cmd_typ : 	STRUCT 
		deleteAllImages : BOOL;
	END_STRUCT;
	hmi_in_typ : 	STRUCT 
		cmd : hmi_in_cmd_typ;
	END_STRUCT;
	hmi_out_typ : 	STRUCT 
		enableDeleteAllImageBtn : BOOL;
		fileNames : ARRAY[0..11]OF STRING[255];
	END_STRUCT;
	hmi_typ : 	STRUCT 
		in : hmi_in_typ;
		out : hmi_out_typ;
		mpFile : MpFileManagerUIConnectType;
	END_STRUCT;
END_TYPE
