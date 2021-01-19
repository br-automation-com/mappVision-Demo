
TYPE
	TcpForwardInfoTyp : 	STRUCT 
		DataSend : DINT; (*Byes recieved from connected to Server and send to the Client*)
		DataRecieved : DINT; (*Bytes recieved from the Client and send to the connected Server*)
		State : TcpForwardInfoStateEnum; (*Current connection state*)
		LastConnectedClientIp : STRING[15]; (*Last connected Client Ip adress*)
		ConnectionsActive : USINT; (*How many Client connections are currently handled*)
	END_STRUCT;
	TcpForwardInfoStateEnum : 
		(
		TcpForwardInfoState_NotRunning := 0, (*Connection is not active*)
		TcpForwardInfoState_Listening := 1, (*Listening for incomming clients*)
		TcpForwardInfoState_BuildingCon := 2, (*Setting up the connection to the server*)
		TcpForwardInfoState_ClientActive := 3 (*Active Client <-> Server communication*)
		);
END_TYPE
