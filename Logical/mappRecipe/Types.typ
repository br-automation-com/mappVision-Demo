(*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*)
(*Global enumerations*)

TYPE
	recSTATE : 
		( (*Recipe management state machine*)
		REC_WAIT,
		REC_REG_NAME,
		REC_REG_VAR,
		REC_CREATE_DIR,
		REC_READ_DIR,
		REC_READ_DIR_1,
		REC_READ_DIR_2,
		REC_READ_DIR_3,
		REC_GEN_FILE_NAME,
		REC_LOAD_SAVE,
		REC_DELETE,
		REC_RENAME,
		REC_VIEW,
		REC_DOWNLOAD,
		REC_DOWNLOAD_1,
		REC_DOWNLOAD_2,
		REC_DOWNLOAD_3,
		REC_DOWNLOAD_4,
		REC_UPLOAD,
		REC_UPLOAD_1,
		REC_UPLOAD_2,
		REC_UPLOAD_3,
		REC_UPLOAD_4,
		REC_UPLOAD_5,
		REC_UPLOAD_6,
		REC_ERROR
		);
	recTYPE : 
		(
		typeCSV,
		typeXML
		);
END_TYPE

(*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*)
(*Global structure*)

TYPE
	recERR : 	STRUCT  (*Recipe management error structure*)
		Text : WSTRING[200]; (* Error text *)
		No : DINT; (* Error number *)
		State : recSTATE; (* Error step *)
	END_STRUCT;
	recCMD : 	STRUCT  (*Recipe management command structure*)
		Init : BOOL := TRUE; (*Init recipes managment*)
		New : BOOL; (*Create new recipe*)
		Load : BOOL; (*Load recipe*)
		Save : BOOL; (*Save recipe*)
		View : BOOL; (*View recipe*)
		Rename : BOOL; (*Rename recipe*)
		Delete : BOOL; (*Delete recipe*)
		Download : BOOL; (*Download recipe*)
		Upload : BOOL; (*Upload recipe*)
		ErrorReset : BOOL; (*Reset pending errors*)
	END_STRUCT;
	recPAR : 	STRUCT  (*Recipe management parameter structure*)
		RecipeVariable : STRING[200]; (*Name of the variable where the data is stored*)
		RecipeName : WSTRING[REC_NAME_LENGTH]; (*Recipe name*)
		RecipeNameNew : WSTRING[REC_NAME_LENGTH]; (*New recipe name*)
		RecipeID : STRING[REC_NAME_LENGTH]; (*File name of the recipe*)
		RecipeDirectory : STRING[200]; (*Recipe directory*)
		DeviceName : STRING[100]; (*Device name where the recipes are stored*)
		MpLink : MpComIdentType; (*MpLink from mappRecipe*)
		Initialized : BOOL; (*Indicates that recipe management was initialized*)
		VisuSlotID : USINT; (*ID for connected web connection*)
		VisuEnableCommand : BOOL;
	END_STRUCT;
	recDAT : 	STRUCT  (*Recipe management data structure*)
		RecipeNames : ARRAY[0..REC_MAX_NUM]OF WSTRING[REC_NAME_LENGTH]; (*Recipe unicode names*)
		RecipeIDs : ARRAY[0..REC_MAX_NUM]OF STRING[REC_NAME_LENGTH]; (*File name of the recipes*)
		RecipeNum : UINT; (*Number of recipes*)
		Status : WSTRING[100]; (*Shows the result of the last command*)
	END_STRUCT;
	recVIS : 	STRUCT  (*Recipe management visualization structure*)
		RecipeNames : ARRAY[0..REC_MAX_NUM]OF WSTRING[REC_VIS_LENGTH]; (*Recipe names as mappView data provider*)
		RecipeNum : UINT; (*Number of visible recipes*)
		RecipeFilter : WSTRING[REC_NAME_LENGTH]; (*Only show recipes that fit this pattern*)
		RecipeSelect : WSTRING[REC_NAME_LENGTH]; (*Select recipe in listbox after command new or rename*)
		DownloadFileUrl : STRING[REC_NAME_LENGTH]; (*URL used with recipe download*)
		UploadOverwriteRequest : BOOL; (*Show message box to overwrite file*)
		UploadOverwriteResponse : USINT; (*Response from message box overwrite file*)
		ReloadUpload : BOOL; (*Reload upload button*)
		RecipeDoubleClick : USINT; (*Track double click event*)
		ViewFilePath : STRING[REC_VIS_LENGTH]; (*Full path for viewing file*)
		ViewFile : BOOL; (*Trigger that opens the fly out window when viewing recipes*)
		ShowMessageBoxError : BOOL; (*Show message box on error*)
	END_STRUCT;
	recMAIN : 	STRUCT  (*Recipe management main structure*)
		CMD : recCMD; (* Command structure *)
		PAR : recPAR; (* Parameter structure *)
		DAT : recDAT; (*Data structure*)
		VIS : ARRAY[0..REC_MAX_CLIENTS_ID]OF recVIS; (*Visualization structure*)
		ERR : recERR; (* Error structure *)
	END_STRUCT;
END_TYPE

(*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*)
(*Structure that contains the recipe variables*)

TYPE
	recVariable : 	STRUCT 
		ApplicationName : STRING[40];
		MaxItemCnt : USINT := 10;
		Timeout : UINT := 5000;
		Gain : USINT;
		Focus : UINT;
		Exposure : UDINT;
		FlashColor : USINT := 1;
		FlashSegment : USINT := 15;
	END_STRUCT;
END_TYPE
