/* Automation Studio generated header file */
/* Do not edit ! */
/* brdkViGeom 1.00.2 */

#ifndef _BRDKVIGEOM_
#define _BRDKVIGEOM_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _brdkViGeom_VERSION
#define _brdkViGeom_VERSION 1.00.2
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "brdkViBase.h"
		#include "brdkViCal.h"
#endif
#ifdef _SG4
		#include "brdkViBase.h"
		#include "brdkViCal.h"
#endif
#ifdef _SGC
		#include "brdkViBase.h"
		#include "brdkViCal.h"
#endif


/* Constants */
#ifdef _REPLACE_CONST
 #define MAX_SHAPE_POINTS 19U
#else
 _GLOBAL_CONST unsigned char MAX_SHAPE_POINTS;
#endif




/* Datatypes and datatypes of function blocks */
typedef enum BRDKVIGEOM_SHAPE_ENM
{	BRDKVIGEOM_SHAPE_NOT_USED = 0,
	BRDKVIGEOM_SHAPE_CIRCLE = 1,
	BRDKVIGEOM_SHAPE_RECTANGLE = 2,
	BRDKVIGEOM_SHAPE_TRIANGLE = 3,
	BRDKVIGEOM_SHAPE_POINTS = 4
} BRDKVIGEOM_SHAPE_ENM;

