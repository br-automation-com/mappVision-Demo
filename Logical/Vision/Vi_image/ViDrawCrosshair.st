FUNCTION_BLOCK ViDrawCrosshair
	// Assign pointers
	IF VisionSensor.CFG.DataStructure <> 0 THEN
		CASE VisionSensor.CFG.VisionFunction OF
			enumBlob:
				Blob ACCESS VisionSensor.CFG.DataStructure;
			enumCoderReader:
				CodeReader ACCESS VisionSensor.CFG.DataStructure;
			enumMatch:
				Match ACCESS VisionSensor.CFG.DataStructure;
			enumMeasurement:
				MT ACCESS VisionSensor.CFG.DataStructure;
			enumOCR:
				OCR ACCESS VisionSensor.CFG.DataStructure;
		END_CASE
	ELSE
		RETURN;
	END_IF
	
	// Draw cross hairs
	IF CmdRefreshCrosshair OR (visCrossHair.ShowCrosshair <> ShowCrosshairOld) OR (visCrossHair.DetailsNo <> DetailsNoOld) OR (SelectedSensor <> SelectedSensorOld) OR (ImageRotation_deg <> ImageRotation_degOld) THEN
		ShowCrosshairOld		:= visCrossHair.ShowCrosshair;
		SelectedSensorOld		:= SelectedSensor;
		ImageRotation_degOld	:= ImageRotation_deg;
		// First delete transformation and make everything invisible
		brsmemset(ADR(visCrossHair.SvgTransformation), 0, SIZEOF(visCrossHair.SvgTransformation));
		brsmemset(ADR(visCrossHair.SvgVisible), 0, SIZEOF(visCrossHair.SvgVisible));
		IF visCrossHair.ShowCrosshair THEN
			// Handle details no
			IF visCrossHair.DetailsNo < 1 THEN
				IF VisionSensor.DAT.ResultCnt > 0 THEN 
					visCrossHair.DetailsNo := VisionSensor.DAT.ResultCnt;
				ELSE
					visCrossHair.DetailsNo := 1;
				END_IF
			END_IF
			IF visCrossHair.DetailsNo > VisionSensor.DAT.ResultCnt THEN
				visCrossHair.DetailsNo := 1;
			END_IF
			DetailsNoOld := visCrossHair.DetailsNo;
			
			// Create cross hairs and data for all results
			FOR idx := 1 TO MAX_NUM_RESULTS DO
				ResultModelNumber	:= 0;
				ResultPositionX		:= 0;
				ResultPositionY		:= 0;
				ResultOrientation	:= 0;
				brsmemset(ADR(CrossHairInfo[idx]), 0, SIZEOF(CrossHairInfo[0]));
				
				// Make sure we have data to display
				IF VisionSensor.DAT.ResultCnt <> 0 AND idx <= VisionSensor.DAT.ResultCnt THEN
					// Select data source from vision function
					MT_UseXY := FALSE;
					CASE VisionSensor.CFG.VisionFunction OF
						enumBlob:
							ResultModelNumber	:= Blob.ModelNumber[idx];
							ResultPositionX		:= UDINT_TO_REAL(Blob.PositionX[idx]) / visCrossHair.CFG.PixelRatio;
							ResultPositionY		:= UDINT_TO_REAL(Blob.PositionY[idx]) / visCrossHair.CFG.PixelRatio;
							ResultOrientation	:= Blob.Orientation[idx] / visCrossHair.CFG.PixelRatio;
						enumCoderReader:
							ResultPositionX		:= UDINT_TO_REAL(CodeReader.PositionX[idx]) / visCrossHair.CFG.PixelRatio;
							ResultPositionY		:= UDINT_TO_REAL(CodeReader.PositionY[idx]) / visCrossHair.CFG.PixelRatio;
							ResultOrientation	:= CodeReader.Orientation[idx] / visCrossHair.CFG.PixelRatio;
						enumMatch:
							ResultModelNumber	:= Match.ModelNumber[idx]; 
							ResultPositionX		:= UDINT_TO_REAL(Match.PositionX[idx]) / visCrossHair.CFG.PixelRatio;
							ResultPositionY		:= UDINT_TO_REAL(Match.PositionY[idx]) / visCrossHair.CFG.PixelRatio;
							ResultOrientation	:= Match.Orientation[idx] / visCrossHair.CFG.PixelRatio;
						enumMeasurement:
							IF MT.UseResultAsXY THEN
								ResultPositionX	:= UDINT_TO_REAL(MT.Result[idx])/10;
								ResultPositionY	:= UDINT_TO_REAL(MT.Result[idx+1])/10;
								idx := idx + 1;
							END_IF
							MT_UseXY := TRUE; // use this variable because of in case Visionfunction != MT then the Pointer MT is not initialized
						enumOCR:
							ResultPositionX		:= UDINT_TO_REAL(OCR.PositionX[idx]) / visCrossHair.CFG.PixelRatio;
							ResultPositionY		:= UDINT_TO_REAL(OCR.PositionY[idx]) / visCrossHair.CFG.PixelRatio;
							ResultOrientation	:= OCR.Orientation[idx] / visCrossHair.CFG.PixelRatio;
					END_CASE
				
					// Show crosshair except for measurement function
					IF VisionSensor.CFG.VisionFunction <> enumMeasurement OR MT_UseXY THEN
						IF ResultPositionX <> 0 AND ResultPositionY <> 0 THEN
							visCrossHair.SvgVisible[idx] := TRUE;
							
							// Calculate cross information, also needed for saving the svg in ViSaveImgOnPLC
							CrossHairInfo[idx].CrosshairScale			:= visCrossHair.CFG.Scale;
							CrossHairInfo[idx].CrosshairSizeScaled		:= USINT_TO_REAL(visCrossHair.CFG.Size) * visCrossHair.CFG.Scale;
							CrossHairInfo[idx].CrosshairTopLeftX		:= ResultPositionX - CrossHairInfo[idx].CrosshairSizeScaled / 2.0;
							CrossHairInfo[idx].CrosshairTopLeftY		:= ResultPositionY - CrossHairInfo[idx].CrosshairSizeScaled / 2.0;
							CrossHairInfo[idx].CrosshairRotateCenter	:= ResultOrientation * -1;
							
							// Crosshair transformation for displaying in the mappView visu
							IF visCrossHair.DetailsNo = idx THEN
								svgTrafo := '[{"select":"#CrosshairBlue","display":false}, {"select":"#CrosshairRed","display":true, "translate":[';
							ELSE
								svgTrafo := '[{"select":"#CrosshairRed","display":false}, { "select":"#CrosshairBlue","display":true, "translate":[';
							END_IF
							// Crosshair position
							CrosshSize		:= CrossHairInfo[idx].CrosshairSizeScaled / 2.0;
							ScaleVertical	:= UINT_TO_REAL(VisionSensor.CFG.ResolutionHeight_Y) / UINT_TO_REAL(VisionSensor.CFG.ResolutionWidth_X);
							CASE ImageRotation_deg OF
								0:		brsitoa(REAL_TO_INT(ResultPositionX															- CrosshSize), ADR(tmpStr));
								90:		brsitoa(REAL_TO_INT((VisionSensor.CFG.ResolutionHeight_Y - ResultPositionY) * ScaleVertical	- CrosshSize), ADR(tmpStr));
								180:	brsitoa(REAL_TO_INT(VisionSensor.CFG.ResolutionWidth_X - ResultPositionX					- CrosshSize), ADR(tmpStr));
								270:	brsitoa(REAL_TO_INT(ResultPositionY * ScaleVertical											- CrosshSize), ADR(tmpStr));
							ELSE
										brsitoa(REAL_TO_INT(ResultPositionX															- CrosshSize), ADR(tmpStr));
							END_CASE
							brsstrcat(ADR(svgTrafo), ADR(tmpStr));
							brsstrcat(ADR(svgTrafo), ADR(','));
							CASE ImageRotation_deg OF
								0:		brsitoa(REAL_TO_INT(ResultPositionY															- CrosshSize), ADR(tmpStr));
								90:		brsitoa(REAL_TO_INT(ResultPositionX * ScaleVertical											- CrosshSize), ADR(tmpStr));
								180:	brsitoa(REAL_TO_INT(VisionSensor.CFG.ResolutionHeight_Y - ResultPositionY					- CrosshSize), ADR(tmpStr));
								270:	brsitoa(REAL_TO_INT((VisionSensor.CFG.ResolutionWidth_X - ResultPositionX) * ScaleVertical	- CrosshSize), ADR(tmpStr));
							ELSE
										brsitoa(REAL_TO_INT(ResultPositionY															- CrosshSize), ADR(tmpStr));
							END_CASE
							brsstrcat(ADR(svgTrafo), ADR(tmpStr));
							// Add cross hair scaling
							brsstrcat(ADR(svgTrafo), ADR('],"scale":['));
							brsftoa(visCrossHair.CFG.Scale, ADR(tmpStr));
							brsstrcat(ADR(svgTrafo), ADR(tmpStr));
							brsstrcat(ADR(svgTrafo), ADR(','));
							brsstrcat(ADR(svgTrafo), ADR(tmpStr));
							// Add cross hair rotation
							brsstrcat(ADR(svgTrafo), ADR('],"spin":['));
							brsftoa(CrossHairInfo[idx].CrosshairRotateCenter - ImageRotation_deg, ADR(tmpStr));
							brsstrcat(ADR(svgTrafo), ADR(tmpStr));
							brsstrcat(ADR(svgTrafo), ADR(','));
							brsftoa(USINT_TO_REAL(visCrossHair.CFG.Size) / 2, ADR(tmpStr)); // For mappView the rotation is based on the original size, not on the scaled size
							brsstrcat(ADR(svgTrafo), ADR(tmpStr));
							brsstrcat(ADR(svgTrafo), ADR(','));
							brsstrcat(ADR(svgTrafo), ADR(tmpStr));
							brsstrcat(ADR(svgTrafo), ADR(']}]'));
							visCrossHair.SvgTransformation[idx] := svgTrafo;
							
							// Add text data to selected cross hair
							IF visCrossHair.DetailsNo = idx THEN
								svgContent := '<text class="cText" fill="red " font-size="22" font-family="Helvetica, Arial, sans-serif"><tspan class="text" x="';
							ELSE
								svgContent := '<text class="cText" fill="blue" font-size="22" font-family="Helvetica, Arial, sans-serif"><tspan class="text" x="';
							END_IF
							CASE ImageRotation_deg OF
								0:		brsitoa(REAL_TO_INT(ResultPositionX															+ CrosshSize), ADR(tmpStr));
								90:		brsitoa(REAL_TO_INT((VisionSensor.CFG.ResolutionHeight_Y - ResultPositionY) * ScaleVertical	+ CrosshSize), ADR(tmpStr));
								180:	brsitoa(REAL_TO_INT(VisionSensor.CFG.ResolutionWidth_X - ResultPositionX					+ CrosshSize), ADR(tmpStr));
								270:	brsitoa(REAL_TO_INT(ResultPositionY * ScaleVertical											+ CrosshSize), ADR(tmpStr));
							ELSE
										brsitoa(REAL_TO_INT(ResultPositionX															+ CrosshSize), ADR(tmpStr));
							END_CASE
							brsstrcat(ADR(svgContent), ADR(tmpStr));
							brsstrcat(ADR(svgContent), ADR('" y="'));
							CASE ImageRotation_deg OF
								0:		brsitoa(REAL_TO_INT(ResultPositionY															+ 5), ADR(tmpStr));
								90:		brsitoa(REAL_TO_INT(ResultPositionX * ScaleVertical											+ 5), ADR(tmpStr));
								180:	brsitoa(REAL_TO_INT(VisionSensor.CFG.ResolutionHeight_Y - ResultPositionY					+ 5), ADR(tmpStr));
								270:	brsitoa(REAL_TO_INT((VisionSensor.CFG.ResolutionWidth_X - ResultPositionX) * ScaleVertical	+ 5), ADR(tmpStr));
							ELSE
										brsitoa(REAL_TO_INT(ResultPositionY															+ 5), ADR(tmpStr));
							END_CASE
							brsstrcat(ADR(svgContent), ADR(tmpStr));
							brsstrcat(ADR(svgContent), ADR('"> '));
							// Add result number
							brsitoa(idx, ADR(tmpStr));
							brsstrcat(ADR(svgContent), ADR(tmpStr));
							brsstrcat(ADR(svgContent), ADR('</tspan></text>'));
							
							// for saving svg file. The texts added below are not of interest for the saved SVG, so copy it now before adding the details information
							brsstrcpy(ADR(CrossHairInfo[idx].Text), ADR(svgContent));
							blueTextPos := FIND(CrossHairInfo[idx].Text, 'fill="blue"'); // Make all texts red. In the SVG is no highlighted crosshair
							IF blueTextPos > 2 THEN
								brsmemcpy(ADR(CrossHairInfo[idx].Text) + blueTextPos - 1, ADR('fill="red "'), 11);
							END_IF
							visCrossHair.SvgContent[idx] := svgContent;
							
							// Create details information to show in the top left corner
							brsstrcat(ADR(svgContent), ADR('<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="10" y="10"> '));
							CrossHairInfo[1].DataVis	:= '';
							CrossHairInfo[idx].Data		:= '';
							// Add model ID information for blob and match
							IF VisionSensor.CFG.VisionFunction = enumBlob OR VisionSensor.CFG.VisionFunction = enumMatch THEN
								CrosshairDetailsText(ADR(svgContent),  ADR('Model ID: '), ResultModelNumber);
								brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('1, '));
								brsitoa(ResultModelNumber, ADR(tmpStr));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', '));
							ELSE
								brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('0, '));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR('"none", '));
							END_IF
							// Add X and Y position information
							CrosshairDetailsText(ADR(svgContent),  ADR('Pos X: '), ResultPositionX);
							CrosshairDetailsText(ADR(svgContent),  ADR('Pos Y: '), ResultPositionY);
							brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('1, 1, '));
							brsftoa(ResultPositionX, ADR(tmpStr));
							brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
							brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', '));
							brsftoa(ResultPositionY, ADR(tmpStr));
							brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
							brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', '));
							// Add orientation information
							IF VisionSensor.CFG.VisionFunction <> enumMeasurement THEN
								CrosshairDetailsText(ADR(svgContent),  ADR('Orientation: '), ResultOrientation);
								brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('1, '));
								brsftoa(ResultOrientation, ADR(tmpStr));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', '));
							ELSE
								brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('0, '));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR('"none", '));
							END_IF
							// Add detail information for blob
							IF VisionSensor.CFG.VisionFunction = enumBlob THEN
								IF Blob.EnhancedBlobInformation = 1 THEN // Only access the Pointer Blob if it really exists. So don't combine this line of code with the line before
									CrosshairDetailsText(ADR(svgContent),  ADR('Clipped: '), Blob.Clipped[idx]);
									CrosshairDetailsText(ADR(svgContent),  ADR('Gray: '), Blob.MeanGrayValue[idx]);
									CrosshairDetailsText(ADR(svgContent),  ADR('Length: '), UDINT_TO_REAL(Blob.Length[idx])/visCrossHair.CFG.PixelRatio);
									CrosshairDetailsText(ADR(svgContent),  ADR('Width: '), UDINT_TO_REAL(Blob.Width[idx])/visCrossHair.CFG.PixelRatio);
									CrosshairDetailsText(ADR(svgContent),  ADR('Area: '), UDINT_TO_REAL(Blob.Area[idx])/visCrossHair.CFG.PixelRatio);
									brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('1, 1, 1, 1, 1, '));
									brsitoa(Blob.Clipped[idx], ADR(tmpStr));
									brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
									brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', '));
									brsitoa(Blob.MeanGrayValue[idx], ADR(tmpStr));
									brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
									brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', '));
									brsftoa(UDINT_TO_REAL(Blob.Length[idx])/visCrossHair.CFG.PixelRatio, ADR(tmpStr));
									brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
									brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', '));
									brsftoa(UDINT_TO_REAL(Blob.Width[idx])/visCrossHair.CFG.PixelRatio, ADR(tmpStr));
									brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
									brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', '));
									brsftoa(UDINT_TO_REAL(Blob.Area[idx])/visCrossHair.CFG.PixelRatio, ADR(tmpStr));
									brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
									brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', '));
								ELSE
									brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('0, 0, 0, 0, 0, '));
									brsstrcat(ADR(CrossHairInfo[idx].Data), ADR('"none", "none", "none", "none", "none", '));
								END_IF
							ELSE
								brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('0, 0, 0, 0, 0, '));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR('"none", "none", "none", "none", "none", '));
							END_IF
							// Add detail information for match
							IF VisionSensor.CFG.VisionFunction = enumMatch THEN
								CrosshairDetailsText(ADR(svgContent),  ADR('Score: '), Match.Score[idx]);
								CrosshairDetailsText(ADR(svgContent),  ADR('Scale: '), Match.Scale[idx]);
								brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('1, 1, '));
								brsitoa(Match.Score[idx], ADR(tmpStr));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', '));
								brsitoa(Match.Scale[idx], ADR(tmpStr));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', '));
							ELSE
								brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('0, 0, '));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR('"none", "none", '));
							END_IF
							// Add detail information for OCR
							IF VisionSensor.CFG.VisionFunction = enumOCR THEN
								CrosshairDetailsText(ADR(svgContent),  ADR('Grading: '), OCR.Grading[idx]);
								brsstrcat(ADR(svgContent), ADR('<tspan class="text" x="10" dy="32">'));
								brsstrcat(ADR(svgContent), ADR('Text: '));
								brsstrcat(ADR(svgContent), ADR(OCR.Text[idx]));
								brsstrcat(ADR(svgContent), ADR('</tspan> '));
								brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('1, 1, '));
								brsitoa(OCR.Grading[idx], ADR(tmpStr));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(', "'));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(OCR.Text[idx]));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR('", '));
							ELSE
								brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('0, 0, '));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR('"none", "none", '));
							END_IF
							// Add detail information for code reader
							IF VisionSensor.CFG.VisionFunction = enumCoderReader THEN
								brsstrcat(ADR(svgContent), ADR('<tspan class="text" x="10" dy="32">'));
								brsstrcat(ADR(svgContent), ADR('Code: '));
								brsstrcat(ADR(svgContent), ADR(CodeTypes[LIMIT(0, CodeReader.BarcodeType[idx], MAX_NUM_CODETYPES)]));
								brsstrcat(ADR(svgContent), ADR('</tspan> '));
								brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('1, '));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR('"'));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(CodeTypes[LIMIT(0, CodeReader.BarcodeType[idx], MAX_NUM_CODETYPES)]));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR('", '));
							ELSE
								brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('0, '));
								brsstrcat(ADR(CrossHairInfo[idx].Data), ADR('"none", '));
							END_IF
							brsstrcat(ADR(CrossHairInfo[1].DataVis), ADR('0')); // For the not used "Result"
							brsstrcat(ADR(CrossHairInfo[idx].Data), ADR('"none"')); // For the not used "Result"
							brsstrcat(ADR(svgContent), ADR('</text>'));
							// Add text data from selected cross hair in the top left corner of the image, but only if the index is the actual index
							IF visCrossHair.DetailsNo = idx THEN
								visCrossHair.SvgContent[idx] := svgContent;
							END_IF
						END_IF
					ELSE // Add result information for measurement
						visCrossHair.SvgTransformation[idx] := '[{"select":"#CrosshairRed","display":false}, {"select":"#CrosshairBlue","display":false}]';
						visCrossHair.SvgVisible[idx] := TRUE;
						brsstrcpy(ADR(svgContent), ADR('<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="10" y="'));
						brsitoa(idx*40, ADR(tmpStr));
						brsstrcat(ADR(svgContent), ADR(tmpStr));
						brsstrcat(ADR(svgContent), ADR('"> '));
						CrosshairDetailsText(ADR(svgContent),  ADR('Result:'), UDINT_TO_REAL(MT.Result[idx])/1000);
						brsstrcat(ADR(svgContent), ADR('</text>'));
						visCrossHair.SvgContent[idx] := svgContent;
						brsstrcpy(ADR(CrossHairInfo[1].DataVis), ADR('0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1'));
						brsstrcpy(ADR(CrossHairInfo[idx].Data), ADR('"none", "none", "none", "none", "none", "none", "none", "none", "none", "none", "none", "none", "none", "none", '));
						brsftoa(UDINT_TO_REAL(MT.Result[idx])/1000, ADR(tmpStr));
						brsstrcat(ADR(CrossHairInfo[idx].Data), ADR(tmpStr));
					END_IF
				ELSIF VisionSensor.DAT.ResultCnt = 0 AND VisionDisabled THEN // Vision function is disabled --> show a message
					visCrossHair.SvgVisible[1]			:= TRUE;
					visCrossHair.SvgTransformation[1]	:= '[{"select":"#CrosshairRed","display":false}, {"select":"#CrosshairBlue","display":false}]';
					visCrossHair.SvgContent[1]			:= '<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="10" y="40"> Processing is disabled </text>';
				END_IF
			END_FOR
		END_IF // IF visCrossHair.ShowCrosshair THEN
	END_IF
END_FUNCTION_BLOCK