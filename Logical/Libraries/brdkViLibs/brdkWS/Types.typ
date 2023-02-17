
TYPE
	brdkWS_ChannelInternal_typ : 	STRUCT 
		receiver : TcpRecv;
		sender : TcpSend;
		closer : TcpClose;
		nextFrameOffset : UDINT;
		recvBuffer : REFERENCE TO USINT;
		sendBuffer : REFERENCE TO USINT;
		state : BRDKWS_WSCH_STATES;
		closeRequest : BOOL;
		closeCount : USINT;
	END_STRUCT;
	brdkWS_ServerInternal_typ : 	STRUCT 
		tcpOpen : TcpOpen;
		tcpServer : TcpServer;
		tcpIoctl : TcpIoctl;
		tcpRecieve : TcpRecv;
		tcpSend : TcpSend;
		tcpClose : TcpClose;
		receiveBuffer : REFERENCE TO USINT;
		sendBuffer : REFERENCE TO USINT;
		state : BRDKWS_WSSER_STATES;
		clientNum : USINT := 0;
		sendMsgState : USINT := 0;
		clientCount : USINT := 0;
		server : UDINT := 0;
		clientIp : STRING[24] := '';
		closeCount : USINT := 0;
		sendMsgClient : USINT := 0;
		sending : BOOL := FALSE;
		nextMsgState : USINT := 0;
		tmppMsg : UDINT := 0;
		tmpMsgLength : UDINT := 0;
		maxNumberOfClients : USINT;
		newClientId : UDINT;
		newClient : BOOL;
		recvBuffer : REFERENCE TO USINT;
	END_STRUCT;
	BRDKWS_WSSER_STATES : 
		(
		BRDKWS_WSSER_UNINIT,
		BRDKWS_WSSER_OPENING,
		BRDKWS_WSSER_LISTINING,
		BRDKWS_WSSER_ACCEPT_RECV,
		BRDKWS_WSSER_ACCEPT_SEND,
		BRDKWS_WSSER_DENY,
		BRDKWS_WSSER_CLOSING
		);
	BRDKWS_WSCH_STATES : 
		(
		BRDKWS_WSCH_INIT,
		BRDKWS_WSCH_RECV,
		BRDKWS_WSCH_SEND,
		BRDKWS_WSCH_SENDING,
		BRDKWS_WSCH_CLOSE,
		BRDKWS_WSCH_CLOSED,
		BRDKWS_WSCH_CLEANUP
		);
END_TYPE
