#include <brdkSTR_func.h>

signed long brdkStrAppendUdintToA(unsigned long value, unsigned long pString, unsigned char base, signed long position) {
	signed long i,cnt=0,len = brdkStrLen(pString);
	signed long start = position > -1 ? position :len+position+1;
	unsigned char tmp;
	i=start;
	tmp = 0x30;
	base = !base ? 10 : base;	/* make sure base is not 0 */
	if (value != 0) {
		while (value > 0) {
			unsigned long rem = value % base;
			unsigned char tmp = (rem > 9)? (rem-10) + 0x41 : rem + 0x30;	/* 0x41 = A, 0x30 = 0*/
			brdkStrFill(pString,1,(unsigned long)&tmp,i++);
	       	value = value/base;
			cnt++;
		}
		brdkStrReverse(pString,start,--i);
		return len+cnt;
	}
	else {
		brdkStrFill(pString,1,(unsigned long)&tmp,i);
		return len+1;
	}
}
