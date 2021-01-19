
{REDUND_ERROR} FUNCTION_BLOCK TcpForward (*TCP Forward : Forwards a socket to other Host and port*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL; (*Enable this functionality*)
		ServerPort : UINT; (*Port to listen to setup the connection to the server ip*)
		ConnectToIp : STRING[24] := '192.168.0.1'; (*Server ip to connect to*)
		ConnectToPort : UINT := 80; (*Server port to connect to*)
		TaskPriority : USINT := 100; (*(1.. lowest, 255.. highest) , above x will influence the cyclic task behavior*)
	END_VAR
	VAR_OUTPUT
		Running : BOOL; (*Listen port is active*)
		Error : BOOL; (*Error active ( See logger for details )*)
	END_VAR
	VAR
		InternalState : USINT;
		InternalTaskhandle : UDINT;
		InternalMem : UDINT;
	END_VAR
	VAR_OUTPUT
		Info : TcpForwardInfoTyp; (*Connection info*)
	END_VAR
END_FUNCTION_BLOCK
