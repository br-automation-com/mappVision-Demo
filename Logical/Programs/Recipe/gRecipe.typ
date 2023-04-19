
TYPE
	gRecipe_out_typ : 	STRUCT 
		active : BOOL;
		mpLink : UDINT;
	END_STRUCT;
	gRecipe_typ : 	STRUCT 
		out : gRecipe_out_typ;
	END_STRUCT;
END_TYPE
