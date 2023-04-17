// Note: This FBK needs to be called at least once in the INIT of the task to alloc memory (restriction of AsMem)
FUNCTION_BLOCK ViShowImgOnVC4
	IF MemInfo.UploadBmp8Adr = 0 THEN // This will only be done once in the INIT of the task
		// Create memory for uploading and transforming image
		// Size: a 5MP picture in bmp format has less than 6.000.000 Bytes. A SVG with bas64 conversion maximum the 4/3 size.
		MemInfo.UploadBmp8Size		:= 6000000;		// Upload of the picture data with httpClient
		MemInfo.Bmp24Size			:= 18000000; 	// The 24bit img could be 3 times bigger
		AsMemPartCreate_0.enable	:= TRUE;
		AsMemPartCreate_0.len		:= MemInfo.UploadBmp8Size + MemInfo.Bmp24Size + 1000; // 1000 Bytes for AsMemPart stuff/header
		AsMemPartCreate_0();
		IF AsMemPartCreate_0.status = ERR_OK THEN
			// Upload mem for loading the image from camera to plc
			AsMemPartAllocClear_0.len		:= MemInfo.UploadBmp8Size;
			AsMemPartAllocClear_0(enable := TRUE, ident := AsMemPartCreate_0.ident);
			IF AsMemPartAllocClear_0.status = ERR_OK THEN
				MemInfo.UploadBmp8Adr		:= AsMemPartAllocClear_0.mem;
			END_IF
			// Bmp24 mem for creating the new image
			AsMemPartAllocClear_0.len		:= MemInfo.Bmp24Size;
			AsMemPartAllocClear_0(enable := TRUE, ident := AsMemPartCreate_0.ident);
			IF AsMemPartAllocClear_0.status = ERR_OK THEN
				MemInfo.Bmp24Adr 			:= AsMemPartAllocClear_0.mem;
			END_IF
		END_IF
	END_IF
	IF NOT Enable THEN
		HTMLStreamContent	:= '<p>Ready</p>';
		RefreshDone			:= FALSE;
		Status := ERR_FUB_ENABLE_FALSE;
		Step := 0;
		RETURN;
	END_IF
	CASE Step OF
		0:
			RefreshDone := FALSE;
			Status := ERR_FUB_BUSY;
			IF MemInfo.UploadBmp8Adr <> 0 AND MemInfo.Bmp24Adr <> 0 THEN
				IF RefreshImage THEN
					Step := 1;
				END_IF
			END_IF
		1: // Initialization
			CreateVC4HTML;
			FileNameBmp24Bit	:= 'http://localhost/CamImgVC4.bmp';
			FileNameBmp24BitDir	:= 'web/CamImgVC4.bmp';
			// Create URI and Host
			URI := '/bmp';
			Host := CFG.PlkIPWithoutNode;
			brsitoa(PowerlinkNode, ADR(tmpStr1));
			brsstrcat(ADR(Host), ADR(tmpStr1));
			HTMLStreamContent := '<p>Please wait... image will be loaded...</p>';
			Step := 10;
		10: // Reset timer and HTTP client
			TON_Timeout(IN := FALSE);
			httpClient_0(enable := FALSE, abort := FALSE, send := FALSE);
			IF httpClient_0.status = ERR_FUB_ENABLE_FALSE THEN
				Step := 11;
			END_IF
			
		11: // Wait for response
			TON_Timeout(IN := TRUE, PT := T#10s); // Time out when no response after 10s
			RequestHeader.keepAlive			:= 'timeout=5, max=100';
			httpClient_0.enable				:= TRUE;
			httpClient_0.send				:= TRUE;
			httpClient_0.method 			:= httpMETHOD_GET;
			httpClient_0.option 			:= httpOPTION_HTTP_11;
			httpClient_0.hostPort			:= 8080;
			httpClient_0.pHost 				:= ADR(Host);
			httpClient_0.pUri 				:= ADR(URI);
			httpClient_0.pResponseData 		:= MemInfo.UploadBmp8Adr;
			httpClient_0.responseDataSize	:= MemInfo.UploadBmp8Size;
			httpClient_0.pRequestHeader		:= ADR(RequestHeader);
			httpClient_0();
			IF httpClient_0.status = ERR_OK AND httpClient_0.responseDataLen <> 0 THEN
				FileSizeIn8Bit				:= httpClient_0.responseDataLen;
				httpClient_0(send := FALSE);
				IF FileSizeIn8Bit < 100 THEN // No image available. Hint: In case of no image there will be sent 86 Bytes with an html error text
					HTMLStreamContent := '<p>No image found on the camera</p>';
					Status := ERR_NO_IMAGE;
					Step := 50;
				ELSE
					Step := 20;
				END_IF
			ELSIF httpClient_0.status <> ERR_FUB_BUSY AND httpClient_0.status <> 0 THEN
				httpClientErrorStatus := httpClient_0.status;
				Step := 19;
			ELSIF TON_Timeout.Q THEN // Timout! httpClient takes too long, so abort
				HTMLStreamContent := '<p>Timeout while loading image</p>';
				Status := ERR_NO_IMAGE;
				Step := 50;
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
				Step := 50;
			END_IF
			
		20: // Convert image from 8 bit bmp with color table to 24 bit bmp image
			brsmemcpy(ADR(Bmp8Bit)+2, MemInfo.UploadBmp8Adr, SIZEOF(Bmp8Bit)); // Use the read data
			brsmemcpy(ADR(Bmp24Bit), ADR(Bmp8Bit), SIZEOF(Bmp24Bit)); // Copy the header, but not the colour data
			// Change and add fileheader
			Bmp24Bit.InfoHeader.biBitCount	:= 24;
			Bmp24Bit.FileHeader.bfOffBits	:= SIZEOF(Bmp24Bit)-2;
			brsmemcpy(MemInfo.Bmp24Adr, ADR(Bmp24Bit)+2, SIZEOF(Bmp24Bit)-2);
			// Generate pixels
			BytesPerLine := Bmp24Bit.InfoHeader.biWidth;
			IF BytesPerLine MOD 4 > 0 THEN // Add fill bytes if necessary. The lengt of a line is always a multiple of 4.
				BytesPerLine := BytesPerLine + (4 - BytesPerLine MOD 4);
			END_IF
			IF Bmp8Bit.FileHeader.bfOffBits > (14+40+4*255) AND BytesPerLine > 0 AND ABS(Bmp24Bit.InfoHeader.biHeight) > 0 THEN // Header 14+40 + ColorTable
				PixelSourceAdr	:= MemInfo.UploadBmp8Adr + Bmp8Bit.FileHeader.bfOffBits;
				PixelDestAdr	:= MemInfo.Bmp24Adr + SIZEOF(Bmp24Bit)-2; // directly start after the header. -2 because of two fillbyts at the beginning
				BytesRemaining	:= BytesPerLine * ABS(Bmp24Bit.InfoHeader.biHeight);
				Step := 21;
			ELSE
				Status := ERR_DATA_BMP;
				Step := 50;
			END_IF
		21:
			FOR i := 0 TO CFG.ConvertCycles DO
				PixelSourceColor ACCESS PixelSourceAdr;
				PixelDestColor ACCESS PixelDestAdr;
				PixelDestColor.Blue		:= Bmp8Bit.ColorTable[PixelSourceColor].Blue;
				PixelDestColor.Green	:= Bmp8Bit.ColorTable[PixelSourceColor].Green;
				PixelDestColor.Red		:= Bmp8Bit.ColorTable[PixelSourceColor].Red;
				BytesRemaining := BytesRemaining - 1;
				IF BytesRemaining = 0 THEN
					Step := 30;
					EXIT;
				ELSE
					PixelSourceAdr		:= PixelSourceAdr + 1;
					PixelDestAdr		:= PixelDestAdr + 3;
					IF PixelSourceAdr > MemInfo.UploadBmp8Adr + MemInfo.UploadBmp8Size - 1 OR PixelDestAdr + 2 > MemInfo.Bmp24Adr + MemInfo.Bmp24Size -1 THEN
						Status := ERR_BUFF_BMP;
						Step := 50;
						EXIT;
					END_IF
				END_IF
			END_FOR
			
		30: // Save content to a bmp file
			FileDelete_0.enable		:= TRUE;
			FileDelete_0.pDevice	:= ADR(CFG.FileDevice);
			FileDelete_0.pName		:= ADR(FileNameBmp24BitDir);
			FileDelete_0();
			IF FileDelete_0.status = ERR_OK OR FileDelete_0.status = fiERR_FILE_NOT_FOUND THEN
				Step := 31;
			ELSIF FileDelete_0.status <> ERR_FUB_BUSY THEN
				Status := FileDelete_0.status;
				Step := 100;
			END_IF
		31:
			FileCreate_0.enable		:= TRUE;
			FileCreate_0.pDevice	:= ADR(CFG.FileDevice);
			FileCreate_0.pFile		:= ADR(FileNameBmp24BitDir);
			FileCreate_0();
			IF FileCreate_0.status = ERR_OK THEN
				Step := 32;
			ELSIF FileCreate_0.status <> ERR_FUB_BUSY THEN
				Status := FileCreate_0.status;
				Step := 100;
			END_IF
		32:
			FileWrite_0.enable		:= TRUE;
			FileWrite_0.ident		:= FileCreate_0.ident;
			FileWrite_0.pSrc		:= MemInfo.Bmp24Adr;
			FileWrite_0.len			:= MIN(MemInfo.Bmp24Size, PixelDestAdr - MemInfo.Bmp24Adr);
			FileWrite_0();
			IF FileWrite_0.status = ERR_OK THEN
				Step := 33;
			ELSIF FileWrite_0.status <> ERR_FUB_BUSY THEN
				Status := FileWrite_0.status;
				Step := 100;
			END_IF
		33:
			FileClose_0.enable	:= TRUE;
			FileClose_0.ident	:= FileCreate_0.ident;
			FileClose_0();
			IF FileClose_0.status = ERR_OK THEN
				Step := 40;
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				Status := FileClose_0.status;
				Step := 100;
			END_IF
			
		40: // Create content for VC4 html control element
			ImgHeight_px := UDINT_TO_UINT(UINT_TO_UDINT(ImgWidthInVC4_px) *1024 / 1280);
			brsstrcpy(ADR(HTMLStreamContent), ADR(VC4HTML[0]));
			brsitoa(ImgWidthInVC4_px, ADR(tmpStr1));
			brsstrcat(ADR(HTMLStreamContent), ADR(tmpStr1));
			brsstrcat(ADR(HTMLStreamContent), ADR(VC4HTML[1]));
			brsitoa(ImgHeight_px, ADR(tmpStr1));
			brsstrcat(ADR(HTMLStreamContent), ADR(tmpStr1));
			brsstrcat(ADR(HTMLStreamContent), ADR(VC4HTML[2]));
			brsstrcat(ADR(HTMLStreamContent), ADR(FileNameBmp24Bit));
			brsstrcat(ADR(HTMLStreamContent), ADR(VC4HTML[3]));
			Status := 0;
			Step := 50;
			
		50:
			RefreshDone := TRUE;
			IF NOT RefreshImage THEN
				RefreshDone := FALSE;
				Step := 0;
			END_IF
	END_CASE
END_FUNCTION_BLOCK