
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
/* Calculate the distance between two points. */
double brdkViBase_distance(double x1, double y1, double x2, double y2)
{
	return sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
}
