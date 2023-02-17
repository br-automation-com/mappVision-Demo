#include <brdkSTR_func.h>

signed long brdkStrToLowerCase(unsigned long pString) {
	unsigned long i=0, cnt=0;
	while(((char*)pString)[i]) {
		if((((char*)pString)[i] >= 0x41) && (((char*)pString)[i] <= 0x5a)) {	/* between A..Z */
			((char*)pString)[i] += 0x20;
			cnt++;
		} 
		i++;
	}
	return cnt;
}
