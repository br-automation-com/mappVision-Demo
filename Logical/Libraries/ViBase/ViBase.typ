(********************************************************************
 * COPYRIGHT (C) BERNECKER + RAINER, AUSTRIA, A-5142 EGGELSBERG
 ********************************************************************
 * Library: ViBase
 * File:	ViBase.typ
 ********************************************************************
 * Declaration of data-types of library ViBase
 ********************************************************************)




TYPE
	ViBaseFubProcessingType : STRUCT (*Internal structure-types for FB-processing*)
		Mediator : ARRAY[0..1]OF DINT;
	END_STRUCT;

	ViBaseControlIfType : 	STRUCT  (*Partial interface type (C only)*)
		VTable : DWORD; (**)
	END_STRUCT;

	ViBaseInternalType : STRUCT (*internal variable*)
		ID : UDINT; (* unused *)
		Check : UDINT; (**)
		ParamHash : UDINT; (**)
		State : WORD; (**)
		Error : UINT; (**)
		Treating: REFERENCE TO ViBaseFubProcessingType;
		Reserve : ARRAY[0..1]OF UDINT; (* unused, internal reference; e.g. memory-pointer*)
		Flags: USINT;
		ControlIf : REFERENCE TO ViBaseControlIfType; (**)
		SeqNo : DINT; (*unused*)
	END_STRUCT;

	ViComponentInternalMappLinkType : STRUCT	(*internal variable*)
		Internal : ARRAY[0..1]OF UDINT; (*Internal data*)
	END_STRUCT;
	ViComponentInternalCameraIfType : 	 STRUCT (*Partial interface type (C only)*)
		Vtable : DWORD; (**)
	END_STRUCT;
	ViComponentType : {REDUND_UNREPLICABLE} 	STRUCT
		CameraType : REFERENCE TO ViComponentInternalCameraIfType ;
		MappLinkInternal : ViComponentInternalMappLinkType;
	END_STRUCT;
END_TYPE

TYPE
	ViBaseErrorEnum :
		(
		viBASE_NO_ERROR := 0, (* No error *)
		viBASE_ERR_FILE_WRITE := -1046282219, (* 0xC1A30015 Failure writing file {1|u}. [Error: 21]*)
		viBASE_ERR_INVALID_FILE_DEVICE := -1046282218, (* 0xC1A30016 Failure accessing file device {1|u}. [Error: 22]*)
		viBASE_ERR_FILE_SYSTEM := -1046282217, (* 0xC1A30017 General error {1|u} in file system. [Error: 23]*)
		viBASE_ERR_NO_MEDIATOR := -1046282197, (* 0xC1A3002B Internal error. [Error: 43]*)
		viBASE_ERR_COMPONENT_CHANGED := -1046282196, (* 0xC1A3002C Internal error. [Error: 44]*)
		viBASE_ERR_INVALID_COMPONENT := -1046282195, (* 0xC1A3002D Internal error. [Error: 45]*)
		viBASE_ERR_INVALID_COMPONENT_IF := -1046282194, (* 0xC1A3002E Internal error. [Error: 46]*)
		viBASE_ERR_INVALID_PARAMETER := -1046282193, (* 0xC1A3002F Invalid Parameter. [Error: 47]*)
		viBASE_ERR_COMPONENT_NOT_READY := -1046282185, (* 0xC1A30037 Vision Component is not ready. [Error: 55]*)
		viBASE_ERR_NO_INSTANCE := -1046282141, (* 0xC1A30063 The function block was called without a valid interface. [Error: 99]*)
		viBASE_ERR_APP_NOT_COMPATIBLE := -1046282120, (* 0xC1A30078 Vision Application '{1|s}' not compatible to '{2|s}'. [Error: 120]*)
		viBASE_WRN_APP_NOT_LOADED := -2120023941, (* 0x81A3007B Vision Application '{1|s}' was loaded with corrections. [Warning: 123]*)
		viBASE_ERR_APP_NOT_LOADED := -1046282117, (* 0xC1A3007B Failure loading Vision Application '{1|s}'. [Error: 123]*)
		viBASE_ERR_APP_NOT_EXIST := -1046282080 (* 0xC1A300A0 Vision Application '{1|s}' does not exist. [Error: 160]*)
		);
END_TYPE


