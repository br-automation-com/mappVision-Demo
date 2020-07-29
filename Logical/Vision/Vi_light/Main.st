// --------------------------------------------------------------------------------------------------------------------
// General external lights task. This is a support task for the mappView visualization.
// Version 1.x (Check revision history for details)
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	// Map global structure to local reference
	VisionLight ACCESS ADR(gVisionLight[visSelectedLight]);

	InitialSearchLight := TRUE;
END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC
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
	IF visSelectedFlashColor <> visSelectedFlashColorOld THEN // The flash color was changed in the mappView visualization
		VisionLight.DAT.FlashColor := UDINT_TO_USINT(brsatoi(ADR(visSelectedFlashColor)));
	ELSE
		brsitoa(VisionLight.DAT.FlashColor, ADR(visSelectedFlashColor));
	END_IF
	visSelectedFlashColorOld := visSelectedFlashColor;

	// -----------------------------------------------------------------------------------------------------------
	// Reset Light trigger
	// -----------------------------------------------------------------------------------------------------------
	IF (VisionLight.DAT.FlashCompletedCnt <> FlashCompletedCntOld OR VisionLight.DAT.FlashFailedCnt <> FlashFailedCntOld OR visLightsReset) THEN
		VisionLight.CMD.FlashTrigger := FALSE;
		visLightsReset := FALSE;
	END_IF
	FlashCompletedCntOld := VisionLight.DAT.FlashCompletedCnt;
	FlashFailedCntOld := VisionLight.DAT.FlashFailedCnt;
	
	// -----------------------------------------------------------------------------------------------------------
	// Reset trigger when timed out
	// -----------------------------------------------------------------------------------------------------------
	IF VisionLight.CMD.FlashTrigger THEN
		TriggerTimeout.IN := TRUE;
		TriggerTimeout.PT := UINT_TO_TIME(VisionLight.DAT.Timeout)*2;
		IF TriggerTimeout.Q THEN
			VisionLight.CMD.FlashTrigger := FALSE;
			VisionLight.CMD.FlashTriggerReset := TRUE;
		END_IF
	ELSE
		TriggerTimeout.IN := FALSE;
		VisionLight.CMD.FlashTriggerReset := FALSE;
	END_IF
	TriggerTimeout();
	
	// -----------------------------------------------------------------------------------------------------------
	// Fire trigger for lights
	// -----------------------------------------------------------------------------------------------------------
	IF(visLightsTrigger AND VisionLight.HW.Ready) THEN
		// Add default delay and fire trigger
		VisionLight.DAT.NettimeDelay := NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
		VisionLight.CMD.FlashTrigger := TRUE;
		visLightsTrigger := FALSE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Disable command button when light is disconnected or not ready
	// -----------------------------------------------------------------------------------------------------------
	IF(NOT VisionLight.HW.Connected OR NOT VisionLight.HW.Ready) THEN
		visEnableCommand := FALSE;
	ELSE
		visEnableCommand := TRUE;
	END_IF
END_PROGRAM