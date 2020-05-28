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
	Match ACCESS ADR(tmpMatch);
	CodeReader ACCESS ADR(tmpCodeReader);
	OCR ACCESS ADR(tmpOCR);
	MT ACCESS ADR(tmpMT);

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
		VisionSensor.CMD.VaListRefresh := TRUE;
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
			enumBlob:
				Blob ACCESS VisionSensor.CFG.DataStructure;
			enumMatch:
				Match ACCESS VisionSensor.CFG.DataStructure;
			enumCoderReader:
				CodeReader ACCESS VisionSensor.CFG.DataStructure;
			enumOCR:
				OCR ACCESS VisionSensor.CFG.DataStructure;
			enumMeasurement:
				MT ACCESS VisionSensor.CFG.DataStructure;
		END_CASE
	ELSE
		RETURN;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Code Reader - selected/detected types
	// -----------------------------------------------------------------------------------------------------------
	IF VisionSensor.CFG.VisionFunction = enumCoderReader THEN
		CodeReader.CodeType := UDINT_TO_USINT(brsatoi(ADR(visSelectedCodeTypePreset)));
		FOR idx:=1 TO MAX_NUM_RESULTS DO
			IF CodeReader.BarcodeType[idx] <> 0 THEN
				brsstrcpy(ADR(visSelectedCodeTypeDetected[idx]), ADR(CodeTypes[LIMIT(0, CodeReader.BarcodeType[idx], MAX_NUM_CODETYPES)]));
			ELSE
				brsstrcpy(ADR(visSelectedCodeTypeDetected[idx]), ADR(''));
			END_IF
		END_FOR
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Display camera status in hex - documenation is also in hex
	// -----------------------------------------------------------------------------------------------------------
	IF VisionSensor.DAT.Status = 0 THEN // Display only a single 0
		visCameraStatus := '0';
	ELSE // Display the status in Format 0x02000800
		visCameraStatus := '';
		FOR i := 0 TO 28 BY 4 DO
			visCameraStatus := CONCAT(MID(HexTab, 1, LIMIT(1, UDINT_TO_INT((SHR(VisionSensor.DAT.Status, i) AND 16#0000000F) + 1), 16)), visCameraStatus);
		END_FOR
		visCameraStatus := CONCAT('0x', visCameraStatus);
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
	// Create HTTP path for web control
	// -----------------------------------------------------------------------------------------------------------
	visHttpPath := 'http://192.168.200.';
	brsitoa(VisionSensor.CFG.PowerlinkNode, ADR(tmpStr1));
	brsstrcat(ADR(visHttpPath), ADR(tmpStr1));
	
	// -----------------------------------------------------------------------------------------------------------
	// Check if vision cockpit is open
	// -----------------------------------------------------------------------------------------------------------
	IF((VisionSensor.DAT.Status AND 16#8000_0000) > 0) THEN
		VisionSensor.DAT.CockpitIsActive := TRUE;
	ELSE
		VisionSensor.DAT.CockpitIsActive := FALSE;
	END_IF
		
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
	IF(NOT VisionSensor.HW.Connected OR NOT (VisionSensor.HW.Ready OR AutoSetupRunning) OR VisionSensor.DAT.ImageProcessingActive) THEN
		visEnableSetup := FALSE;
	ELSE
		visEnableSetup := TRUE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Transfer auto setup data to preset values
	// -----------------------------------------------------------------------------------------------------------
	IF(VisionSensor.CMD.AutoSetupStartStop AND VisionSensor.DAT.Status <> 0) THEN
		AutoSetupRunning := TRUE;
	ELSIF(VisionSensor.CMD.AutoSetupStartStop = FALSE) THEN
		AutoSetupRunning := FALSE;
	END_IF
	IF(VisionSensor.CMD.AutoSetupStartStop AND VisionSensor.DAT.Status = 0 AND AutoSetupRunning = TRUE) THEN
		VisionSensor.DAT.Gain				:= VisionSensor.DAT.AutoSetupGain;
		VisionSensor.DAT.Focus				:= VisionSensor.DAT.AutoSetupFocus;
		VisionSensor.DAT.Exposure			:= VisionSensor.DAT.AutoSetupExposure;
		VisionSensor.CMD.AutoSetupStartStop	:= FALSE;
		AutoSetupRunning					:= FALSE;
		visImageTrigger						:= TRUE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Fire trigger for camera image
	// -----------------------------------------------------------------------------------------------------------
	IF((visImageTrigger OR EDGEPOS(visEnableVision)) AND VisionSensor.HW.Ready AND NOT VisionSensor.DAT.ImageProcessingActive) THEN
		// Add default delay and fire trigger
		VisionSensor.DAT.NettimeDelay := NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
		VisionSensor.CMD.ImageTrigger := TRUE;
		visImageTrigger := FALSE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Repetitive mode
	// -----------------------------------------------------------------------------------------------------------
	visEnableRepetitive := visEnableCommand OR visRepetitiveMode; // Enable of the repetitive mode button. Don't disable while repetitive mode is active
	IF visRepetitiveMode THEN
		// Trigger new image every 0.5s
		RepetitiveModeTimer.IN := TRUE;
		RepetitiveModeTimer.PT := T#500ms;
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
	RepetitiveModeTimer();
	VisionSensor.DAT.Enable := visEnableVision AND NOT visRepetitiveMode;
	
	// -----------------------------------------------------------------------------------------------------------
	// Reset image trigger, reload web page and store image when process is finished
	// -----------------------------------------------------------------------------------------------------------
	IF ((VisionSensor.DAT.AcquisitionCompletedCnt <> AcquisitionCompletedCntOld OR VisionSensor.DAT.AcquisitionFailedCnt <> AcquisitionFailedCntOld) AND VisionSensor.DAT.ImageProcessingActive = FALSE) THEN
		AcquisitionCompletedCntOld		:= VisionSensor.DAT.AcquisitionCompletedCnt;
		AcquisitionFailedCntOld			:= VisionSensor.DAT.AcquisitionFailedCnt;
		VisionSensor.CMD.BrowserReload	:= TRUE;
		VisionSensor.CMD.ImageTrigger	:= FALSE;	
		// Store image to flash card
		IF visAutoArchiv AND NOT DisableAutoArchiv THEN
			gVisionImage.CMD.Save := TRUE;
		END_IF
		IF NOT visRepetitiveMode THEN
			DisableAutoArchiv := FALSE;
		END_IF
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Reset trigger when timed out
	// -----------------------------------------------------------------------------------------------------------
	IF VisionSensor.CMD.ImageTrigger THEN
		TriggerTimeout.IN := TRUE;
		TriggerTimeout.PT := UINT_TO_TIME(VisionSensor.DAT.Timeout)*2;
		IF TriggerTimeout.Q THEN
			VisionSensor.CMD.ImageTrigger := FALSE;
			VisionSensor.CMD.ImageTriggerReset := TRUE;
		END_IF
	ELSE
		TriggerTimeout.IN := FALSE;
		VisionSensor.CMD.ImageTriggerReset := FALSE;
	END_IF
	TriggerTimeout();

	// -----------------------------------------------------------------------------------------------------------
	// Auto reset web reload when stuck
	// -----------------------------------------------------------------------------------------------------------
	ReloadTimeout.PT := VisionSensor.DAT.Timeout/10;
	ReloadTimeout.IN := VisionSensor.CMD.BrowserReload;
	ReloadTimeout();
	IF(ReloadTimeout.Q) THEN
		ReloadTimeout.IN := FALSE;
		VisionSensor.CMD.BrowserReload := FALSE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Get list of vision applications and components
	// -----------------------------------------------------------------------------------------------------------
	IF (VisionSensor.CMD.VaListRefresh) THEN
		VaGetList_01.Enable := TRUE;
		VaGetList_01();
		VisionSensor.FCT.Status := ERR_FUB_BUSY;
				
		// -----------------------------------------------------------------------------------------------------------
		// OK
		IF(VaGetList_01.Status = ERR_OK) THEN
			// Make sure we dont exceed array limit
			IF(VaGetList_01.VaApplicationCnt > 0 AND VaGetList_01.VaApplicationCnt < SIZEOF(VisionSensor.FCT.ApplicationNameList)/SIZEOF(VisionSensor.FCT.ApplicationNameList[0])) THEN
				// Convert vision application list to main structure and mappView format
				FOR idx:=0 TO VaGetList_01.VaApplicationCnt - 1 DO
					VisionSensor.FCT.ApplicationNameList[idx] := VaGetList_01.VaApplicationNames[idx];
					String2DataProvider(ADR(VaGetList_01.VaApplicationNames[idx]), ADR(visVisionApplicationList[idx]));
				END_FOR
				VisionSensor.FCT.Status := ERR_OK;
			ELSE
				VisionSensor.FCT.Status := ERR_VA_LIST_NUM;				
			END_IF
			VisionSensor.FCT.ApplicationNameCnt := VaGetList_01.VaApplicationCnt;
			// Reset function block
			VaGetList_01.Enable := FALSE;
			VaGetList_01();
			VisionSensor.CMD.VaListRefresh := FALSE;
			// -----------------------------------------------------------------------------------------------------------
			// Error
		ELSIF(VaGetList_01.Status <> ERR_FUB_BUSY) THEN
			VisionSensor.FCT.Status := VaGetList_01.Status;
			VaGetList_01.Enable := FALSE;
			VaGetList_01();
			VisionSensor.CMD.VaListRefresh := FALSE;
		END_IF
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Load vision application
	// -----------------------------------------------------------------------------------------------------------
	IF (VisionSensor.CMD.VaSwitchApplication) THEN
		ViBaseLoadApplication_01.MpLink := ADR(VisionSensor.CFG.ComponentLink);
		ViBaseLoadApplication_01.Name := ADR(VisionSensor.FCT.ApplicationName);
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
	// Hide cross hairs on main page
	// -----------------------------------------------------------------------------------------------------------
	IF NOT visCrossHair.ShowCrosshair THEN
		FOR idx:=1 TO MAX_NUM_RESULTS DO
			visCrossHair.SvgTransformation[idx] := '';
			visCrossHair.SvgVisible[idx] := FALSE;
		END_FOR;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Draw cross hairs on main page
	// -----------------------------------------------------------------------------------------------------------
	IF(visSelectedSensor <> visSelectedSensorOld) THEN
		brsmemset(ADR(visCrossHair.SvgVisible), 0, SIZEOF(visCrossHair.SvgVisible));
	END_IF
	visSelectedSensorOld := visSelectedSensor;
	
	IF (EDGENEG(VisionSensor.DAT.ImageProcessingActive) AND visCrossHair.ShowCrosshair) OR EDGEPOS(visCrossHair.ShowCrosshair) OR (visCrossHair.DetailsNo <> DetailsNoOld) THEN
		// -----------------------------------------------------------------------------------------------------------
		// Handle details no
		IF(visCrossHair.DetailsNo < 1) THEN
			visCrossHair.DetailsNo := VisionSensor.DAT.ResultCnt;
		END_IF
		IF(visCrossHair.DetailsNo > VisionSensor.DAT.ResultCnt) THEN
			visCrossHair.DetailsNo := 1;
		END_IF		
		DetailsNoOld := visCrossHair.DetailsNo;
		
		// -----------------------------------------------------------------------------------------------------------
		// Create cross hairs and data for all results
		FOR idx := 1 TO MAX_NUM_RESULTS DO
			visCrossHair.SvgTransformation[idx] := '';
			visCrossHair.SvgVisible[idx] := FALSE;
			CrosshairPositionX := 0;
			CrosshairPositionY := 0;
			gVisionImage.DAT.Crosshair[idx].CrosshairX		:= 0;
			gVisionImage.DAT.Crosshair[idx].CrosshairY		:= 0;
			gVisionImage.DAT.Crosshair[idx].CrosshairRotate	:= 0;
			brsmemset(ADR(gVisionImage.DAT.Crosshair[idx].Text), 0, SIZEOF(gVisionImage.DAT.Crosshair[idx].Text));
			
			// -----------------------------------------------------------------------------------------------------------
			// Make sure we have data to display
			IF(VisionSensor.DAT.ResultCnt <> 0 AND idx <= VisionSensor.DAT.ResultCnt) THEN
				// Select data source from vision function
				CASE VisionSensor.CFG.VisionFunction OF
					enumBlob:
						CrosshairModelNumber := Blob.ModelNumber[idx];
						CrosshairPositionX := UDINT_TO_REAL(Blob.PositionX[idx]);    
						CrosshairPositionY := UDINT_TO_REAL(Blob.PositionY[idx]);    
						CrosshairOrientation := Blob.Orientation[idx];
					enumMatch:
						CrosshairModelNumber := Match.ModelNumber[idx]; 
						CrosshairPositionX := UDINT_TO_REAL(Match.PositionX[idx]);    
						CrosshairPositionY := UDINT_TO_REAL(Match.PositionY[idx]);    
						CrosshairOrientation := Match.Orientation[idx];
					enumCoderReader:
						CrosshairPositionX := UDINT_TO_REAL(CodeReader.PositionX[idx]);    
						CrosshairPositionY := UDINT_TO_REAL(CodeReader.PositionY[idx]);    
						CrosshairOrientation := CodeReader.Orientation[idx];
					enumOCR:
						CrosshairPositionX := UDINT_TO_REAL(OCR.PositionX[idx]);    
						CrosshairPositionY := UDINT_TO_REAL(OCR.PositionY[idx]);    
						CrosshairOrientation := OCR.Orientation[idx];
					enumMeasurement:
						IF(MT.UseResultAsXY = TRUE) THEN
							CrosshairPositionX := UDINT_TO_REAL(MT.Result[idx])/10;    
							CrosshairPositionY := UDINT_TO_REAL(MT.Result[idx+1])/10;
							idx := idx + 1;
						END_IF
				END_CASE
			
				// -----------------------------------------------------------------------------------------------------------
				// Show crosshair except for measurement function
				IF (VisionSensor.CFG.VisionFunction <> enumMeasurement OR MT.UseResultAsXY = TRUE) THEN
					// -----------------------------------------------------------------------------------------------------------
					// Set start values
					IF(CrosshairPositionX <> 0 AND CrosshairPositionY <> 0) THEN
						visCrossHair.SvgVisible[idx] := TRUE;
						
						// Highlight selected crosshair and show detailed information
						IF(visCrossHair.DetailsNo = idx) THEN
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
						gVisionImage.DAT.Crosshair[idx].CrosshairX := tmpXI - tmpC; 
						
						// Calculate cross hair Y offset
						tmpYI := CrosshairPositionY / visCrossHair.PixelRatio;
						brsitoa(REAL_TO_INT(tmpYI - tmpC), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						gVisionImage.DAT.Crosshair[idx].CrosshairY := tmpYI - tmpC; 
		
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
						visCrossHair.SvgTransformation[idx] := tmpStr1;
						gVisionImage.DAT.Crosshair[idx].CrosshairRotate := CrosshairOrientation/-100;
					
						// -----------------------------------------------------------------------------------------------------------
						// Add text data to selected cross hair
						IF(visCrossHair.DetailsNo = idx) THEN
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
						brsitoa(idx, ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR('</tspan></text>'));
										
						IF(visCrossHair.DetailsNo = idx) THEN
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
							IF(VisionSensor.CFG.VisionFunction = enumBlob AND Blob.EnhancedBlobInformation = 1) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Clipped: '), Blob.Clipped[idx]);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Gray: '), Blob.MeanGrayValue[idx]);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Length: '), UDINT_TO_REAL(Blob.Length[idx])/visCrossHair.PixelRatio);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Width: '), UDINT_TO_REAL(Blob.Width[idx])/visCrossHair.PixelRatio);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Area: '), UDINT_TO_REAL(Blob.Area[idx])/visCrossHair.PixelRatio);
							END_IF
							// Add detail information for match
							IF(VisionSensor.CFG.VisionFunction = enumMatch) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Score: '), Match.Score[idx]);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Scale: '), Match.Scale[idx]);
							END_IF
							// Add detail information for OCR
							IF(VisionSensor.CFG.VisionFunction = enumOCR) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Grading: '), OCR.Grading[idx]);
								brsstrcat(ADR(tmpStr1), ADR('<tspan class="text" x="10" dy="32">'));
								brsstrcat(ADR(tmpStr1), ADR('Text: '));
								brsstrcat(ADR(tmpStr1), ADR(OCR.Text[idx]));
								brsstrcat(ADR(tmpStr1), ADR('</tspan> '));
							END_IF
							// Add detail information for code reader
							IF(VisionSensor.CFG.VisionFunction = enumCoderReader) THEN
								brsstrcat(ADR(tmpStr1), ADR('<tspan class="text" x="10" dy="32">'));
								brsstrcat(ADR(tmpStr1), ADR('Code: '));
								brsstrcat(ADR(tmpStr1), ADR(CodeTypes[LIMIT(0, CodeReader.BarcodeType[idx], MAX_NUM_CODETYPES)]));
								brsstrcat(ADR(tmpStr1), ADR('</tspan> '));
							END_IF
							brsstrcat(ADR(tmpStr1), ADR('</text>'));
						END_IF
					END_IF
				// -----------------------------------------------------------------------------------------------------------
				// Add result information measurement
				ELSE
					visCrossHair.SvgTransformation[idx] := '[{"select":"#CrosshairRed","display":false}, {"select":"#CrosshairBlue","display":false}]';
					visCrossHair.SvgVisible[idx] := TRUE;
					brsstrcpy(ADR(tmpStr1), ADR('<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="10" y="'));
					brsitoa(idx*40, ADR(tmpStr2));
					brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
					brsstrcat(ADR(tmpStr1), ADR('"> '));
					CrosshairDetailsText(ADR(tmpStr1),  ADR('Result:'), UDINT_TO_REAL(MT.Result[idx])/1000);
					brsstrcat(ADR(tmpStr1), ADR('</text>'));
				END_IF	
				visCrossHair.SvgContent[idx] := tmpStr1;
				// for saving svg file
				brsstrcpy(ADR(gVisionImage.DAT.Crosshair[idx].Text), ADR(tmpStr1));
			// -----------------------------------------------------------------------------------------------------------
			// Show information that processing is disabled
			ELSIF(VisionSensor.DAT.ResultCnt = 0 AND visEnableVision = FALSE) THEN
				visCrossHair.SvgVisible[1] := TRUE;
				visCrossHair.SvgTransformation[1] := '[{"select":"#CrosshairRed","display":false}, {"select":"#CrosshairBlue","display":false}]';
				visCrossHair.SvgContent[1] := '<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="10" y="40"> Processing is disabled </text>';
			END_IF	
		END_FOR
	END_IF
	
END_PROGRAM
