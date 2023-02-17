#include <brdkSTR_func.h>

signed long brdkStrSubStr(unsigned long pDestination, unsigned long pSource, signed long start, signed long length) {
	signed long i=0,len=0;
	char buffer[length];	/* if the destination and source is the same string we need a buffer */
	if(start < 0) {
		len = brdkStrLen(pSource);
		if(length<1) {
			len = start;
			start = length*(-1);
			length = brdkStrLen(pSource)-start+len+1;
		}
		else start = len+start-length+1;
	}
	else if(length<1) length = brdkStrLen(pSource)-start+length; 	
	for(i=0; i< length; i++) buffer[i] = ((char*)pSource)[start+i];
	for(i=0; i< length; i++) ((char*)pDestination)[i] = buffer[i];
	((char*)pDestination)[i] = 0;	
	return length;
}
