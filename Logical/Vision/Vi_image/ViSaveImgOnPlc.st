FUNCTION_BLOCK ViSaveImgOnPlc
	IF NOT Enable THEN
		Status := ERR_FUB_ENABLE_FALSE;
		Step := 0;
	END_IF
	CASE Step OF
		0:
			Status := ERR_FUB_BUSY;
			Step := 1;
		1: // Initialization
			ACTION_InitTexts;
			brsmemcpy(ADR(b64key), ADR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'), SIZEOF(b64key));
			// Generate new filenames
			DTGetTime_0(enable := TRUE);
			DT_TO_DTStructure(DTGetTime_0.DT1, ADR(DTStructure_0));
			FileNameImg := CFG.DirName;
			brsstrcat(ADR(FileNameImg), ADR('/'));
			tmpStr1 := UINT_TO_STRING(DTStructure_0.year);
			brsstrcat(ADR(FileNameImg), ADR(tmpStr1));
			brsstrcat(ADR(FileNameImg), ADR('_'));
			tmpStr1 := USINT_TO_STRING(DTStructure_0.month);
			IF(DTStructure_0.month < 10) THEN
				brsstrcat(ADR(FileNameImg), ADR('0'));
			END_IF
			brsstrcat(ADR(FileNameImg), ADR(tmpStr1));
			brsstrcat(ADR(FileNameImg), ADR('_'));
			tmpStr1 := USINT_TO_STRING(DTStructure_0.day);
			IF(DTStructure_0.day < 10) THEN
				brsstrcat(ADR(FileNameImg), ADR('0'));
			END_IF
			brsstrcat(ADR(FileNameImg), ADR(tmpStr1));
			brsstrcat(ADR(FileNameImg), ADR('_'));
			tmpStr1 := USINT_TO_STRING(DTStructure_0.hour);
			IF(DTStructure_0.hour < 10) THEN
				brsstrcat(ADR(FileNameImg), ADR('0'));
			END_IF
			brsstrcat(ADR(FileNameImg), ADR(tmpStr1));
			brsstrcat(ADR(FileNameImg), ADR('_'));
			tmpStr1 := USINT_TO_STRING(DTStructure_0.minute);
			IF(DTStructure_0.minute < 10) THEN
				brsstrcat(ADR(FileNameImg), ADR('0'));
			END_IF
			brsstrcat(ADR(FileNameImg), ADR(tmpStr1));
			brsstrcat(ADR(FileNameImg), ADR('_'));
			tmpStr1 := USINT_TO_STRING(DTStructure_0.second);
			IF(DTStructure_0.second < 10) THEN
				brsstrcat(ADR(FileNameImg), ADR('0'));
			END_IF
			brsstrcat(ADR(FileNameImg), ADR(tmpStr1));
			brsstrcat(ADR(FileNameImg), ADR('.'));
			brsstrcpy(ADR(FileNameSvg), ADR(FileNameImg)); // Same filename but differend ending
			IF CFG.Format = 0 THEN
				brsstrcat(ADR(FileNameImg), ADR('jpg'));
			ELSE
				brsstrcat(ADR(FileNameImg), ADR('bmp'));
			END_IF
			brsstrcat(ADR(FileNameSvg), ADR('svg'));
			// Create URI and Host
			URI := '/';
			IF CFG.Format = 0 THEN
				brsstrcat(ADR(URI), ADR('jpg'));
				brsstrcat(ADR(URI), ADR('?q='));
				brsitoa(CFG.QualityJPG, ADR(tmpStr1));
				brsstrcat(ADR(URI), ADR(tmpStr1));
			ELSE
				brsstrcat(ADR(URI), ADR('bmp'));
			END_IF
			Host := CFG.CameraIP;
			brsitoa(SelectedSensor, ADR(tmpStr1));
			brsstrcat(ADR(Host), ADR(tmpStr1));
			DiagStartTime := clock_ms();
			Step := 10;
			
		10: // Reset timer and HTTP client
			TON_ReloadTimeout(IN := FALSE);
			httpClient_0(enable := FALSE, abort := FALSE, send := FALSE);
			IF httpClient_0.status = ERR_FUB_ENABLE_FALSE THEN
				Step := 11;
			END_IF
			
		11: // Wait for response
			TON_ReloadTimeout(IN := TRUE, PT := T#10s); // Time out when no response after 10s
			RequestHeader.keepAlive			:= 'timeout=5, max=100';
			httpClient_0.enable				:= TRUE;
			httpClient_0.send				:= TRUE;
			httpClient_0.method 			:= httpMETHOD_GET;
			httpClient_0.option 			:= httpOPTION_HTTP_11;
			httpClient_0.hostPort			:= 8080;
			httpClient_0.pHost 				:= ADR(Host);
			httpClient_0.pUri 				:= ADR(URI);
			httpClient_0.pResponseData 		:= MemInfo.UploadAdr;
			httpClient_0.responseDataSize	:= MemInfo.UploadSize;
			httpClient_0.pRequestHeader		:= ADR(RequestHeader);
			httpClient_0();
			IF httpClient_0.status = 0 AND httpClient_0.responseDataLen <> 0 THEN
				UploadedImgSize				:= httpClient_0.responseDataLen;
				httpClient_0(send := FALSE);
				IF CFG.UploadBmpJpg THEN
					Step := 20; // save the image (bmp or jpg)
				ELSE
					Step := 30; // directly upload the svg
				END_IF
			ELSIF httpClient_0.status <> ERR_FUB_BUSY AND httpClient_0.status <> 0 THEN
				httpClientErrorStatus := httpClient_0.status;
				Step := 19;
			ELSIF TON_ReloadTimeout.Q THEN // Timout! httpClient takes too long, so abort
				Status := ERR_NO_IMAGE;
				Step := 0;
			END_IF
		19: // httpclient Error
			httpClient_0.enable	:= TRUE;
			httpClient_0.send	:= FALSE;
			httpClient_0.abort	:= TRUE;
			httpClient_0();
			IF httpClient_0.status <> ERR_FUB_BUSY THEN
				httpClient_0.abort := FALSE;
				httpClient_0();
				Status := httpClientErrorStatus;
				Step := 0;
			END_IF

		20: // Save bmp/jpg file
			DiagTime.BeginSaveBMPJPG := clock_ms() - DiagStartTime;
			FileCreate_0.enable		:= TRUE;
			FileCreate_0.pDevice	:= ADR(CFG.FileDevice);
			FileCreate_0.pFile		:= ADR(FileNameImg);
			FileCreate_0();
			IF FileCreate_0.status = 0 THEN
				Step := 21;
			ELSIF FileCreate_0.status <> ERR_FUB_BUSY THEN
				Status := FileCreate_0.status;
				Step := 0;
			END_IF	
		21:
			FileWrite_0.enable		:= TRUE;
			FileWrite_0.ident		:= FileCreate_0.ident;
			FileWrite_0.offset		:= 0;
			FileWrite_0.pSrc		:= MemInfo.UploadAdr;
			FileWrite_0.len			:= UploadedImgSize;
			FileWrite_0();
			IF FileWrite_0.status = 0 THEN
				Step := 22;
			ELSIF FileWrite_0.status <> ERR_FUB_BUSY THEN
				Status := FileWrite_0.status;
				Step := 0;
			END_IF	
		22:
			FileClose_0.enable		:= TRUE;
			FileClose_0.ident		:= FileCreate_0.ident;
			FileClose_0();
			IF FileClose_0.status = 0 THEN
				DiagTime.EndSaveBMPJPG := clock_ms() - DiagStartTime;
				IF CFG.UploadSVG THEN
					Step := 30;
				ELSE // ready
					Status := 0;
					Step := 0;
				END_IF
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				Status := FileClose_0.status;
				Step := 0;
			END_IF
		
		30: // Create SVG file with image and crosshair/texts
			DiagTime.BeginSVG := clock_ms() - DiagStartTime;
			b64neededOutput	:= (UploadedImgSize/3)*4 + BOOL_TO_UDINT(UDINT_TO_BOOL(UploadedImgSize MOD 3))*4;
			IF b64neededOutput < MemInfo.SvgSize - MemInfo.SvgHeaderSize - MemInfo.CrosshSize THEN
				brsmemset(MemInfo.SvgAdr, 0, MemInfo.SvgSize); // clear complete memory
				// Prepare the svg header up to the base64 picture data
				brsstrcpy(MemInfo.SvgAdr, ADR(SvgTexts.Header1));
				brsstrcat(MemInfo.SvgAdr, ADR(FileNameSvg));
				brsstrcat(MemInfo.SvgAdr, ADR(SvgTexts.Header2));
				IF CFG.Format = 0 THEN
					brsstrcat(MemInfo.SvgAdr, ADR('jpg'));
				ELSE
					brsstrcat(MemInfo.SvgAdr, ADR('bmp'));
				END_IF
				brsstrcat(MemInfo.SvgAdr, ADR(SvgTexts.Header3));
				Step := 31;
			ELSE
				Status := ERR_BUFF_TOO_SMALL;
				Step := 0;
			END_IF
		
		31: // Code picture data with Base64 to embedd the picture into a svg file
			b64AdrInBuffer	:= MemInfo.UploadAdr; // Original bmp or jpg picture
			b64AdrOutBuffer	:= MemInfo.SvgAdr + brsstrlen(MemInfo.SvgAdr); // Write to the end of the actual svg data
			b64actposIN		:= b64AdrInBuffer;
			b64actposOUT	:= b64AdrOutBuffer;
			Step := 32;
		32: // Convert
			FOR i := 0 TO CFG.ConvertCycles DO
				IF b64actposIN < b64AdrInBuffer + UploadedImgSize THEN
					b64blockLen := UDINT_TO_USINT(LIMIT(0, b64AdrInBuffer + UploadedImgSize - b64actposIN, 3));
					b64in ACCESS b64actposIN;
					b64out ACCESS b64actposOUT;
					b64out[0]		:= b64key[ SHR(b64in[0],2) ];	// always
					IF b64blockLen = 1 THEN
						b64out[1]	:= b64key[ SHL((b64in[0] AND 16#03),4)];
						b64out[2]	:= 61;	// 61 = '='
						b64out[3]	:= 61;	// 61 = '='
					ELSIF b64blockLen = 2 THEN
						b64out[1]	:= b64key[ SHL((b64in[0] AND 16#03),4) OR SHR(b64in[1],4) ];
						b64out[2]	:= b64key[ SHL((b64in[1] AND 16#0F),2)];
						b64out[3]	:= 61;	// 61 = '='
					ELSIF b64blockLen = 3 THEN
						b64out[1]	:= b64key[ SHL((b64in[0] AND 16#03),4) OR SHR(b64in[1],4) ];
						b64out[2]	:= b64key[ SHL((b64in[1] AND 16#0F),2) OR SHR(b64in[2],6) ];
						b64out[3]	:= b64key[ b64in[2] AND 16#3F ];
					END_IF
					b64actposIN		:= b64actposIN + 3;
					b64actposOUT	:= b64actposOUT + 4;
				ELSE
					Step := 33;
					EXIT;
				END_IF
			END_FOR

		33: // Prepare the second part after base64 picture data
			brsmemset(MemInfo.CrosshAdr, 0, MemInfo.CrosshSize);
			brsstrcat(MemInfo.CrosshAdr, ADR(SvgTexts.Header4));
			brsstrcat(MemInfo.CrosshAdr, ADR(SvgTexts.CrosshairDefinition));
			FOR i := 1 TO MAX_NUM_RESULTS DO
				IF CrossHairInfo[i].CrosshairX <> 0 AND CrossHairInfo[i].CrosshairY <> 0 THEN
					brsstrcat(MemInfo.CrosshAdr, ADR(SvgTexts.Crosshair1));
					brsitoa(REAL_TO_DINT(CrossHairInfo[i].CrosshairX), ADR(tmpStr1));
					brsstrcat(MemInfo.CrosshAdr, ADR(tmpStr1));
					brsstrcat(MemInfo.CrosshAdr, ADR(','));
					brsitoa(REAL_TO_DINT(CrossHairInfo[i].CrosshairY), ADR(tmpStr1));
					brsstrcat(MemInfo.CrosshAdr, ADR(tmpStr1));
					brsstrcat(MemInfo.CrosshAdr, ADR(') rotate('));
					brsitoa(REAL_TO_DINT(CrossHairInfo[i].CrosshairRotate), ADR(tmpStr1));
					brsstrcat(MemInfo.CrosshAdr, ADR(tmpStr1));
					brsstrcat(MemInfo.CrosshAdr, ADR(',40,40)"/>'));
				END_IF
			END_FOR
			FOR i := 1 TO MAX_NUM_RESULTS DO
				IF CrossHairInfo[i].CrosshairX <> 0 AND CrossHairInfo[i].CrosshairY <> 0 THEN
					brsstrcat(MemInfo.CrosshAdr, ADR('$r$n$t'));
					brsstrcat(MemInfo.CrosshAdr, ADR(CrossHairInfo[i].Text));
				END_IF
			END_FOR
			brsstrcat(MemInfo.CrosshAdr, ADR(SvgTexts.SvgClose));
			Step := 41;
		41:
			brsstrcat(MemInfo.SvgAdr, MemInfo.CrosshAdr);
			Step := 50;
		50:
			DiagTime.BeginSVGSave := clock_ms() - DiagStartTime;
			FileCreate_0.enable		:= TRUE;
			FileCreate_0.pDevice	:= ADR(CFG.FileDevice);
			FileCreate_0.pFile		:= ADR(FileNameSvg);
			FileCreate_0();
			IF FileCreate_0.status = 0 THEN
				Step := 51;
			ELSIF FileCreate_0.status <> ERR_FUB_BUSY THEN
				Status := FileCreate_0.status;
				Step := 0;
			END_IF
		51:
			FileWrite_0.enable		:= TRUE;
			FileWrite_0.ident		:= FileCreate_0.ident;
			FileWrite_0.offset		:= 0;
			FileWrite_0.pSrc		:= MemInfo.SvgAdr;
			FileWrite_0.len			:= brsstrlen(MemInfo.SvgAdr);
			FileWrite_0();
			IF FileWrite_0.status = 0 THEN
				Step := 52;
			ELSIF FileWrite_0.status <> ERR_FUB_BUSY THEN
				Status := FileWrite_0.status;
				Step := 0;
			END_IF
		52:
			FileClose_0.enable		:= TRUE;
			FileClose_0.ident		:= FileCreate_0.ident;
			FileClose_0();
			IF FileClose_0.status = 0 THEN
				DiagTime.EndSVGSave := clock_ms() - DiagStartTime;
				Status := 0;
				Step := 0;
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				Status := FileClose_0.status;
				Step := 0;
			END_IF
	END_CASE
END_FUNCTION_BLOCK