typedef struct brdkViGeom_shape_typ
{	double length;
	double width;
	double offsetAngle;
	struct brdkViBase_2d_typ offset;
	enum BRDKVIGEOM_SHAPE_ENM type;
	unsigned char numPoints;
	struct brdkViBase_2d_typ points[20];
} brdkViGeom_shape_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC double brdkViGeom_scalarProduct2D(struct brdkViBase_2d_typ* vectorA, struct brdkViBase_2d_typ* vectorB);
_BUR_PUBLIC plcbit brdkViGeom_checkPointInShape(struct brdkViGeom_shape_typ* shape, struct brdkViBase_2d_typ* shapePoints, struct brdkViBase_2d_typ* checkPoint, struct brdkViBase_2d_typ* center);
_BUR_PUBLIC plcbit brdkViGeom_checkPointInPolygon(struct brdkViBase_2d_typ* checkPoint, struct brdkViBase_2d_typ* shapePoints, unsigned char numShapePoints);
_BUR_PUBLIC plcbit brdkViGeom_checkPointInRect(struct brdkViBase_2d_typ* pointA, struct brdkViBase_2d_typ* pointB, struct brdkViBase_2d_typ* pointD, struct brdkViBase_2d_typ* pointCheck);
_BUR_PUBLIC plcbit brdkViGeom_checkPointInTrigon(struct brdkViBase_2d_typ* pointA, struct brdkViBase_2d_typ* pointB, struct brdkViBase_2d_typ* pointC, struct brdkViBase_2d_typ* checkPoint);
_BUR_PUBLIC plcbit brdkViGeom_rectIntersection(struct brdkViBase_2d_typ Rect1[4], struct brdkViBase_2d_typ* center1, double length1, double width1, struct brdkViBase_2d_typ Rect2[4], struct brdkViBase_2d_typ* center2, double length2, double width2);
_BUR_PUBLIC plcbit brdkViGeom_checkShapeIntersect(struct brdkViGeom_shape_typ* shape1, struct brdkViBase_2d_typ* shape1Center, struct brdkViBase_2d_typ* shape1Points, struct brdkViGeom_shape_typ* shape2, struct brdkViBase_2d_typ* shape2Center, struct brdkViBase_2d_typ* shape2Points);
_BUR_PUBLIC plcbit brdkViGeom_drawSvgEllipse(struct brdkViBase_2d_typ* center, double rx, double ry, double angle, unsigned long pStr, unsigned long pArgs);
_BUR_PUBLIC plcbit brdkViGeom_drawSvgCircle(struct brdkViBase_2d_typ* center, double r, unsigned long pStr, unsigned long pArgs);
_BUR_PUBLIC plcbit brdkViGeom_drawSvgLine(struct brdkViBase_2d_typ* p1, struct brdkViBase_2d_typ* p2, unsigned long pStr, unsigned long pArgs);
_BUR_PUBLIC plcbit brdkViGeom_drawSvgImage(unsigned long pUrl, struct brdkViBase_2d_typ* position, unsigned long pUnit, double height, double width, unsigned long pStr, unsigned long pArgs);
_BUR_PUBLIC plcbit brdkViGeom_drawSvgText(unsigned long pText, struct brdkViBase_2d_typ* position, float linespacing, unsigned long pStr, unsigned long pArgs);
_BUR_PUBLIC plcbit brdkViGeom_drawSvgPoly(struct brdkViBase_2d_typ* points, unsigned char numPoints, unsigned long pStr, unsigned long pArgs);
_BUR_PUBLIC plcbit brdkViGeom_drawSvgRect(struct brdkViBase_2d_typ* pointA, struct brdkViBase_2d_typ* pointB, struct brdkViBase_2d_typ* pointC, struct brdkViBase_2d_typ* pointD, unsigned long pStr, unsigned long pArgs);
_BUR_PUBLIC plcbit brdkViGeom_drawSvgTriFromCP(struct brdkViBase_2d_typ* center, double height, double width, double orientation, unsigned long pStr, unsigned long pArgs);
_BUR_PUBLIC plcbit brdkViGeom_drawSvgRectFromCP(struct brdkViBase_2d_typ* center, double length, double width, double orientation, unsigned long pStr, unsigned long pArgs);
_BUR_PUBLIC plcbit brdkViGeom_drawSvgTrigon(struct brdkViBase_2d_typ* pointA, struct brdkViBase_2d_typ* pointB, struct brdkViBase_2d_typ* pointC, unsigned long pStr, unsigned long pArgs);
_BUR_PUBLIC plcbit brdkViGeom_drawCalibration(double P[3][4], double axsisLength, struct brdkViBase_3d_typ* holePos, unsigned char numHoles, unsigned long pStr, unsigned long pArgsHole, unsigned long pArgsAxis);
_BUR_PUBLIC double brdkViGeom_closestNeigbour(unsigned char idx, unsigned char length, struct brdkViBase_2d_typ* points);
_BUR_PUBLIC plcbit brdkViGeom_getRectPoints(double length, double width, struct brdkViBase_2d_typ* centerPoint, double orientation, struct brdkViBase_2d_typ* pointA, struct brdkViBase_2d_typ* pointB, struct brdkViBase_2d_typ* pointC, struct brdkViBase_2d_typ* pointD);
_BUR_PUBLIC plcbit brdkViGeom_getLinesIntersection(struct brdkViBase_2d_typ* lineA_point1, struct brdkViBase_2d_typ* lineA_point2, struct brdkViBase_2d_typ* lineB_point1, struct brdkViBase_2d_typ* lineB_point2, struct brdkViBase_2d_typ* intersectionPoint);
_BUR_PUBLIC plcbit brdkViGeom_getLineFunc(struct brdkViBase_2d_typ* pointA, struct brdkViBase_2d_typ* pointB, double* a, double* b);
_BUR_PUBLIC plcbit brdkViGeom_getTrigonPoints(double height, double width, struct brdkViBase_2d_typ* centerPoint, double orientation, struct brdkViBase_2d_typ* pointA, struct brdkViBase_2d_typ* pointB, struct brdkViBase_2d_typ* pointC);
_BUR_PUBLIC plcbit brdkViGeom_getLineCrossForY(double a, double b, double Y, double* X);
_BUR_PUBLIC plcbit brdkViGeom_offsetShapePoints(struct brdkViBase_2d_typ* shapePoints, struct brdkViBase_2d_typ* baseShapePoints, unsigned char numPoints, double orientation, struct brdkViBase_2d_typ* offset);
_BUR_PUBLIC double brdkViGeom_rot2eul(double rotMat[3][3], enum brdkViBase_angle_enum angle);
_BUR_PUBLIC plcbit brdkViGeom_offsetVector(double orientation, struct brdkViBase_2d_typ* offset, struct brdkViBase_2d_typ* vector);
_BUR_PUBLIC plcbit brdkViGeom_rotatePoint(double angle, struct brdkViBase_2d_typ* point);


#ifdef __cplusplus
};
#endif
#endif /* _BRDKVIGEOM_ */

