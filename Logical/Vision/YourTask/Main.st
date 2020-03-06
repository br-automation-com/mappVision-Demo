
PROGRAM _INIT
	// Motion function block initialization
	MpAxisBasic_0.Enable := TRUE;
	MpAxisBasic_0.MpLink := ADR(gAxis_1);
	MpAxisBasic_0.Parameters := ADR(MpAxisBasicPar_0);
	MpAxisBasic_0(); 	
END_PROGRAM

PROGRAM _CYCLIC
	// -----------------------------------------------------------------------------------------------------------
	// Vision sensor configuration
	// -----------------------------------------------------------------------------------------------------------	
	// Configuration for blob
	gVisionSensor[1].CFG.VisionFunction := enumBlob;
	gVisionSensor[1].CFG.PowerlinkNode := 1;
	gVisionSensor[1].CFG.DataStructure := ADR(gBlob);
	// Configuration for meaurement
	gVisionSensor[2].CFG.VisionFunction := enumMeasurement;
	gVisionSensor[2].CFG.PowerlinkNode := 2;
	gVisionSensor[2].CFG.DataStructure := ADR(gMT);
	// Configuration for code reader
	gVisionSensor[3].CFG.VisionFunction := enumCoderReader;
	gVisionSensor[3].CFG.PowerlinkNode := 3;
	gVisionSensor[3].CFG.DataStructure := ADR(gCodeReader);
	// Configuration for match
	gVisionSensor[4].CFG.VisionFunction := enumMatch;
	gVisionSensor[4].CFG.PowerlinkNode := 4;
	gVisionSensor[4].CFG.DataStructure := ADR(gMatch);
	// Configuration for OCR
	gVisionSensor[5].CFG.VisionFunction := enumOCR;
	gVisionSensor[5].CFG.PowerlinkNode := 5;
	gVisionSensor[5].CFG.DataStructure := ADR(gOCR);

	// -----------------------------------------------------------------------------------------------------------
	// Lights configuration
	// -----------------------------------------------------------------------------------------------------------	
	// Configuration for barlights
	gVisionLight[1].CFG.LightType := enumBarlight;
	gVisionLight[1].CFG.PowerlinkNode := 10;
	gVisionLight[2].CFG.LightType := enumBarlight;
	gVisionLight[2].CFG.PowerlinkNode := 11;

	// --------------------------------------------------------------------------------------------------------------------
	// Motion sample for using nettime
	// --------------------------------------------------------------------------------------------------------------------
	CASE MotionStep OF
		// --------------------------------------------------------------------------------------------------------------------
		// Initialization MotionStep -> waiting for the servo drive
		// --------------------------------------------------------------------------------------------------------------------
		stINIT:
			// --------------------------------------------------------------------------------------------------------------------
			// Axis is ready to be powered on and the function block is active
			IF (MpAxisBasic_0.Info.ReadyToPowerOn = TRUE) AND (MpAxisBasic_0.Active) THEN
				// Go to the powering state
				MotionStep := stPOWER;
			END_IF		
			// --------------------------------------------------------------------------------------------------------------------
			// Axis powering MotionStep
			// --------------------------------------------------------------------------------------------------------------------
		stPOWER:
			// Axis not yet powered? -> Set the power command
			IF MpAxisBasic_0.PowerOn = FALSE THEN
				MpAxisBasic_0.Power := TRUE;
				// Axis already powered? -> Go to the homing state
			ELSIF MpAxisBasic_0.PowerOn = TRUE THEN
				MotionStep := stHOME;
			END_IF
			// --------------------------------------------------------------------------------------------------------------------		
			// Axis homing MotionStep
			// --------------------------------------------------------------------------------------------------------------------
		stHOME:
			// Axis not yet homed? -> Set the home command
			IF MpAxisBasic_0.IsHomed = FALSE THEN
				MpAxisBasic_0.Home := TRUE;
				// Axis already homed? -> Reset the homing command and go to the "Ready" state
			ELSIF MpAxisBasic_0.IsHomed = TRUE THEN
				MpAxisBasic_0.Home := FALSE;
				MotionStep := stREADY;
			END_IF		
			// --------------------------------------------------------------------------------------------------------------------
			// Ready for the process
			// --------------------------------------------------------------------------------------------------------------------
		stREADY:
			// Waiting for the "Run" command
			IF cmdAxisRun = TRUE THEN
				// Motion related
				MpAxisBasicPar_0.Velocity := Velocity;
				MpAxisBasicPar_0.Acceleration := Acceleration;
				MpAxisBasicPar_0.Deceleration := Acceleration;
				MotionStep := stRUN;
			END_IF
			// --------------------------------------------------------------------------------------------------------------------		
			// Run the process -> move the axis, calculate the nettimes and acquire images
			// --------------------------------------------------------------------------------------------------------------------
		stRUN:
			// Move the axis
			MpAxisBasic_0.MoveVelocity := TRUE;
			gVisionNettime.DAT.AxisInVelocity := MpAxisBasic_0.InVelocity;
			gVisionNettime.DAT.AxisPosition := MpAxisBasic_0.Position;
			gVisionNettime.DAT.AxisVelocity := MpAxisBasic_0.Velocity;

			// --------------------------------------------------------------------------------------------------------------------
			// "Run" command has been reset? -> Stop the process
			IF cmdAxisRun = FALSE THEN
				MpAxisBasic_0.MoveVelocity := FALSE;
				IF MpAxisBasic_0.MoveActive = FALSE THEN
					MotionStep := stREADY;
				END_IF
			END_IF
	END_CASE;
	
	// Motion function block call
	MpAxisBasic_0();
END_PROGRAM

PROGRAM _EXIT	
	MpAxisBasic_0.Enable := FALSE;
	MpAxisBasic_0();
END_PROGRAM

