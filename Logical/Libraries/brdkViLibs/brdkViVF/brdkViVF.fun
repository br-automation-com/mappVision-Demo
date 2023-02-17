
FUNCTION brdkViVF_shapeBlob : BOOL (*Function for shaping the BLOB used in the vision function.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		imgWidth : INT; (*Width of image.*)
		imgHeight : INT; (*Height of image*)
		pImg1 : REFERENCE TO USINT; (*Pointer to first image.*)
		pImg2 : REFERENCE TO USINT; (*Pointer to second image. Can also be an USINT value*)
		center : brdkViBase_2d_typ; (*Center of shape BLOB.*)
		outerShape : brdkViGeom_shape_typ; (*Defines the shape of the outer BLOB.*)
		innerShape : brdkViGeom_shape_typ; (*Defines the shape of the inner BLOB.*)
		orientation : LREAL; (*Orientation of BLOB.*)
		minDiff : INT; (*The minimum difference between img1 and img2 before the pixels are considered*)
		stepSize : INT; (*Step size in X and Y direction when going though the image of and evaluating pixels*)
	END_VAR
	VAR_IN_OUT
		blob : brdkViVF_blobInfo_typ; (*BLOB with information of type brdkViVF_blobInfo_typ*)
	END_VAR
END_FUNCTION
