(********************************************************************
 * COPYRIGHT (C) BERNECKER + RAINER, AUSTRIA, A-5142 EGGELSBERG
 ********************************************************************
 * Library: ViBase
 * File:	ViBase.fun
 ********************************************************************
 * Declaration of IEC-FBs of library ViBase
 ********************************************************************)


FUNCTION_BLOCK ViBaseSaveDiagData
VAR_INPUT
		MpLink : REFERENCE TO ViComponentType;
		Execute : BOOL;
		DeviceName : REFERENCE TO STRING[50];
		FileName : REFERENCE TO STRING[255];
	END_VAR
	VAR_OUTPUT
		Done : BOOL;
		Busy : BOOL;
		Error : BOOL;
		StatusID : DINT;
	END_VAR
	VAR
		Internal :  {REDUND_UNREPLICABLE}  ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViBaseLoadApplication
	VAR_INPUT
		MpLink : REFERENCE TO ViComponentType;
		Execute : BOOL;
		Name : REFERENCE TO STRING[50];
	END_VAR
	VAR_OUTPUT
		Done : BOOL;
		Busy : BOOL;
		Error : BOOL;
		StatusID : DINT;
	END_VAR
	VAR
		Internal :  {REDUND_UNREPLICABLE}  ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK