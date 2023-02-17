#include <brdkSTR_func.h>

signed long brdkStrWord(unsigned long pDestination, unsigned long pSource, unsigned long pDelimiter, signed long number, unsigned long sizeOfString) {
	unsigned long sIdx = 0, dIdx = 0;
	signed long cnt = 1;
	if(pDestination != 0 && pSource != 0 && number != 0) {
		if(pDelimiter == 0) pDelimiter = (unsigned long)" ";			/* use white space is delimiter pointer is 0 */
		while(((char*)pSource)[sIdx] != 0) {
			if(((char*)pSource)[sIdx] != ((char*)pDelimiter)[0]) {
				((char*)pDestination)[dIdx++] = ((char*)pSource)[sIdx];
			}
			else {
				if(number > 0) {
					if(cnt == number) break;
					else {
						dIdx = 0;
						cnt++;
					}
				}
				else {
					cnt = number;
					dIdx = 0;	
				}
			}	
			sIdx++;
			if(dIdx > sizeOfString) return -2;								/* destination string too small */
		}
		if(number > cnt) return -3;
		((char*)pDestination)[dIdx] = 0;
		return dIdx;
	}
	else return -1;
	return -4;
}
