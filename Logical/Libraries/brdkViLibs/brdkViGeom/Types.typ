
TYPE
	brdkViGeom_shape_typ : 	STRUCT  (*Contains variables used for shape.*)
		length : LREAL; (*Length of the shape. Not used for polygons.*)
		width : LREAL; (*Width of the shape. Not used for polygons.*)
		offsetAngle : LREAL; (*Desired angle the points should be offset by.*)
		offset : brdkViBase_2d_typ; (*Current offset of the shape points.*)
		type : BRDKVIGEOM_SHAPE_ENM := (0); (*Defines the type of shape.*)
		numPoints : USINT; (*Number of points used in the defined shape.*)
		points : ARRAY[0..MAX_SHAPE_POINTS]OF brdkViBase_2d_typ; (*Total amount of points in the shape.*)
	END_STRUCT;
	BRDKVIGEOM_SHAPE_ENM : 
		( (*Shape definition.*)
		BRDKVIGEOM_SHAPE_NOT_USED := 0, (*No definiable shape.*)
		BRDKVIGEOM_SHAPE_CIRCLE := 1, (*Circle.*)
		BRDKVIGEOM_SHAPE_RECTANGLE := 2, (*Rectangle.*)
		BRDKVIGEOM_SHAPE_TRIANGLE := 3, (*Triangle.*)
		BRDKVIGEOM_SHAPE_POINTS := 4 (*Polygon.*)
		);
END_TYPE
