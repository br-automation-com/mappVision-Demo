

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

/* Initialize rand function. */
plcbit brdkViBase_initRand(unsigned long seed)
{
	if(seed == 0){
		seed = clock_ms();
	}
	
	srand(seed);
	return 1;
}
