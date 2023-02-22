
#include <bur/plctypes.h>
#ifdef __cplusplus
	extern "C"
	{
#endif
	#include "brdkViBase.h"
	#include <time.h>
#ifdef __cplusplus
	};
#endif
/* TODO: Add your comment here */
plcbit brdkViBase_dateTimeToString(DATE_AND_TIME date, plcstring* format, unsigned long pStr)
{
	char tmp[30];
	struct tm *tm = gmtime((time_t*)&date);
	strftime(tmp, 30, format, tm);
	brsstrcat(pStr,(UDINT) tmp);

}
