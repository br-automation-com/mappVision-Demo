
TYPE
	MpAxisBasicParType : 	STRUCT 
		Position : LREAL := 0.0; (*Target position for the movement [measurement units]*)
		Distance : LREAL := 0.0; (*Traverse path for the movement [measurement units]*)
		Velocity : REAL := 5; (*Maximum velocity [measurement units / s]*)
		Acceleration : REAL := 50; (*Maximum acceleration [measurement units / s²]*)
		Deceleration : REAL := 50; (*Maximum deceleration [measurement units / s²]*)
		Direction : McDirectionEnum := mcDIR_POSITIVE; (*Direction of movement *)
		Homing : MpAxisHomingType; (*Homing parameter*)
		Jog : MpAxisJogType; (*Jog parameter*)
		Stop : MpAxisStopType; (*Stop parameter*)
		LimitLoad : MpAxisLimitLoadType; (*Limit load parameter*)
	END_STRUCT;
	MpAxisHomingType : 	STRUCT 
		Mode : McHomingModeEnum; (*Selects the mode for homing.*)
		Position : LREAL; (*Absolute position after the homing signal is detected [measurement units] *)
	END_STRUCT;
	MpAxisJogType : 	STRUCT 
		Velocity : REAL := 2; (*Maximum velocity [measurement units / s]*)
		Acceleration : REAL := 25; (*Maximum acceleration [measurement units / s²]*)
		Deceleration : REAL := 50; (*Maximum deceleration [measurement units / s²]*)
		LimitPosition : MpAxisJogLimitPositionType; (*Limit positions for the jog movement *)
	END_STRUCT;
	MpAxisJogLimitPositionType : 	STRUCT 
		FirstPosition : LREAL := 0.0; (*"Lower" limit position for the jog movement [measurement units]*)
		LastPosition : LREAL := 0.0; (*"Upper" limit position for the jog movement [measurement units]*)
	END_STRUCT;
	MpAxisStopType : 	STRUCT 
		Deceleration : REAL := 50; (*Maximum deceleration [measurement units / s²]*)
	END_STRUCT;
	MpAxisLimitLoadType : 	STRUCT 
		Load : REAL := 0.0; (*Value for limiting the accelerating torque [Nm]*)
		Direction : McDirectionEnum := mcDIR_CURRENT; (*Direction of movement *)
	END_STRUCT;
	MpAxisBasicInfoType : 	STRUCT 
		CommunicationReady : BOOL; (*TRUE if MpAxisBasic is ready to communicate*)
		ReadyToPowerOn : BOOL; (*TRUE if MpAxisBasic is ready for operation*)
		Simulation : BOOL; (*TRUE if axis is operated in simulation mode*)
		Jogging : BOOL; (*Performing movement*)
		JogLimitReached : BOOL; (*Indicates that the axis has reached one of the two position limits *)
		LimitLoadActive : BOOL; (*Limit active*)
		PLCopenState : McAxisPLCopenStateEnum; (*PLCopen state*)
		DigitalInputsStatus : McDigitalInputStatusType; (*Status of the digital inputs*)
		Diag : MpAxisDiagExtType; (*Diagnostic structure for the status ID*)
		LibraryInfo : McLibraryInfoType; (*Library info about the specific axis implementation*)
		CommunicationState : McCommunicationStateEnum; (*Communication state*)
	END_STRUCT;
	MpAxisDiagExtType : 	STRUCT 
		StatusID : MpAxisStatusIDType; (*StatusID information*)
		Internal : MpAxisInternalType; (*Internal data*)
		ExecutingCommand : MpAxisExecutingCmdEnum; (*Command information*)
	END_STRUCT;
	MpAxisInternalType : 	STRUCT 
		ID : DINT; (*ID*)
		Severity : MpComSeveritiesEnum; (*Severity*)
		Facility : MpComFacilitiesEnum; (*Facility*)
		Code : UINT; (*UINT*)
	END_STRUCT;
	MpAxisStatusIDType : 	STRUCT 
		ID : MpAxisErrorEnum; (*Error*)
		Severity : MpComSeveritiesEnum; (*Severity*)
		Code : UINT; (*Code*)
	END_STRUCT;
	MpAxisExecutingCmdEnum : 
		(
		mcAXIS_CMD_IDLE := 0,
		mcAXIS_CMD_HOMING,
		mcAXIS_CMD_STOP,
		mcAXIS_CMD_HALT,
		mcAXIS_CMD_MOVE_VELOCITY,
		mcAXIS_CMD_MOVE_ABSOLUTE,
		mcAXIS_CMD_MOVE_ADDITIVE,
		mcAXIS_CMD_JOG_POSITIVE,
		mcAXIS_CMD_JOG_NEGATIVE,
		mcAXIS_CMD_REMOTE_CONTROL
		);
END_TYPE
