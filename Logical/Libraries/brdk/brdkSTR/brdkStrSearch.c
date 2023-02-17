#include <brdkSTR_func.h>

signed long brdkStrSearch(unsigned long pString, unsigned long pSearchString) {
	signed long lenString = brdkStrLen(pString), lenSearch = brdkStrLen(pSearchString);
	return search(pString, lenString, pSearchString, lenSearch);
}
