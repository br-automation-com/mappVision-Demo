
TYPE
	gRecipe_in_cmd_typ : 	STRUCT 
		saveData : BOOL;
	END_STRUCT;
	gRecipe_in_typ : 	STRUCT 
		cmd : gRecipe_in_cmd_typ;
		filename : STRING[255];
		readyForInit : BOOL;
	END_STRUCT;
	gRecipe_out_typ : 	STRUCT 
		active : BOOL;
		mpLink : UDINT;
		init : BOOL;
	END_STRUCT;
	gRecipe_typ : 	STRUCT 
		out : gRecipe_out_typ;
		in : gRecipe_in_typ;
	END_STRUCT;
END_TYPE
