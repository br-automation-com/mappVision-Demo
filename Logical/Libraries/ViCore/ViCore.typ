(********************************************************************
 * COPYRIGHT (C) BERNECKER + RAINER, AUSTRIA, A-5142 EGGELSBERG
 ********************************************************************
 * Library: ViCore
 * File:	ViCore.typ
 ********************************************************************
 * Declaration of data-types of library ViCore
 ********************************************************************)


TYPE
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
