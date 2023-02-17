#include <brdkSTR_func.h>

signed long brdkStrReverse(unsigned long pString, signed long startPosition, signed long endPosition) {
	signed long start = -1, end = -1, len = brdkStrLen(pString), cnt = 0;
    unsigned char tmp;
	/* make sure start position is valid */
	if(startPosition > -1 && startPosition < len) start = startPosition;
	else return -1;
	/* make sure end position is valid */
	if(endPosition > -1 && endPosition < len && endPosition > startPosition) end = endPosition;
	else if(endPosition < 0) end = len + endPosition;
	else return -1;
	while (start < end) {
        tmp = ((char*)pString)[start];   
        ((char*)pString)[start++] = ((char*)pString)[end];
        ((char*)pString)[end--] = tmp;
		cnt++;
    }   
	return cnt;
}
