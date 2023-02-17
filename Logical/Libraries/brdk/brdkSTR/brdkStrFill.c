#include <brdkSTR_func.h>

signed long brdkStrFill(unsigned long pString, signed long amount, unsigned long pChar, signed long position) {
	signed long i,j, len = brdkStrLen(pString), tmpPos;
	char ch;
	i = len+amount;
	j = len;
	ch = pChar != 0 && *(char*)pChar != 0 ? *(char*)pChar : 0x20;	/* white space is default */
	tmpPos = position >= 0 ? position : len + 1 + position;
	if(tmpPos > -1) {
		while(j>=tmpPos) ((char*)pString)[i--] = ((char*)pString)[j--];
		while(i>=tmpPos) ((char*)pString)[i--] = ch;
		return len+amount;
	}
	else return -1;
}
