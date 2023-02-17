#include <brdkSTR_func.h>

unsigned long brdkStrMemMove(unsigned long pDestination, unsigned long pSource, unsigned long amount) {
	unsigned long i=0;
	char buffer[amount];	/* if the destination and source is the same string we need a buffer */
	for(i=0; i< amount; i++) buffer[i] = ((char*)pSource)[i];
	for(i=0; i< amount; i++) ((char*)pDestination)[i] = buffer[i];
	return pDestination+amount;
}
