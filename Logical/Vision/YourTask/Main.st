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
	gVisionSensor[1].CFG.VisionFunction	:= enumBlob;		// Used to run specific code for this vision function
	gVisionSensor[1].CFG.PowerlinkNode	:= 1;				// Powerlink node number
	gVisionSensor[1].CFG.DataStructure	:= ADR(gBlob);		// Global structures that holds all data related to this function
	gVisionSensor[1].CFG.ComponentLink	:= gCameraBlob;		// Vision component name defined under mappVision in the configuration view
	// Configuration for meaurement
	gVisionSensor[2].CFG.VisionFunction	:= enumMeasurement;
	gVisionSensor[2].CFG.PowerlinkNode	:= 2;
	gVisionSensor[2].CFG.DataStructure	:= ADR(gMT);
	gVisionSensor[2].CFG.ComponentLink	:= gCameraMeasurement;
	// Configuration for code reader
	gVisionSensor[3].CFG.VisionFunction	:= enumCoderReader;
	gVisionSensor[3].CFG.PowerlinkNode	:= 3;
	gVisionSensor[3].CFG.DataStructure	:= ADR(gCodeReader);
	gVisionSensor[3].CFG.ComponentLink	:= gCameraCodeReading;
	// Configuration for match
	gVisionSensor[4].CFG.VisionFunction	:= enumMatch;
	gVisionSensor[4].CFG.PowerlinkNode	:= 4;
	gVisionSensor[4].CFG.DataStructure	:= ADR(gMatch);
	gVisionSensor[4].CFG.ComponentLink	:= gCameraMatch;
	// Configuration for OCR
	gVisionSensor[5].CFG.VisionFunction	:= enumOCR;
	gVisionSensor[5].CFG.PowerlinkNode	:= 5;
	gVisionSensor[5].CFG.DataStructure	:= ADR(gOCR);
	gVisionSensor[2].CFG.ComponentLink	:= gCameraMeasurement;

	// -----------------------------------------------------------------------------------------------------------
	// Lights configuration
	// -----------------------------------------------------------------------------------------------------------	
	// Configuration for backlights
	gVisionLight[1].CFG.LightType		:= enumBarlight;
	gVisionLight[1].DAT.FlashColor		:= 1;
	gVisionLight[1].CFG.PowerlinkNode	:= 10;
	gVisionLight[2].CFG.LightType		:= enumBarlight;
	gVisionLight[2].DAT.FlashColor		:= 1;
	gVisionLight[2].CFG.PowerlinkNode	:= 11;
	
	cmdLoadRecipeAfterBoot	:= TRUE;
END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC
	// -----------------------------------------------------------------------------------------------------------	
	// Trigger selected backlight when selected sensor is triggered
	IF(EDGEPOS(gVisionSensor[visSelectedSensor].CMD.ImageTrigger)) THEN
		gVisionLight[visSelectedLight].DAT.Exposure		:= gVisionSensor[visSelectedSensor].DAT.Exposure;
		gVisionLight[visSelectedLight].DAT.NettimeDelay	:= gVisionSensor[visSelectedSensor].DAT.NettimeDelay;
		gVisionLight[visSelectedLight].CMD.FlashTrigger	:= TRUE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------	
	// Transfer data when loading a recipe
	IF EDGENEG(Recipe_01.CMD.Load) OR cmdLoadRecipeAfterBoot THEN
		cmdLoadRecipeAfterBoot := FALSE;
		gVisionSensor[visSelectedSensor].FCT.ApplicationName	:= RecipeData.ApplicationName;
		gVisionSensor[visSelectedSensor].DAT.Exposure			:= RecipeData.Exposure;
		gVisionSensor[visSelectedSensor].DAT.FlashColor			:= RecipeData.FlashColor;
		gVisionSensor[visSelectedSensor].DAT.FlashSegment		:= RecipeData.FlashSegment;
		gVisionSensor[visSelectedSensor].DAT.Focus				:= RecipeData.Focus;
		gVisionSensor[visSelectedSensor].DAT.Gain				:= RecipeData.Gain;
		gVisionSensor[visSelectedSensor].DAT.MaxItemCnt			:= RecipeData.MaxItemCnt;
		gVisionSensor[visSelectedSensor].DAT.Timeout			:= RecipeData.Timeout;
		// Switch vision application when recipe for blob was loaded
		gVisionSensor[1].CMD.VaSwitchApplication := TRUE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------	
	// Transfer data cyclic to the remanent variable
	IF NOT Recipe_01.CMD.Load THEN
		RecipeData.ApplicationName	:= gVisionSensor[visSelectedSensor].FCT.ApplicationName;
		RecipeData.Exposure			:= gVisionSensor[visSelectedSensor].DAT.Exposure;
		RecipeData.FlashColor		:= gVisionSensor[visSelectedSensor].DAT.FlashColor;
		RecipeData.FlashSegment		:= gVisionSensor[visSelectedSensor].DAT.FlashSegment;
		RecipeData.Focus			:= gVisionSensor[visSelectedSensor].DAT.Focus;
		RecipeData.Gain				:= gVisionSensor[visSelectedSensor].DAT.Gain;
		RecipeData.MaxItemCnt		:= gVisionSensor[visSelectedSensor].DAT.MaxItemCnt;
		RecipeData.Timeout			:= gVisionSensor[visSelectedSensor].DAT.Timeout;
	END_IF
	IF visSaveRecipe OR visNewRecipe THEN
		IF(visNewRecipe) THEN
			Recipe_01.CMD.New := TRUE;
		ELSE
			Recipe_01.CMD.Save := TRUE;
		END_IF
		visNewRecipe := FALSE;
		visSaveRecipe := FALSE;
	END_IF
END_PROGRAM