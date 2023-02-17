#include <brdkSTR_func.h>

signed long brdkStrInsertAtPos(unsigned long pString, unsigned long pInsert, signed long position) {
	signed long i,j, len = brdkStrLen(pString), lenIns = brdkStrLen(pInsert), tmpPos;
	if(lenIns > 0) {
		if(len==0 && (position==0 || position==-1)){
			i=0;
			while(((char*)pInsert)[i]) {
				((char*)pString)[i] = ((char*)pInsert)[i];
				i++;
			}
			((char*)pString)[i] = 0;
			len = i;
		}
		else if(position <= len) {
			i = len+lenIns;
			j = len;
			tmpPos = position >= 0 ? position : len + 1 + position;
			if(tmpPos > -1) {
				while(j>=tmpPos) ((char*)pString)[i--] = ((char*)pString)[j--];
				j=lenIns-1;
				while(i>=tmpPos) ((char*)pString)[i--] = ((char*)pInsert)[j--];
				len+=lenIns;
			}
			else len = -1;
		}
	}
	return len;
}
