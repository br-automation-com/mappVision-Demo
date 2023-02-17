#include <brdkSTR_func.h>

unsigned long brdkStrNCpy(unsigned long pDestination, unsigned long pSource, unsigned long amount) {
	unsigned long i=0;
	for(i=0; i< amount; i++) {
		if(((char*)pSource)[i]) ((char*)pDestination)[i] = ((char*)pSource)[i];
		else ((char*)pDestination)[i] = 0;
	}
	return pDestination+amount;
}
