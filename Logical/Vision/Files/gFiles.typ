
TYPE
	gFiles_output_typ : 	STRUCT 
		fileDevice : STRING[10];
		ready : BOOL;
	END_STRUCT;
	gFiles_typ : 	STRUCT 
		output : gFiles_output_typ;
	END_STRUCT;
END_TYPE
