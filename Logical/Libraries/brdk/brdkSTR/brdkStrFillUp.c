#include <brdkSTR_func.h>

signed long brdkStrFillUp(unsigned long pString, signed long maxLength, unsigned long pChar, signed long position) {
	signed long amount = maxLength-brdkStrLen(pString);
	if(amount > 0) {
		if(brdkStrFill(pString, amount, pChar, position) != -1) return amount;
		else return -1;
	}
	return 0;
}
