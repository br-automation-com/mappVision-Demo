#include <brdkSTR_func.h>

unsigned long brdkStrAToUdint(unsigned long pString, unsigned char base) {
	signed long len = brdkStrLen(pString);
	return aToUdint(pString, len, base);
}
