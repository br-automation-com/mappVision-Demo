
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
		ContentStart : STRING[500];
		ContentAfterTitle : STRING[200];
		ContentBase64 : STRING[200];
		ContentBeginJS : STRING[2000];
		ContentBetween1 : STRING[200];
		ContentBetween2 : STRING[200];
		ContentEndJS : STRING[3000];
		ContentCrossHairBegin : STRING[200];
		ContentCrossHairMiddle : STRING[200];
		ContentCrossHairEnd : STRING[200];
		ContentCrossHairRed : STRING[200];
		ContentCrossHairIndex : STRING[200];
		ContentEnd : STRING[2000];
	END_STRUCT;
	DiagTime_Type : 	STRUCT 
		Refresh : TIME;
		BeginSaveBMPJPG : TIME;
		EndSaveBMPJPG : TIME;
		BeginSVG : TIME;
		BeginSVGSave : TIME;
		EndSVGSave : TIME;
	END_STRUCT;
	MemInfoSave_Type : 	STRUCT 
		UploadAdr : UDINT;
		UploadSize : UDINT; (*Upload of the picture data with httpClient*)
		SvgAdr : UDINT;
		SvgSize : UDINT;
		CrosshAdr : UDINT;
		CrosshSize : UDINT; (*Crosshairs, Texts, ...*)
		SvgHeaderSize : UDINT; (*Fileheader, ...*)
	END_STRUCT;
	MemInfoVC4_Type : 	STRUCT 
		UploadBmp8Adr : UDINT;
		UploadBmp8Size : UDINT; (*Upload of the picture data with httpClient*)
		Bmp24Adr : UDINT;
		Bmp24Size : UDINT;
	END_STRUCT;
	typCrossHair : 	STRUCT  (*Cross hair data structure*)
		SvgTransformation : ARRAY[1..MAX_NUM_RESULTS]OF STRING[200] := [10('')]; (*Transformation string for paper widget*)
		SvgContent : ARRAY[1..MAX_NUM_RESULTS]OF STRING[1000]; (*Transformation string for paper widget*)
		SvgVisible : ARRAY[1..MAX_NUM_RESULTS]OF BOOL := [10(FALSE)];
		CFG : typCrossHairCfg;
		DetailsNo : USINT := 1;
		ShowCrosshair : BOOL := TRUE; (*Enable/Disable cross hairs*)
	END_STRUCT;
	typCrossHairCfg : 	STRUCT 
		Scale : REAL := 1; (*Scale size of the cross hair*)
		PixelRatio : REAL := 100; (*Position value for one pixel*)
		Size : USINT := 80; (*Size of the cross hair in pixel*)
		Font : USINT := 35;
		RefSizeX : UINT := 1280; (*Size of the Webviewer Widget*)
		RefSizeY : UINT := 1024; (*Size of the Webviewer Widget*)
	END_STRUCT;
	typCrossHairInfo : 	STRUCT 
		CrosshairTopLeftX : REAL; (*top left position of the crosshair in pixels*)
		CrosshairTopLeftY : REAL; (*top left position of the crosshair in pixels*)
		CrosshairRotateCenter : REAL; (*crosshair rotation around center in degrees*)
		CrosshairSizeScaled : REAL; (*crosshair size in pixel (in both directions)*)
		CrosshairScale : REAL;
		DataVis : STRING[80];
		Data : STRING[400];
		Text : STRING[1000];
	END_STRUCT;
	Bmp24Bit_Type : 	STRUCT 
		FileHeader : BmpFileHeader_Type;
		InfoHeader : BmpInfoHeader_Type;
	END_STRUCT;
	Bmp8Bit_Type : 	STRUCT 
		FileHeader : BmpFileHeader_Type;
		InfoHeader : BmpInfoHeader_Type;
		ColorTable : ARRAY[0..255]OF BmpColorTable_Type;
	END_STRUCT;
	BmpFileHeader_Type : 	STRUCT 
		Fill : ARRAY[0..1]OF USINT;
		bfType : ARRAY[0..1]OF USINT;
		bfSize : UDINT;
		bfReserved : UDINT;
		bfOffBits : UDINT;
	END_STRUCT;
	BmpInfoHeader_Type : 	STRUCT 
		biSize : UDINT;
		biWidth : DINT;
		biHeight : DINT;
		biPlanes : UINT;
		biBitCount : UINT;
		biCompression : UDINT;
		biSizeImage : UDINT;
		biXPelsPerMeter : DINT;
		biYPelsPerMeter : DINT;
		biClrUSer : UDINT;
		biClrImportant : UDINT;
	END_STRUCT;
	BmpColorTable_Type : 	STRUCT 
		Blue : USINT;
		Green : USINT;
		Red : USINT;
		Fill : USINT;
	END_STRUCT;
	PixelDestColor_Type : 	STRUCT 
		Blue : USINT;
		Green : USINT;
		Red : USINT;
	END_STRUCT;
END_TYPE
