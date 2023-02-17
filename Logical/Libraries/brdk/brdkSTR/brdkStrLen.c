#include <brdkSTR_func.h>

signed long brdkStrLen(unsigned long pString) {
	unsigned long len = 0;
	while(((char*)pString)[len]) len++;	/* makes a little strlen */
	return len;
}
