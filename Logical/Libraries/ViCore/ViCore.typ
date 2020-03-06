(********************************************************************
 * COPYRIGHT (C) BERNECKER + RAINER, AUSTRIA, A-5142 EGGELSBERG
 ********************************************************************
 * Library: ViCore
 * File:	ViCore.typ
 ********************************************************************
 * Declaration of data-types of library ViCore
 ********************************************************************)


TYPE
	ViComponentInternalMappLinkType : 	STRUCT
		Internal : ARRAY[0..1]OF UDINT;
	END_STRUCT;
	ViComponentInternalCameraIfType : 	STRUCT
		Internal : ARRAY[0..1]OF UDINT;
	END_STRUCT;
	ViComponentType : {REDUND_UNREPLICABLE} 	STRUCT
		mappLinkInternal : ViComponentInternalMappLinkType;
		CameraType :  ViComponentInternalCameraIfType;
	END_STRUCT;


END_TYPE
