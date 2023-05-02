
TYPE
	retain_typ : 	STRUCT 
		lastLoadedName : STRING[255];
	END_STRUCT;
	local_typ : 	STRUCT 
		mpRecipeUi : MpRecipeUI;
		mpRecipe : MpRecipeCsv;
		New_Member : USINT;
		delayTon : TON;
		autoLoadTon : TON;
	END_STRUCT;
	hmi_in_typ : 	STRUCT 
		downloadDone : BOOL;
		download : BOOL;
	END_STRUCT;
	hmi_typ : 	STRUCT 
		mpRecipe : MpRecipeUIConnectType;
		out : hmi_out_typ;
		in : hmi_in_typ;
	END_STRUCT;
	hmi_out_typ : 	STRUCT 
		viewUrl : STRING[255];
		selectedName : STRING[255];
		downloadSrc : STRING[500];
		enableBtn : BOOL;
		lastLoaded : STRING[255];
	END_STRUCT;
END_TYPE
