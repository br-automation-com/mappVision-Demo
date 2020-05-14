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
