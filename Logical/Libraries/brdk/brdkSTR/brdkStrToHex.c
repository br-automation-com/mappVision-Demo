#include <brdkSTR_func.h>

signed long brdkStrToHex(unsigned long pString) {
	signed long i=0;
	unsigned long rem;
	unsigned char tmp;
	while(((char*)pString)[i]) {
		unsigned char value = (unsigned char)((char*)pString)[i];
		if(value < 0x10) {															/* a character with value below 9 we want representated with a 0 in front */
			brdkStrFill(pString,1,(unsigned long)&"0",i++);
			rem = value % 16;
		    ((char*)pString)[i++] = (rem > 9)? (rem-10) + 0x41 : rem + 0x30;		/* 0x41 = A, 0x30 = 0*/
		}
		else {
			while(value > 0) {
				rem = value % 16;
		       	((char*)pString)[i++] = (rem > 9)? (rem-10) + 0x41 : rem + 0x30;	/* 0x41 = A, 0x30 = 0*/
		       	value = value/16;
				if(value > 0) brdkStrFill(pString,1,(unsigned long)&" ",i);
				else {
					/* swap places */
					tmp = ((char*)pString)[i-1];
					((char*)pString)[i-1] = ((char*)pString)[i-2];
					((char*)pString)[i-2] = tmp;
				}
			}
		}
	}
	((char*)pString)[i] = 0;
	return i;
}
