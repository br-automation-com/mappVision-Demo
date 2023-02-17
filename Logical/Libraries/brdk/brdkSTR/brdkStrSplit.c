#include <brdkSTR_func.h>

signed long brdkStrSplit(unsigned long pArray, unsigned long pString, unsigned long pDelimiter, unsigned long sizeOfArray, unsigned long sizeOfArrayString, unsigned char greedy) {
	signed long size = 0;
	if(pArray != 0 && pString != 0 && sizeOfArray != 0 && sizeOfArrayString != 0) {		/* check all pointers are set */
		if(pDelimiter == 0) pDelimiter = (unsigned long)" ";							/* use white space is delimiter pointer is 0 */
		unsigned long i = 0, pArr = pArray, aIdx = 0;
		while(((char*)pString)[i] != 0) {												/* run while we dopn't hit a 0 */
			if(((char*)pString)[i] != ((char*)pDelimiter)[0]) {							/* check for delimiter */
				((char*)pArr)[aIdx++] = ((char*)pString)[i++];
				if(aIdx >= sizeOfArrayString) return -2;								/* array string too small */
			}
			else {
				if(!greedy) ((char*)pArr)[aIdx++] = ((char*)pString)[i];				/* check is delimiter should be removed */
				i++;
				if(aIdx >= sizeOfArrayString) return -2;								/* array string too small */
				((char*)pArr)[aIdx] = 0;
				pArr += sizeOfArrayString;												/* jump to the next array element */
				aIdx = 0;
				size++;
				if(pArr > (pArray + sizeOfArray)) return -3;							/* array too small */
			}
		}
		((char*)pArr)[aIdx] = 0;
		pArr += sizeOfArrayString;														/* jump to the next array element */
		size++;
		while(pArr < (pArray + sizeOfArray)) {											/* set the rest of the array elements to '' */
			((char*)pArr)[0] = 0;
			pArr += sizeOfArrayString;		
		}
		return size;
	}
	else return -1;
	return -4;
}
