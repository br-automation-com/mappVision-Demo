
TYPE
	brdkViVF_blobInfo_typ : 	STRUCT  (*BLOB Information.*)
		histColor : ARRAY[0..255]OF UDINT; (*UDINT array containing colors in the image histogram.*)
		colorSum : UDINT; (*Sum of colors in the BLOB.*)
		meanColor : USINT; (*Mean color in the BLOB.*)
		maxColor : USINT; (*Maximum color value of the BLOB*)
		minColor : USINT; (*Minimum color value of the BLOB*)
		area : UDINT; (*Area of BLOB.*)
	END_STRUCT;
	brdkViVF_bloblist_typ : 	STRUCT 
		pBlobs : UDINT;
		cnt : UDINT;
	END_STRUCT;
	brdkViVF_blob_typ : 	STRUCT 
		pPx : UDINT;
		cnt : UDINT;
	END_STRUCT;
END_TYPE
