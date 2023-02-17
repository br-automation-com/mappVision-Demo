#include <brdkSTR_func.h>

unsigned long brdkStrCpy(unsigned long pDestination, unsigned long pSource) {
	unsigned long i=0;
	do ((char*)pDestination)[i] = ((char*)pSource)[i];
	while(((char*)pSource)[i++] != 0);
	return pDestination+i;
}
