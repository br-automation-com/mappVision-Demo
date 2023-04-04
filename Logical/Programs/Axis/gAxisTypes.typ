(*-----------------------------------------------------------------------------------------------------------------------------------------*)
(*General vision structures*)

TYPE
	gAxis_status_typ : 	STRUCT 
		position : REAL;
		velocity : REAL;
		inVelocity : BOOL;
		triggerTimeDelta : DINT;
		nettime : DINT;
		powerlinkCycleTime : DINT;
	END_STRUCT;
	gAxis_typ : 	STRUCT 
		status : gAxis_status_typ;
	END_STRUCT;
END_TYPE
