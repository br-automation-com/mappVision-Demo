(********************************************************************
 * COPYRIGHT (C) BERNECKER + RAINER, AUSTRIA, A-5142 EGGELSBERG
 ********************************************************************
 * Library: ViBase
 * File:	ViBase.typ
 ********************************************************************
 * Declaration of data-types of library ViBase
 ********************************************************************)

TYPE
	ViBaseFubProcessingType : 	STRUCT  (*Internal structure-types for FB-processing*)
		Mediator : ARRAY[0..1]OF DINT;
	END_STRUCT;
	ViBaseControlIfType : 	STRUCT  (*Partial interface type (C only)*)
		VTable : DWORD;
	END_STRUCT;
	ViBaseInternalType : 	STRUCT  (*internal variable*)
		ID : UDINT; (* unused *)
		Check : UDINT;
		ParamHash : UDINT;
		State : WORD;
		Error : UINT;
		Treating : REFERENCE TO ViBaseFubProcessingType;
		Reserve : ARRAY[0..1]OF UDINT; (* unused, internal reference; e.g. memory-pointer*)
		Flags : USINT;
		ControlIf : REFERENCE TO ViBaseControlIfType;
		SeqNo : DINT; (*unused*)
	END_STRUCT;
	ViComponentInternalMappLinkType : 	STRUCT  (*internal variable*)
		Internal : ARRAY[0..1]OF UDINT; (*Internal data*)
	END_STRUCT;
	ViComponentInternalCameraIfType : 	STRUCT  (*Partial interface type (C only)*)
		Vtable : DWORD;
	END_STRUCT;
	ViComponentType : {REDUND_UNREPLICABLE} 	STRUCT
		CameraType : REFERENCE TO ViComponentInternalCameraIfType;
		MappLinkInternal : ViComponentInternalMappLinkType;
	END_STRUCT;
	ViBaseFormatEnum :
		( (*	Enumeration of format options*)
		viBASE_FORMAT_PLAIN_TEXT := 0, (*Elements are listed in plain text format for direct usage in e.g. ViBaseLoadApplication
													mapp View connection: e.g. Table Widget
													StringArray1D (stringValue)*)
		viBASE_FORMAT_ITEMCOLLECTION := 1 (*Elements are listed in ItemCollection format {"value":"VA Name", "text":"VA Name"}
													mapp View connection: Selector Widgets
													ItemCollection-Array (dataProvider)*)
		);
	ViBaseImageTypeEnum :
		( (*	Enumeration of image types*)
		viBASE_IMAGE_TYPE_BMP := 0, (*The image data is uncompressed in the Bitmap format*)
		viBASE_IMAGE_TYPE_JPG := 1 (*The image data is lossy compressed in the JPG format*)
		);
	ViBaseFormatItemCollectionType :STRING[130]; (*This type is intended for vision application list entry in ItemCollection format.
													An array of this type can be used in mapp View for ItemCollection bindings on selector widgets*)
	ViBaseFormatPlainTextType :STRING[50]; (*This type is intended for vision application list entry in plain text.
													An array of this can be used in mapp View for StringArra1D bindings e.g. in a Table*)
END_TYPE
