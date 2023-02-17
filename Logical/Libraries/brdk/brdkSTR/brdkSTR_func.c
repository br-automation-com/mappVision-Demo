#include <brdkSTR_func.h>

/* search for a string in a string */
signed long search(signed long pString, signed long lenString, signed long pSearchString, signed long lenSearch) {
	signed long pos=-1, i=0,j=0;
	if(lenString>lenSearch) {
		for(i=0; i <= lenString-lenSearch; i++) {
			j=0;
			if(((char*)pString)[i] == ((char*)pSearchString)[j]) {	
				while(((char*)pString)[i+j] == ((char*)pSearchString)[j]) {
					j++;
					if(j==lenSearch) {
						pos = i;
						i=lenString-lenSearch+1;
						break;
					}
				}
			}
		}
	}
	return pos;
}

/* convert a string to an UDINT */
unsigned long aToUdint(unsigned long pString, signed long len, unsigned char base) {
	unsigned long value = 0,i;
	if(len > 0) {
		for(i=0; i <len; i++) {
			switch(base) {

				case 0: case 10:
					if(((char*)pString)[i] >= 0x30 && ((char*)pString)[i] <= 0x39) value = (value * 10) + (((char*)pString)[i]-0x30);			/* 0x30 = 0, 0x39 = 9 */
					else {
						value = 0;
						i = len;	
					}
					break;

				case 2:
					if(((char*)pString)[i] >= 0x30 && ((char*)pString)[i] <= 0x31) value += (((char*)pString)[i]-0x30)*(1<<(len-1-i));			/* 0x30 = 0, 0x31 = 1 */		
					else {
						value = 0;
						i = len;	
					}
					break;

				case 16:
					if(((char*)pString)[i] >= 0x30 && ((char*)pString)[i] <= 0x39) 	value += (((char*)pString)[i]-0x30)*(1<<(4*(len-1-i)));		/* 0x30 = 0, 0x39 = 9 */
					else if(((char*)pString)[i] >= 0x41 && ((char*)pString)[i] <= 0x46) value += (((char*)pString)[i]-0x37)*(1<<(4*(len-1-i)));	/* 0x41 = A, 0x46 = F */
					else if(((char*)pString)[i] >= 0x61 && ((char*)pString)[i] <= 0x66)value += (((char*)pString)[i]-0x57)*(1<<(4*(len-1-i)));	/* 0x61 = a, 0x66 = f */
					else {
						value = 0;
						i = len;	
					}
					break;

				default:
					value = 0;
					i = len;
					break;

			}
		}	
	}
	return value;
}



