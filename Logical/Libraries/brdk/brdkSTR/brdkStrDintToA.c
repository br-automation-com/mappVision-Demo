#include <brdkSTR_func.h>

signed long brdkStrDintToA(signed long value, unsigned long pString, unsigned char base) {
	if(value < 0) {
		((char*)pString)[0] = 0x2d; /* - sign */
		return brdkStrUdintToA(-value,pString+1,BRDK_STR_CONVERT_DECIMAL)+1;
	}
	else return brdkStrUdintToA(value,pString,base);
}
