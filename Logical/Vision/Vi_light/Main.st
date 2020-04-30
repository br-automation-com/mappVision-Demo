// --------------------------------------------------------------------------------------------------------------------
// General external lights task. This is a support task for the mappView visualization.
// Version 1.x (Check revision history for details)
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	// Map global structure to local reference
	VisionLight ACCESS ADR(gVisionLight[visSelectedLight]);
	
	// Flash color
	brsitoa(VisionLight.CFG.FlashColor, ADR(visSelectedFlashColor));
	 
END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC
	 // -----------------------------------------------------------------------------------------------------------
	// Map global structure to local reference
	// -----------------------------------------------------------------------------------------------------------
	// Make sure we dont exceed array limit
	IF(visSelectedLight > SIZEOF(gVisionLight)/SIZEOF(gVisionLight[1])) THEN
		visSelectedLight := 1;
	END_IF
	IF(visSelectedLight < 1) THEN
		visSelectedLight := SIZEOF(gVisionLight)/SIZEOF(gVisionLight[1]);
	END_IF
	VisionLight ACCESS ADR(gVisionLight[visSelectedLight]);
	
	// -----------------------------------------------------------------------------------------------------------
	// Reset Light trigger
	// -----------------------------------------------------------------------------------------------------------
	IF (VisionLight.STA.FlashCompletedCnt <> FlashCompletedCntOld OR VisionLight.STA.FlashFailedCnt <> FlashFailedCntOld OR visLightsReset) THEN
		VisionLight.CMD.FlashTrigger := FALSE;
		visLightsReset := FALSE;
	END_IF
	FlashCompletedCntOld := VisionLight.STA.FlashCompletedCnt;
	FlashFailedCntOld := VisionLight.STA.FlashFailedCnt;
	
	// -----------------------------------------------------------------------------------------------------------
	// Reset trigger when timed out
	// -----------------------------------------------------------------------------------------------------------
	IF VisionLight.CMD.FlashTrigger THEN
		TriggerTimeout.IN := TRUE;
		TriggerTimeout.PT := UINT_TO_TIME(VisionLight.CFG.Timeout)*2;
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
		VisionLight.CFG.NettimeDelay := NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
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
	
	// -----------------------------------------------------------------------------------------------------------
	// Vision Sensor - flash color
	VisionLight.CFG.FlashColor := UDINT_TO_USINT(brsatoi(ADR(visSelectedFlashColor)));
	
END_PROGRAM

PROGRAM _EXIT
	 
END_PROGRAM

