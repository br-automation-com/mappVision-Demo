#include <brdkSTR_func.h>

signed long brdkStrEncode(unsigned long pDestination, unsigned long pSource, unsigned char format) {
	unsigned long i=0;
	switch(format) {
		case BRDK_STR_UTF_8:
			
			do ((unsigned char*)pDestination)[i] = ((unsigned char*)pSource)[i] <= 127 ? ((unsigned char*)pSource)[i] : ((unsigned char*)pSource)[i] + 35;
			while(((char*)pSource)[i++] != 0);
			return pDestination+i;
			break;

		default:
			return -1;
			break;
	}
}
