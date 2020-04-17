// -----------------------------------------------------------------------------------------------------------
// Use this task to add your own code
// -----------------------------------------------------------------------------------------------------------	

// -----------------------------------------------------------------------------------------------------------
// Initialization
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _INIT
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
END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC
	// -----------------------------------------------------------------------------------------------------------	
	// Trigger first backlight when sensor is triggered
	IF(EDGEPOS(gVisionSensor[1].CMD.ImageTrigger)) THEN
		gVisionLight[1].CFG.Exposure := gVisionSensor[1].CFG.Exposure;
		gVisionLight[1].CFG.NettimeDelay := gVisionSensor[1].CFG.NettimeDelay;
		gVisionLight[1].CMD.FlashTrigger := TRUE;
	END_IF
END_PROGRAM