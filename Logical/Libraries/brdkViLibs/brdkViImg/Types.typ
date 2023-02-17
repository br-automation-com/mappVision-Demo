
TYPE
	brdkViImg_getImageSimulate_typ : 	STRUCT  (*MappView simulation configuration structure*)
		pFile : UDINT; (*pointer to string with the file name*)
		pDevice : UDINT; (*pointer to string with file device name*)
		activate : BOOL := FALSE; (*Active simulation if true*)
		autoIncrementNumber : BOOL := FALSE; (*Increment number with one (between min and max number) after image update*)
		useRandomNumbers : BOOL := FALSE; (*Use random numbers between min and max number*)
		appendNumber : BOOL := FALSE; (*Append number after filename*)
		maxNumber : UDINT := 0; (*Maximum file number*)
		minNumber : UDINT := 0; (*Minimum file number*)
	END_STRUCT;
	brdkViImg_mappViewInternal_typ : 	STRUCT 
		taskIdent : UDINT;
		name : STRING[10];
		tick : UDINT;
		state : USINT;
		getImage : brdkViImg_getImage;
		tmpImgArr : brdkViImg_imageArray_typ;
		strImgEnd : STRING[100];
		startAdrBase64 : UDINT;
		init : BOOL;
		imgH : UDINT;
		imgW : UDINT;
		oldPSvgImage : UDINT;
		maxLength : UDINT;
		svgBaseLength : UDINT;
		newSvgReady : BOOL;
		wsServer : brdkWS_Server;
		svgMaxLength : UDINT;
		pSvg : UDINT;
		pTmpMsg : UDINT;
		pTmpMem : UDINT;
		tmpMsgSize : UDINT;
		tmpMemSize : UDINT;
		wsChannels : ARRAY[0..BRDKVIIMG_WS_MAX_NUM_CLIENTS]OF brdkWS_Channel;
		actualMsgLength : UDINT;
		wsSend : BOOL;
		wsRecData : ARRAY[0..BRDKVIIMG_WS_MAX_NUM_CLIENTS,0..199]OF USINT;
	END_STRUCT;
	brdkViImg_mappViewInfo_typ : 	STRUCT  (*Information used by mappView.*)
		failedCount : UDINT; (*Amount of failed image downloads from the camera.*)
		imgCount : UDINT; (*Total number of images downloaded from camera.*)
	END_STRUCT;
	BRDKVIIMG_IMG_TYPE : 
		( (*Image types used by brdkViImg (either BMP or JPEG)*)
		BRDKVIIMG_IMG_TYPE_BMP, (*Use BMP image*)
		BRDKVIIMG_IMG_TYPE_JPEG (*Use Jpeg image*)
		);
	brdkViImg_imageArray_typ : 	STRUCT  (*Image array containing information about the image.*)
		pData : UDINT; (*Pointer to the UDINT image data array.*)
		colors : UDINT; (*Array containing colors in the image.*)
		height : UDINT; (*Height of the image.*)
		width : UDINT; (*Width of the image.*)
		size : UDINT; (*Image size*)
	END_STRUCT;
	brdkViImg_getImageMemInfo_typ : 	STRUCT  (*Get information about image stored in memory.*)
		uploadAdr : UDINT; (*Upload address to the httpClient.*)
		uploadSize : UDINT; (*Upload of the picture data with httpClient*)
		imageAdr : UDINT; (*Address of the image in memory.*)
		imageSize : UDINT; (*Size of the image in memory.*)
	END_STRUCT;
	brdkViImg_getImageInternal_typ : 	STRUCT 
		memInfo : brdkViImg_getImageMemInfo_typ;
		fileClose_0 : FileClose;
		fileRead_0 : FileRead;
		fileOpen_0 : FileOpen;
		fileName : STRING[255];
		fileNumber : UDINT;
		viBaseGetImage_0 : ViBaseGetImage;
	END_STRUCT;
	brdkViImg_bmpInfoHeader_typ : 	STRUCT  (*BMP information header.*)
		size : UDINT := 0; (*Size of this header (in bytes)*)
		width : DINT := 0; (*width of bitmap in pixels*)
		height : DINT := 0; (*height of bitmap in pixels ( (if negative, top-down, with origin in upper left corner, if negative, top-down, with origin in upper left corner) *)
		planes : UINT := 1; (*No. of planes for the target device, this is always 1*)
		bit_count : UINT := 0; (*No. of bits per pixel*)
		compression : UDINT := 0; (*0 or 3 - uncompressed. THIS PROGRAM CONSIDERS ONLY UNCOMPRESSED BMP images*)
		size_image : UDINT := 0; (*0 - for uncompressed images*)
		x_pixels_per_meter : DINT := 0; (*X-pixels per meter (BMP standard)*)
		y_pixels_per_meter : DINT := 0; (*Y-pixels per meter (BMP standard)*)
		colors_used : UDINT := 0; (*No. color indexes in the color table. Use 0 for the max number of colors allowed by bit_count*)
		colors_imported : UDINT := 0; (*No. of colors used for displaying the bitmap. If 0 all colors are required*)
	END_STRUCT;
	brdkViImg_bmpHeader_typ : 	STRUCT  (*BMP header data type containing file header, information header and color header.*)
		file_header : brdkViImg_bmpFileHeader_typ; (*BMP header of type brdkViImg_bmpFileHeader_typ*)
		bmp_info : brdkViImg_bmpInfoHeader_typ; (*BMP information of type brdkViImg_bmpInfoHeader_typ*)
		bmp_color : brdkViImg_bmpColorHeader_typ; (*BMP color information of brdkViImg_bmpColorHeader_typ*)
	END_STRUCT;
	brdkViImg_bmpFileHeader_typ : 	STRUCT  (*BMP file header*)
		file_type : UINT := 19778; (*File type always BM which is 0x4D42*)
		file_size : UDINT := 0; (*Size of the file (in bytes)*)
		reserved1 : UINT := 0; (*Reserved, always 0*)
		reserved2 : UINT := 0; (*Reserved, always 0*)
		offset_data : UDINT := 0; (*Start position of pixel data (bytes from the beginning of the file)*)
	END_STRUCT;
	brdkViImg_bmpColorHeader_typ : 	STRUCT  (*BMP color header*)
		red_mask : UDINT := 16711680; (*Bit mask for the red channel*)
		green_mask : UDINT := 65280; (*Bit mask for the green channel*)
		blue_mask : {REDUND_UNREPLICABLE} UDINT := 255; (*Bit mask for the blue channel*)
		alpha_mask : UDINT := 4278190080; (*Bit mask for the alpha channel*)
		color_space_type : UDINT := 1934772034; (*Default "sRGB" (0x73524742)*)
		unused : ARRAY[0..15]OF UDINT := [16(0)]; (*Unused data for sRGB color space*)
	END_STRUCT;
END_TYPE
