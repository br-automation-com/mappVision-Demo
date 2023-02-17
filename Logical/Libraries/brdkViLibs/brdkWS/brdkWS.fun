
FUNCTION_BLOCK brdkWS_Server (*Opens and starts listening and accepting incoming valid websocket connections *) (*$GROUP=User*)
	VAR_INPUT
		enable : BOOL := FALSE; (*Enable function block bit*)
		port : UINT := 18000; (*Port to listen to*)
		pIfAddr : UDINT; (*Pointer to the interface address to bind to*)
		bufferSize : UDINT := 10000;
	END_VAR
	VAR_OUTPUT
		clientIps : ARRAY[0..BRDKWS_MAX_NUM_CLIENTS] OF STRING[24]; (*Client id used by sockets*)
		clients : ARRAY[0..BRDKWS_MAX_NUM_CLIENTS] OF UDINT; (*Client id used by sockets*)
		statusMsg : UINT; (*Status of operation ERR_OK etc*)
		status : UINT; (*Status of operation ERR_OK etc*)
		numberOfConnectedClients : UINT;
	END_VAR
	VAR
		internal : brdkWS_ServerInternal_typ;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION brdkWS_MakeFrame : BOOL (*Create and append a websocket frame to the send buffer*)
	VAR_INPUT
		pData : UDINT; (*Pointer to the data that should be included in the frame*)
		dataLength : UDINT; (*Lenght of the data that should be included in the frame*)
		pOutframe : UDINT; (*Pointer to send buffer*)
		outLenght : REFERENCE TO UDINT; (*Pointer to actual lenght of the send buffer, will be incremented with dataLength*)
		text : BOOL; (*Frame type can be text (TRUE) or binary (FALSE)*)
	END_VAR
END_FUNCTION

FUNCTION_BLOCK brdkWS_Channel (* Bidirectional Websocket channel with both send and receive implemented*)
	VAR_INPUT
		enable : BOOL; (*Enable function block*)
		ident : UDINT; (*Client tcp socket identity*)
		bufferSize : UDINT := 10000; (*Buffer size used for internal receive and send messages*)
		doSend : BOOL; (*Trigger a send (is automatically reset to FALSE)*)
		pSendData : UDINT; (*Pointer to data area to send*)
		sendLen : UDINT; (*Lenght of data area to send*)
		pRecvData : UDINT; (*Pointer to data area where received data is stored*)
		parentServer : UDINT; (*Pointer to brdkWS_WsServer*)
	END_VAR
	VAR_OUTPUT
		rcvLen : UINT; (*Length of where data is stored when received*)
		rcvFrameType : USINT; (*Websocket frame type, can only be WS_FRAME_TEXT and WS_FRAME_BINARY*)
		recvStatus : UINT; (*Status word where error codes for send status is stored*)
		sendStatus : UINT; (*Status word where error codes for receive status of fb is stored*)
	END_VAR
	VAR
		internal : brdkWS_ChannelInternal_typ;
	END_VAR
END_FUNCTION_BLOCK
