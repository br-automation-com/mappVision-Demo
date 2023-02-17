#include <brdkSTR_func.h>

unsigned char brdkStrIsAlphabet(unsigned long pString) {
	unsigned long len = 0;
	while(((char*)pString)[len]) {
		if (((char*)pString)[len] > 0x5A) {	/* is it larger that Z */
			if(((char*)pString)[len] < 0x61 || 0x7a < ((char*)pString)[len]) return 0;
		}
		else if(((char*)pString)[len] < 0x41) return 0;		/* is it smaller than A */
		len++;
	}
	return 1;
}
