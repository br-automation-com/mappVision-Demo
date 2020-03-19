PROGRAM _INIT
	// -----------------------------------------------------------------------------------------------------------
	// Map global structure to local reference
	VisionLight ACCESS ADR(gVisionLight[visSelectedLight]);
	 
END_PROGRAM

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
	IF (VisionLight.STA.FlashCompletedCnt <> FlashCompletedCntOld OR VisionLight.STA.FlashFailedCnt <> FlashFailedCntOld) THEN
		VisionLight.CMD.FlashTrigger := FALSE;
	END_IF
	FlashCompletedCntOld := VisionLight.STA.FlashCompletedCnt;
	FlashFailedCntOld := VisionLight.STA.FlashFailedCnt;
	
	// -----------------------------------------------------------------------------------------------------------
	// Fire trigger for lights
	// -----------------------------------------------------------------------------------------------------------
	IF(visLightsTrigger AND VisionLight.HW.Ready) THEN
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
	
	IF(gVisionSensor[1].CMD.ImageTrigger) THEN
		gVisionLight[1].CFG.Exposure := gVisionSensor[1].CFG.Exposure;
		gVisionLight[2].CFG.Exposure := gVisionSensor[1].CFG.Exposure;
		gVisionLight[1].CFG.NettimeDelay := gVisionSensor[1].CFG.NettimeDelay;
		gVisionLight[2].CFG.NettimeDelay := gVisionSensor[1].CFG.NettimeDelay;
		gVisionLight[1].CMD.FlashTrigger := TRUE;
		gVisionLight[2].CMD.FlashTrigger := TRUE;
	ELSE
		gVisionLight[1].CMD.FlashTrigger := FALSE;
		gVisionLight[2].CMD.FlashTrigger := FALSE;
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
	 
END_PROGRAM

