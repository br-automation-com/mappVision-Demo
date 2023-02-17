#include <brdkSTR_func.h>

signed long brdkStrToUpperCaseWords(unsigned long pString) {
	unsigned long i=0,cnt=0;
	if(((char*)pString)[i]) {
		if(((char*)pString)[i] >= 0x61 && ((char*)pString)[i] <= 0x7a) {	/* check the first character */
	 		((char*)pString)[i] -= 0x20;
			cnt++;
		}
	}
	i++;
	while(((char*)pString)[i]) {
		if((((char*)pString)[i] >= 0x61) && (((char*)pString)[i] <= 0x7a) && ((char*)pString)[i-1] == 0x20){	/* between a..z and a space before */
			((char*)pString)[i] -= 0x20;
			cnt++;	
		} 
		i++;
	}
	return cnt;
}
