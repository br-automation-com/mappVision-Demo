
TYPE
	user_local_typ : 	STRUCT 
		tmp : USINT;
	END_STRUCT;
END_TYPE

(*hardware*)

TYPE
	user_hw_in_typ : 	STRUCT 
		tmp : USINT;
	END_STRUCT;
	user_hw_out_typ : 	STRUCT 
		tmp : USINT;
	END_STRUCT;
END_TYPE

(*HMI*)

TYPE
	user_hw_typ : 	STRUCT 
		in : user_hw_in_typ;
		out : user_hw_out_typ;
	END_STRUCT;
END_TYPE

(*Common HMI*)

TYPE
	user_commonHmi_typ : 	STRUCT 
		in : user_commonHmi_in_typ;
		out : user_commonHmi_out_typ;
	END_STRUCT;
	user_commonHmi_out_typ : 	STRUCT 
		tmp : USINT;
	END_STRUCT;
	user_commonHmi_in_typ : 	STRUCT 
		tmp : USINT;
	END_STRUCT;
END_TYPE

(*HMI*)

TYPE
	user_hmi_typ : 	STRUCT 
		in : user_hmi_in_typ;
		out : user_hmi_out_typ;
	END_STRUCT;
	user_hmi_out_typ : 	STRUCT 
		tmp : USINT;
	END_STRUCT;
	user_hmi_in_typ : 	STRUCT 
		tmp : USINT;
	END_STRUCT;
END_TYPE

(*Recipe*)

TYPE
	user_common_recipe_typ : 	STRUCT 
		tmp : USINT;
	END_STRUCT;
	user_recipe_typ : 	STRUCT 
		tmp : USINT;
	END_STRUCT;
END_TYPE
