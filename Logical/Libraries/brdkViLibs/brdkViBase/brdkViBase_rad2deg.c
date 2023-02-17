
#include <bur/plctypes.h>
#ifdef __cplusplus
	extern "C"
	{
#endif
	#include "brdkViGeom.h"
#ifdef __cplusplus
	};
#endif

#include <math.h>
/* Function to convert radian to degree. Return angle in degrees. */
double brdkViBase_rad2deg(double rad)
{
	return rad / M_PI * 180.0;
}
