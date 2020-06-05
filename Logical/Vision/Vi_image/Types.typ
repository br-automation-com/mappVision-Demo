
TYPE
	VIStep_Enum : 
		(
		VISTEP_WAIT,
		VISTEP_CREATE_DIR,
		VISTEP_DELETE_DIR,
		VISTEP_DELETE_IMAGE,
		VISTEP_REFRESH_IMG_LIST,
		VISTEP_DOWNLOAD_IMAGE,
		VISTEP_SAVE_IMG_ON_PLC,
		VISTEP_ERR
		);
	SvgTexts_Type : 	STRUCT 
		Header1 : STRING[500];
		Header2 : STRING[500];
		Header3 : STRING[500];
		Header4 : STRING[500];
		CrosshairDefinition : STRING[1000];
		Crosshair1 : STRING[500];
		SvgClose : STRING[50];
	END_STRUCT;
	DiagTime_Type : 	STRUCT 
		Refresh : TIME;
		BeginSaveBMPJPG : TIME;
		EndSaveBMPJPG : TIME;
		BeginSVG : TIME;
		BeginSVGSave : TIME;
		EndSVGSave : TIME;
	END_STRUCT;
	MemInfo_Type : 	STRUCT 
		UploadAdr : UDINT;
		UploadSize : UDINT; (*Upload of the picture data with httpClient*)
		SvgAdr : UDINT;
		SvgSize : UDINT;
		CrosshAdr : UDINT;
		CrosshSize : UDINT; (*Crosshairs, Texts, ...*)
		SvgHeaderSize : UDINT; (*Fileheader, ...*)
	END_STRUCT;
	typCrossHair : 	STRUCT  (*Cross hair data structure*)
		SvgTransformation : ARRAY[1..MAX_NUM_RESULTS]OF STRING[200] := [10('')]; (*Transformation string for paper widget*)
		SvgContent : ARRAY[1..MAX_NUM_RESULTS]OF STRING[1000]; (*Transformation string for paper widget*)
		SvgVisible : ARRAY[1..MAX_NUM_RESULTS]OF BOOL := [10(FALSE)];
		Scale : REAL := 1; (*Scale size of the cross hair*)
		PixelRatio : REAL := 100; (*Position value for one pixel*)
		Size : USINT := 80; (*Size of the cross hair in pixel*)
		Font : USINT := 35;
		DetailsNo : USINT := 1;
		ShowCrosshair : BOOL := TRUE; (*Enable/Disable cross hairs*)
	END_STRUCT;
	typCrossHairInfo : 	STRUCT 
		CrosshairX : REAL;
		CrosshairY : REAL;
		CrosshairRotate : REAL;
		Text : STRING[1000];
	END_STRUCT;
END_TYPE
