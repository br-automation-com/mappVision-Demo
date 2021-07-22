
FUNCTION_BLOCK ViDownloadImage (* *) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL;
		FileDevice : STRING[80];
		FileName : STRING[80];
		ImgName : STRING[80];
		visDownloadFileUrl : REFERENCE TO STRING[200];
	END_VAR
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		Step : INT;
		AsMemPartCreate_0 : AsMemPartCreate;
		AsMemPartAllocClear_0 : AsMemPartAllocClear;
		MemSvgAdr : UDINT;
		MemSvgSize : UDINT;
		FileOpen_0 : FileOpen;
		FileRead_0 : FileRead;
		FileClose_0 : FileClose;
		TON_Timeout : TON;
		httpService_Download : httpService;
		response_header : httpResponseHeader_t;
		response_header_data : STRING[300];
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViRefreshImageList
	VAR_INPUT
		Enable : BOOL;
		VisionImage : REFERENCE TO typVisionImage;
		ImageList : REFERENCE TO ARRAY[0..19] OF STRING[80];
		visSelectedImage : REFERENCE TO STRING[80];
	END_VAR
	VAR_OUTPUT
		Status : UINT;
		DirEntries : UINT;
	END_VAR
	VAR
		Step : INT;
		visSelectedImageOld : STRING[80];
		idx : UINT;
		file_newest : STRING[80];
		file_oldest : STRING[80];
		date_newest : DATE_AND_TIME;
		date_oldest : DATE_AND_TIME;
		cmdDeleteOldest : BOOL;
		DirRead_0 : DirRead;
		FileDelete_0 : FileDelete;
		dir_data : fiDIR_READ_DATA;
		DeleteFileName : STRING[80];
		TON_VisPause : TON;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViSaveImgOnPlc
	VAR_INPUT
		Enable : BOOL;
		CFG : typVisionImageConfig;
		PowerlinkNode : USINT;
		CrossHairInfo : REFERENCE TO ARRAY[0..MAX_NUM_RESULTS] OF typCrossHairInfo;
	END_VAR
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		Step : INT;
		AsMemPartCreate_0 : AsMemPartCreate;
		AsMemPartAllocClear_0 : AsMemPartAllocClear;
		MemInfo : MemInfoSave_Type;
		DiagStartTime : TIME;
		DiagTime : DiagTime_Type;
		DTGetTime_0 : DTGetTime;
		DTStructure_0 : DTStructure;
		FileNameImg : STRING[80];
		FileNameSvg : STRING[80];
		URI : STRING[80];
		Host : STRING[80];
		httpClient_0 : httpClient;
		httpClientErrorStatus : UINT;
		RequestHeader : httpRequestHeader_t;
		TON_ReloadTimeout : TON;
		UploadedImgSize : UDINT;
		FileCreate_0 : FileCreate;
		FileWrite_0 : FileWrite;
		FileClose_0 : FileClose;
		b64AdrInBuffer : UDINT;
		b64AdrOutBuffer : UDINT;
		b64neededOutput : UDINT;
		b64key : ARRAY[0..63] OF USINT;
		b64actposIN : UDINT;
		b64actposOUT : UDINT;
		b64in : REFERENCE TO ARRAY[0..2] OF USINT;
		b64out : REFERENCE TO ARRAY[0..3] OF USINT;
		b64blockLen : UINT;
		FirstElement : BOOL;
		SvgTexts : SvgTexts_Type;
		tmpStr1 : STRING[80];
		i : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViDrawCrosshair
	VAR_INPUT
		SelectedSensor : UINT;
		CmdRefreshCrosshair : BOOL;
		VisionSensor : REFERENCE TO typVisionMain;
		CodeTypes : REFERENCE TO ARRAY[0..MAX_NUM_CODETYPES] OF STRING[80];
		VisionDisabled : BOOL;
		TextAlignment : BOOL; (*0: left, 1: right*)
		ImageRotation_deg : UINT;
		visCrossHair : REFERENCE TO typCrossHair;
	END_VAR
	VAR_OUTPUT
		CrossHairInfo : ARRAY[0..MAX_NUM_RESULTS] OF typCrossHairInfo;
	END_VAR
	VAR
		idx : UINT;
		SelectedSensorOld : UINT;
		Blob : REFERENCE TO typBlobMain;
		CodeReader : REFERENCE TO typCodeReaderMain;
		Match : REFERENCE TO typMatchMain;
		MT : REFERENCE TO typMTMain;
		Pixel : REFERENCE TO typPixelMain;
		OCR : REFERENCE TO typOCRMain;
		DetailsNoOld : USINT;
		ShowCrosshairOld : BOOL;
		ImageRotation_degOld : UINT;
		TextAlignmentOld : BOOL;
		ResultModelNumber : USINT;
		ResultPositionX : REAL;
		ResultPositionY : REAL;
		ResultOrientation : REAL;
		CrosshSize : REAL;
		ScaleVertical : REAL;
		svgTrafo : STRING[200];
		svgContent : STRING[1000];
		tmpStr : STRING[100];
		blueTextPos : INT;
		MT_UseXY : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViCreateWebDirFile
	VAR_INPUT
		Enable : BOOL;
		FileDevUser : STRING[80];
		EthDevice : STRING[80];
		EthIP : STRING[80];
		visWebViewerPath : REFERENCE TO STRING[80];
	END_VAR
	VAR_OUTPUT
		Status : UINT;
		Done : BOOL;
	END_VAR
	VAR
		Step : INT;
		DirInfo_0 : DirInfo;
		DirCreate_0 : DirCreate;
		FileDelete_0 : FileDelete;
		FileCreate_0 : FileCreate;
		FileWrite_0 : FileWrite;
		FileClose_0 : FileClose;
		DevLink_0 : DevLink;
		FileCopy_0 : FileCopy;
		DevUnlink_0 : DevUnlink;
		FileDevSystem : STRING[80];
		FileDevSystemPara : STRING[80];
		DirNameWeb : STRING[80];
		FileNameVisImgHtml : STRING[80];
		FileNameEyeSystem : STRING[80];
		FileNameEyeUser : STRING[80];
		HtmlFileContent1 : STRING[1500];
		HtmlFileContent2 : STRING[2000];
		FileWriteData : STRING[3600];
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViShowImgOnVC4
	VAR_INPUT
		Enable : BOOL;
		RefreshImage : BOOL;
		CFG : typVisionImageConfig;
		PowerlinkNode : USINT;
		ImgWidthInVC4_px : UINT;
	END_VAR
	VAR_OUTPUT
		Status : UINT;
		HTMLStreamContent : STRING[600];
		RefreshDone : BOOL;
	END_VAR
	VAR
		Step : INT;
		AsMemPartCreate_0 : AsMemPartCreate;
		AsMemPartAllocClear_0 : AsMemPartAllocClear;
		MemInfo : MemInfoVC4_Type;
		FileNameBmp24Bit : STRING[80];
		FileNameBmp24BitDir : STRING[80];
		URI : STRING[80];
		Host : STRING[80];
		ImgHeight_px : UINT;
		httpClient_0 : httpClient;
		httpClientErrorStatus : UINT;
		RequestHeader : httpRequestHeader_t;
		TON_Timeout : TON;
		FileSizeIn8Bit : UDINT;
		FileDelete_0 : FileDelete;
		FileCreate_0 : FileCreate;
		FileWrite_0 : FileWrite;
		FileClose_0 : FileClose;
		Bmp8Bit : Bmp8Bit_Type;
		Bmp24Bit : Bmp24Bit_Type;
		BytesPerLine : DINT;
		PixelSourceAdr : UDINT;
		PixelDestAdr : UDINT;
		PixelSourceColor : REFERENCE TO USINT;
		PixelDestColor : REFERENCE TO PixelDestColor_Type;
		BytesRemaining : DINT;
		VC4HTML : ARRAY[0..3] OF STRING[300];
		tmpStr1 : STRING[30];
		i : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION CrosshairDetailsValue : BOOL
	VAR_INPUT
		strTarget : UDINT;
		strText : UDINT;
		fValue : REAL;
		TextAlignment : BOOL;
	END_VAR
	VAR
		tmpStr : STRING[80];
	END_VAR
END_FUNCTION

FUNCTION CrosshairDetailsText : BOOL
	VAR_INPUT
		strTarget : UDINT;
		strText : UDINT;
		adrText : UDINT;
		TextAlignment : BOOL;
	END_VAR
	VAR
		tmpStr : STRING[80];
	END_VAR
END_FUNCTION
