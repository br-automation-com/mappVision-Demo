// --------------------------------------------------------------------------------------------------------------------
// General vision task. This is a support task for the mappView visualization. The following functions are implemneted
// - Disable mappView functions when camera is not ready, available
// - Load image on main page when camera has finished inspection
// - Transfer parameters after vision setup
// - Draw crosshairs into image on the main page
// Version 2.x (Check revision history for details)
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	// -----------------------------------------------------------------------------------------------------------
	// Map global structure to local reference
	VisionSensor ACCESS ADR(gVisionSensor[visSelectedSensor]);
	Blob ACCESS ADR(tmpBlob);
	Match ACCESS ADR(tmpMatch);
	CodeReader ACCESS ADR(tmpCodeReader);
	OCR ACCESS ADR(tmpOCR);
	MT ACCESS ADR(tmpMT);

	// -----------------------------------------------------------------------------------------------------------
	// Preload code types
	FOR i := 0 TO MAX_NUM_CODETYPES DO
		IF CodeTypes[i] <> '' THEN
			brsstrcat(ADR(visCodeTypePresentDropDownValues[i]), ADR('{"value":"'));
			brsitoa(i, ADR(tmpStr1));
			brsstrcat(ADR(visCodeTypePresentDropDownValues[i]), ADR(tmpStr1));
			brsstrcat(ADR(visCodeTypePresentDropDownValues[i]), ADR('","text":"'));
			brsstrcat(ADR(visCodeTypePresentDropDownValues[i]), ADR(CodeTypes[i]));
			brsstrcat(ADR(visCodeTypePresentDropDownValues[i]), ADR('"}'));
		END_IF
	END_FOR

	// -----------------------------------------------------------------------------------------------------------
	visTableNo;
	InitialSearchSensor := TRUE;
END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC
	// -----------------------------------------------------------------------------------------------------------
	// Select first available camera after reboot
	// -----------------------------------------------------------------------------------------------------------
	IF InitialSearchSensor THEN 
		FOR i := 1 TO MAX_NUM_CAMS DO
			IF gVisionSensor[i].HW.Connected THEN
				visSelectedSensor := i;
				InitialSearchSensor := FALSE;
				EXIT;
			END_IF
		END_FOR
		VisionSensor.CMD.VaListRefresh := TRUE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Map global structure to local reference for mappView
	// -----------------------------------------------------------------------------------------------------------
	// Make sure we dont exceed array limit
	IF(visSelectedSensor > MAX_NUM_CAMS) THEN
		visSelectedSensor := 1;
	END_IF
	IF(visSelectedSensor < 1) THEN
		visSelectedSensor := MAX_NUM_CAMS;
	END_IF
	// -----------------------------------------------------------------------------------------------------------
	// Assign pointers
	VisionSensor ACCESS ADR(gVisionSensor[visSelectedSensor]);
	IF(VisionSensor.CFG.DataStructure <> 0) THEN
		CASE VisionSensor.CFG.VisionFunction OF
			enumBlob:
				Blob ACCESS VisionSensor.CFG.DataStructure;
			enumMatch:
				Match ACCESS VisionSensor.CFG.DataStructure;
			enumCoderReader:
				CodeReader ACCESS VisionSensor.CFG.DataStructure;
			enumOCR:
				OCR ACCESS VisionSensor.CFG.DataStructure;
			enumMeasurement:
				MT ACCESS VisionSensor.CFG.DataStructure;
		END_CASE
	ELSE
		RETURN;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Display camera status in hex - documenation is also in hex
	// -----------------------------------------------------------------------------------------------------------
	IF VisionSensor.DAT.Status = 0 THEN // Display only a single 0
		visCameraStatus := '0';
	ELSIF VisionSensor.DAT.Status = 16#00000001 THEN
		visCameraStatus := 'Image acquisition';
	ELSIF VisionSensor.DAT.Status = 16#00000002 THEN
		visCameraStatus := 'Waiting trigger';
	ELSIF VisionSensor.DAT.Status = 16#00000010 THEN
		visCameraStatus := 'Searching settings';
	ELSIF VisionSensor.DAT.Status = 16#00000080 THEN
		visCameraStatus := 'Setting focus';
	ELSIF VisionSensor.DAT.Status = 16#00000090 THEN
		visCameraStatus := 'Searching settings';
	ELSIF VisionSensor.DAT.Status = 16#00000800 THEN
		visCameraStatus := 'Cam CPU not ready';
	ELSIF VisionSensor.DAT.Status = 16#00001000 THEN
		visCameraStatus := 'Cam sensor not ready';
	ELSIF VisionSensor.DAT.Status = 16#02000000 THEN
		visCameraStatus := 'OS check/update';
	ELSIF VisionSensor.DAT.Status = 16#80000000 THEN
		visCameraStatus := 'Vision cockpit active';
	ELSE // Display the status in hex format 0x02000800
		visCameraStatus := '';
		FOR i := 0 TO 28 BY 4 DO
			visCameraStatus := CONCAT(MID(HexTab, 1, LIMIT(1, UDINT_TO_INT((SHR(VisionSensor.DAT.Status, i) AND 16#0000000F) + 1), 16)), visCameraStatus);
		END_FOR
		visCameraStatus := CONCAT('0x', visCameraStatus);
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Check if vision cockpit is open
	// -----------------------------------------------------------------------------------------------------------
	IF((VisionSensor.DAT.Status AND 16#8000_0000) > 0) THEN
		VisionSensor.DAT.CockpitIsActive := TRUE;
	ELSE
		VisionSensor.DAT.CockpitIsActive := FALSE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Code Reader - selected/detected types
	// -----------------------------------------------------------------------------------------------------------
	IF VisionSensor.CFG.VisionFunction = enumCoderReader THEN
		CodeReader.CodeType := UDINT_TO_USINT(brsatoi(ADR(visSelectedCodeTypePreset)));
		FOR idx:=1 TO MAX_NUM_RESULTS DO
			IF CodeReader.BarcodeType[idx] <> 0 THEN
				brsstrcpy(ADR(visSelectedCodeTypeDetected[idx]), ADR(CodeTypes[LIMIT(0, CodeReader.BarcodeType[idx], MAX_NUM_CODETYPES)]));
			ELSE
				brsstrcpy(ADR(visSelectedCodeTypeDetected[idx]), ADR(''));
			END_IF
		END_FOR
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Translate flash color and segments from mappView to IO mapping
	// -----------------------------------------------------------------------------------------------------------
	// Hint: Normally copy from recipe (VisionSensor) to visu. Only in case of a change in the visu copy to recipe
	IF visSelectedFlashColor <> visSelectedFlashColorOld THEN // The flash color was changed in the mappView visualization
		VisionSensor.DAT.FlashColor := UDINT_TO_USINT(brsatoi(ADR(visSelectedFlashColor)));
	ELSE
		brsitoa(VisionSensor.DAT.FlashColor, ADR(visSelectedFlashColor));
	END_IF
	visSelectedFlashColorOld := visSelectedFlashColor;
	IF brsmemcmp(ADR(visSelectedFlashSegment), ADR(visSelectedFlashSegmentOld), SIZEOF(visSelectedFlashSegment)) <> 0 THEN // The flash segments was changed in the mappView visualization
		VisionSensor.DAT.FlashSegment := SHL(visSelectedFlashSegment[0], 0) OR SHL(visSelectedFlashSegment[1], 1) OR SHL(visSelectedFlashSegment[2], 2) OR SHL(visSelectedFlashSegment[3], 3);
	ELSE
		visSelectedFlashSegment[0] := VisionSensor.DAT.FlashSegment.0;
		visSelectedFlashSegment[1] := VisionSensor.DAT.FlashSegment.1;
		visSelectedFlashSegment[2] := VisionSensor.DAT.FlashSegment.2;
		visSelectedFlashSegment[3] := VisionSensor.DAT.FlashSegment.3;
	END_IF
	visSelectedFlashSegmentOld := visSelectedFlashSegment;

	// -----------------------------------------------------------------------------------------------------------
	// Create HTTP path for web control
	// -----------------------------------------------------------------------------------------------------------
	visHttpPath := 'http://192.168.200.';
	brsitoa(VisionSensor.CFG.PowerlinkNode, ADR(tmpStr1));
	brsstrcat(ADR(visHttpPath), ADR(tmpStr1));
		
	// -----------------------------------------------------------------------------------------------------------
	// Disable command buttons when camera is disconnected, not ready, processing an image or vision cockpit is open
	// -----------------------------------------------------------------------------------------------------------
	IF(NOT VisionSensor.HW.Connected OR NOT VisionSensor.HW.Ready OR VisionSensor.DAT.ImageProcessingActive OR VisionSensor.DAT.CockpitIsActive) THEN
		visEnableCommand := FALSE;
	ELSE
		visEnableCommand := TRUE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Disable setup buttons when camera is disconnected, processing an image or not ready
	// -----------------------------------------------------------------------------------------------------------
	IF(NOT VisionSensor.HW.Connected OR NOT (VisionSensor.HW.Ready OR AutoSetupRunning) OR VisionSensor.DAT.ImageProcessingActive) THEN
		visEnableSetup := FALSE;
	ELSE
		visEnableSetup := TRUE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Transfer auto setup data to preset values
	// -----------------------------------------------------------------------------------------------------------
	IF(VisionSensor.CMD.AutoSetupStartStop AND VisionSensor.DAT.Status <> 0) THEN
		AutoSetupRunning := TRUE;
	ELSIF NOT VisionSensor.CMD.AutoSetupStartStop THEN
		AutoSetupRunning := FALSE;
	END_IF
	IF(VisionSensor.CMD.AutoSetupStartStop AND VisionSensor.DAT.Status = 0 AND AutoSetupRunning) THEN
		VisionSensor.DAT.Gain				:= VisionSensor.DAT.AutoSetupGain;
		VisionSensor.DAT.Focus				:= VisionSensor.DAT.AutoSetupFocus;
		VisionSensor.DAT.Exposure			:= VisionSensor.DAT.AutoSetupExposure;
		VisionSensor.CMD.AutoSetupStartStop	:= FALSE;
		AutoSetupRunning					:= FALSE;
		TON_DelayAfterAutoSetup.IN				:= TRUE;
	END_IF
	TON_DelayAfterAutoSetup(PT := T#50ms);
	IF TON_DelayAfterAutoSetup.Q THEN // After the camera tells it is ready, we need to wait still at least ca 20ms, otherwise it does not accept the trigger
		TON_DelayAfterAutoSetup.IN := FALSE;
		visImageTrigger := TRUE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Fire trigger for camera image
	// -----------------------------------------------------------------------------------------------------------
	IF((visImageTrigger OR EDGEPOS(visEnableVision)) AND VisionSensor.HW.Ready AND NOT VisionSensor.DAT.ImageProcessingActive) THEN
		// Add default delay and fire trigger
		VisionSensor.DAT.NettimeDelay := NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
		VisionSensor.CMD.ImageTrigger := TRUE;
		visImageTrigger := FALSE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Repetitive mode
	// -----------------------------------------------------------------------------------------------------------
	visEnableRepetitive := visEnableCommand OR visRepetitiveMode; // Enable of the repetitive mode button. Don't disable while repetitive mode is active
	IF visRepetitiveMode THEN
		// Trigger new image every 0.5s
		RepetitiveModeTimer.IN := TRUE;
		RepetitiveModeTimer.PT := T#500ms;
		IF RepetitiveModeTimer.Q THEN
			IF VisionSensor.HW.Ready AND NOT VisionSensor.DAT.ImageProcessingActive THEN
				RepetitiveModeTimer.IN := FALSE;
				VisionSensor.DAT.NettimeDelay := NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
				VisionSensor.CMD.ImageTrigger := TRUE;
			END_IF
		END_IF
		DisableAutoArchiv := TRUE;
	ELSE
		RepetitiveModeTimer.IN := TRUE;
	END_IF
	RepetitiveModeTimer();
	VisionSensor.DAT.Enable := visEnableVision AND NOT visRepetitiveMode;
	
	// -----------------------------------------------------------------------------------------------------------
	// Reset image trigger, reload web page and store image when process is finished
	// -----------------------------------------------------------------------------------------------------------
	IF ((VisionSensor.DAT.AcquisitionCompletedCnt <> AcquisitionCompletedCntOld OR VisionSensor.DAT.AcquisitionFailedCnt <> AcquisitionFailedCntOld) AND NOT VisionSensor.DAT.ImageProcessingActive) THEN
		AcquisitionCompletedCntOld		:= VisionSensor.DAT.AcquisitionCompletedCnt;
		AcquisitionFailedCntOld			:= VisionSensor.DAT.AcquisitionFailedCnt;
		VisionSensor.CMD.BrowserReload	:= TRUE;
		VisionSensor.CMD.ImageTrigger	:= FALSE;	
		// Store image to flash card
		IF visAutoArchiv AND NOT DisableAutoArchiv THEN
			gVisionImage.CMD.SaveImageOnPLC := TRUE;
		END_IF
		IF NOT visRepetitiveMode THEN
			DisableAutoArchiv := FALSE;
		END_IF
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Reset trigger when timed out
	// -----------------------------------------------------------------------------------------------------------
	IF VisionSensor.CMD.ImageTrigger THEN
		TriggerTimeout.IN := TRUE;
		TriggerTimeout.PT := UINT_TO_TIME(VisionSensor.DAT.Timeout)*2;
		IF TriggerTimeout.Q THEN
			VisionSensor.CMD.ImageTrigger := FALSE;
			VisionSensor.CMD.ImageTriggerReset := TRUE;
		END_IF
	ELSE
		TriggerTimeout.IN := FALSE;
		VisionSensor.CMD.ImageTriggerReset := FALSE;
	END_IF
	TriggerTimeout();

	// -----------------------------------------------------------------------------------------------------------
	// Auto reset web reload when stuck
	// -----------------------------------------------------------------------------------------------------------
	ReloadTimeout.PT := VisionSensor.DAT.Timeout/10;
	ReloadTimeout.IN := VisionSensor.CMD.BrowserReload;
	ReloadTimeout();
	IF(ReloadTimeout.Q) THEN
		ReloadTimeout.IN := FALSE;
		VisionSensor.CMD.BrowserReload := FALSE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Get list of vision applications and components
	// -----------------------------------------------------------------------------------------------------------
	IF (VisionSensor.CMD.VaListRefresh) THEN
		VaGetList_01(Enable := TRUE);
		VisionSensor.FCT.Status := ERR_FUB_BUSY;
		// -----------------------------------------------------------------------------------------------------------
		// OK
		IF(VaGetList_01.Status = ERR_OK) THEN
			// Make sure we dont exceed array limit
			IF(VaGetList_01.VaApplicationCnt > 0 AND VaGetList_01.VaApplicationCnt < SIZEOF(VisionSensor.FCT.ApplicationNameList)/SIZEOF(VisionSensor.FCT.ApplicationNameList[0])) THEN
				// Convert vision application list to main structure and mappView format
				FOR idx:=0 TO VaGetList_01.VaApplicationCnt - 1 DO
					VisionSensor.FCT.ApplicationNameList[idx] := VaGetList_01.VaApplicationNames[idx];
					String2DataProvider(ADR(VaGetList_01.VaApplicationNames[idx]), ADR(visVisionApplicationList[idx]));
				END_FOR
				VisionSensor.FCT.Status := ERR_OK;
			ELSE
				VisionSensor.FCT.Status := ERR_VA_LIST_NUM;				
			END_IF
			VisionSensor.FCT.ApplicationNameCnt := VaGetList_01.VaApplicationCnt;
			// Reset function block
			VaGetList_01(Enable := FALSE);
			VisionSensor.CMD.VaListRefresh := FALSE;
			// -----------------------------------------------------------------------------------------------------------
			// Error
		ELSIF(VaGetList_01.Status <> ERR_FUB_BUSY) THEN
			VisionSensor.FCT.Status := VaGetList_01.Status;
			VaGetList_01(Enable := FALSE);
			VisionSensor.CMD.VaListRefresh := FALSE;
		END_IF
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Load vision application
	// -----------------------------------------------------------------------------------------------------------
	IF (VisionSensor.CMD.VaSwitchApplication) THEN
		ViBaseLoadApplication_01.MpLink	:= ADR(VisionSensor.CFG.ComponentLink);
		ViBaseLoadApplication_01.Name	:= ADR(VisionSensor.FCT.ApplicationName);
		VisionSensor.FCT.Status := ERR_FUB_BUSY;
		
		// -----------------------------------------------------------------------------------------------------------
		// OK
		IF (ViBaseLoadApplication_01.Done) THEN
			VisionSensor.FCT.Status := ERR_OK;
			VisionSensor.CMD.VaSwitchApplication := FALSE;
		// -----------------------------------------------------------------------------------------------------------
		// Error
		ELSIF (NOT ViBaseLoadApplication_01.Busy AND ViBaseLoadApplication_01.Error) THEN
			VisionSensor.FCT.Status := ViBaseLoadApplication_01.StatusID;
			VisionSensor.CMD.VaSwitchApplication := FALSE;
		END_IF		
	END_IF
	ViBaseLoadApplication_01.Execute := VisionSensor.CMD.VaSwitchApplication;
	ViBaseLoadApplication_01();
	
	// -----------------------------------------------------------------------------------------------------------
	// Informations for Vi_image
	// -----------------------------------------------------------------------------------------------------------
	IF EDGENEG(VisionSensor.DAT.ImageProcessingActive) THEN
		gVisionImage.CMD.RefreshCrosshair := TRUE;
	END_IF
	gVisionImage.DAT.VisionDisabled := NOT visEnableVision;
END_PROGRAM
