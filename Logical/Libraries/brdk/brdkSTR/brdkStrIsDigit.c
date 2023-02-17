#include <brdkSTR_func.h>

unsigned char brdkStrIsDigit(unsigned long pString) {
	unsigned long len = 0;
	while(((char*)pString)[len]) {
		if (((char*)pString)[len] < 0x30 || 0x39 < ((char*)pString)[len]) return 0;
		len++;
	}
	return 1;
}

