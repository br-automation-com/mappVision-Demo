#include <brdkSTR_func.h>

signed long brdkStrMemCmp(unsigned long pString1, unsigned long pString2, unsigned long amount) {
	unsigned long i=0;
	for(i=0; i< amount; i++) if(((char*)pString1)[i] != ((char*)pString2)[i]) break;
	return ((char*)pString1)[i]-((char*)pString2)[i];
}
