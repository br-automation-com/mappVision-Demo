// --------------------------------------------------------------------------------------------------------------------
// General vision task. This is a support task for the mappVision. The following functions are implemneted
// - Translate some values in text messages
// - Reset camera trigger when inspection is finsihed
// - Load vision application
// - Save diagnostic data
// Version 2.x (Check revision history for details)
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT

END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC
	// -----------------------------------------------------------------------------------------------------------
	// Translate camera status in readable text
	// -----------------------------------------------------------------------------------------------------------
	IF gVisionSensor[idSensor].DAT.Status = 0 THEN // Display only a single 0
		gVisionSensor[idSensor].DAT.StatusText := 'Ready';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000001 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Image acquisition';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000002 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Waiting trigger';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000010 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Searching settings';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000080 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Setting focus';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000090 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Searching settings';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000800 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Cam CPU not ready';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00001000 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Cam sensor not ready';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#01000000 OR gVisionSensor[idSensor].DAT.Status = 16#02000000 OR gVisionSensor[idSensor].DAT.Status = 16#03000000 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'OS check/update';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#80000000 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Vision cockpit active';
	ELSE 
		// Display the status in hex format 0x02000800
		gVisionSensor[idSensor].DAT.StatusText := '';
		FOR i := 0 TO 28 BY 4 DO
			gVisionSensor[idSensor].DAT.StatusText := CONCAT(MID(HexTab, 1, LIMIT(1, UDINT_TO_INT((SHR(gVisionSensor[idSensor].DAT.Status, i) AND 16#0000000F) + 1), 16)), gVisionSensor[idSensor].DAT.StatusText);
		END_FOR
		gVisionSensor[idSensor].DAT.StatusText := CONCAT('0x', gVisionSensor[idSensor].DAT.StatusText);
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Check if vision cockpit is open
	// -----------------------------------------------------------------------------------------------------------
	gVisionSensor[idSensor].DAT.CockpitIsActive := (gVisionSensor[idSensor].DAT.Status AND 16#8000_0000) > 0;
		
	// -----------------------------------------------------------------------------------------------------------
	// Auto setup handling
	// -----------------------------------------------------------------------------------------------------------
	IF(gVisionSensor[idSensor].CMD.AutoSetupStartStop AND gVisionSensor[idSensor].DAT.Status <> 0) THEN
		AutoSetupRunning[idSensor] := TRUE;
	ELSIF NOT gVisionSensor[idSensor].CMD.AutoSetupStartStop THEN
		AutoSetupRunning[idSensor] := FALSE;
	END_IF
	IF(gVisionSensor[idSensor].CMD.AutoSetupStartStop AND gVisionSensor[idSensor].DAT.Status = 0 AND AutoSetupRunning[idSensor]) THEN // Setup successfully finished
		gVisionSensor[idSensor].DAT.Gain					:= gVisionSensor[idSensor].DAT.AutoSetupGain;
		gVisionSensor[idSensor].DAT.Focus				:= gVisionSensor[idSensor].DAT.AutoSetupFocus;
		gVisionSensor[idSensor].DAT.Exposure				:= gVisionSensor[idSensor].DAT.AutoSetupExposure;
		gVisionSensor[idSensor].CMD.AutoSetupStartStop	:= FALSE;
		AutoSetupRunning[idSensor]						:= FALSE;
		TON_DelayAfterAutoSetup[idSensor].IN					:= TRUE;
	END_IF
	TON_DelayAfterAutoSetup[idSensor](PT := T#50ms);
	IF TON_DelayAfterAutoSetup[idSensor].Q THEN // After the camera tells it is ready, we need to wait still at least ca 20ms, otherwise it does not accept the trigger
		TON_DelayAfterAutoSetup[idSensor].IN := FALSE;
		IF gVisionSensor[idSensor].HW.Ready AND NOT gVisionSensor[idSensor].DAT.ImageProcessingActive THEN
			IF NETTIME_ENABLE THEN
				gVisionSensor[idSensor].DAT.NettimeDelay := NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
			END_IF
			gVisionSensor[idSensor].CMD.ImageTrigger	:= TRUE;
			gVisionSensor[idSensor].DAT.Active			:= TRUE;
		END_IF
	END_IF
		
	// -----------------------------------------------------------------------------------------------------------
	// Reset image trigger, reload web page and store image when process is finished
	// -----------------------------------------------------------------------------------------------------------
	IF ((gVisionSensor[idSensor].DAT.AcquisitionCompletedCnt <> AcquisitionCompletedCntOld[idSensor] OR gVisionSensor[idSensor].DAT.AcquisitionFailedCnt <> AcquisitionFailedCntOld[idSensor]) AND NOT gVisionSensor[idSensor].DAT.ImageProcessingActive AND gVisionSensor[idSensor].HW.Ready) THEN
		AcquisitionCompletedCntOld[idSensor]		:= gVisionSensor[idSensor].DAT.AcquisitionCompletedCnt;
		AcquisitionFailedCntOld[idSensor]			:= gVisionSensor[idSensor].DAT.AcquisitionFailedCnt;
		gVisionSensor[idSensor].CMD.ImageTrigger	:= FALSE;
		gVisionSensor[idSensor].DAT.Active			:= FALSE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Reset trigger when timed out
	// -----------------------------------------------------------------------------------------------------------
	IF gVisionSensor[idSensor].CMD.ImageTrigger THEN
		TriggerTimeoutSensor[idSensor].IN := TRUE;
		TriggerTimeoutSensor[idSensor].PT := REAL_TO_TIME(gVisionSensor[idSensor].DAT.Timeout * 1.25);
		IF TriggerTimeoutSensor[idSensor].Q THEN
			gVisionSensor[idSensor].CMD.ImageTrigger			:= FALSE;
			gVisionSensor[idSensor].CMD.ImageTriggerReset	:= TRUE;
			gVisionSensor[idSensor].DAT.Active				:= FALSE;
		END_IF
	ELSE
		TriggerTimeoutSensor[idSensor].IN := FALSE;
		gVisionSensor[idSensor].CMD.ImageTriggerReset := FALSE;
	END_IF
	TriggerTimeoutSensor[idSensor]();

	// -----------------------------------------------------------------------------------------------------------
	// Load vision application
	// -----------------------------------------------------------------------------------------------------------
	IF (gVisionSensor[idSensor].CMD.VaSwitchApplication) THEN
		ViBaseLoadApplication_01.MpLink	:= ADR(gVisionSensor[idSensor].CFG.ComponentLink);
		ViBaseLoadApplication_01.Name	:= ADR(gVisionSensor[idSensor].FCT.ApplicationName);
		gVisionSensor[idSensor].FCT.Status := ERR_FUB_BUSY;
		
		// -----------------------------------------------------------------------------------------------------------
		// OK
		IF (ViBaseLoadApplication_01.Done) THEN
			gVisionSensor[idSensor].FCT.Status := ERR_OK;
			gVisionSensor[idSensor].CMD.VaSwitchApplication := FALSE;
			// -----------------------------------------------------------------------------------------------------------
			// Error
		ELSIF (NOT ViBaseLoadApplication_01.Busy AND ViBaseLoadApplication_01.Error) THEN
			gVisionSensor[idSensor].FCT.Status := ViBaseLoadApplication_01.StatusID;
			gVisionSensor[idSensor].CMD.VaSwitchApplication := FALSE;
		END_IF		
	END_IF
	ViBaseLoadApplication_01.Execute := gVisionSensor[idSensor].CMD.VaSwitchApplication;
	ViBaseLoadApplication_01();
	// Dont proceed until loading is finished
	IF (gVisionSensor[idSensor].CMD.VaSwitchApplication) THEN
		RETURN;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Save diagnostic data
	// -----------------------------------------------------------------------------------------------------------
	IF (gVisionSensor[idSensor].CMD.SaveDiagData) THEN
		// Delete old file first
		FDelete.enable := gVisionSensor[idSensor].CMD.SaveDiagData AND NOT ViBaseSaveDiagData_01.Execute;
		FDelete.pDevice := ADR(DEVICE_NAME);
		FDelete.pName := ADR(gVisionSensor[idSensor].DIA.DiagName);
		IF (FDelete.status <> ERR_FUB_BUSY) THEN
			ViBaseSaveDiagData_01.Execute := TRUE;
		END_IF
		// Upload diagnostic information
		ViBaseSaveDiagData_01.MpLink := ADR(gVisionSensor[idSensor].CFG.ComponentLink);
		ViBaseSaveDiagData_01.DeviceName := ADR(DEVICE_NAME);
		ViBaseSaveDiagData_01.FileName := ADR(gVisionSensor[idSensor].DIA.DiagName);
		gVisionSensor[idSensor].DIA.Status := ERR_FUB_BUSY;
		
		// -----------------------------------------------------------------------------------------------------------
		// OK
		IF (ViBaseSaveDiagData_01.Done) THEN
			gVisionSensor[idSensor].DIA.Status := ERR_OK;
			ViBaseSaveDiagData_01.Execute := FALSE;
			gVisionSensor[idSensor].CMD.SaveDiagData := FALSE;
			// -----------------------------------------------------------------------------------------------------------
			// Error
		ELSIF (NOT ViBaseSaveDiagData_01.Busy AND ViBaseSaveDiagData_01.Error) THEN
			gVisionSensor[idSensor].DIA.Status := ViBaseSaveDiagData_01.StatusID;
			ViBaseSaveDiagData_01.Execute := FALSE;
			gVisionSensor[idSensor].CMD.SaveDiagData := FALSE;
		END_IF
	END_IF
	ViBaseSaveDiagData_01();
	FDelete();
	// Dont proceed until loading is finished
	IF (gVisionSensor[idSensor].CMD.SaveDiagData) THEN
		RETURN;
	END_IF
	
	// Proceed with next sensor
	idSensor := idSensor + 1;
	IF (idSensor > MAX_NUM_CAMS) THEN
		idSensor := 1;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Reset Light trigger
	// -----------------------------------------------------------------------------------------------------------
	IF (gVisionLight[idLight].DAT.FlashCompletedCnt <> FlashCompletedCntOld[idLight] OR gVisionLight[idLight].DAT.FlashFailedCnt <> FlashFailedCntOld[idLight]) THEN
		FlashCompletedCntOld[idLight]			:= gVisionLight[idLight].DAT.FlashCompletedCnt;
		FlashFailedCntOld[idLight]				:= gVisionLight[idLight].DAT.FlashFailedCnt;
		gVisionLight[idLight].CMD.FlashTrigger	:= FALSE;
	END_IF
		
	// -----------------------------------------------------------------------------------------------------------
	// Reset trigger when timed out
	// -----------------------------------------------------------------------------------------------------------
	IF gVisionLight[idLight].CMD.FlashTrigger THEN
		TriggerTimeoutLight[idLight].IN := TRUE;
		TriggerTimeoutLight[idLight].PT := REAL_TO_TIME(gVisionLight[idLight].DAT.Timeout * 1.25);
		IF TriggerTimeoutLight[idLight].Q THEN
			gVisionLight[idLight].CMD.FlashTrigger		:= FALSE;
			gVisionLight[idLight].CMD.FlashTriggerReset	:= TRUE;
		END_IF
	ELSE
		TriggerTimeoutLight[idLight].IN := FALSE;
		gVisionLight[idLight].CMD.FlashTriggerReset := FALSE;
	END_IF
	TriggerTimeoutLight[idLight]();

	// Proceed with next light
	idLight := idLight + 1;
	IF (idLight > MAX_NUM_LIGHTS) THEN
		idLight := 1;
	END_IF
END_PROGRAM
