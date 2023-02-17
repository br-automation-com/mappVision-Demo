#include <brdkSTR_func.h>

unsigned char brdkStrIsEmpty(unsigned long pString) {
	return ((char*)pString)[0] == 0;
}
