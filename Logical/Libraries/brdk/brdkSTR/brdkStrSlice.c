#include <brdkSTR_func.h>

signed long brdkStrSlice(unsigned long pString, signed long start, signed long end) {
	signed long i,j, len = -1;
	if(start > -1) {
		if(start > 0) {
			len = brdkStrLen(pString);
			j=0;
			while(j<start) {
				for(i=0;i < len;i++) ((char*)pString)[i] = ((char*)pString)[i+1];	/* moves all characters one place left */
				len--;
				j++;
			}
		}
		if(end > 0) {
			end -= start; 
			((char*)pString)[end] = 0;
			len = end;	
		}
		else if(end < 0) {
			len = brdkStrLen(pString);
			if((end*(-1))<=len) {
				len += end; 
				((char*)pString)[len+1+end] = 0;
			}
		}
		return len;
	}
	else return -1;
}
