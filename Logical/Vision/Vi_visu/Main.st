// --------------------------------------------------------------------------------------------------------------------
// This is a support task for the mappView visualization. The following functions are implemneted
// - Disable mappView functions when camera is not ready, available
// - Transfer parameters after vision setup
// Version 2.x (Check revision history for details)
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	// -----------------------------------------------------------------------------------------------------------
	// Map global structure to local reference
	VisionSensor ACCESS ADR(gVisionSensor[gSelectedSensor]);
	Blob ACCESS ADR(tmpBlob);
	CodeReader ACCESS ADR(tmpCodeReader);
	Match ACCESS ADR(tmpMatch);
	MT ACCESS ADR(tmpMT);
	OCR ACCESS ADR(tmpOCR);
	Pixel ACCESS ADR(tmpPixel);
	
	// Map global structure to local reference
	VisionLight ACCESS ADR(gVisionLight[gSelectedLight]);

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
	// Select first available camera after reboot
	IF InitialSearchSensor THEN 
		FOR i := 1 TO MAX_NUM_CAMS DO
			IF gVisionSensor[i].HW.Connected THEN
				gSelectedSensor := i;
				InitialSearchSensor := FALSE;
				EXIT;
			END_IF
		END_FOR
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Map global structure to local reference for mappView
	// -----------------------------------------------------------------------------------------------------------
	// Make sure we dont exceed array limit
	IF(gSelectedSensor > MAX_NUM_CAMS) THEN
		gSelectedSensor := 1;
	END_IF
	IF(gSelectedSensor < 1) THEN
		gSelectedSensor := MAX_NUM_CAMS;
	END_IF

	// Assign pointers
	VisionSensor ACCESS ADR(gVisionSensor[gSelectedSensor]);
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

	// Display camera status
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
	IF visSensorFlashColor <> visSensorFlashColorOld THEN
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
	IF(NOT VisionSensor.HW.Connected OR NOT (VisionSensor.HW.Ready OR AutoSetupRunning[gSelectedSensor]) OR VisionSensor.DAT.ImageProcessingActive) THEN
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
		// Hide previous results
		FOR i := 1 TO MAX_NUM_RESULTS DO
			visCrossHair.SvgVisible[i] := FALSE;
		END_FOR;			
		VisionSensor.CMD.ImageTrigger	:= TRUE;
		visImageTrigger					:= FALSE;
		VisionSensor.DAT.Active			:= TRUE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Get image from camera
	// -----------------------------------------------------------------------------------------------------------
	IF EDGENEG(VisionSensor.CMD.ImageTrigger) THEN
		gVisionImage.CFG.ComponentLink := gVisionSensor[gSelectedSensor].CFG.ComponentLink;
		gVisionImage.CMD.GetImage := TRUE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Repetitive mode
	// -----------------------------------------------------------------------------------------------------------
	visEnableRepetitive := visSensorEnableCommand OR visRepetitiveMode;
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
		VisionSensor.DAT.Enable := FALSE;
	ELSE
		RepetitiveModeTimer.IN := TRUE;
	END_IF
	RepetitiveModeTimer(PT := T#3000ms);

	// -----------------------------------------------------------------------------------------------------------
	// Select first available light after reboot
	// -----------------------------------------------------------------------------------------------------------
	IF InitialSearchLight THEN 
		FOR i := 1 TO MAX_NUM_LIGHTS DO
			IF gVisionLight[i].HW.Connected THEN
				gSelectedLight := i;
				InitialSearchLight := FALSE;
				EXIT;
			END_IF
		END_FOR
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Map global structure to local reference
	// -----------------------------------------------------------------------------------------------------------
	// Make sure we dont exceed array limit
	IF(gSelectedLight > MAX_NUM_LIGHTS) THEN
		gSelectedLight := 1;
	END_IF
	IF(gSelectedLight < 1) THEN
		gSelectedLight := MAX_NUM_LIGHTS;
	END_IF
	VisionLight ACCESS ADR(gVisionLight[gSelectedLight]);
	
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
	
	// -----------------------------------------------------------------------------------------------------------
	// Draw cross hairs on main page
	// -----------------------------------------------------------------------------------------------------------
	IF (EDGENEG(gVisionImage.CMD.GetImage) AND visCrossHair.ShowCrosshair) OR EDGEPOS(visCrossHair.ShowCrosshair) OR (visCrossHair.DetailsNo <> DetailsNoOld) THEN
		// -----------------------------------------------------------------------------------------------------------
		// Handle details no
		IF(visCrossHair.DetailsNo < 1) THEN
			visCrossHair.DetailsNo := VisionSensor.DAT.ResultCnt;
		END_IF
		IF(visCrossHair.DetailsNo > VisionSensor.DAT.ResultCnt) THEN
			visCrossHair.DetailsNo := 1;
		END_IF
		IF visCrossHair.PixelRatio = 0 THEN
			RETURN;
		END_IF
		DetailsNoOld := visCrossHair.DetailsNo;
		brsmemset(ADR(gVisionImage.DAT.Crosshair), 0, SIZEOF(gVisionImage.DAT.Crosshair));
		
		// -----------------------------------------------------------------------------------------------------------
		// Create cross hairs and data for all results
		FOR i := 1 TO MAX_NUM_RESULTS DO
			visCrossHair.SvgTransformation[i] := '';
			visCrossHair.SvgVisible[i] := FALSE;
			CrosshairPositionX := 0;
			CrosshairPositionY := 0;
			gVisionImage.DAT.Crosshair[i].CrosshairX		:= 0;
			gVisionImage.DAT.Crosshair[i].CrosshairY		:= 0;
			gVisionImage.DAT.Crosshair[i].CrosshairRotate	:= 0;
			brsmemset(ADR(gVisionImage.DAT.Crosshair[i].Text), 0, SIZEOF(gVisionImage.DAT.Crosshair[i].Text));
			
			// -----------------------------------------------------------------------------------------------------------
			// Make sure we have data to display
			IF(VisionSensor.DAT.ResultCnt <> 0 AND i <= VisionSensor.DAT.ResultCnt) THEN
				// Select data source from vision function
				CASE VisionSensor.CFG.VisionFunction OF
					enumBlob:
						CrosshairModelNumber := gBlob.ModelNumber[i];
						CrosshairPositionX := UDINT_TO_REAL(gBlob.PositionX[i]);    
						CrosshairPositionY := UDINT_TO_REAL(gBlob.PositionY[i]);    
						CrosshairOrientation := gBlob.Orientation[i];
					enumMatch:
						CrosshairModelNumber := gMatch.ModelNumber[i]; 
						CrosshairPositionX := UDINT_TO_REAL(gMatch.PositionX[i]);    
						CrosshairPositionY := UDINT_TO_REAL(gMatch.PositionY[i]);    
						CrosshairOrientation := gMatch.Orientation[i];
					enumCoderReader:
						CrosshairPositionX := UDINT_TO_REAL(gCodeReader.PositionX[i]);    
						CrosshairPositionY := UDINT_TO_REAL(gCodeReader.PositionY[i]);    
						CrosshairOrientation := gCodeReader.Orientation[i];
					enumOCR:
						CrosshairPositionX := UDINT_TO_REAL(gOCR.PositionX[i]);    
						CrosshairPositionY := UDINT_TO_REAL(gOCR.PositionY[i]);    
						CrosshairOrientation := gOCR.Orientation[i];
					enumMeasurement:
						IF(gMT.UseResultAsXY = TRUE) THEN
							CrosshairPositionX := UDINT_TO_REAL(gMT.Result[i])/10;    
							CrosshairPositionY := UDINT_TO_REAL(gMT.Result[i+1])/10;
							i := i + 1;
						END_IF
				END_CASE
			
				// -----------------------------------------------------------------------------------------------------------
				// Show crosshair except for measurement function
				IF (VisionSensor.CFG.VisionFunction <> enumMeasurement OR gMT.UseResultAsXY = TRUE) THEN
					// -----------------------------------------------------------------------------------------------------------
					// Set start values
					IF(CrosshairPositionX <> 0 AND CrosshairPositionY <> 0) THEN
						visCrossHair.SvgVisible[i] := TRUE;
						
						// Highlight selected crosshair and show detailed information
						IF(visCrossHair.DetailsNo = i) THEN
							tmpStr1 := '[{"select":"#CrosshairBlue","display":false}, {"select":"#CrosshairRed","display":true, "translate":[';
						ELSE
							tmpStr1 := '[{"select":"#CrosshairRed","display":false}, { "select":"#CrosshairBlue","display":true, "translate":[';
						END_IF
						
						// Calculate cross hair X offset
						tmpXI := CrosshairPositionX / visCrossHair.PixelRatio;
						tmpC := USINT_TO_REAL(visCrossHair.Size) * visCrossHair.Scale / 2.0;
						brsitoa(REAL_TO_INT(tmpXI - tmpC), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(','));
						gVisionImage.DAT.Crosshair[i].CrosshairX := tmpXI - tmpC; 
						
						// Calculate cross hair Y offset
						tmpYI := CrosshairPositionY / visCrossHair.PixelRatio;
						brsitoa(REAL_TO_INT(tmpYI - tmpC), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						gVisionImage.DAT.Crosshair[i].CrosshairY := tmpYI - tmpC; 
		
						// Add cross hair scaling
						brsstrcat(ADR(tmpStr1), ADR('],"scale":['));
						brsftoa(visCrossHair.Scale, ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(','));
						brsftoa(visCrossHair.Scale, ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
	
						// Add cross hair rotation
						brsstrcat(ADR(tmpStr1), ADR('],"spin":['));
						brsftoa(CrosshairOrientation/-100, ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(','));
						brsitoa(visCrossHair.Size/2, ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(','));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(']}]'));
						visCrossHair.SvgTransformation[i] := tmpStr1;
						gVisionImage.DAT.Crosshair[i].CrosshairRotate := CrosshairOrientation/-100;
					
						// -----------------------------------------------------------------------------------------------------------
						// Add text data to selected cross hair
						IF(visCrossHair.DetailsNo = i) THEN
							tmpStr1 := '<text class="cText" fill="red" font-size="22" font-family="Helvetica, Arial, sans-serif" x="';
						ELSE
							tmpStr1 := '<text class="cText" fill="blue" font-size="22" font-family="Helvetica, Arial, sans-serif" x="';
						END_IF
						brsitoa(REAL_TO_INT(tmpXI - tmpC + visCrossHair.Size), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR('" y="'));
						brsitoa(REAL_TO_INT(tmpYI - tmpC + visCrossHair.Size/2), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR('"> '));
	
						// Create prototype for new entry
						tmpStr3:= '<tspan class="text" x="';
						brsitoa(REAL_TO_INT(tmpXI + tmpC), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr3), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr3), ADR('" dy="-5" >'));
	
						// Add result no information
						brsstrcat(ADR(tmpStr1), ADR(tmpStr3));
						brsitoa(i, ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR('</tspan></text>'));
										
						IF(visCrossHair.DetailsNo = i) THEN
							// -----------------------------------------------------------------------------------------------------------
							// Add text data from selected cross hair
							brsstrcat(ADR(tmpStr1), ADR('<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="10" y="10"> '));
							
							// Add modell ID information for blob and match
							IF(VisionSensor.CFG.VisionFunction = enumBlob OR VisionSensor.CFG.VisionFunction = enumMatch) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('ID: '), CrosshairModelNumber);
							END_IF
							// Add X and Y position information
							IF(CrosshairPositionX <> 0) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Pos X: '), CrosshairPositionX/visCrossHair.PixelRatio);
							END_IF	
							IF(CrosshairPositionY <> 0) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Pos Y: '), CrosshairPositionY/visCrossHair.PixelRatio);
							END_IF		
							// Add orientation information
							IF(VisionSensor.CFG.VisionFunction <> enumMeasurement) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Orientation: '), CrosshairOrientation/visCrossHair.PixelRatio);
							END_IF
							// Add detail information for blob
							IF(VisionSensor.CFG.VisionFunction = enumBlob AND gBlob.EnhancedBlobInformation = 1) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Clipped: '), gBlob.Clipped[i]);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Gray: '), gBlob.MeanGrayValue[i]);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Length: '), UDINT_TO_REAL(gBlob.Length[i])/visCrossHair.PixelRatio);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Width: '), UDINT_TO_REAL(gBlob.Width[i])/visCrossHair.PixelRatio);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Area: '), UDINT_TO_REAL(gBlob.Area[i])/visCrossHair.PixelRatio);
							END_IF
							// Add detail information for match
							IF(VisionSensor.CFG.VisionFunction = enumMatch) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Score: '), gMatch.Score[i]);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Scale: '), gMatch.Scale[i]);
							END_IF
							// Add detail information for code reader
							IF(VisionSensor.CFG.VisionFunction = enumCoderReader) THEN
								//CrosshairDetailsText(ADR(tmpStr1),  ADR('Code:'), UDINT_TO_REAL(CodeReader.BarcodeType[i]));
								tmpStr2:= '<tspan class="text" x="10" dy="32">';
								brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
								brsstrcat(ADR(tmpStr1), ADR('Code: '));
								brsstrcat(ADR(tmpStr1), ADR(CodeTypes[LIMIT(0, gCodeReader.BarcodeType[i], MAX_NUM_CODETYPES)]));
								brsstrcat(ADR(tmpStr1), ADR('</tspan> '));
							END_IF
							brsstrcat(ADR(tmpStr1), ADR('</text>'));
						END_IF
					END_IF
					// -----------------------------------------------------------------------------------------------------------
					// Add result information measurement
				ELSE
					visCrossHair.SvgTransformation[i] := '[{"select":"#CrosshairRed","display":false}, {"select":"#CrosshairBlue","display":false}]';
					visCrossHair.SvgVisible[i] := TRUE;
					brsstrcpy(ADR(tmpStr1), ADR('<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="10" y="'));
					brsitoa(i*40, ADR(tmpStr2));
					brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
					brsstrcat(ADR(tmpStr1), ADR('"> '));
					CrosshairDetailsText(ADR(tmpStr1),  ADR('Result:'), UDINT_TO_REAL(gMT.Result[i])/1000);
					brsstrcat(ADR(tmpStr1), ADR('</text>'));
				END_IF	
				visCrossHair.SvgContent[i] := tmpStr1;
				// for saving svg file
				brsstrcpy(ADR(gVisionImage.DAT.Crosshair[i].Text), ADR(tmpStr1));
			END_IF	
		END_FOR
	END_IF
END_PROGRAM
