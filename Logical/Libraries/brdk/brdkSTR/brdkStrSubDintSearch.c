#include <brdkSTR_func.h>

signed long brdkStrSubDintSearch(unsigned long pSource, unsigned long pStart, unsigned long pEnd, signed long startOffset, unsigned char base) {
	signed long posEnd, lenSource = brdkStrLen(pSource), lenStart = brdkStrLen(pStart), lenEnd, posGreedyStartOffset;
	signed long posStart = search(pSource, lenSource, pStart, lenStart);
	if(posStart > -1) {
		lenEnd = brdkStrLen(pEnd);
		posGreedyStartOffset = posStart + lenStart + startOffset;
		posEnd = search((unsigned long)&((char*)pSource)[posGreedyStartOffset], lenSource-posGreedyStartOffset, pEnd, lenEnd);
		if(posEnd > -1) {
			/* check if string starts with a minus sign */
			if(((char*)pSource)[posGreedyStartOffset] == 0x2d) return -aToUdint((unsigned long)&((char*)pSource)[posGreedyStartOffset+1],posEnd,base);
			else return aToUdint((unsigned long)&((char*)pSource)[posGreedyStartOffset],posEnd,base);
		}
	}
	return -1;
}
