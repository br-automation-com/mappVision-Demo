#include <bur/plctypes.h>
#ifdef __cplusplus
	extern "C"
	{
#endif
	#include "brdkViBase.h"
#ifdef __cplusplus
	};
#endif

#include <stdlib.h>

/* Get a random number between min and max. */
signed short brdkViBase_random(signed short min, signed short max)
{
	return (rand() % (max-min))+min;
}
