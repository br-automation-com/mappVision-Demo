// --------------------------------------------------------------------------------------------------------------------
// General external lights task. This is a support task for the mappView visualization.
// Version 1.x (Check revision history for details)
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	// Map global structure to local reference
	VisionLight ACCESS ADR(gVisionLight[visSelectedLight]);
	 
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
	// Fire trigger for lights
	// -----------------------------------------------------------------------------------------------------------
	IF(visLightsTrigger AND VisionLight.HW.Ready) THEN
		VisionLight.CFG.NettimeDelay := NettimeCurrent_us + 10000;
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

PROGRAM _EXIT
	 
END_PROGRAM

