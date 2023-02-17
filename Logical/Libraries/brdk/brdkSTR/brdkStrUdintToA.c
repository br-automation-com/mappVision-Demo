#include <brdkSTR_func.h>

signed long brdkStrUdintToA(unsigned long value, unsigned long pString, unsigned char base) {
	int i=0;
	((char*)pString)[0] = 0;
	base = !base ? 10 : base;	/* make sure base is not 0 */
	if (value != 0) {
		while (value > 0) {
			unsigned long rem = value % base;
	       	((char*)pString)[i++] = (rem > 9)? (rem-10) + 0x41 : rem + 0x30;	/* 0x41 = A, 0x30 = 0*/
	       	value = value/base;
		}
		((char*)pString)[i] = 0;	
	}
	else {
		((char*)pString)[i++] = 0x30;	/* 0 */
		((char*)pString)[i] = 0;
	}
	brdkStrReverse(pString,0,-1);
	return i;
}
