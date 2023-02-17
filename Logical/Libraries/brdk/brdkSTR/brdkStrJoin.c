#include <brdkSTR_func.h>

signed long brdkStrJoin(unsigned long pString, unsigned long pArray, unsigned long pDelimiter, unsigned long sizeOfArray, unsigned long sizeOfArrayString, unsigned long sizeOfString) {
	unsigned long sIdx = 0, pArr = pArray, aIdx = 0;
	if(pArray != 0 && pString != 0 && sizeOfArray != 0 && sizeOfArrayString != 0) {		/* check all pointers are set */
		if(pDelimiter == 0) pDelimiter = (unsigned long)" ";							/* use white space is delimiter pointer is 0 */
		while(((char*)pArr)[0] != 0) {													/* continue until we find the first empty array string */
			if(((char*)pArr)[aIdx] != 0) {
				((char*)pString)[sIdx++] = ((char*)pArr)[aIdx++];						/* copy string data */
				if(sIdx >= sizeOfString) return -2;										/* destination string too small */
			}
			else {
				pArr += sizeOfArrayString;												/* jump to the next array element */
				aIdx = 0;
				((char*)pString)[sIdx++] = ((char*)pDelimiter)[0];						/* insert delimiter */
				if(sIdx >= sizeOfString) return -2;										/* destination string too small */
				if(pArr > (pArray + sizeOfArray)) {										/* we hit the end of the array */
					break;					
				}
			}
		}
		if(sIdx == 0) return 0;															/* nothing copied */
		sIdx--;
		((char*)pString)[sIdx] = 0;														/* end the string. -e because we inserted a delimiter at the end */
		return sIdx;
	}
	else return -1;
	return -4;
}
