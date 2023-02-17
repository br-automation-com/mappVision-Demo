#include <brdkSTR_func.h>

unsigned char brdkStrSubStrSearch(unsigned long pDestination, unsigned long pSource, unsigned long pStart, unsigned long pEnd, signed long startOffset, unsigned char greedy) {
	signed long posEnd, lenSource = brdkStrLen(pSource), lenStart = brdkStrLen(pStart), lenEnd, posGreedyStartOffset;
	signed long posStart = search(pSource, lenSource, pStart, lenStart);
	if(posStart > -1) {
		lenEnd = brdkStrLen(pEnd);
		posGreedyStartOffset = posStart + lenStart + startOffset;
		posEnd = search((unsigned long)&((char*)pSource)[posGreedyStartOffset], lenSource-posGreedyStartOffset, pEnd, lenEnd);
		if(posEnd > -1) {
			if(!greedy) {
				posGreedyStartOffset = posStart;
				posEnd += lenStart + startOffset + 1;
			}
			brdkStrMemCpy(pDestination, (unsigned long)&((char*)pSource)[posGreedyStartOffset],posEnd);
			((char*)pDestination)[posEnd] = 0;
			return 1;
		}
	}
	return 0;
}
