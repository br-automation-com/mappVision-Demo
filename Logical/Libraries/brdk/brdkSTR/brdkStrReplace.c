#include <brdkSTR_func.h>

signed long brdkStrReplace(unsigned long pString, unsigned long pFind, unsigned long pReplace) {
	signed long i=0, cnt=0, lenF = brdkStrLen(pFind), lenR = brdkStrLen(pReplace);
	i = brdkStrSearch(pString,pFind);
	while(i > -1) {	
		brdkStrRemove(pString,i,lenF);
		brdkStrInsertAtPos(pString,pReplace,i);
		pString += i + lenR;
		i = brdkStrSearch(pString,pFind);
		cnt++;
	}
	return cnt;
}
