#include <brdkSTR_func.h>

unsigned long brdkStrMemSet(unsigned long pDestination, unsigned char value, unsigned long amount) {
	unsigned long i=0;
	for(i=0; i< amount; i++) ((char*)pDestination)[i] = value;
	return pDestination+amount;
}
