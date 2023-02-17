#include <brdkSTR_func.h>

signed long brdkStrCmp(unsigned long pString1, unsigned long pString2) {
	unsigned long i=0;
	do if(((char*)pString1)[i] != ((char*)pString2)[i]) break;
	while(((char*)pString1)[i] != 0 && ((char*)pString2)[i++] != 0);
	return ((char*)pString1)[i]-((char*)pString2)[i];
}
