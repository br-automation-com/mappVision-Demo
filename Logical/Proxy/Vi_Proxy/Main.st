
PROGRAM _INIT
	TcpForward_0.ServerPort := 8888;
	TcpForward_0.ConnectToPort := 8080 ; 			// Port used by Vision
	TcpForward_0.Enable := TRUE ;
	
END_PROGRAM

PROGRAM _CYCLIC
	ipSTR := '192.168.200.';
	brsitoa(visSelectedSensor, ADR(nodeSTR));
	brsstrcat(ADR(ipSTR), ADR(nodeSTR));
	TcpForward_0.ConnectToIp := ipSTR; 				//Vision camera IP ( Node 1 on powerlink network )
	TcpForward_0();
	
END_PROGRAM

PROGRAM _EXIT
	TcpForward_0.Enable := FALSE;
	TcpForward_0();
	
END_PROGRAM

