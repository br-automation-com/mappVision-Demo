FUNCTION_BLOCK ViDrawCrosshair
	// Assign pointers
	IF VisionSensor.CFG.DataStructure <> 0 THEN
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
	
	// Hide cross hairs
	IF NOT visCrossHair.ShowCrosshair THEN
		brsmemset(ADR(visCrossHair.SvgTransformation), 0, SIZEOF(visCrossHair.SvgTransformation));
		brsmemset(ADR(visCrossHair.SvgVisible), 0, SIZEOF(visCrossHair.SvgVisible));
	END_IF
	
	// Draw cross hairs
	IF CmdRefreshCrosshair OR NOT ShowCrosshairOld OR (visCrossHair.DetailsNo <> DetailsNoOld) OR (SelectedSensor <> SelectedSensorOld) THEN
		SelectedSensorOld := SelectedSensor;
		// First delete transformation and make everything invisible
		brsmemset(ADR(visCrossHair.SvgTransformation), 0, SIZEOF(visCrossHair.SvgTransformation));
		brsmemset(ADR(visCrossHair.SvgVisible), 0, SIZEOF(visCrossHair.SvgVisible));
		IF visCrossHair.ShowCrosshair THEN
			// Handle details no
			IF visCrossHair.DetailsNo < 1 THEN
				visCrossHair.DetailsNo := VisionSensor.DAT.ResultCnt;
			END_IF
			IF visCrossHair.DetailsNo > VisionSensor.DAT.ResultCnt THEN
				visCrossHair.DetailsNo := 1;
			END_IF
			DetailsNoOld := visCrossHair.DetailsNo;
			
			// Create cross hairs and data for all results
			FOR idx := 1 TO MAX_NUM_RESULTS DO
				CrosshairPositionX := 0;
				CrosshairPositionY := 0;
				CrossHairInfo[idx].CrosshairX		:= 0;
				CrossHairInfo[idx].CrosshairY		:= 0;
				CrossHairInfo[idx].CrosshairRotate	:= 0;
				brsmemset(ADR(CrossHairInfo[idx].Text), 0, SIZEOF(CrossHairInfo[idx].Text));
				
				// Make sure we have data to display
				IF VisionSensor.DAT.ResultCnt <> 0 AND idx <= VisionSensor.DAT.ResultCnt THEN
					// Select data source from vision function
					CASE VisionSensor.CFG.VisionFunction OF
						enumBlob:
							CrosshairModelNumber	:= Blob.ModelNumber[idx];
							CrosshairPositionX		:= UDINT_TO_REAL(Blob.PositionX[idx]);
							CrosshairPositionY		:= UDINT_TO_REAL(Blob.PositionY[idx]);
							CrosshairOrientation	:= Blob.Orientation[idx];
						enumMatch:
							CrosshairModelNumber	:= Match.ModelNumber[idx]; 
							CrosshairPositionX		:= UDINT_TO_REAL(Match.PositionX[idx]);
							CrosshairPositionY		:= UDINT_TO_REAL(Match.PositionY[idx]);
							CrosshairOrientation	:= Match.Orientation[idx];
						enumCoderReader:
							CrosshairPositionX		:= UDINT_TO_REAL(CodeReader.PositionX[idx]);
							CrosshairPositionY		:= UDINT_TO_REAL(CodeReader.PositionY[idx]);
							CrosshairOrientation	:= CodeReader.Orientation[idx];
						enumOCR:
							CrosshairPositionX		:= UDINT_TO_REAL(OCR.PositionX[idx]);
							CrosshairPositionY		:= UDINT_TO_REAL(OCR.PositionY[idx]);
							CrosshairOrientation	:= OCR.Orientation[idx];
						enumMeasurement:
							IF MT.UseResultAsXY THEN
								CrosshairPositionX	:= UDINT_TO_REAL(MT.Result[idx])/10;
								CrosshairPositionY	:= UDINT_TO_REAL(MT.Result[idx+1])/10;
								idx := idx + 1;
							END_IF
							MT.UseResultAsXY := TRUE; // use this variable because of in case Visionfunction != MT then the Pointer MT is not initialized
					END_CASE
				
					// Show crosshair except for measurement function
					IF VisionSensor.CFG.VisionFunction <> enumMeasurement OR MT_UseXY THEN
						IF CrosshairPositionX <> 0 AND CrosshairPositionY <> 0 THEN
							visCrossHair.SvgVisible[idx] := TRUE;
							// Highlight selected crosshair and show detailed information
							IF visCrossHair.DetailsNo = idx THEN
								tmpStr1 := '[{"select":"#CrosshairBlue","display":false}, {"select":"#CrosshairRed","display":true, "translate":[';
							ELSE
								tmpStr1 := '[{"select":"#CrosshairRed","display":false}, { "select":"#CrosshairBlue","display":true, "translate":[';
							END_IF
							
							// Calculate cross hair X and Y offset
							tmpXI := CrosshairPositionX / visCrossHair.PixelRatio;
							tmpYI := CrosshairPositionY / visCrossHair.PixelRatio;
							tmpC := USINT_TO_REAL(visCrossHair.Size) * visCrossHair.Scale / 2.0;
							brsitoa(REAL_TO_INT(tmpXI - tmpC), ADR(tmpStr2));
							brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
							brsstrcat(ADR(tmpStr1), ADR(','));
							brsitoa(REAL_TO_INT(tmpYI - tmpC), ADR(tmpStr2));
							brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
							CrossHairInfo[idx].CrosshairX := tmpXI - tmpC;
							CrossHairInfo[idx].CrosshairY := tmpYI - tmpC;
			
							// Add cross hair scaling
							brsstrcat(ADR(tmpStr1), ADR('],"scale":['));
							brsftoa(visCrossHair.Scale, ADR(tmpStr2));
							brsstrcat(ADR(tmpStr1), ADR(tmpStr2));
							brsstrcat(ADR(tmpStr1), ADR(','));
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
							CrossHairInfo[idx].CrosshairRotate := CrosshairOrientation/-100;
						
							// Add text data to selected cross hair
							IF visCrossHair.DetailsNo = idx THEN
								tmpStr1 := '<text class="cText" fill="red " font-size="22" font-family="Helvetica, Arial, sans-serif" x="';
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
							
							// for saving svg file. The texts added below are not of interest for the saved SVG, so copy it now before adding the details information
							brsstrcpy(ADR(CrossHairInfo[idx].Text), ADR(tmpStr1));
							blueTextPos := FIND(CrossHairInfo[idx].Text, 'fill="blue"'); // Make all texts red. In the SVG is no highlighted crosshair
							IF blueTextPos > 2 THEN
								brsmemcpy(ADR(CrossHairInfo[idx].Text) + blueTextPos - 1, ADR('fill="red "'), 11);
							END_IF
							
							IF visCrossHair.DetailsNo = idx THEN // Add text data from selected cross hair in the top left corner of the image
								brsstrcat(ADR(tmpStr1), ADR('<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="10" y="10"> '));
								
								// Add model ID information for blob and match
								IF VisionSensor.CFG.VisionFunction = enumBlob OR VisionSensor.CFG.VisionFunction = enumMatch THEN
									CrosshairDetailsText(ADR(tmpStr1),  ADR('ID: '), CrosshairModelNumber);
								END_IF
								// Add X and Y position information
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Pos X: '), CrosshairPositionX/visCrossHair.PixelRatio);
								CrosshairDetailsText(ADR(tmpStr1),  ADR('Pos Y: '), CrosshairPositionY/visCrossHair.PixelRatio);
								// Add orientation information
								IF VisionSensor.CFG.VisionFunction <> enumMeasurement THEN
									CrosshairDetailsText(ADR(tmpStr1),  ADR('Orientation: '), CrosshairOrientation/visCrossHair.PixelRatio);
								END_IF
								// Add detail information for blob
								IF VisionSensor.CFG.VisionFunction = enumBlob AND Blob.EnhancedBlobInformation = 1 THEN
									CrosshairDetailsText(ADR(tmpStr1),  ADR('Clipped: '), Blob.Clipped[idx]);
									CrosshairDetailsText(ADR(tmpStr1),  ADR('Gray: '), Blob.MeanGrayValue[idx]);
									CrosshairDetailsText(ADR(tmpStr1),  ADR('Length: '), UDINT_TO_REAL(Blob.Length[idx])/visCrossHair.PixelRatio);
									CrosshairDetailsText(ADR(tmpStr1),  ADR('Width: '), UDINT_TO_REAL(Blob.Width[idx])/visCrossHair.PixelRatio);
									CrosshairDetailsText(ADR(tmpStr1),  ADR('Area: '), UDINT_TO_REAL(Blob.Area[idx])/visCrossHair.PixelRatio);
								END_IF
								// Add detail information for match
								IF VisionSensor.CFG.VisionFunction = enumMatch THEN
									CrosshairDetailsText(ADR(tmpStr1),  ADR('Score: '), Match.Score[idx]);
									CrosshairDetailsText(ADR(tmpStr1),  ADR('Scale: '), Match.Scale[idx]);
								END_IF
								// Add detail information for OCR
								IF VisionSensor.CFG.VisionFunction = enumOCR THEN
									CrosshairDetailsText(ADR(tmpStr1),  ADR('Grading: '), OCR.Grading[idx]);
									brsstrcat(ADR(tmpStr1), ADR('<tspan class="text" x="10" dy="32">'));
									brsstrcat(ADR(tmpStr1), ADR('Text: '));
									brsstrcat(ADR(tmpStr1), ADR(OCR.Text[idx]));
									brsstrcat(ADR(tmpStr1), ADR('</tspan> '));
								END_IF
								// Add detail information for code reader
								IF VisionSensor.CFG.VisionFunction = enumCoderReader THEN
									brsstrcat(ADR(tmpStr1), ADR('<tspan class="text" x="10" dy="32">'));
									brsstrcat(ADR(tmpStr1), ADR('Code: '));
									brsstrcat(ADR(tmpStr1), ADR(CodeTypes[LIMIT(0, CodeReader.BarcodeType[idx], MAX_NUM_CODETYPES)]));
									brsstrcat(ADR(tmpStr1), ADR('</tspan> '));
								END_IF
								brsstrcat(ADR(tmpStr1), ADR('</text>'));
							END_IF
						END_IF
					ELSE // Add result information measurement
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
				ELSIF VisionSensor.DAT.ResultCnt = 0 AND VisionDisabled THEN // Vision function is disabled --> show a message
					visCrossHair.SvgVisible[1]			:= TRUE;
					visCrossHair.SvgTransformation[1]	:= '[{"select":"#CrosshairRed","display":false}, {"select":"#CrosshairBlue","display":false}]';
					visCrossHair.SvgContent[1]			:= '<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="10" y="40"> Processing is disabled </text>';
				END_IF
			END_FOR
		END_IF // IF visCrossHair.ShowCrosshair THEN
	END_IF
	ShowCrosshairOld := visCrossHair.ShowCrosshair;
END_FUNCTION_BLOCK