
FUNCTION brdkViGeom_scalarProduct2D : LREAL (*Function to calculate the scalar product of a two 2d vector. Returns the scalar product of the two 2d vector.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		vectorA : brdkViBase_2d_typ; (*Vector A (x,y)*)
		vectorB : brdkViBase_2d_typ; (*Vector B (x,y)*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_checkPointInShape : BOOL (*Function to check if a point is inside a defined shape. Returns 0 if point is not defined by a shape. For circles return brdkViBase_distance output. Polygons returns output of brdkViGeom_checkPointInPolygon*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		shape : brdkViGeom_shape_typ; (*Shape structure defining the shape information*)
		shapePoints : brdkViBase_2d_typ; (*Array of shape points (not passed as an array as AS takes care of this)*)
		checkPoint : brdkViBase_2d_typ; (*Point to check if its inside the shape*)
		center : brdkViBase_2d_typ; (*Center point of the shape (is only used if the shape is circle)*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_checkPointInPolygon : BOOL (*Function to check if a point is inside a polygon defined by an array of points. Returns True if point the point is inside. Returns False if the point is not inside.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		checkPoint : brdkViBase_2d_typ; (*Check point to cehck if its inside the polygon*)
		shapePoints : brdkViBase_2d_typ; (*Array of polygon  points (not passed as an array as AS takes care of this)*)
		numShapePoints : USINT; (*Number of polygon points*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_checkPointInRect : BOOL (*Function to check if a point is inside a rectangle defined by four points. Returns True if the point is inside. Returns False if the point is not inside.
*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pointA : brdkViBase_2d_typ; (*First point in rectangle  ( |_ )*)
		pointB : brdkViBase_2d_typ; (*Second point in rectangle  ( |_ )*)
		pointD : brdkViBase_2d_typ; (*Thrid point in rectangle  ( |_ )*)
		pointCheck : brdkViBase_2d_typ; (*Point to check if its inside the rectangle*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_checkPointInTrigon : BOOL (*Function to check if a point is inside a triangle defined by three points. Returns True if the point is inside. Returns False if the point is not inside.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pointA : brdkViBase_2d_typ; (*First point in triangle*)
		pointB : brdkViBase_2d_typ; (*Second point in triangle*)
		pointC : brdkViBase_2d_typ; (*Third point in triangle*)
		checkPoint : brdkViBase_2d_typ; (*Point to check if its inside the triangle*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_rectIntersection : BOOL (*Function to check if two rectangles intersect eachother. Returns true if the rectangles intersect. Returns False if the rectangles does not intersect.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Rect1 : ARRAY[0..3] OF brdkViBase_2d_typ; (*Points of the first rectangle *)
		center1 : brdkViBase_2d_typ; (*Center point of the first rectanle*)
		length1 : LREAL; (*Length for the first rectangle*)
		width1 : LREAL; (*Width for the first rectangle*)
		Rect2 : ARRAY[0..3] OF brdkViBase_2d_typ; (*Points of the second rectangle *)
		center2 : brdkViBase_2d_typ; (*Center point of the second rectangle*)
		length2 : LREAL; (*Length for the second rectangle*)
		width2 : LREAL; (*Width for the second rectangle*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_checkShapeIntersect : BOOL (*Function to check if two shapes intersect eachother. Returns true if shapes intersects. Returns False if the shapes does not intersect.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		shape1 : brdkViGeom_shape_typ; (*Shape structure defining the shape information for the first shape*)
		shape1Center : brdkViBase_2d_typ; (*Center point of the first shape (is only used if the shape is circle)*)
		shape1Points : brdkViBase_2d_typ; (*Array of shape points for the first shape (not passed as an array as AS takes care of this)*)
		shape2 : brdkViGeom_shape_typ; (*Shape structure defining the shape information for the second shape*)
		shape2Center : brdkViBase_2d_typ; (*Center point of the second shape (is only used if the shape is circle)*)
		shape2Points : brdkViBase_2d_typ; (*Array of shape points for the second shape (not passed as an array as AS takes care of this)*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_drawSvgEllipse : BOOL (*Function to create a svg string with ellipse defined by a center point and radius.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		center : brdkViBase_2d_typ; (*Center point of the ellipse *)
		rx : LREAL; (*Radius of the ellipse x direction*)
		ry : LREAL; (*Radius of the ellipse y direction*)
		angle : LREAL; (*Rotation angle in degrees around the center point*)
		pStr : UDINT; (*Pointer to the string where the Svg element is appended*)
		pArgs : UDINT; (*Pointer to a string with addition arguments for the Svg element*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_drawSvgCircle : BOOL (*Function to create a svg string with circle defined by a center point and radius.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		center : brdkViBase_2d_typ; (*Center point of the circle*)
		r : LREAL; (*Radius of the circle*)
		pStr : UDINT; (*Pointer to the string where the Svg element is appended*)
		pArgs : UDINT; (*Pointer to a string with addition arguments for the Svg element*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_drawSvgLine : BOOL (*Function to create a svg string with line defined by two points.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		p1 : brdkViBase_2d_typ; (*First point of the line*)
		p2 : brdkViBase_2d_typ; (*Second point of the line*)
		pStr : UDINT; (*Pointer to the string where the Svg element is appended*)
		pArgs : UDINT; (*Pointer to a string with addition arguments for the Svg element*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_drawSvgImage : BOOL (*Function to create a svg string with and image from an url or base 64 string *) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pUrl : UDINT; (*pointer to a string with the image URL or base 64 string *)
		position : brdkViBase_2d_typ; (*Pointer to a 2D position coordinate*)
		pUnit : UDINT; (*Pointer to a string with the unit for the widht and height values. i.e. '%'*)
		height : LREAL; (*Image height*)
		width : LREAL; (*Image width*)
		pStr : UDINT; (*Pointer to the string where the Svg element is appended*)
		pArgs : UDINT; (*Pointer to a string with addition arguments for the Svg element*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_drawSvgText : BOOL (*Function to create a svg string with a muli line text element*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pText : UDINT; (*pointer to a string with the text that should be included in the SVG (for new line use $N)*)
		position : brdkViBase_2d_typ; (*Pointer to a 2D position coordinate*)
		linespacing : REAL; (*Line spacing 1.0 = charecter height*)
		pStr : UDINT; (*Pointer to the string where the Svg element is appended*)
		pArgs : UDINT; (*Pointer to a string with addition arguments for the Svg element*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_drawSvgPoly : BOOL (*Function to create a svg string with polygon defined by an array of points.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		points : brdkViBase_2d_typ; (*Array of shape points (not give as an array as AS does this automatically)*)
		numPoints : USINT; (*Number of points in the polygon*)
		pStr : UDINT; (*Pointer to the string where the Svg element is appended*)
		pArgs : UDINT; (*Pointer to a string with addition arguments for the Svg element*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_drawSvgRect : BOOL (*Function to create a svg string with rect defined by four points.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pointA : brdkViBase_2d_typ; (*First point of the rectangle*)
		pointB : brdkViBase_2d_typ; (*Second point of the rectangle*)
		pointC : brdkViBase_2d_typ; (*Third point of the rectangle*)
		pointD : brdkViBase_2d_typ; (*Fourth point of the rectangle*)
		pStr : UDINT; (*Pointer to the string where the Svg element is appended*)
		pArgs : UDINT; (*Pointer to a string with addition arguments for the Svg element*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_drawSvgTriFromCP : BOOL (*Function to create a svg string with triangle defined by a length, width, center point and orientaion.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		center : brdkViBase_2d_typ; (*Center point of the triance (triangle is places width/2 and length/2*)
		height : LREAL; (*height of the triangle ( /_\ distance from the bottom line to the top)*)
		width : LREAL; (*Width of the triangle ( /_\ bottom line)*)
		orientation : LREAL; (*Orientation in degrees for the rotation*)
		pStr : UDINT; (*Pointer to the string where the Svg element is appended*)
		pArgs : UDINT; (*Pointer to a string with addition arguments for the Svg element*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_drawSvgRectFromCP : BOOL (*Function to create a svg string with rectangle defined by a length, width, center point and orientaion.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		center : brdkViBase_2d_typ; (*Center point of the rectangle (width/2 and length/2)*)
		length : LREAL; (*length of the rectangle*)
		width : LREAL; (*Width of rectangle*)
		orientation : LREAL; (*Orientation in degrees for the rotation*)
		pStr : UDINT; (*Pointer to the string where the Svg element is appended*)
		pArgs : UDINT; (*Pointer to a string with addition arguments for the Svg element*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_drawSvgTrigon : BOOL (*Function to create a svg string with triangle defined by three points.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pointA : brdkViBase_2d_typ; (*First point of the triangle*)
		pointB : brdkViBase_2d_typ; (*Second point of the triangle*)
		pointC : brdkViBase_2d_typ; (*Third point of the triangle*)
		pStr : UDINT; (*Pointer to the string where the Svg element is appended*)
		pArgs : UDINT; (*Pointer to a string with addition arguments for the Svg element*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_drawCalibration : BOOL (*Function to create the svg string with the four calibration holes and the x and y axis.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		P : ARRAY[0..2,0..3] OF LREAL; (*3x4 projection matrix (comes form the camera calibration)*)
		axsisLength : LREAL; (*Axis lengths in real units (fx. mm)*)
		holePos : brdkViBase_3d_typ; (*First index of an array of hole positions in real coordinates (fx. mm) i.e holes[0]*)
		numHoles : USINT; (*Number of holes (only 4 is supported currently)*)
		pStr : UDINT; (*Pointer to the string where the Svg element is appended*)
		pArgsHole : UDINT; (*Pointer to a string with addition arguments for the Svg hole circle elements (fx 'style="stroke-color: red;"')*)
		pArgsAxis : UDINT; (*Pointer to a string with addition arguments for the Svg axis lines elements (fx 'style="stroke-color: red;"')*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_closestNeigbour : LREAL (*Function to get the distance to the closest neigbour point. Returns the minimum distance between two points.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		idx : USINT; (*Index to find the closeset neigbour for*)
		length : USINT; (*Lenght of points array*)
		points : brdkViBase_2d_typ; (*Array of points (not givens as and pointer as AS takes care of this)*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_getRectPoints : BOOL (*Function to get the four points defining a rectangle with a length, width, center point and orientation.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		length : LREAL; (*Length of the rectangle*)
		width : LREAL; (*Width of rectangle*)
		centerPoint : brdkViBase_2d_typ; (*Center point of the rectangle (width/2 and length/2)*)
		orientation : LREAL; (*Orientation in degrees for the rotation*)
		pointA : brdkViBase_2d_typ; (*First point of the rectangle*)
		pointB : brdkViBase_2d_typ; (*Second point of the rectangle*)
		pointC : brdkViBase_2d_typ; (*Third point of the rectangle*)
		pointD : brdkViBase_2d_typ; (*Fourth point of the rectangle*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_getLinesIntersection : BOOL (*Function to get the intersection point between two lines defined each by two points. Returns True if collision is detected. Returns False if no collision is detected.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		lineA_point1 : brdkViBase_2d_typ; (*First point of line A*)
		lineA_point2 : brdkViBase_2d_typ; (*Second point of line A*)
		lineB_point1 : brdkViBase_2d_typ; (*First point of line B*)
		lineB_point2 : brdkViBase_2d_typ; (*Second point of line B*)
		intersectionPoint : brdkViBase_2d_typ; (*Intersection point*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_getLineFunc : BOOL (*Function to get the line function(y=ax+b) parameters a and b, defined by two points. Returns True if line function is found. Returns False if no line function can be found.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		pointA : brdkViBase_2d_typ; (*First point of the line*)
		pointB : brdkViBase_2d_typ; (*Second point of the line*)
	END_VAR
	VAR_IN_OUT
		a : LREAL; (*pointer to real to contain the value of a*)
		b : LREAL; (*pointer to real to contain the value of b*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_getTrigonPoints : BOOL (*Function to get the three points defining an triangle with a length, width, center point and orientation.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		height : LREAL; (*height of the triangle ( /_\ distance from the bottom line to the top)*)
		width : LREAL; (*Width of the triangle ( /_\ bottom line)*)
		centerPoint : brdkViBase_2d_typ; (*Center point of the triance (triangle is places height/2 and width/2*)
		orientation : LREAL; (*Orientation in degrees for the rotation*)
		pointA : brdkViBase_2d_typ; (*First point of the triangle*)
		pointB : brdkViBase_2d_typ; (*Second point of the triangle*)
		pointC : brdkViBase_2d_typ; (*Third point of the triangle*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_getLineCrossForY : BOOL (*Function to get the x value for a line intersection with a specific y value.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		a : LREAL; (*First point of the line*)
		b : LREAL; (*Second point of the line*)
		Y : LREAL; (*Y value to find the x value for*)
	END_VAR
	VAR_IN_OUT
		X : LREAL; (*Pointer to real to contain the found intersection X value*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_offsetShapePoints : BOOL (*Function to offset a shape with to a given location and orientation.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		shapePoints : brdkViBase_2d_typ; (*Array of result shape points (not give as an array as AS does this automatically)*)
		baseShapePoints : brdkViBase_2d_typ; (*Array of input shape points that should be offset (not give as an array as AS does this automatically)*)
		numPoints : USINT; (*Number of points in the shape arrays*)
		orientation : LREAL; (*Orientation in degrees for the rotation*)
		offset : brdkViBase_2d_typ; (*The offset set point*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_rot2eul : LREAL (*Funtion to return a euler angle from a rotation matrix. Returns the angle in degees.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rotMat : ARRAY[0..2,0..2] OF LREAL; (*3x3 Rotation matix *)
		angle : brdkViBase_angle_enum; (*The angle that should be returned*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_offsetVector : BOOL (*Function to offset an vector with a given point an orientaion.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		orientation : LREAL; (*Offset orientaion around origo*)
		offset : brdkViBase_2d_typ; (*Offset set x and y values*)
	END_VAR
	VAR_IN_OUT
		vector : brdkViBase_2d_typ; (*Vector point (x, y)*)
	END_VAR
END_FUNCTION

FUNCTION brdkViGeom_rotatePoint : BOOL (*Function to rotate a point around origo.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		angle : LREAL; (*Rotation angle in degrees*)
	END_VAR
	VAR_IN_OUT
		point : brdkViBase_2d_typ; (*Point that should be rotated*)
	END_VAR
END_FUNCTION
