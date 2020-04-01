	// --------------------------------------------------------------------------------------------------------------------
	// Motion sample for using nettime
	// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	MpAxisBasic_0.Enable			:= TRUE;
	MpAxisBasic_0.MpLink			:= ADR(gAxis_1);
	MpAxisBasic_0.Parameters		:= ADR(MpAxisBasicPar_0);
	MpAxisBasic_0();
	// The following lines are necessary if you want to home to the encoders refpulse. If you do not want to use it: comment these lines out.
	// It is also possible to configure the refpulse at the axis settings, but unfortunately acutally it does not work.
	MpAxisBasicPar_0.Homing.Mode	:= mcHOMING_INIT;
	MC_BR_InitHome_0.Axis			:= ADR(gAxis_1);
	MC_BR_InitHome_0.Execute		:= TRUE;
	MC_BR_InitHome_0.HomingParameters.HomingMode		:= mcHOMING_DIRECT;
	MC_BR_InitHome_0.HomingParameters.Position			:= 0;
	MC_BR_InitHome_0.HomingParameters.StartVelocity		:= 30;
	MC_BR_InitHome_0.HomingParameters.HomingVelocity	:= 15;
	MC_BR_InitHome_0.HomingParameters.Acceleration		:= 50;
	MC_BR_InitHome_0.HomingParameters.ReferencePulse	:= mcSWITCH_ON;
END_PROGRAM
PROGRAM _CYCLIC
	MpAxisBasic_0.Power					:= MpAxisBasic_0.Active AND MpAxisBasic_0.Info.ReadyToPowerOn AND cmdAxisPower;
	MpAxisBasic_0.ErrorReset			:= cmdAxisErrorReset;
	MpAxisBasic_0.Home					:= MpAxisBasic_0.PowerOn AND NOT MpAxisBasic_0.IsHomed XOR cmdAxisHome;
	MpAxisBasic_0.MoveVelocity			:= MpAxisBasic_0.PowerOn AND MpAxisBasic_0.IsHomed AND cmdAxisRun;
	IF MpAxisBasic_0.PowerOn AND MpAxisBasic_0.IsHomed AND cmdAxisMoveAbs THEN
		MpAxisBasic_0.MoveAbsolute		:= TRUE;
		MpAxisBasicPar_0.Position		:= gVisionNettime.CFG.AxisPositionTrigger;
	END_IF
	cmdAxisMoveAbs					:= FALSE;
	IF AxisVelocity <> MpAxisBasicPar_0.Velocity OR AxisAcceleration <> MpAxisBasicPar_0.Acceleration THEN
		MpAxisBasicPar_0.Velocity		:= AxisVelocity;
		MpAxisBasicPar_0.Acceleration	:= AxisAcceleration;
		MpAxisBasicPar_0.Deceleration	:= AxisAcceleration;
		MpAxisBasic_0.Update			:= TRUE;
	END_IF
	MpAxisBasic_0();
	gVisionNettime.DAT.AxisInVelocity	:= MpAxisBasic_0.InVelocity;
	gVisionNettime.DAT.AxisPosition		:= MpAxisBasic_0.Position;
	gVisionNettime.DAT.AxisVelocity		:= MpAxisBasic_0.Velocity;
	IF MpAxisBasic_0.UpdateDone THEN
		MpAxisBasic_0.Update := FALSE;
	END_IF
	IF MpAxisBasic_0.InPosition THEN
		MpAxisBasic_0.MoveAbsolute		:= FALSE;
	END_IF
	
	// Function to use reference pulse of the encoder for homing
	MC_BR_InitHome_0();
	IF MC_BR_InitHome_0.Done THEN
		MC_BR_InitHome_0.Execute := FALSE;
	END_IF
END_PROGRAM