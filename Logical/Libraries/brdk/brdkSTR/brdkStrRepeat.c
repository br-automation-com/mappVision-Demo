#include <brdkSTR_func.h>

signed long brdkStrRepeat(unsigned long pString, signed long times) {
	signed long i,j,t,len = brdkStrLen(pString);
	j=len;
	for(t=0; t < times; t++) {
		for(i=0; i< len; i++) ((char*)pString)[j+i] = ((char*)pString)[i];
		j += len;
	}
	((char*)pString)[j] = 0;
	return j;
}
