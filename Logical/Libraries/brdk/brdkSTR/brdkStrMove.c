#include <brdkSTR_func.h>

unsigned long brdkStrMove(unsigned long pDestination, unsigned long pSource) {
	return brdkStrMemMove(pDestination,pSource,brdkStrLen(pSource));
}
