
TYPE
	MTLinAlgMatrixType : 	STRUCT  (*Matrix datatype*)
		Handle : REFERENCE TO LREAL; (*Pointer to an m x n - dimensional  matrix. *)
		Rows : UINT; (*Matrix row dimension - m.*)
		Columns : UINT; (*Matrix column dimension - n. *)
	END_STRUCT;
END_TYPE
