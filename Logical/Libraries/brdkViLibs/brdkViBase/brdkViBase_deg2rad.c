
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
/* Function to convert degrees to radians. Return angle in radians. */
double brdkViBase_deg2rad(double deg)
{
	return deg * M_PI / 180.0;
}
