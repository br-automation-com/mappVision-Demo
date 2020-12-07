(********************************************************************
 * COPYRIGHT (C) BERNECKER + RAINER, AUSTRIA, A-5142 EGGELSBERG
 ********************************************************************
 * Library: ViBase
 * File:	ViBase.fun
 ********************************************************************
 * Declaration of IEC-FBs of library ViBase
 ********************************************************************)


FUNCTION_BLOCK ViBaseSaveDiagData (*A set of diagnostic data for the image processing on a camera can be saved to the PLC with function block ViBaseSaveDiagData.*)
VAR_INPUT
		MpLink : REFERENCE TO ViComponentType; (*Pointer to the vision component from which diagnostic data should be stored.*)
		Execute : BOOL; (*Execution of the function block begins on a rising edge of this input.*)
		DeviceName : REFERENCE TO STRING[50]; (*Pointer to the device name. Points to the name of an existing file device (e.g. "HD0") that was created in AS or with function block DevLink.*)
		FileName : REFERENCE TO STRING[255]; (*Pointer to the filename. The filename consists of the path and filename (e.g. "dir1\package1.tar.gz"). The path specification refers to the specified file device. If no name is specified, <Nettime>.tar.gz is used.*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Execution successful. Function block is finished.*)
		Busy : BOOL; (*The function block is active and must continue to be called.*)
		Error : BOOL; (*Error during execution.*)
		StatusID : DINT; (*Status information*)
	END_VAR
	VAR
		Internal :  {REDUND_UNREPLICABLE}  ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViBaseLoadApplication (*Function block ViBaseLoadApplication can be used to load a vision application from the controller to a camera module.*)
	VAR_INPUT
		MpLink : REFERENCE TO ViComponentType; (*Pointer to the vision component to which the vision application is loaded.*)
		Execute : BOOL; (*Execution of the function block begins on a rising edge of this input.*)
		Name : REFERENCE TO STRING[50]; (*Pointer to the name of the vision application to be loaded.*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Execution successful. Function block is finished.*)
		Busy : BOOL; (*The function block is active and must continue to be called.*)
		Error : BOOL; (*Error during execution.*)
		StatusID : DINT; (*Status information*)
	END_VAR
	VAR
		Internal :  {REDUND_UNREPLICABLE}  ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK