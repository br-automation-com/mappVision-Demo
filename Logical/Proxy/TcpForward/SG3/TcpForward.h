/* Automation Studio generated header file */
/* Do not edit ! */
/* TcpForward 0.00.6 */

#ifndef _TCPFORWARD_
#define _TCPFORWARD_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _TcpForward_VERSION
#define _TcpForward_VERSION 0.00.6
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Datatypes and datatypes of function blocks */
typedef enum TcpForwardInfoStateEnum
{	TcpForwardInfoState_NotRunning = 0,
	TcpForwardInfoState_Listening = 1,
	TcpForwardInfoState_BuildingCon = 2,
	TcpForwardInfoState_ClientActive = 3
} TcpForwardInfoStateEnum;

typedef struct TcpForwardInfoTyp
{	signed long DataSend;
	signed long DataRecieved;
	enum TcpForwardInfoStateEnum State;
	plcstring LastConnectedClientIp[16];
	unsigned char ConnectionsActive;
} TcpForwardInfoTyp;

typedef struct TcpForward
{
	/* VAR_INPUT (analog) */
	unsigned short ServerPort;
	plcstring ConnectToIp[25];
	unsigned short ConnectToPort;
	unsigned char TaskPriority;
	/* VAR_OUTPUT (analog) */
	struct TcpForwardInfoTyp Info;
	/* VAR (analog) */
	unsigned char InternalState;
	unsigned long InternalTaskhandle;
	unsigned long InternalMem;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Running;
	plcbit Error;
} TcpForward_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void TcpForward(struct TcpForward* inst);


#ifdef __cplusplus
};
#endif
#endif /* _TCPFORWARD_ */

