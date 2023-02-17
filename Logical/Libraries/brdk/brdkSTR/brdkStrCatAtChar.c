#include <brdkSTR_func.h>

signed long brdkStrCatAtChar(unsigned long pDestination, unsigned long pSource, unsigned long pChar, signed long direction, unsigned char greedy) {
	unsigned long i=0,len = brdkStrLen(pSource);
	signed long start = brdkStrIndexOf(pDestination,pChar,direction);
	if(start > -1) {
		start += !greedy;
		for(i=0; i< len; i++) ((char*)pDestination)[start+i] = ((char*)pSource)[i];
		((char*)pDestination)[start+i] = 0;
	}
	return start;
}
