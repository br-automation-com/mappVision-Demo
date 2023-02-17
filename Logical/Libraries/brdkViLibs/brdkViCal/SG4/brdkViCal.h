/* Automation Studio generated header file */
/* Do not edit ! */
/* brdkViCal 1.00.1 */

#ifndef _BRDKVICAL_
#define _BRDKVICAL_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _brdkViCal_VERSION
#define _brdkViCal_VERSION 1.00.1
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "MTLinAlg.h"
		#include "brdkViBase.h"
#endif
#ifdef _SG4
		#include "MTLinAlg.h"
		#include "brdkViBase.h"
#endif
#ifdef _SGC
		#include "MTLinAlg.h"
		#include "brdkViBase.h"
#endif





/* Prototyping of functions and function blocks */
_BUR_PUBLIC plcbit brdkViCal_UndistortPoint(double radialDistortion[3], double tangentialDistortion[2], double K[3][3], struct brdkViBase_2d_typ* imgPoint);
_BUR_PUBLIC plcbit brdkViCal_RadialUndistortPoint(double radialDistortion[5], double K[3][3], struct brdkViBase_2d_typ* orgImgPoint, struct brdkViBase_2d_typ* newImgPoint);
_BUR_PUBLIC plcbit brdkViCal_InvP(double P[3][4], double invP[3][3]);
_BUR_PUBLIC plcbit brdkViCal_Calibration(struct brdkViBase_3d_typ* real, struct brdkViBase_2d_typ* img, unsigned char num, double P[3][4]);
_BUR_PUBLIC plcbit brdkViCal_CalcProjMat(double rotMat[3][3], double transVec[3], double K[3][3], double P[3][4]);
_BUR_PUBLIC double brdkViCal_3DtoPxLen(double P[3][4], double len, unsigned long pImgCenter);
_BUR_PUBLIC plcbit brdkViCal_3dTo2d(double P[3][4], struct brdkViBase_3d_typ* worldPos, struct brdkViBase_2d_typ* imgPos);
_BUR_PUBLIC plcbit brdkViCal_2dTo3d(struct brdkViBase_2d_typ* imgPos, double invP[3][3], struct brdkViBase_3d_typ* worldPos);
_BUR_PUBLIC double brdkViCal_3dto2dOrientation(double orientation, double P[3][4], double rotCenterX, double rotCenterY);
_BUR_PUBLIC double brdkViCal_2dto3dOrientation(double orientation, double invP[3][3], double rotCenterX, double rotCenterY);


#ifdef __cplusplus
};
#endif
#endif /* _BRDKVICAL_ */

