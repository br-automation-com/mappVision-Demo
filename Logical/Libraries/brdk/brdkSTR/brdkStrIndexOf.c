#include <brdkSTR_func.h>

signed long brdkStrIndexOf(unsigned long pString, unsigned long pChar, signed long direction) {
	signed long i;
	if(direction > -1) {
		i = 0;
		while(((char*)pString)[i]) {
			if(((char*)pString)[i] == ((char*)pChar)[0]) break;
			else i++;
		}
		if(((char*)pString)[i] != 0) return i;
		else return -1;
	}
	else {
		i = brdkStrLen(pString)-1;
		while(((char*)pString)[i] && i > -1) if(((char*)pString)[i--] == ((char*)pChar)[0]) break;
		if(((char*)pString)[i] != 0) return ++i;
		else return -1;
	}
}
