
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

FUNCTION brdkViVF_threshold : BOOL (*The function brdkViVF_threshold applies thresholding to an image. The function takes in an image (input), as well as minimum and maximum threshold values (min and max), and a fill value (fill). The function performs thresholding on the input image, such that any pixel values less than the minimum threshold are set to the fill value, and any pixel values greater than the maximum threshold are also set to the fill value. The resulting thresholded image is returned in the output variable.*) (*The function performs thresholding on the input image, such that any pixel values greater than or equal to the minimum threshold and less than or equal to the maximum threshold are set to the fill. The resulting thresholded image is returned in the output variable.*)
	VAR_INPUT
		input : brdkViImg_imageArray_typ; (*Input image array.*)
		min : USINT; (*Minimum threshold value.*)
		max : USINT; (*Maximum threshold value.*)
		fill : USINT; (*Fill value for pixels inside threshold range.*)
	END_VAR
	VAR_IN_OUT
		output : brdkViImg_imageArray_typ; (*Output image array. (if pData is 0 then the output image memory is allocated to the size og the input image)*)
	END_VAR
END_FUNCTION

FUNCTION brdkViVF_dilate : BOOL (*Applies dilation to an image. The function takes in an binary input image and the number of iterations to perform the dilation.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		input : brdkViImg_imageArray_typ; (*Binary input image array.*)
		iterations : USINT; (*Number of iterations to perform dilation.*)
	END_VAR
	VAR_IN_OUT
		output : brdkViImg_imageArray_typ; (*Output image array.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViVF_absDiff : BOOL (*Computes the absolute difference between two images. The function takes in two input images, 'inputA' and 'inputB', and a gain value to scale the result.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		inputA : brdkViImg_imageArray_typ; (*Input image A.*)
		inputB : brdkViImg_imageArray_typ; (*Input image B.*)
		Gain : REAL; (*Gain value to scale the result.*)
	END_VAR
	VAR_IN_OUT
		output : brdkViImg_imageArray_typ; (*Output image array.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViVF_opening : BOOL (*Applies opening morphological operation to a binary input image. The function takes in an input binary image and the number of iterations to perform the opening.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		input : brdkViImg_imageArray_typ; (*Binary input image array.*)
		iterations : USINT; (*Number of iterations to perform opening.*)
	END_VAR
	VAR_IN_OUT
		output : brdkViImg_imageArray_typ; (*Output image array.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViVF_closing : BOOL (*Performs closing on a binary input image. The function takes in an input image and the number of iterations to perform the closing.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		input : brdkViImg_imageArray_typ; (*Binary input image array.*)
		iterations : USINT; (*Number of iterations to perform closing.*)
	END_VAR
	VAR_IN_OUT
		output : brdkViImg_imageArray_typ; (*Output image array.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViVF_erode : BOOL (*Applies erosion to a binary image. The function takes in a binary input image and the number of iterations to perform erosion.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		input : brdkViImg_imageArray_typ; (*Binary input image array.*)
		iterations : USINT; (*Number of iterations to perform erosion.*)
	END_VAR
	VAR_IN_OUT
		output : brdkViImg_imageArray_typ; (*Output image array.*)
	END_VAR
END_FUNCTION
