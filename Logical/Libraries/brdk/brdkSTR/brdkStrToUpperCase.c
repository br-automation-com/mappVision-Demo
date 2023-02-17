#include <brdkSTR_func.h>

signed long brdkStrToUpperCase(unsigned long pString) {
	unsigned long i=0,cnt=0;
	while(((char*)pString)[i]) {
		if((((char*)pString)[i] >= 0x61) && (((char*)pString)[i] <= 0x7a)) {	/* between a..z */
			((char*)pString)[i] -= 0x20;
			cnt++;
		} 
		i++;
	}
	return cnt;
}
