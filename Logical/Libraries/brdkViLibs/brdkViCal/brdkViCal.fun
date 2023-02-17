
FUNCTION brdkViCal_UndistortPoint : BOOL (*Undistort 2d points with known radial and tangential distortion parameters and internal camera calibration matrix*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		radialDistortion : ARRAY[0..2] OF LREAL; (*Radial distortion parameters*)
		tangentialDistortion : ARRAY[0..1] OF LREAL; (*Tangential distortion parameters*)
		K : ARRAY[0..2,0..2] OF LREAL; (*Camera internal calibration matrix*)
	END_VAR
	VAR_IN_OUT
		imgPoint : brdkViBase_2d_typ; (*image points (will be updated)*)
	END_VAR
END_FUNCTION

FUNCTION brdkViCal_RadialUndistortPoint : BOOL (*Undistort 2d points with known radial distortion parameters and internal camera calibration matrix*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		radialDistortion : ARRAY[0..4] OF LREAL; (*Radial distortion parameters*)
		K : ARRAY[0..2,0..2] OF LREAL; (*Camera internal calibration matrix*)
		orgImgPoint : brdkViBase_2d_typ; (*Original image points (will be updated)*)
	END_VAR
	VAR_IN_OUT
		newImgPoint : brdkViBase_2d_typ; (*New image point (will be updated)*)
	END_VAR
END_FUNCTION

FUNCTION brdkViCal_InvP : BOOL (*Calculate inverse camera projection matrix*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		P : ARRAY[0..2,0..3] OF LREAL; (*Camera projection matrix*)
	END_VAR
	VAR_IN_OUT
		invP : ARRAY[0..2,0..2] OF LREAL; (*Camera invers projection matrix*)
	END_VAR
END_FUNCTION

FUNCTION brdkViCal_Calibration : BOOL (*Calculate the camera projection matrix from 4 know points in image 2d and world 3d for a planar surface*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		real : brdkViBase_3d_typ; (*First index of an array of 3d world points  i.e  points[0]*)
		img : brdkViBase_2d_typ; (*Array of 2d image points*)
		num : USINT; (*Number of points used (4  is best)*)
	END_VAR
	VAR_IN_OUT
		P : ARRAY[0..2,0..3] OF LREAL; (*Camera projection matrix*)
	END_VAR
END_FUNCTION

FUNCTION brdkViCal_CalcProjMat : BOOL (*Calculate camera projection matrix from internal camera matrix, rotation matrix and translation matrix.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rotMat : ARRAY[0..2,0..2] OF LREAL; (*Rotation matrix*)
		transVec : ARRAY[0..2] OF LREAL; (*Translation vector*)
		K : ARRAY[0..2,0..2] OF LREAL; (*Camera internal calibration matrix*)
	END_VAR
	VAR_IN_OUT
		P : ARRAY[0..2,0..3] OF LREAL; (*Camera projection matrix*)
	END_VAR
END_FUNCTION

FUNCTION brdkViCal_3DtoPxLen : LREAL (*Converts a 3D length and converts to a pixel length*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		P : ARRAY[0..2,0..3] OF LREAL; (*Camera Projection matrix*)
		len : LREAL; (*Length of 3D vector*)
		pImgCenter : UDINT; (*Pointer to center of image*)
	END_VAR
END_FUNCTION

FUNCTION brdkViCal_3dTo2d : BOOL (*Project 3d to 2d image coordinate*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		P : ARRAY[0..2,0..3] OF LREAL; (*Camera Projection matrix*)
		worldPos : brdkViBase_3d_typ; (*3D world positions*)
	END_VAR
	VAR_IN_OUT
		imgPos : brdkViBase_2d_typ; (*2D image position*)
	END_VAR
END_FUNCTION

FUNCTION brdkViCal_2dTo3d : BOOL (*Inverse projection of 2d image to 3d world position*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		imgPos : brdkViBase_2d_typ; (*2D image position*)
		invP : ARRAY[0..2,0..2] OF LREAL; (*Inverse camera projection matrix*)
	END_VAR
	VAR_IN_OUT
		worldPos : brdkViBase_3d_typ; (*3D world positions*)
	END_VAR
END_FUNCTION

FUNCTION brdkViCal_3dto2dOrientation : LREAL (*Converts 3D world orientation to 2D image orientation*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		orientation : LREAL; (*3D orientation in world coordinates*)
		P : ARRAY[0..2,0..3] OF LREAL; (*Camera projection matrix.*)
		rotCenterX : LREAL; (*Angle rotation around x-coordinate in center of image *)
		rotCenterY : LREAL; (*Angle rotation around y-coordinate in center of image*)
	END_VAR
END_FUNCTION

FUNCTION brdkViCal_2dto3dOrientation : LREAL (*Converts 2D image orientation to 3D world orientation*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		orientation : LREAL; (*2D orientation in image.*)
		invP : ARRAY[0..2,0..2] OF LREAL; (*Inverse camera projection matrix.*)
		rotCenterX : LREAL; (*Rotation around x-coordinate in center of image*)
		rotCenterY : LREAL; (*Rotation about y-coordinate in center of image*)
	END_VAR
END_FUNCTION
