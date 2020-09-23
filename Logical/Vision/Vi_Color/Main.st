
PROGRAM _INIT
	// ---------------------------------------------------------------------------------------------------------------------
	// Camera configuration
	gVisionSensor[VI_COLOR_SENSOR].DAT.Gain := 1;							
	gVisionSensor[VI_COLOR_SENSOR].DAT.Focus := 14000;
	gVisionSensor[VI_COLOR_SENSOR].DAT.Exposure := 150;
	gVisionSensor[VI_COLOR_SENSOR].DAT.ChromaticLock := TRUE;
	gBlob.EnhancedBlobInformation := TRUE;
	 
END_PROGRAM

PROGRAM _CYCLIC
	CASE Step OF
		// ---------------------------------------------------------------------------------------------------------------------
		// Wait for new upload command
		VISTEP_WAIT: 
			gVisionColor.DAT.Status := ERR_OK;
			IF gVisionColor.CMD.Evaluate OR gVisionColor.CMD.Teach THEN
				idx := 1;
				brsmemset(ADR(gVisionColor.DAT), 0, SIZEOF(gVisionColor.DAT));
				gVisionColor.CFG.TeachingIndex := visSelectedProduct + 1;
				gVisionColor.DAT.Status := ERR_FUB_BUSY;
				gVisionSensor[VI_COLOR_SENSOR].DAT.Enable := TRUE;
				Step := VISTEP_FLASH;
			END_IF
			// ---------------------------------------------------------------------------------------------------------------------
			// Teach new color
		VISTEP_FLASH:
			// Flash with all available colors
			IF(idx = 1 AND gVisionColor.CFG.FlashColor1 <> 0) THEN
				gVisionSensor[VI_COLOR_SENSOR].DAT.FlashColor := gVisionColor.CFG.FlashColor1;
			ELSIF(idx = 2 AND gVisionColor.CFG.FlashColor2 <> 0) THEN
				gVisionSensor[VI_COLOR_SENSOR].DAT.FlashColor := gVisionColor.CFG.FlashColor2;
			ELSIF(idx = 3 AND gVisionColor.CFG.FlashColor3 <> 0) THEN
				gVisionSensor[VI_COLOR_SENSOR].DAT.FlashColor := gVisionColor.CFG.FlashColor3;
			ELSIF(idx = 4 AND gVisionColor.CFG.FlashColor4 <> 0) THEN
				gVisionSensor[VI_COLOR_SENSOR].DAT.FlashColor := gVisionColor.CFG.FlashColor4;
				// Finish flashing when no color is set
			ELSE
				IF(gVisionColor.CMD.Teach) THEN
					gVisionColor.CMD.Teach := FALSE;
					Step := VISTEP_WAIT;
				ELSE
					Step := VISTEP_CHECK;
				END_IF
				RETURN;
			END_IF
			// Take new image with selected color
			gVisionSensor[VI_COLOR_SENSOR].DAT.NettimeDelay	:= NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
			gVisionSensor[VI_COLOR_SENSOR].CMD.ImageTrigger 	:= TRUE;
			IF(gVisionColor.CMD.Teach) THEN
				Step := VISTEP_TEACH;
			ELSE
				Step := VISTEP_CHECK;
			END_IF
			// ---------------------------------------------------------------------------------------------------------------------
			// Teach new color
		VISTEP_TEACH:
			// Wait for trigger to finish
			IF(gVisionSensor[VI_COLOR_SENSOR].CMD.ImageTrigger = FALSE) THEN
				IF(gVisionSensor[VI_COLOR_SENSOR].DAT.ResultCnt > 0)  THEN
					IF(idx = 1) THEN
						gVisionColor.CFG.GrayValue1[gVisionColor.CFG.TeachingIndex] := gBlob.MeanGrayValue[1];
					ELSIF(idx = 2) THEN
						gVisionColor.CFG.GrayValue2[gVisionColor.CFG.TeachingIndex] := gBlob.MeanGrayValue[1];
					ELSIF(idx = 3) THEN
						gVisionColor.CFG.GrayValue3[gVisionColor.CFG.TeachingIndex] := gBlob.MeanGrayValue[1];
					ELSIF(idx = 4) THEN
						gVisionColor.CFG.GrayValue4[gVisionColor.CFG.TeachingIndex] := gBlob.MeanGrayValue[1];
					END_IF
					// 
					idx := idx + 1;
					IF(idx > 4) THEN
						gVisionColor.CMD.Teach := FALSE;
						Step := VISTEP_WAIT;
					ELSE
						Step := VISTEP_FLASH;
					END_IF
				ELSE
					gVisionColor.DAT.Status := ERR_VI_COLOR_IDENTIFY;
					Step := VISTEP_ERR;
				END_IF
			END_IF
			// ---------------------------------------------------------------------------------------------------------------------
			// Check new product
		VISTEP_CHECK:
			// Wait for trigger to finish
			IF(gVisionSensor[VI_COLOR_SENSOR].CMD.ImageTrigger = FALSE) THEN
				IF(gVisionSensor[VI_COLOR_SENSOR].DAT.ResultCnt > 0)  THEN
					IF(idx = 1) THEN
						gVisionColor.DAT.GrayValue1 := gBlob.MeanGrayValue[1];
					ELSIF(idx = 2) THEN
						gVisionColor.DAT.GrayValue2 := gBlob.MeanGrayValue[1];
					ELSIF(idx = 3) THEN
						gVisionColor.DAT.GrayValue3 := gBlob.MeanGrayValue[1];
					ELSIF(idx = 4) THEN
						gVisionColor.DAT.GrayValue4 := gBlob.MeanGrayValue[1];
					END_IF
					// 
					idx := idx + 1;
					IF(idx > 4) THEN
						gVisionColor.DAT.LowError := 16#FFFF;
						gVisionColor.DAT.LowIndex := 16#FFFF;
						gVisionColor.DAT.LowDistance := 16#FFFF;
						Step := VISTEP_EVAL;
					ELSE
						Step := VISTEP_FLASH;
					END_IF
				ELSE
					gVisionColor.DAT.Status := ERR_VI_COLOR_IDENTIFY;
					Step := VISTEP_ERR;
				END_IF
			END_IF
			// ---------------------------------------------------------------------------------------------------------------------
			// Check new product
		VISTEP_EVAL:
			FOR idx:= 1 TO MAX_NUM_PRODUCTS DO
				// Abort when product gray values are empty
				IF(gVisionColor.CFG.GrayValue1[idx] = 0 AND gVisionColor.CFG.GrayValue2[idx] = 0 AND gVisionColor.CFG.GrayValue3[idx] = 0 AND gVisionColor.CFG.GrayValue4[idx] = 0) THEN
					EXIT;
				END_IF
				// Calculate error for all colors and products
				FOR idy:= 1 TO 4 DO
					IF(idy = 1 AND gVisionColor.CFG.FlashColor1 <> 0) THEN
						gVisionColor.DAT.TotalError[idx] := gVisionColor.DAT.TotalError[idx] + ABS(UINT_TO_INT(gVisionColor.DAT.GrayValue1) - gVisionColor.CFG.GrayValue1[idx]);
					ELSIF(idy = 2 AND gVisionColor.CFG.FlashColor2 <> 0) THEN
						gVisionColor.DAT.TotalError[idx] := gVisionColor.DAT.TotalError[idx] + ABS(UINT_TO_INT(gVisionColor.DAT.GrayValue2) - gVisionColor.CFG.GrayValue2[idx]);
					ELSIF(idy = 3 AND gVisionColor.CFG.FlashColor3 <> 0) THEN
						gVisionColor.DAT.TotalError[idx] := gVisionColor.DAT.TotalError[idx] + ABS(UINT_TO_INT(gVisionColor.DAT.GrayValue3) - gVisionColor.CFG.GrayValue3[idx]);
					ELSIF(idy = 4 AND gVisionColor.CFG.FlashColor4 <> 0) THEN
						gVisionColor.DAT.TotalError[idx] := gVisionColor.DAT.TotalError[idx] + ABS(UINT_TO_INT(gVisionColor.DAT.GrayValue4) - gVisionColor.CFG.GrayValue4[idx]);
					END_IF
				END_FOR;
				// New lowest error
				IF(gVisionColor.DAT.TotalError[idx] < gVisionColor.DAT.LowError) THEN
					gVisionColor.DAT.LowError := gVisionColor.DAT.TotalError[idx];
					gVisionColor.DAT.LowIndex := idx;
					gVisionColor.DAT.LowName := gVisionColor.CFG.ProductName[idx];
				END_IF
			END_FOR;
			// Check distance to next best value
			IF(gVisionColor.DAT.LowIndex <> 16#FFFF) THEN
				FOR idx:= 1 TO MAX_NUM_PRODUCTS DO
					// Abort when product gray values are empty
					IF(gVisionColor.CFG.GrayValue1[idx] = 0 AND gVisionColor.CFG.GrayValue2[idx] = 0 AND gVisionColor.CFG.GrayValue3[idx] = 0 AND gVisionColor.CFG.GrayValue4[idx] = 0) THEN
						EXIT;
					END_IF
					// Store next best product
					IF(gVisionColor.DAT.LowIndex <> idx AND INT_TO_UINT(ABS(UINT_TO_INT(gVisionColor.DAT.TotalError[gVisionColor.DAT.LowIndex])) - gVisionColor.DAT.TotalError[idx]) < gVisionColor.DAT.LowDistance) THEN
						gVisionColor.DAT.LowDistance := ABS(UINT_TO_INT(gVisionColor.DAT.TotalError[gVisionColor.DAT.LowIndex]) - gVisionColor.DAT.TotalError[idx]);
					END_IF
				END_FOR;
				visSelectedProduct := gVisionColor.DAT.LowIndex - 1;
			END_IF
			// Make sure we dont exceed max error
			IF(gVisionColor.DAT.LowError > gVisionColor.CFG.MaxError) THEN
				gVisionColor.DAT.Status := ERR_VI_COLOR_MAX_ERROR;
				Step := VISTEP_ERR;
				// Make sure we have enough distance to next best value
			ELSIF(gVisionColor.DAT.LowDistance < gVisionColor.CFG.MinDifference) THEN
				gVisionColor.DAT.Status := ERR_VI_COLOR_MIN_DISTANCE;
				Step := VISTEP_ERR;
				// Make sure we dont exceed max error
			ELSE
				gVisionColor.CMD.Evaluate := FALSE;
				Step := VISTEP_WAIT;
			END_IF		
			// ---------------------------------------------------------------------------------------------------------------------
			// Error state
		VISTEP_ERR: 
			IF gVisionColor.CMD.ResetError THEN
				gVisionColor.CMD.ResetError := FALSE;
				gVisionColor.DAT.Status := 0;
				Step := VISTEP_WAIT;
			ELSE
				brsmemset(ADR(gVisionColor.CMD), 0, SIZEOF(gVisionColor.CMD));
			END_IF
	END_CASE	 
END_PROGRAM


