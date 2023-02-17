#include <brdkSTR_func.h>

unsigned char brdkStrCharAt(unsigned long pString, unsigned long index, unsigned long pChar) {
	if(index < brdkStrLen(pString)) {
		*(char*)pChar = ((char*)pString)[index];
		return ((char*)pString)[index];
	}
	else {
		*(char*)pChar = 0;
		return 0;
	}
}
