#include <brdkSTR_func.h>

signed long brdkStrCharCount(unsigned long pString, unsigned long pChar) {
	signed long i=0, cnt=0;
	if(pChar != 0 && *(char*)pChar != 0) {
		while(((char*)pString)[i]) if(((char*)pString)[i++] == *(char*)pChar) cnt++;
	}
	else cnt = -1;
	return cnt;
}
