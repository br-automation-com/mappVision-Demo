// -----------------------------------------------------------------------------------------------------------
// Use this task to add your own code
// -----------------------------------------------------------------------------------------------------------	

// -----------------------------------------------------------------------------------------------------------
// Initialization
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _INIT
END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC
	// -----------------------------------------------------------------------------------------------------------
	// Vision sensor configuration
	// -----------------------------------------------------------------------------------------------------------
	// Configuration for blob
	gVisionSensor[1].CFG.VisionFunction		:= enumBlob;			// Used to run specific code for this vision function
	gVisionSensor[1].CFG.PowerlinkNode		:= 1;					// Powerlink node number
	gVisionSensor[1].CFG.DataStructure		:= ADR(gBlob);			// Global structures that holds all data related to this function
	gVisionSensor[1].CFG.ComponentLink		:= gCameraBlob;			// Vision component name defined under mappVision in the configuration view
	gVisionSensor[1].CFG.ResolutionWidth	:= 1280;
	gVisionSensor[1].CFG.ResolutionHeight	:= 1024;
	// Configuration for code reader
	gVisionSensor[2].CFG.VisionFunction		:= enumCoderReader;
	gVisionSensor[2].CFG.PowerlinkNode		:= 2;
	gVisionSensor[2].CFG.DataStructure		:= ADR(gCodeReader);
	gVisionSensor[2].CFG.ComponentLink		:= gCameraCodeReading;
	gVisionSensor[2].CFG.ResolutionWidth	:= 1280;
	gVisionSensor[2].CFG.ResolutionHeight	:= 1024;
	// Configuration for match
	gVisionSensor[3].CFG.VisionFunction		:= enumMatch;
	gVisionSensor[3].CFG.PowerlinkNode		:= 3;
	gVisionSensor[3].CFG.DataStructure		:= ADR(gMatch);
	gVisionSensor[3].CFG.ComponentLink		:= gCameraMatch;
	gVisionSensor[3].CFG.ResolutionWidth	:= 1280;
	gVisionSensor[3].CFG.ResolutionHeight	:= 1024;
	// Configuration for meaurement
	gVisionSensor[4].CFG.VisionFunction		:= enumMeasurement;
	gVisionSensor[4].CFG.PowerlinkNode		:= 4;
	gVisionSensor[4].CFG.DataStructure		:= ADR(gMT);
	gVisionSensor[4].CFG.ComponentLink		:= gCameraMeasurement;
	gVisionSensor[4].CFG.ResolutionWidth	:= 1280;
	gVisionSensor[4].CFG.ResolutionHeight	:= 1024;
	// Configuration for OCR
	gVisionSensor[5].CFG.VisionFunction		:= enumOCR;
	gVisionSensor[5].CFG.PowerlinkNode		:= 5;
	gVisionSensor[5].CFG.DataStructure		:= ADR(gOCR);
	gVisionSensor[5].CFG.ComponentLink		:= gCameraOCR;
	gVisionSensor[5].CFG.ResolutionWidth	:= 1280;
	gVisionSensor[5].CFG.ResolutionHeight	:= 1024;
	// Configuration for PixelCounter
	gVisionSensor[6].CFG.VisionFunction		:= enumPixelCounter;
	gVisionSensor[6].CFG.PowerlinkNode		:= 6;
	gVisionSensor[6].CFG.DataStructure		:= ADR(gPixel);
	gVisionSensor[6].CFG.ComponentLink		:= gCameraPxl;
	gVisionSensor[6].CFG.ResolutionWidth	:= 1280;
	gVisionSensor[6].CFG.ResolutionHeight	:= 1024;

	// -----------------------------------------------------------------------------------------------------------
	// Lights configuration
	// -----------------------------------------------------------------------------------------------------------	
	// Configuration for backlights
	gVisionLight[1].CFG.LightType		:= enumBacklight;
	gVisionLight[1].CFG.PowerlinkNode	:= 10;
	gVisionLight[1].DAT.FlashColor		:= 1;
	gVisionLight[2].CFG.LightType		:= enumBacklight;
	gVisionLight[2].CFG.PowerlinkNode	:= 11;
	gVisionLight[2].DAT.FlashColor		:= 1;
	// Configuration for lightbars
	gVisionLight[3].CFG.LightType		:= enumLightbar;
	gVisionLight[3].CFG.PowerlinkNode	:= 20;
	gVisionLight[3].DAT.FlashColor		:= 1;
	
	// -----------------------------------------------------------------------------------------------------------
	// Backlight handling, this block can be deleted when no backlights are used
	// -----------------------------------------------------------------------------------------------------------	

	// -----------------------------------------------------------------------------------------------------------	
	// Trigger selected backlight when selected sensor is triggered
	IF(EDGEPOS(gVisionSensor[gSelectedSensor].CMD.ImageTrigger)) THEN
		gVisionLight[gSelectedLight].DAT.Exposure		:= gVisionSensor[gSelectedSensor].DAT.Exposure;
		gVisionLight[gSelectedLight].DAT.NettimeDelay	:= gVisionSensor[gSelectedSensor].DAT.NettimeDelay;
		gVisionLight[gSelectedLight].CMD.FlashTrigger	:= TRUE;
	END_IF
	
END_PROGRAM