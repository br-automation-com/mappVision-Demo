/* Automation Studio generated header file */
/* Do not edit ! */
/* brdkWS 1.00.0 */

#ifndef _BRDKWS_
#define _BRDKWS_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _brdkWS_VERSION
#define _brdkWS_VERSION 1.00.0
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "AsHttp.h"
		#include "AsTCP.h"
#endif
#ifdef _SG4
		#include "AsHttp.h"
		#include "AsTCP.h"
#endif
#ifdef _SGC
		#include "AsHttp.h"
		#include "AsTCP.h"
#endif


/* Constants */
#ifdef _REPLACE_CONST
 #define BRDKWS_MAX_NUM_CLIENTS 20U
#else
 _GLOBAL_CONST unsigned long BRDKWS_MAX_NUM_CLIENTS;
#endif




/* Datatypes and datatypes of function blocks */
typedef enum BRDKWS_WSSER_STATES
{	BRDKWS_WSSER_UNINIT,
	BRDKWS_WSSER_OPENING,
	BRDKWS_WSSER_LISTINING,
	BRDKWS_WSSER_ACCEPT_RECV,
	BRDKWS_WSSER_ACCEPT_SEND,
	BRDKWS_WSSER_DENY,
	BRDKWS_WSSER_CLOSING
} BRDKWS_WSSER_STATES;

typedef enum BRDKWS_WSCH_STATES
{	BRDKWS_WSCH_INIT,
	BRDKWS_WSCH_RECV,
	BRDKWS_WSCH_SEND,
	BRDKWS_WSCH_SENDING,
	BRDKWS_WSCH_CLOSE,
	BRDKWS_WSCH_CLOSED,
	BRDKWS_WSCH_CLEANUP
} BRDKWS_WSCH_STATES;

typedef struct brdkWS_ChannelInternal_typ
{	struct TcpRecv receiver;
	struct TcpSend sender;
	struct TcpClose closer;
	unsigned long nextFrameOffset;
	unsigned char* recvBuffer;
	unsigned char* sendBuffer;
	enum BRDKWS_WSCH_STATES state;
	plcbit closeRequest;
	unsigned char closeCount;
} brdkWS_ChannelInternal_typ;

typedef struct brdkWS_ServerInternal_typ
{	struct TcpOpen tcpOpen;
	struct TcpServer tcpServer;
	struct TcpIoctl tcpIoctl;
	struct TcpRecv tcpRecieve;
	struct TcpSend tcpSend;
	struct TcpClose tcpClose;
	unsigned char* receiveBuffer;
	unsigned char* sendBuffer;
	enum BRDKWS_WSSER_STATES state;
	unsigned char clientNum;
	unsigned char sendMsgState;
	unsigned char clientCount;
	unsigned long server;
	plcstring clientIp[25];
	unsigned char closeCount;
	unsigned char sendMsgClient;
	plcbit sending;
	unsigned char nextMsgState;
	unsigned long tmppMsg;
	unsigned long tmpMsgLength;
	unsigned char maxNumberOfClients;
	unsigned long newClientId;
	plcbit newClient;
	unsigned char* recvBuffer;
} brdkWS_ServerInternal_typ;

typedef struct brdkWS_Server
{
	/* VAR_INPUT (analog) */
	unsigned short port;
	unsigned long pIfAddr;
	unsigned long bufferSize;
	/* VAR_OUTPUT (analog) */
	plcstring clientIps[21][25];
	unsigned long clients[21];
	unsigned short statusMsg;
	unsigned short status;
	unsigned short numberOfConnectedClients;
	/* VAR (analog) */
	struct brdkWS_ServerInternal_typ internal;
	/* VAR_INPUT (digital) */
	plcbit enable;
} brdkWS_Server_typ;

typedef struct brdkWS_Channel
{
	/* VAR_INPUT (analog) */
	unsigned long ident;
	unsigned long bufferSize;
	unsigned long pSendData;
	unsigned long sendLen;
	unsigned long pRecvData;
	unsigned long parentServer;
	/* VAR_OUTPUT (analog) */
	unsigned short rcvLen;
	unsigned char rcvFrameType;
	unsigned short recvStatus;
	unsigned short sendStatus;
	/* VAR (analog) */
	struct brdkWS_ChannelInternal_typ internal;
	/* VAR_INPUT (digital) */
	plcbit enable;
	plcbit doSend;
} brdkWS_Channel_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void brdkWS_Server(struct brdkWS_Server* inst);
_BUR_PUBLIC void brdkWS_Channel(struct brdkWS_Channel* inst);
_BUR_PUBLIC plcbit brdkWS_MakeFrame(unsigned long pData, unsigned long dataLength, unsigned long pOutframe, unsigned long* outLenght, plcbit text);
_BUR_PUBLIC plcbit brdkWs_clinetInitFrame(unsigned long pOutframe, unsigned long pKey);
_BUR_PUBLIC plcbit brdkWS_ClientMakeFrame(unsigned long pData, unsigned long dataLength, unsigned long pOutframe, unsigned long* outLenght, plcbit text);


#ifdef __cplusplus
};
#endif
#endif /* _BRDKWS_ */

