
FUNCTION_BLOCK MpAxisBasic
	VAR_INPUT
		MpLink : REFERENCE TO McAxisType; (*The axis reference creates a link between the function block and an axis.*) (* *) (*#PAR#;*)
		Enable : BOOL; (*The function block is active as long as this input is set.*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Used to reset errors*) (* *) (*#PAR#;*)
		Parameters : REFERENCE TO MpAxisBasicParType; (*Parameters of the function block*) (* *) (*#PAR#;*)
		Update : BOOL; (*Updates the parameters*) (* *) (*#PAR#;*)
		Power : BOOL; (*Level-sensitive command for turning an axis on/off. In the event of an error, a new rising edge is required to restart the axis.*) (* *) (*#CMD#;*)
		Home : BOOL; (*Command for homing the axis*) (* *) (*#CMD#;*)
		MoveVelocity : BOOL; (*Starts a constant movement with a defined velocity*) (* *) (*#CMD#;*)
		MoveAbsolute : BOOL; (*Starts an absolute movement*) (* *) (*#CMD#;*)
		MoveAdditive : BOOL; (*Starts a relative movement*) (* *) (*#CMD#;*)
		Stop : BOOL; (*Stops the axis*) (* *) (*#CMD#;*)
		JogPositive : BOOL; (*Movement in the positive direction. Stops automatically at the software limit position.*) (* *) (*#CMD#OPT#;*)
		JogNegative : BOOL; (*Movement in the negative direction. Stops automatically at the software limit position.*) (* *) (*#CMD#OPT#;*)
		LimitLoad : BOOL; (*Enables torque limitation*) (* *) (*#CMD#OPT#;*)
		ReleaseBrake : BOOL; (*Releases the brake (but only when the motor is switched off)*) (* *) (*#CMD#OPT#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Error occurred during operation*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block*) (* *) (*#PAR#;*)
		UpdateDone : BOOL; (*Parameter update completed*) (* *) (*#PAR#;*)
		Position : LREAL; (*Current position of the axis [measurement units]*) (* *) (*#CYC#;*)
		Velocity : REAL; (*Current speed of the axis [measurement units/s]*) (* *) (*#CYC#;*)
		CommandBusy : BOOL; (*Function block currently executing a command*) (* *) (*#CMD#OPT#;*)
		CommandAborted : BOOL; (*Function block interrupted while executing a command*) (* *) (*#CMD#OPT#;*)
		PowerOn : BOOL; (*Axis switched on*) (* *) (*#CMD#;*)
		IsHomed : BOOL; (*Axis referenced*) (* *) (*#CMD#;*)
		InVelocity : BOOL; (*Axis running with defined velocity*) (* *) (*#CMD#;*)
		InPosition : BOOL; (*Axis reached the desired position*) (* *) (*#CMD#;*)
		MoveActive : BOOL; (*Movement active*) (* *) (*#CMD#;*)
		MoveDone : BOOL; (*Movement complete*) (* *) (*#CMD#;*)
		Stopped : BOOL; (*Axis stopped*) (* *) (*#CMD#;*)
		LimitLoadReady : BOOL; (*Torque limitation ready*) (* *) (*#CMD#OPT#;*)
		BrakeReleased : BOOL; (*Brake released*) (* *) (*#CMD#OPT#;*)
		Info : MpAxisBasicInfoType; (*Additional information*) (* *) (*#CMD#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpComInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK
