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
	CodeReader ACCESS ADR(tmpCodeReader);
	Match ACCESS ADR(tmpMatch);
	MT ACCESS ADR(tmpMT);
	OCR ACCESS ADR(tmpOCR);

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
// Part 1: Things to be done for every camera/sensor
// -----------------------------------------------------------------------------------------------------------
	FOR idx := 1 TO MAX_NUM_CAMS DO
		// -----------------------------------------------------------------------------------------------------------
		// Display camera status in hex - documenation is also in hex
		// -----------------------------------------------------------------------------------------------------------
		IF gVisionSensor[idx].DAT.Status = 0 THEN // Display only a single 0
			gVisionSensor[idx].DAT.StatusText := '0';
		ELSIF gVisionSensor[idx].DAT.Status = 16#00000001 THEN
			gVisionSensor[idx].DAT.StatusText := 'Image acquisition';
		ELSIF gVisionSensor[idx].DAT.Status = 16#00000002 THEN
			gVisionSensor[idx].DAT.StatusText := 'Waiting trigger';
		ELSIF gVisionSensor[idx].DAT.Status = 16#00000010 THEN
			gVisionSensor[idx].DAT.StatusText := 'Searching settings';
		ELSIF gVisionSensor[idx].DAT.Status = 16#00000080 THEN
			gVisionSensor[idx].DAT.StatusText := 'Setting focus';
		ELSIF gVisionSensor[idx].DAT.Status = 16#00000090 THEN
			gVisionSensor[idx].DAT.StatusText := 'Searching settings';
		ELSIF gVisionSensor[idx].DAT.Status = 16#00000800 THEN
			gVisionSensor[idx].DAT.StatusText := 'Cam CPU not ready';
		ELSIF gVisionSensor[idx].DAT.Status = 16#00001000 THEN
			gVisionSensor[idx].DAT.StatusText := 'Cam sensor not ready';
		ELSIF gVisionSensor[idx].DAT.Status = 16#02000000 THEN
			gVisionSensor[idx].DAT.StatusText := 'OS check/update';
		ELSIF gVisionSensor[idx].DAT.Status = 16#80000000 THEN
			gVisionSensor[idx].DAT.StatusText := 'Vision cockpit active';
		ELSE // Display the status in hex format 0x02000800
			gVisionSensor[idx].DAT.StatusText := '';
			FOR i := 0 TO 28 BY 4 DO
				gVisionSensor[idx].DAT.StatusText := CONCAT(MID(HexTab, 1, LIMIT(1, UDINT_TO_INT((SHR(gVisionSensor[idx].DAT.Status, i) AND 16#0000000F) + 1), 16)), gVisionSensor[idx].DAT.StatusText);
			END_FOR
			gVisionSensor[idx].DAT.StatusText := CONCAT('0x', gVisionSensor[idx].DAT.StatusText);
		END_IF
	
		// -----------------------------------------------------------------------------------------------------------
		// Check if vision cockpit is open
		// -----------------------------------------------------------------------------------------------------------
		gVisionSensor[idx].DAT.CockpitIsActive := (gVisionSensor[idx].DAT.Status AND 16#8000_0000) > 0;
		
		// -----------------------------------------------------------------------------------------------------------
		// Auto setup handling
		// -----------------------------------------------------------------------------------------------------------
		IF(gVisionSensor[idx].CMD.AutoSetupStartStop AND gVisionSensor[idx].DAT.Status <> 0) THEN
			AutoSetupRunning[idx] := TRUE;
		ELSIF NOT gVisionSensor[idx].CMD.AutoSetupStartStop THEN
			AutoSetupRunning[idx] := FALSE;
		END_IF
		IF(gVisionSensor[idx].CMD.AutoSetupStartStop AND gVisionSensor[idx].DAT.Status = 0 AND AutoSetupRunning[idx]) THEN // Setup successfully finished
			gVisionSensor[idx].DAT.Gain					:= gVisionSensor[idx].DAT.AutoSetupGain;
			gVisionSensor[idx].DAT.Focus				:= gVisionSensor[idx].DAT.AutoSetupFocus;
			gVisionSensor[idx].DAT.Exposure				:= gVisionSensor[idx].DAT.AutoSetupExposure;
			gVisionSensor[idx].CMD.AutoSetupStartStop	:= FALSE;
			AutoSetupRunning[idx]						:= FALSE;
			TON_DelayAfterAutoSetup.IN					:= TRUE;
		END_IF
		TON_DelayAfterAutoSetup(PT := T#50ms);
		IF TON_DelayAfterAutoSetup.Q THEN // After the camera tells it is ready, we need to wait still at least ca 20ms, otherwise it does not accept the trigger
			TON_DelayAfterAutoSetup.IN := FALSE;
			IF gVisionSensor[idx].HW.Ready AND NOT gVisionSensor[idx].DAT.ImageProcessingActive THEN
				gVisionSensor[idx].DAT.NettimeDelay	:= NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
				gVisionSensor[idx].CMD.ImageTrigger	:= TRUE;
				gVisionSensor[idx].DAT.Active			:= TRUE;
			END_IF
		END_IF
		
		// -----------------------------------------------------------------------------------------------------------
		// Reset image trigger, reload web page and store image when process is finished
		// -----------------------------------------------------------------------------------------------------------
		IF ((gVisionSensor[idx].DAT.AcquisitionCompletedCnt <> AcquisitionCompletedCntOld[idx] OR gVisionSensor[idx].DAT.AcquisitionFailedCnt <> AcquisitionFailedCntOld[idx]) AND NOT gVisionSensor[idx].DAT.ImageProcessingActive AND gVisionSensor[idx].HW.Ready) THEN
			AcquisitionCompletedCntOld[idx]			:= gVisionSensor[idx].DAT.AcquisitionCompletedCnt;
			AcquisitionFailedCntOld[idx]			:= gVisionSensor[idx].DAT.AcquisitionFailedCnt;
			gVisionSensor[idx].CMD.ImageTrigger		:= FALSE;
			gVisionSensor[idx].DAT.Active			:= FALSE;
			// Store image to flash card, only for the actual selected camera
			IF idx = visSelectedSensor THEN
				IF visAutoArchiv AND NOT DisableAutoArchiv THEN
					gVisionImage.CMD.SaveImageOnPLC := TRUE;
				END_IF
				IF NOT visRepetitiveMode THEN
					DisableAutoArchiv := FALSE;
				END_IF
			END_IF
		END_IF
	
		// -----------------------------------------------------------------------------------------------------------
		// Reset trigger when timed out
		// -----------------------------------------------------------------------------------------------------------
		IF gVisionSensor[idx].CMD.ImageTrigger THEN
			TriggerTimeout[idx].IN := TRUE;
			TriggerTimeout[idx].PT := UINT_TO_TIME(gVisionSensor[idx].DAT.Timeout)*1.25;
			IF TriggerTimeout[idx].Q THEN
				gVisionSensor[idx].CMD.ImageTrigger		:= FALSE;
				gVisionSensor[idx].CMD.ImageTriggerReset	:= TRUE;
				gVisionSensor[idx].DAT.Active				:= FALSE;
			END_IF
		ELSE
			TriggerTimeout[idx].IN := FALSE;
			gVisionSensor[idx].CMD.ImageTriggerReset := FALSE;
		END_IF
		TriggerTimeout[idx]();
	END_FOR
	
// -----------------------------------------------------------------------------------------------------------
// Part 2: Things to be done for the actual selected camera / visualization related things
// -----------------------------------------------------------------------------------------------------------
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
		visVaListRefresh := TRUE;
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
			enumBlob:			Blob ACCESS VisionSensor.CFG.DataStructure;
			enumCoderReader:	CodeReader ACCESS VisionSensor.CFG.DataStructure;
			enumMatch:			Match ACCESS VisionSensor.CFG.DataStructure;
			enumMeasurement:	MT ACCESS VisionSensor.CFG.DataStructure;
			enumOCR:			OCR ACCESS VisionSensor.CFG.DataStructure;
		END_CASE
	ELSE
		RETURN;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Display camera status
	// -----------------------------------------------------------------------------------------------------------
	visCameraStatus := VisionSensor.DAT.StatusText;
		
	// -----------------------------------------------------------------------------------------------------------
	// Code Reader - selected/detected types
	// -----------------------------------------------------------------------------------------------------------
	IF VisionSensor.CFG.VisionFunction = enumCoderReader THEN
		IF(visSelectedCodeTypeToPLC <> '') THEN
			CodeReader.CodeType := UDINT_TO_USINT(brsatoi(ADR(visSelectedCodeTypeToPLC)));
			visSelectedCodeTypeToPLC := '';
		END_IF
		brsitoa(CodeReader.CodeType, ADR(visSelectedCodeTypeFromPLC));
		FOR i := 1 TO MAX_NUM_RESULTS DO
			IF CodeReader.BarcodeType[i] <> 0 THEN
				brsstrcpy(ADR(visSelectedCodeTypeDetected[i]), ADR(CodeTypes[LIMIT(0, CodeReader.BarcodeType[i], MAX_NUM_CODETYPES)]));
			ELSE
				brsstrcpy(ADR(visSelectedCodeTypeDetected[i]), ADR(''));
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
	IF(NOT VisionSensor.HW.Connected OR NOT (VisionSensor.HW.Ready OR AutoSetupRunning[visSelectedSensor]) OR VisionSensor.DAT.ImageProcessingActive) THEN
		visEnableSetup := FALSE;
	ELSE
		visEnableSetup := TRUE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Fire trigger for camera image
	// -----------------------------------------------------------------------------------------------------------
	IF((visImageTrigger OR EDGEPOS(visEnableVision)) AND VisionSensor.HW.Ready AND NOT VisionSensor.DAT.ImageProcessingActive) THEN
		// Add default delay and fire trigger
		VisionSensor.DAT.NettimeDelay	:= NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
		VisionSensor.CMD.ImageTrigger	:= TRUE;
		visImageTrigger					:= FALSE;
		VisionSensor.DAT.Active			:= TRUE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Repetitive mode
	// -----------------------------------------------------------------------------------------------------------
	visEnableRepetitive := visEnableCommand OR visRepetitiveMode; // Enable of the repetitive mode button. Don't disable while repetitive mode is active
	IF visRepetitiveMode THEN
		RepetitiveModeTimer.IN := TRUE;
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
	RepetitiveModeTimer(PT := T#200ms);
	VisionSensor.DAT.Enable := visEnableVision AND NOT visRepetitiveMode;
	
	// -----------------------------------------------------------------------------------------------------------
	// Get list of vision applications and components
	// -----------------------------------------------------------------------------------------------------------
	IF (visVaListRefresh) THEN
		VaGetList_01(Enable := TRUE);
		VisionSensor.FCT.Status := ERR_FUB_BUSY;
		IF VaGetList_01.Status <> ERR_FUB_BUSY THEN
			// Convert vision application list to mappView format
			IF VaGetList_01.Status = ERR_OK THEN
				IF VaGetList_01.VaApplicationCnt > 0 AND VaGetList_01.VaApplicationCnt < MAX_IDX_VA_LIST THEN
					FOR i:=0 TO VaGetList_01.VaApplicationCnt - 1 DO
						String2DataProvider(ADR(VaGetList_01.VaApplicationNames[i]), ADR(visVisionApplicationList[i]));
					END_FOR
				END_IF
				VisionSensor.FCT.Status := ERR_OK;
			ELSE // Error
				brsmemset(ADR(visVisionApplicationList), 0, SIZEOF(visVisionApplicationList));
				VisionSensor.FCT.Status := VaGetList_01.Status;
			END_IF
			// Reset function block
			VaGetList_01(Enable := FALSE);
			visVaListRefresh := FALSE;
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
	
	// -----------------------------------------------------------------------------------------------------------
	// Save diagnostic data
	// -----------------------------------------------------------------------------------------------------------
	IF (VisionSensor.CMD.SaveDiagData) THEN
		// Delete old file first
		FDelete.enable := VisionSensor.CMD.SaveDiagData AND NOT ViBaseSaveDiagData_01.Execute;
		FDelete.pDevice := ADR(DEVICE_NAME);
		FDelete.pName := ADR(VisionSensor.DIA.DiagName);
		IF (FDelete.status <> ERR_FUB_BUSY) THEN
			ViBaseSaveDiagData_01.Execute := TRUE;
		END_IF
		// Upload diagnostic information
		ViBaseSaveDiagData_01.MpLink := ADR(VisionSensor.CFG.ComponentLink);
		ViBaseSaveDiagData_01.DeviceName := ADR(DEVICE_NAME);
		ViBaseSaveDiagData_01.FileName := ADR(VisionSensor.DIA.DiagName);
		VisionSensor.DIA.Status := ERR_FUB_BUSY;
		
		// -----------------------------------------------------------------------------------------------------------
		// OK
		IF (ViBaseSaveDiagData_01.Done) THEN
			VisionSensor.DIA.Status := ERR_OK;
			ViBaseSaveDiagData_01.Execute := FALSE;
			VisionSensor.CMD.SaveDiagData := FALSE;
		// -----------------------------------------------------------------------------------------------------------
		// Error
		ELSIF (NOT ViBaseSaveDiagData_01.Busy AND ViBaseSaveDiagData_01.Error) THEN
			VisionSensor.DIA.Status := ViBaseSaveDiagData_01.StatusID;
			ViBaseSaveDiagData_01.Execute := FALSE;
			VisionSensor.CMD.SaveDiagData := FALSE;
		END_IF
	END_IF
	ViBaseSaveDiagData_01();
	FDelete();

END_PROGRAM
