// --------------------------------------------------------------------------------------------------------------------
// General vision task. This is a support task for the mappView visualization. The following functions are implemneted
// - Disable mappView functions when camera is not ready, available
// - Load image on main page when camera has finished inspection
// - Transfer parameters after vision setup
// - Draw crosshairs into image on the main page
// Version 2.0
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

	// Vision sensor - flash color
	brsitoa(VisionSensor.CFG.FlashColor, ADR(visSelectedFlashColor));
	visTableNo;
END_PROGRAM

PROGRAM _CYCLIC
	// -----------------------------------------------------------------------------------------------------------
	// Map global structure to local reference for mappView
	// -----------------------------------------------------------------------------------------------------------
	// Make sure we dont exceed array limit
	IF(visSelectedSensor > SIZEOF(gVisionSensor)/SIZEOF(gVisionSensor[1])) THEN
		visSelectedSensor := 1;
	END_IF
	IF(visSelectedSensor < 1) THEN
		visSelectedSensor := SIZEOF(gVisionSensor)/SIZEOF(gVisionSensor[1]);
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
				// Code Reader - selected/detected types
				CodeReader.CFG.CodeType := UDINT_TO_USINT(brsatoi(ADR(visSelectedCodeTypePreset)));
				FOR idx:=1 TO MAX_NUM_RESULTS DO
					brsitoa(CodeReader.DATA.BarcodeType[idx], ADR(visSelectedCodeTypeDetected[idx]));
				END_FOR;
			enumOCR:
				OCR ACCESS VisionSensor.CFG.DataStructure;
			enumMeasurement:
				MT ACCESS VisionSensor.CFG.DataStructure;
		END_CASE
	ELSE
		RETURN;
	END_IF
	// Vision Sensor - flash color
	VisionSensor.CFG.FlashColor := UDINT_TO_USINT(brsatoi(ADR(visSelectedFlashColor)));

	// -----------------------------------------------------------------------------------------------------------
	// Transfer data from global structure to mappView on selected camera change
	// -----------------------------------------------------------------------------------------------------------
	IF(visSelectedSensor <> visSelectedSensorOld) THEN
		// Vision Sensor - flash color
		brsitoa(VisionSensor.CFG.FlashColor, ADR(visSelectedFlashColor));
		brsmemset(ADR(visCrossHair.SvgVisible), 0, SIZEOF(visCrossHair.SvgVisible));
	END_IF
	visSelectedSensorOld := visSelectedSensor;
	
	// -----------------------------------------------------------------------------------------------------------
	// Create HTTP path for web control
	// -----------------------------------------------------------------------------------------------------------
	visHttpPath := 'http://192.168.200.';
	brsitoa(VisionSensor.CFG.PowerlinkNode, ADR(tmpStr1));
	brsstrcat(ADR(visHttpPath), ADR(tmpStr1));
	
	// -----------------------------------------------------------------------------------------------------------
	// Check if vision cockpit is open
	// -----------------------------------------------------------------------------------------------------------
	IF(VisionSensor.STA.Status = 16777216) THEN
		VisionSensor.STA.CockpitIsActive := TRUE;
	ELSE
		VisionSensor.STA.CockpitIsActive := FALSE;
	END_IF
		
	// -----------------------------------------------------------------------------------------------------------
	// Disable command buttons when camera is disconnected, not ready, processing an image or vision cockpit is open
	// -----------------------------------------------------------------------------------------------------------
	IF(NOT VisionSensor.HW.Connected OR NOT VisionSensor.HW.Ready OR VisionSensor.STA.ImageProcessingActive OR VisionSensor.STA.CockpitIsActive) THEN
		visEnableCommand := FALSE;
	ELSE
		visEnableCommand := TRUE;
	END_IF
	IF EDGEPOS(visEnableCommand) THEN
		visEnableVision := TRUE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Disable setup buttons when camera is disconnected, processing an image or not ready
	// -----------------------------------------------------------------------------------------------------------
	IF(NOT VisionSensor.HW.Connected OR NOT VisionSensor.HW.Ready OR VisionSensor.STA.ImageProcessingActive) THEN
		visEnableSetup := FALSE;
	ELSE
		visEnableSetup := TRUE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Fire trigger for camera image
	// -----------------------------------------------------------------------------------------------------------
	IF(visImageTrigger AND VisionSensor.HW.Ready AND NOT VisionSensor.STA.ImageProcessingActive) THEN
		// When nettime is used dealy trigger by 10ms
		IF(NettimeCurrent <> 0) THEN
			VisionSensor.CFG.NettimeDelay := NettimeCurrent + 10000;
		END_IF
		VisionSensor.CMD.ImageTrigger := TRUE;
		visImageTrigger := FALSE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Repetitive mode
	// -----------------------------------------------------------------------------------------------------------
	IF visRepetitiveMode THEN
		RepetitiveModeTimer.IN := TRUE;
		RepetitiveModeTimer.PT := T#500ms;
		IF RepetitiveModeTimer.Q THEN
			IF VisionSensor.HW.Ready AND NOT VisionSensor.STA.ImageProcessingActive THEN
				RepetitiveModeTimer.IN := FALSE;
				VisionSensor.CMD.ImageTrigger := TRUE;
			END_IF
		END_IF
		DisableAutoArchiv := TRUE;
	ELSE
		RepetitiveModeTimer.IN := TRUE;
	END_IF
	RepetitiveModeTimer();
	VisionSensor.CFG.Enable := visEnableVision AND NOT visRepetitiveMode; 
	
	// -----------------------------------------------------------------------------------------------------------
	// Reset image trigger, reload web page and store image when process is finished
	// -----------------------------------------------------------------------------------------------------------
	IF ((VisionSensor.STA.AcquisitionCompletedCnt <> AcquisitionCompletedCntOld OR VisionSensor.STA.AcquisitionFailedCnt <> AcquisitionFailedCntOld) AND VisionSensor.STA.ImageProcessingActive = FALSE) THEN
		AcquisitionCompletedCntOld := VisionSensor.STA.AcquisitionCompletedCnt;
		AcquisitionFailedCntOld := VisionSensor.STA.AcquisitionFailedCnt;
		VisionSensor.CMD.BrowserReload := TRUE;
		VisionSensor.CMD.ImageTrigger := FALSE;	
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
		TriggerTimeout.PT := VisionSensor.CFG.Timeout/5;
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
	ReloadTimeout.PT := VisionSensor.CFG.Timeout/10;
	ReloadTimeout.IN := VisionSensor.CMD.BrowserReload;
	ReloadTimeout();
	IF(ReloadTimeout.Q) THEN
		ReloadTimeout.IN := FALSE;
		VisionSensor.CMD.BrowserReload := FALSE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Transfer auto setup data to preset values
	// -----------------------------------------------------------------------------------------------------------
	IF(EDGEPOS(VisionSensor.CMD.AutoSetupTransfer)) THEN
		VisionSensor.CFG.Gain := VisionSensor.STA.AutoSetupGain;
		VisionSensor.CFG.Focus := VisionSensor.STA.AutoSetupFocus;
		VisionSensor.CFG.Exposure := VisionSensor.STA.AutoSetupExposure;
		VisionSensor.CMD.AutoSetupTransfer := FALSE;
		VisionSensor.CMD.AutoSetupStartStop := FALSE;
		VisionSensor.CMD.ImageTrigger := TRUE;
	END_IF
	
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
	IF (EDGENEG(VisionSensor.STA.ImageProcessingActive) AND visCrossHair.ShowCrosshair) OR EDGEPOS(visCrossHair.ShowCrosshair) OR (visCrossHair.DetailsNo <> DetailsNoOld) THEN
		// Handle details no
		IF(visCrossHair.DetailsNo < 1) THEN
			visCrossHair.DetailsNo := VisionSensor.STA.ResultCnt;
		END_IF
		IF(visCrossHair.DetailsNo > VisionSensor.STA.ResultCnt) THEN
			visCrossHair.DetailsNo := 1;
		END_IF		
		DetailsNoOld := visCrossHair.DetailsNo;
		
		// Create cross hairs and data for all results
		FOR idx := 1 TO MAX_NUM_RESULTS DO
			visCrossHair.SvgTransformation[idx] := '';
			visCrossHair.SvgVisible[idx] := FALSE;
			CrosshairPositionX := 0;
			CrosshairPositionY := 0;
			gVisionImage.DATA.Crosshair[idx].CrosshairX		:= 0;
			gVisionImage.DATA.Crosshair[idx].CrosshairY		:= 0;
			gVisionImage.DATA.Crosshair[idx].CrosshairRotate	:= 0;
			brsmemset(ADR(gVisionImage.DATA.Crosshair[idx].Text), 0, SIZEOF(gVisionImage.DATA.Crosshair[idx].Text));

			// Make sure we have data to display
			IF(VisionSensor.STA.ResultCnt <> 0 AND idx <= VisionSensor.STA.ResultCnt) THEN
				// Select data source from vision function
				CASE VisionSensor.CFG.VisionFunction OF
					enumBlob:
						CrosshairModelNumber := Blob.DATA.ModelNumber[idx];
						CrosshairPositionX := UDINT_TO_REAL(Blob.DATA.PositionX[idx]);    
						CrosshairPositionY := UDINT_TO_REAL(Blob.DATA.PositionY[idx]);    
						CrosshairOrientation := Blob.DATA.Orientation[idx];
					enumMatch:
						CrosshairModelNumber := Match.DATA.ModelNumber[idx]; 
						CrosshairPositionX := UDINT_TO_REAL(Match.DATA.PositionX[idx]);    
						CrosshairPositionY := UDINT_TO_REAL(Match.DATA.PositionY[idx]);    
						CrosshairOrientation := Match.DATA.Orientation[idx];
					enumCoderReader:
						CrosshairPositionX := UDINT_TO_REAL(CodeReader.DATA.PositionX[idx]);    
						CrosshairPositionY := UDINT_TO_REAL(CodeReader.DATA.PositionY[idx]);    
						CrosshairOrientation := CodeReader.DATA.Orientation[idx];
					enumOCR:
						CrosshairPositionX := UDINT_TO_REAL(OCR.DATA.PositionX[idx]);    
						CrosshairPositionY := UDINT_TO_REAL(OCR.DATA.PositionY[idx]);    
						CrosshairOrientation := OCR.DATA.Orientation[idx];
					enumMeasurement:
						IF(MT.CFG.UseResultAsXY = TRUE) THEN
							CrosshairPositionX := UDINT_TO_REAL(MT.DATA.Result[idx])/10;    
							CrosshairPositionY := UDINT_TO_REAL(MT.DATA.Result[idx+1])/10;
							idx := idx + 1;
						END_IF
				END_CASE
			
				// Show crosshair except for measurement function
				IF (VisionSensor.CFG.VisionFunction <> enumMeasurement OR MT.CFG.UseResultAsXY = TRUE) THEN
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
						gVisionImage.DATA.Crosshair[idx].CrosshairX := tmpXI - tmpC; 
						
						// Calculate cross hair Y offset
						tmpYI := CrosshairPositionY / visCrossHair.PixelRatio;
						brsitoa(REAL_TO_INT(tmpYI - tmpC), ADR(tmpStr2));
						brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
						gVisionImage.DATA.Crosshair[idx].CrosshairY := tmpYI - tmpC; 
		
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
						gVisionImage.DATA.Crosshair[idx].CrosshairRotate := CrosshairOrientation/-100;
					
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
							// Add text data to cross hair
							brsstrcat(ADR(tmpStr1), ADR('<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="10" y="10"> '));
							
							// Add modell ID information for blob and match
							IF(VisionSensor.CFG.VisionFunction = enumBlob OR VisionSensor.CFG.VisionFunction = enumMatch) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('ID:'), CrosshairModelNumber);
							END_IF
							// Add X and Y position information
							IF(CrosshairPositionX <> 0) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Pos X:'), CrosshairPositionX/visCrossHair.PixelRatio);
							END_IF	
							IF(CrosshairPositionY <> 0) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Pos Y:'), CrosshairPositionY/visCrossHair.PixelRatio);
							END_IF		
							// Add orientation information
							IF(VisionSensor.CFG.VisionFunction <> enumMeasurement) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Orientation:'), CrosshairOrientation/visCrossHair.PixelRatio);
							END_IF
							// Add detail information for blob
							IF(VisionSensor.CFG.VisionFunction = enumBlob) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Clipped:'), Blob.DATA.Clipped[idx]);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Gray:'), Blob.DATA.MeanGrayValue[idx]);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Length:'), UDINT_TO_REAL(Blob.DATA.Length[idx])/visCrossHair.PixelRatio);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Width:'), UDINT_TO_REAL(Blob.DATA.Width[idx])/visCrossHair.PixelRatio);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Area:'), UDINT_TO_REAL(Blob.DATA.Area[idx])/visCrossHair.PixelRatio);
							END_IF
							// Add detail information for match
							IF(VisionSensor.CFG.VisionFunction = enumMatch) THEN
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Score:'), Match.DATA.Score[idx]);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Scale:'), Match.DATA.Scale[idx]);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Code:'), UDINT_TO_REAL(CodeReader.DATA.BarcodeType[idx]));
							END_IF
							brsstrcat(ADR(tmpStr1), ADR('</text>'));
						END_IF
					END_IF
				// Add result information measurement
				ELSE
					visCrossHair.SvgTransformation[idx] := '[{"select":"#CrosshairRed","display":false}, {"select":"#CrosshairBlue","display":false}]';
					visCrossHair.SvgVisible[idx] := TRUE;
					brsstrcpy(ADR(tmpStr1), ADR('<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="10" y="'));
					brsitoa(idx*40, ADR(tmpStr2));
					brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
					brsstrcat(ADR(tmpStr1), ADR('"> '));
					CrosshairDetailsText(ADR(tmpStr1),  ADR('Result:'), UDINT_TO_REAL(MT.DATA.Result[idx])/1000);
					brsstrcat(ADR(tmpStr1), ADR('</text>'));
				END_IF	
				visCrossHair.SvgContent[idx] := tmpStr1;
				// for saving svg file
				brsstrcpy(ADR(gVisionImage.DATA.Crosshair[idx].Text), ADR(tmpStr1)); 
			END_IF	
		END_FOR
	END_IF
	
END_PROGRAM
