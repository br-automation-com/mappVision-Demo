#include <brdkSTR_func.h>

unsigned long brdkStrRemove(unsigned long pString, signed long start, signed long length) {
	signed long end, len=0;
	if(start < 0) {
		len = brdkStrLen(pString);
		if(length<1) {
			len = start;
			start = length*(-1);
			length = brdkStrLen(pString)-start+len+1;
		}
		else start = len+start-length+1;
	}
	else if(length<1) length = brdkStrLen(pString)-start+length; 	
	end = start+length;
	while(((char*)pString)[end]) ((char*)pString)[start++] = ((char*)pString)[end++];
	((char*)pString)[start] = 0;
	return pString+start+1;
}
