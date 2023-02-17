
{REDUND_OK} FUNCTION MTLinAlgMatrixAddition : DINT (*Returns the status of addition of two m x n matrices.*) (* $GROUP=mapp Control,$CAT=Control Tools,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpControlTools.png *)
	VAR_INPUT
		Matrix1 : MTLinAlgMatrixType; (*m x n - dimensional matrix as first operand.*) (* *) (*#PAR#*)
		Matrix2 : MTLinAlgMatrixType; (*m x n - dimensional matrix as second  operand.*) (* *) (*#PAR#*)
		Result : MTLinAlgMatrixType; (*m x n - dimensional matrix as result of matrix addition. *) (* *) (*#PAR#*)
	END_VAR
END_FUNCTION

{REDUND_OK} FUNCTION MTLinAlgSolveEquation : DINT (*Returns the status of solving the linear equation system.*) (* $GROUP=mapp Control,$CAT=Control Tools,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpControlTools.png *)
	VAR_INPUT
		Matrix : MTLinAlgMatrixType; (*m x n - dimensional matrix.*) (* *) (*#PAR#*)
		Vector : MTLinAlgMatrixType; (*m - dimensional vector. (columns = 1)*) (* *) (*#PAR#*)
		Result : MTLinAlgMatrixType; (*m -dimensional Solution vector of the equation system. (columns = 1)*) (* *) (*#PAR#*)
	END_VAR
END_FUNCTION

{REDUND_OK} FUNCTION MTLinAlgMatrixInverse : DINT (*Returns the status of calculation of the inverse of a matrix.*) (* $GROUP=mapp Control,$CAT=Control Tools,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpControlTools.png *)
	VAR_INPUT
		Matrix : MTLinAlgMatrixType; (*n x n - dimensional matrix.*) (* *) (*#PAR#*)
		Result : MTLinAlgMatrixType; (*Inverse of the square matrix. *) (* *) (*#PAR#*)
	END_VAR
END_FUNCTION

{REDUND_OK} FUNCTION MTLinAlgMatrixMultiplication : DINT (*Returns the status of the multiplication of an l x m - dimensional matrix with an m x n - dimensional matrix. *) (* $GROUP=mapp Control,$CAT=Control Tools,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpControlTools.png *)
	VAR_INPUT
		Matrix1 : MTLinAlgMatrixType; (*l x m - dimensional matrix as first operand. *) (* *) (*#PAR#*)
		Matrix2 : MTLinAlgMatrixType; (*m x n - dimensional matrix as second operand. *) (* *) (*#PAR#*)
		Result : MTLinAlgMatrixType; (*l x n - dimensional matrix as result of matrix multiplication. *) (* *) (*#PAR#*)
	END_VAR
END_FUNCTION

{REDUND_OK} FUNCTION MTLinAlgMatrixSubtraction : DINT (*Returns the status of subtraction of two m x n matrices.*) (* $GROUP=mapp Control,$CAT=Control Tools,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpControlTools.png *)
	VAR_INPUT
		Matrix1 : MTLinAlgMatrixType; (*m x n - dimensional matrix as first operand.*) (* *) (*#PAR#*)
		Matrix2 : MTLinAlgMatrixType; (*m x n - dimensional matrix as second  operand.*) (* *) (*#PAR#*)
		Result : MTLinAlgMatrixType; (*m x n - dimensional matrix as result of matrix subtraction. *) (* *) (*#PAR#*)
	END_VAR
END_FUNCTION
