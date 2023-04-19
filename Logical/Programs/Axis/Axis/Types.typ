
TYPE
	hmi_out_typ : 	STRUCT 
		positon : REAL;
		veleocity : REAL;
		inVelocity : BOOL;
		inPostion : BOOL;
		powerlinkCycle_us : DINT;
		triggerPosDelta : REAL;
		triggerTimeDelta : DINT; (*In us*)
	END_STRUCT;
	recipe_typ : 	STRUCT 
		acceleration : REAL := 360;
		velocity : REAL := 36000;
		axisPositionDelayCycles : REAL;
		visionPreTriggerCycles : REAL;
		axisPositionTrigger : REAL;
		axisPeriod : REAL;
	END_STRUCT;
	hmi_in_cmd_typ : 	STRUCT 
		moveAbs : BOOL;
		home : BOOL;
		power : BOOL;
		run : BOOL;
		errReset : BOOL;
	END_STRUCT;
	hmi_in_typ : 	STRUCT 
		recipe : recipe_typ;
		cmd : hmi_in_cmd_typ;
	END_STRUCT;
	hmi_typ : 	STRUCT 
		in : hmi_in_typ;
		out : hmi_out_typ;
	END_STRUCT;
	local_typ : 	STRUCT 
		mpAxisBasic_0 : MpAxisBasic;
		mpAxisBasicPar_0 : MpAxisBasicParType;
		nettimeLastCycle_us : DINT;
		powerlinkCycle_us : DINT;
		axisPositionNow : REAL;
		triggerPosDelta : REAL;
		triggerTimeDelta : DINT; (*In us*)
		mpRecipeRegVar : MpRecipeRegParSync;
	END_STRUCT;
	hw_in_typ : 	STRUCT 
		nettime : DINT;
	END_STRUCT;
	hw_typ : 	STRUCT 
		in : hw_in_typ;
	END_STRUCT;
END_TYPE
