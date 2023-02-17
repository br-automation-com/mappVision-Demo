
FUNCTION brdkViImg_freeMem : UDINT (*Function to free the memory buffer.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pointer : UDINT; (*Pointer to the memory buffer.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViImg_getPixel : USINT (*Function to return pixel value (0-255) at point x and y in image.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		x : INT; (*X coordinate in image.*)
		y : INT; (*Y coordinate in image.*)
		width : UDINT; (*Width of image.*)
		pSrc : REFERENCE TO USINT; (*Pointer to image data array.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViImg_JpgEncode : UDINT (*Function to encode data to JPG format. Returns size of the compressed data.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pSrc : UDINT; (*Pointer to JPG image destination.*)
		len : UDINT; (*Size of source data.*)
		width : INT; (*Width of JPG Image.*)
		height : INT; (*Height of JPG Image.*)
		channels : INT; (*color channels (1 for grey scale image)*)
		quality : USINT; (*Quality of JPG Image. 1-99% (JPG is not lossless)*)
		pDest : REFERENCE TO USINT; (*Pointer to destination data.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViImg_getBmpImgInfo : BOOL (*Function to get BMP Image information. Returns True if BMP information is extracted. Returns False if no data is available or decoder encounters an error.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pSrc : UDINT; (*Pointer to Image Data.*)
		len : UDINT; (*Size of the image.*)
	END_VAR
	VAR_IN_OUT
		pDest : brdkViImg_imageArray_typ; (*Pointer to brdkVIImg_imageArray where jpeg iformation is stored*)
	END_VAR
END_FUNCTION

FUNCTION brdkViImg_getJpegImgInfo : BOOL (*Function to get JPEG Image information. Returns True if JPEG information is extracted. Returns False if no data is available or decoder encounters an error.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pSrc : UDINT; (*Pointer to Image Data.*)
		len : UDINT; (*Size of the image.*)
	END_VAR
	VAR_IN_OUT
		pDest : brdkViImg_imageArray_typ; (*Pointer to brdkVIImg_imageArray where jpeg iformation is stored*)
	END_VAR
END_FUNCTION

FUNCTION brdkViImg_base64Encode : BOOL (*Function to encode data to base64. Returns true on succesful encoding. Returns false on inter overflows. Returns %NULL on failure.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pSrc : REFERENCE TO USINT; (*Pointer to data to be encoded.*)
		len : UDINT; (*Length of data to be encoded.*)
		pDest : REFERENCE TO USINT; (*Point to output location  where encoded data is stored*)
		maxDestLen : UDINT; (*Maximum length of encoded data.*)
	END_VAR
	VAR_IN_OUT
		pDestLen : UDINT; (* Pointer to UDINT where the size of the encoded data is stored*)
	END_VAR
END_FUNCTION

FUNCTION brdkViImg_base64Decode : BOOL (*Function to decode bae64 data type. Returns true on successful decoding. Returns false on unsuccesful decoding. Returns %NULL on failure.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pSrc : REFERENCE TO USINT; (*Pointer data to be decoded.*)
		len : UDINT; (*Length of data to decoded.*)
		pDest : REFERENCE TO USINT; (*Pointer to output location of decoded data.*)
		maxDestLen : UDINT; (*Maximum length of decoded data.*)
	END_VAR
	VAR_IN_OUT
		pDestLen : UDINT; (* Pointer to UDINT where the size of the encoded data is stored*)
	END_VAR
END_FUNCTION

FUNCTION brdkViImg_bmpDecode : UDINT (*Function to decode BMP file format. Returns pData. Returns false if unexpected mask format and/or unexpected color space type. *) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pSrc : UDINT; (*Pointer to source data.*)
		pDest : UDINT; (*Pointer to image data.*)
	END_VAR
	VAR_IN_OUT
		sizeMem : UDINT; (*Memory size.*)
		bmpHeader : brdkViImg_bmpHeader_typ; (*BMP header of type brdkViImg_bmpHeader.*)
		height : UDINT; (*Height of BMP image.*)
		width : UDINT; (*Width of BMP image.*)
		channels : USINT; (*Color channels of the image (1 if its grey scale)*)
	END_VAR
END_FUNCTION

{REDUND_UNREPLICABLE} FUNCTION_BLOCK brdkViImg_getImage (*Function block to download image from camera*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pMappLink : {REDUND_UNREPLICABLE} UDINT; (*Pointer to the vision component mapp variable fx. gCamera*)
		imageFormat : {REDUND_UNREPLICABLE} BRDKVIIMG_IMG_TYPE; (*Image format (BRDKVIIMG_IMG_TYPE_BMP or BRDKVIIMG_IMG_TYPE_JPG)*)
		simulateConfig : {REDUND_UNREPLICABLE} brdkViImg_getImageSimulate_typ; (*If true the image is decoded to an 2D array*)
		jpegQuality : {REDUND_UNREPLICABLE} USINT; (*Quality of the image (only JPEG)*)
		getImage : {REDUND_UNREPLICABLE} BOOL; (*Trigger download of image, (is automatically reset to false)*)
		enable : {REDUND_UNREPLICABLE} BOOL; (*Enable the function block.*)
		timeout : {REDUND_UNREPLICABLE} TIME := T#2000ms; (*Timeout will trigger a retry for download of  the image*)
	END_VAR
	VAR_OUTPUT
		pDest : {REDUND_UNREPLICABLE} UDINT; (*Pointer to memory containing the image*)
		destLen : {REDUND_UNREPLICABLE} UDINT; (*Size of the image*)
		initDone : {REDUND_UNREPLICABLE} BOOL; (*Initialization is done*)
		status : {REDUND_UNREPLICABLE} UINT; (*Status of the function block*)
	END_VAR
	VAR
		state : {REDUND_UNREPLICABLE} USINT;
		internal : {REDUND_UNREPLICABLE} brdkViImg_getImageInternal_typ;
		tmpStr1 : {REDUND_UNREPLICABLE} STRING[80];
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK brdkViImg_mappView (*Function block for loading an image from the memory buffer in mappView.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		enable : {REDUND_UNREPLICABLE} BOOL; (*Enable function block (will allocate/free memory)*)
		updateImage : {REDUND_UNREPLICABLE} BOOL; (*Trigger an update of the image (is automatically reset to false)*)
		simulateConfig : {REDUND_UNREPLICABLE} brdkViImg_getImageSimulate_typ; (*If true the image is decoded to an 2D array*)
		getImageArray : {REDUND_UNREPLICABLE} BOOL; (*If true the image is decoded to an 2D array*)
		imageFormat : {REDUND_UNREPLICABLE} BRDKVIIMG_IMG_TYPE; (*Image format (BRDKVIIMG_IMG_TYPE_BMP or BRDKVIIMG_IMG_TYPE_JPG)*)
		jpegQuality : {REDUND_UNREPLICABLE} USINT; (*Jpeg quality*)
		pMappLink : {REDUND_UNREPLICABLE} UDINT; (*Pointer to the vision component mapp variable fx. gCamera*)
		pSvgImage : {REDUND_UNREPLICABLE} UDINT; (*Pointer to the SVG string where data the image data should be added*)
		maxSvgImageLength : {REDUND_UNREPLICABLE} UDINT; (*Maximum lenght of the SVG string*)
		svgImagePosition : {REDUND_UNREPLICABLE} brdkViBase_2d_typ; (*Position of the image for the SVG string*)
		pImageArray : REFERENCE TO brdkViImg_imageArray_typ; (*Pointer to the image array structure where the decode image is stored along with information about it*)
		wsPort : UINT := 0; (*Websocket port number to accept connections from brdk Image Widgets (0=web socket is not used)*)
		timeout : {REDUND_UNREPLICABLE} UDINT := 6000; (*Timeout will trigger a retry for download of  the image*)
	END_VAR
	VAR_OUTPUT
		status : {REDUND_UNREPLICABLE} UDINT; (*Status of the function block*)
		info : {REDUND_UNREPLICABLE} brdkViImg_mappViewInfo_typ; (*Execution information of the function block*)
		svgLength : UDINT; (*Actual lenght of the SVG string*)
		newSvgReady : BOOL; (*True when the SVG string have been updated*)
	END_VAR
	VAR
		internal : {REDUND_UNREPLICABLE} brdkViImg_mappViewInternal_typ;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_UNREPLICABLE} FUNCTION_BLOCK brdkViImg_JpgDecode (*Function block for decoding JPG image. Loads a JEPG image from a memory buffer or file. On return width/height will be set to image dimension, channels will be set to either 1 or 3.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		enable : {REDUND_UNREPLICABLE} BOOL; (*Enables the function block.*)
		start : {REDUND_UNREPLICABLE} BOOL; (*Starts the JPG decoding.*)
		pSrc : REFERENCE TO USINT; (*Source data of the JPG image.*)
		len : {REDUND_UNREPLICABLE} UDINT; (*Extracts the size of the JPG image.*)
		sizeMem : {REDUND_UNREPLICABLE} UDINT; (*Current size of the dest memory (if new is lower or equal the memory is reused)*)
		name : {REDUND_UNREPLICABLE} STRING[32]; (*uniqe name used for the thread there is created*)
	END_VAR
	VAR_OUTPUT
		width : {REDUND_UNREPLICABLE} INT; (*Outputs width ofJPG image.*)
		height : {REDUND_UNREPLICABLE} INT; (*Outputs height of JPG Image.*)
		channels : {REDUND_UNREPLICABLE} INT; (*Color channels, 1 for greyscale or 3 for RGB colors.*)
		pDest : {REDUND_UNREPLICABLE} UDINT; (*Pointer to ouput decoded image data*)
		status : {REDUND_UNREPLICABLE} UDINT; (*Status of the function block*)
		failedCnt : {REDUND_UNREPLICABLE} UDINT; (*Number of failed decodings of images*)
		imgCnt : {REDUND_UNREPLICABLE} UDINT; (*Total number of decoded images*)
	END_VAR
	VAR
		taskIdent : {REDUND_UNREPLICABLE} UDINT;
		state : {REDUND_UNREPLICABLE} USINT;
		tick : {REDUND_UNREPLICABLE} USINT;
		tickOld : {REDUND_UNREPLICABLE} USINT;
		tonHeartbeat : {REDUND_UNREPLICABLE} TON;
	END_VAR
END_FUNCTION_BLOCK
