/* Automation Studio generated header file */
/* Do not edit ! */
/* brdkViMapp 1.01.1 */

#ifndef _BRDKVIMAPP_
#define _BRDKVIMAPP_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _brdkViMapp_VERSION
#define _brdkViMapp_VERSION 1.01.1
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Datatypes and datatypes of function blocks */
typedef enum BRDKVIMAPP_TRIGGERMODE_ENM
{	BRDKVIMAPP_TRIGGERMODE_DELAY = 0,
	BRDKVIMAPP_TRIGGERMODE_NETTIME = 1
} BRDKVIMAPP_TRIGGERMODE_ENM;

typedef enum BRDKVIMAPP_COMPILEROPTION_ENM
{	BRDKVIMAPP_COMPILER_INTERPRETED = 0,
	BRDKVIMAPP_COMPILER_STARTUP_COMP = 1
} BRDKVIMAPP_COMPILEROPTION_ENM;

typedef struct brdkViMapp_VF_typ
{	plcstring widgetModels[150001];
	plcstring ROI[150001];
	plcstring params[1001];
} brdkViMapp_VF_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC plcbit brdkViMapp_getVfDataSet(plcstring* VaName, unsigned char VFidx, unsigned long pParam, unsigned long pROI, unsigned long pWidgetModels, unsigned long pModels, unsigned long maxLen, unsigned long pError);
_BUR_PUBLIC plcbit brdkViMapp_setVfDataSet(plcstring* VaName, unsigned char VFidx, unsigned long pParam, unsigned long pROI, unsigned long pWidgetModels, unsigned long pModels, unsigned long pError);
_BUR_PUBLIC plcbit brdkViMapp_setCompilerOption(plcstring* VaName, enum BRDKVIMAPP_COMPILEROPTION_ENM option, unsigned long pError);
_BUR_PUBLIC plcbit brdkViMapp_getCompilerOption(plcstring* VaName, enum BRDKVIMAPP_COMPILEROPTION_ENM* option, unsigned long pError);
_BUR_PUBLIC plcbit brdkViMapp_setTriggerMode(plcstring* VaName, enum BRDKVIMAPP_TRIGGERMODE_ENM mode, unsigned long pError);
_BUR_PUBLIC plcbit brdkViMapp_getTriggerMode(plcstring* VaName, enum BRDKVIMAPP_TRIGGERMODE_ENM* mode, unsigned long pError);
_BUR_PUBLIC plcbit brdkViMapp_setFlipImgHorizontal(plcstring* VaName, plcbit flip, unsigned long pError);
_BUR_PUBLIC plcbit brdkViMapp_getFlipImgHorizontal(plcstring* VaName, plcbit* flip, unsigned long pError);
_BUR_PUBLIC plcbit brdkViMapp_setFlipImgVertical(plcstring* VaName, plcbit flip, unsigned long pError);
_BUR_PUBLIC plcbit brdkViMapp_getFlipImgVertical(plcstring* VaName, plcbit* flip, unsigned long pError);


#ifdef __cplusplus
};
#endif
#endif /* _BRDKVIMAPP_ */

