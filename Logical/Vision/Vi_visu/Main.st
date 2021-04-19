// --------------------------------------------------------------------------------------------------------------------
// This is a support task for the mappView visualization. The following functions are implemneted
// - Disable mappView functions when camera is not ready, available
// - Transfer parameters after vision setup
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
	Pixel ACCESS ADR(tmpPixel);
	
	// Map global structure to local reference
	VisionLight ACCESS ADR(gVisionLight[visSelectedLight]);

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
	InitialSearchLight := TRUE;
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
			enumPixelCounter:	Pixel ACCESS VisionSensor.CFG.DataStructure;
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
		IF visSelectedCodeType <> visSelectedCodeTypeOld THEN
			CodeReader.CodeType := UDINT_TO_USINT(brsatoi(ADR(visSelectedCodeType)));
		ELSE
			brsitoa(CodeReader.CodeType, ADR(visSelectedCodeType));
		END_IF
		visSelectedCodeTypeOld := visSelectedCodeType;
		IF visSelectedParameterMode <> visSelectedParameterModeOld THEN
			CodeReader.ParameterMode := UDINT_TO_USINT(brsatoi(ADR(visSelectedParameterMode)));
		ELSE
			brsitoa(CodeReader.ParameterMode, ADR(visSelectedParameterMode));
		END_IF
		visSelectedParameterModeOld := visSelectedParameterMode;
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
	IF visSensorFlashColor <> visSensorFlashColorOld THEN // The flash color was changed in the mappView visualization
		VisionSensor.DAT.FlashColor := UDINT_TO_USINT(brsatoi(ADR(visSensorFlashColor)));
	ELSE
		brsitoa(VisionSensor.DAT.FlashColor, ADR(visSensorFlashColor));
	END_IF
	visSensorFlashColorOld := visSensorFlashColor;
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
		visSensorEnableCommand := FALSE;
	ELSE
		visSensorEnableCommand := TRUE;
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
	IF((visImageTrigger OR EDGEPOS(VisionSensor.DAT.Enable)) AND VisionSensor.HW.Ready AND NOT VisionSensor.DAT.ImageProcessingActive) THEN
		// Add default delay and fire trigger
		IF NETTIME_ENABLE THEN
			VisionSensor.DAT.NettimeDelay := NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
		END_IF
		VisionSensor.CMD.ImageTrigger	:= TRUE;
		visImageTrigger					:= FALSE;
		VisionSensor.DAT.Active			:= TRUE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Auto save image
	// -----------------------------------------------------------------------------------------------------------
	IF EDGENEG(VisionSensor.CMD.ImageTrigger) THEN
		IF visAutoArchiv AND NOT DisableAutoArchiv THEN
			gVisionImage.CMD.SaveImageOnPLC := TRUE;
		END_IF
		IF NOT visRepetitiveMode THEN
			DisableAutoArchiv := FALSE;
		END_IF
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Repetitive mode
	// -----------------------------------------------------------------------------------------------------------
	visEnableRepetitive := visSensorEnableCommand OR visRepetitiveMode; // Enable of the repetitive mode button. Don't disable while repetitive mode is active
	IF visRepetitiveMode THEN
		RepetitiveModeTimer.IN := TRUE;
		IF RepetitiveModeTimer.Q THEN
			IF VisionSensor.HW.Ready AND NOT VisionSensor.DAT.ImageProcessingActive THEN
				IF NETTIME_ENABLE THEN
					VisionSensor.DAT.NettimeDelay := NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
				END_IF
				RepetitiveModeTimer.IN := FALSE;
				VisionSensor.CMD.ImageTrigger := TRUE;
			END_IF
		END_IF
		DisableAutoArchiv := TRUE;
		VisionSensor.DAT.Enable := FALSE;
	ELSE
		RepetitiveModeTimer.IN := TRUE;
	END_IF
	RepetitiveModeTimer(PT := T#200ms);
	
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
	// Select first available light after reboot
	// -----------------------------------------------------------------------------------------------------------
	IF InitialSearchLight THEN 
		FOR i := 1 TO MAX_NUM_LIGHTS DO
			IF gVisionLight[i].HW.Connected THEN
				visSelectedLight := i;
				InitialSearchLight := FALSE;
				EXIT;
			END_IF
		END_FOR
	END_IF
	// -----------------------------------------------------------------------------------------------------------
	// Map global structure to local reference
	// -----------------------------------------------------------------------------------------------------------
	// Make sure we dont exceed array limit
	IF(visSelectedLight > MAX_NUM_LIGHTS) THEN
		visSelectedLight := 1;
	END_IF
	IF(visSelectedLight < 1) THEN
		visSelectedLight := MAX_NUM_LIGHTS;
	END_IF
	VisionLight ACCESS ADR(gVisionLight[visSelectedLight]);
	
	// -----------------------------------------------------------------------------------------------------------
	// Translate flash color from mappView to IO mapping
	// -----------------------------------------------------------------------------------------------------------
	// Hint: Normally copy from recipe (VisionLight) to visu. Only in case of a change in the visu copy to recipe
	IF visLightsFlashColor <> visLightsFlashColorOld THEN // The flash color was changed in the mappView visualization
		VisionLight.DAT.FlashColor := UDINT_TO_USINT(brsatoi(ADR(visLightsFlashColor)));
	ELSE
		brsitoa(VisionLight.DAT.FlashColor, ADR(visLightsFlashColor));
	END_IF
	visLightsFlashColorOld := visLightsFlashColor;

	// -----------------------------------------------------------------------------------------------------------
	// Reset Light trigger manually
	// -----------------------------------------------------------------------------------------------------------
	IF (visLightsReset) THEN
		VisionLight.CMD.FlashTrigger := FALSE;
		visLightsReset := FALSE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Fire trigger for lights
	// -----------------------------------------------------------------------------------------------------------
	IF(visLightsTrigger AND VisionLight.HW.Ready) THEN
		// Add default delay and fire trigger
		IF NETTIME_ENABLE THEN
			VisionLight.DAT.NettimeDelay := NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
		END_IF
		VisionLight.CMD.FlashTrigger := TRUE;
		visLightsTrigger := FALSE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Disable command button when light is disconnected or not ready
	// -----------------------------------------------------------------------------------------------------------
	IF(NOT VisionLight.HW.Connected OR NOT VisionLight.HW.Ready) THEN
		visLightsEnableCommand := FALSE;
	ELSE
		visLightsEnableCommand := TRUE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Enable fields for different light types
	// -----------------------------------------------------------------------------------------------------------
	visEnableLightBarValues := VisionLight.CFG.LightType = enumLightbar;
END_PROGRAM
