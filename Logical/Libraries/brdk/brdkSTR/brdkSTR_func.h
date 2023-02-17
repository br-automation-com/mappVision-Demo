#ifndef BRDK_STR_FUNCS
#define BRDK_STR_FUNCS 1

#include <brdkSTR.h>
#include <bur/plctypes.h>

#ifdef __cplusplus
	extern "C"
	{
#endif

signed long search(signed long pString, signed long lenString, signed long pSearchString, signed long lenSearch);
unsigned long aToUdint(unsigned long pString, signed long len, unsigned char base);

#ifdef __cplusplus
	};
#endif

#endif
