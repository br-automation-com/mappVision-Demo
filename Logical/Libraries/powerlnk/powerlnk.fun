                                                                      
{REDUND_CONTEXT} {REDUND_UNREPLICABLE} FUNCTION plAction : UINT					(*triggers events and reads statistic information*)
	VAR_INPUT
		ident	:UDINT;						(*identifier for which the action should be triggered*)
		actionID	:UDINT;					(*ID number of the action which should be triggered*)
		pObject	:UDINT;						(*pointer to the structure in which the parameters and return values of the action are entered*)
		objectLen	:UDINT;					(*size of the structure which was specified with pObject*)
	END_VAR
END_FUNCTION
{REDUND_CONTEXT} {REDUND_UNREPLICABLE} FUNCTION plState : UINT						(*queries status*)
	VAR_INPUT
		ident	:UDINT;						(*identifier of a data point, identifier of a non-cyclic channel or POWERLINK station identifier*)
	END_VAR
END_FUNCTION
{REDUND_CONTEXT} {REDUND_UNREPLICABLE} FUNCTION plAcycWrite : UINT					(*submits data on a non-cyclic communication channel*)
	VAR_INPUT
		ident	:UDINT;						(*identifier returned from plAcycOpen*)
		bufferAdr	:UDINT;					(*pointer to the buffer which should be written*)
		bufferLen	:UDINT;					(*number of bytes which should be written*)
		pWrittenLen	:REFERENCE TO UDINT;	(*pointer to the number of actual written bytes*)
	END_VAR
END_FUNCTION
{REDUND_CONTEXT} {REDUND_UNREPLICABLE} FUNCTION plAcycInvite : UINT				(*requests data on a non-cyclic communication channel*)
	VAR_INPUT
		ident	:UDINT;						(*identifier returned from plAcycOpen*)
	END_VAR
END_FUNCTION
{REDUND_CONTEXT} {REDUND_UNREPLICABLE} FUNCTION plAcycRead : UINT					(*reads data on a non-cyclic communication channel*)
	VAR_INPUT
		ident	:UDINT;						(*identifier returned from plAcycOpen*)
		bufferAdr	:UDINT;					(*pointer to the buffer where reading should take place*)
		bufferLen	:UDINT;					(*maximum number of bytes which should be read*)
		pReadLen	:REFERENCE TO UDINT;	(*pointer to the number of actual read bytes*)
	END_VAR
END_FUNCTION	
{REDUND_CONTEXT} {REDUND_UNREPLICABLE} FUNCTION plAcycClose : UINT					(*closes a non-cyclic communication channel*)
	VAR_INPUT
		ident	:UDINT;						(*identifier returned from plAcycOpen()*)
	END_VAR	
END_FUNCTION
{REDUND_CONTEXT} {REDUND_UNREPLICABLE} FUNCTION plAcycOpen : UINT					(*opens a non-cyclic communication channel*)
	VAR_INPUT
		pName	:STRING[80];				(*pointer to the station and channel name which should be written to or read from*)
		flags	:UDINT;						(*e.g. plOPEN_MODE_READ = read, plOPEN_MODE_WRITE = write, ...*)
		pIdent	:REFERENCE TO UDINT;		(*pointer to the ID of the opened channel*)
	END_VAR
END_FUNCTION
{REDUND_CONTEXT} {REDUND_UNREPLICABLE} FUNCTION plCEDelete : UINT					(*deletes a cyclic copy instruction*)
	VAR_INPUT
		ident	:UDINT;						(*identifier returned from plCECreate*)
	END_VAR
END_FUNCTION
{REDUND_CONTEXT} {REDUND_UNREPLICABLE} FUNCTION plCECreate : UINT					(*creates a cyclic copy instruction*)
	VAR_INPUT
		pDatapoint	:STRING[80];			(*pointer to the string with a data point definition*)
		address	:UDINT;						(*pointer to the image from/to which the value of the IO data point should be copied*)
		taskclass	:SINT;					(*e.g. plCE_CYCLIC_1 = Cyclic #1, plCE_CYCLIC_2 = Cyclic #2, ...*)
		pIdent	:REFERENCE TO UDINT;		(*pointer to the ID where the created data point should be returned*)
	END_VAR
END_FUNCTION
{REDUND_CONTEXT} {REDUND_UNREPLICABLE} FUNCTION plConfig : UINT					(*sets the POWERLINK configuration*)
	VAR_INPUT
		pConfigStruct	:UDINT;				(*pointer to the configuration structure*)
	END_VAR
END_FUNCTION
