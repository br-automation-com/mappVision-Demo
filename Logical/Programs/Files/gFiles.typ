
TYPE
	gFiles_input_typ : 	STRUCT 
		refresh : BOOL;
	END_STRUCT;
	gFiles_output_typ : 	STRUCT 
		fileDevice : STRING[10];
		ready : BOOL;
	END_STRUCT;
	gFiles_typ : 	STRUCT 
		output : gFiles_output_typ;
		input : gFiles_input_typ;
	END_STRUCT;
END_TYPE
