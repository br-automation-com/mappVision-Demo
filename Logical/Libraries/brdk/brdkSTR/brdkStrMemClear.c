#include <brdkSTR_func.h>

unsigned long brdkStrMemClear(unsigned long pDestination, unsigned long amount) {
	return brdkStrMemSet(pDestination,0,amount);
}
