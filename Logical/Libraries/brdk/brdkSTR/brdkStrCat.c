#include <brdkSTR_func.h>

unsigned long brdkStrCat(unsigned long pDestination, unsigned long pSource) {
	unsigned long i=0,len = brdkStrLen(pSource), start = brdkStrLen(pDestination);
	for(i=0; i< len; i++) ((char*)pDestination)[start+i] = ((char*)pSource)[i];
	((char*)pDestination)[start+i] = 0;
	return pDestination+start+i;
}
