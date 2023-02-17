#include <brdkSTR_func.h>

signed long brdkStrAToDint(unsigned long pString, unsigned char base) {
	/* check if string starts with a minus sign */
	if(((char*)pString)[0] == 0x2d) return -brdkStrAToUdint(pString+1,BRDK_STR_CONVERT_DECIMAL);
	else return brdkStrAToUdint(pString,base);
}
