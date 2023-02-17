#include <brdkSTR_func.h>

unsigned long brdkStrMemCpy(unsigned long pDestination, unsigned long pSource, unsigned long amount) {
	unsigned long i=0;
	for(i=0; i< amount; i++) ((char*)pDestination)[i] = ((char*)pSource)[i];
	return pDestination+amount;
}
