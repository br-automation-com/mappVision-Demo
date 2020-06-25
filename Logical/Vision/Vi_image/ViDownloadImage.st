// Note: This FBK needs to be called at least once in the INIT of the task to alloc memory (restriction of AsMem)
FUNCTION_BLOCK ViDownloadImage
	IF NOT Enable THEN
		Status := ERR_FUB_ENABLE_FALSE;
		Step := 0;
		RETURN;
	END_IF
	IF MemSvgAdr = 0 THEN // This will only be done once in the INIT of the task
		// Create memory for saving the image
		// Size: a 5MP picture in bmp format has less than 6.000.000 Bytes. A SVG with bas64 conversion maximum the 4/3 size.
		// UploadSize					:= 6000000;		// Upload of the picture data with httpClient
		// SvgHeaderSize				:= 2000; 		// Fileheader, ...
		// CrosshSize					:= 18000; 		// Crosshairs, Texts, ...
		MemSvgSize						:= 6000000 * 4 / 3 + 2000 + 18000;
		AsMemPartCreate_0.enable		:= TRUE;
		AsMemPartCreate_0.len			:= MemSvgSize + 1000; // 1000 Bytes for AsMemPart stuff/header
		AsMemPartCreate_0();
		IF AsMemPartCreate_0.status = 0 THEN
			// Svg mem for creating the svg file including the image
			AsMemPartAllocClear_0.len	:= MemSvgSize;
			AsMemPartAllocClear_0(enable := TRUE, ident := AsMemPartCreate_0.ident);
			IF AsMemPartAllocClear_0.status = 0 THEN
				MemSvgAdr 				:= AsMemPartAllocClear_0.mem;
			END_IF
		END_IF
	END_IF
	CASE Step OF
		0:
			visDownloadFileUrl := '';
			Status := ERR_FUB_BUSY;
			IF MemSvgAdr <> 0 THEN
				Step := 1;
			END_IF
		1:
			FileOpen_0.enable	:= TRUE;
			FileOpen_0.pDevice 	:= ADR(FileDevice);
			FileOpen_0.pFile	:= ADR(FileName);
			FileOpen_0();
			IF FileOpen_0.status = 0 THEN
				IF FileOpen_0.filelen <= MemSvgSize THEN // Make sure file fits into memory
					brsmemset(MemSvgAdr, 0, MemSvgSize);
					Step := 2;
				ELSE // File is too large
					Status := ERR_MEM_DOWNLOAD;
					Step := 0;
				END_IF
			ELSIF FileOpen_0.status <> ERR_FUB_BUSY THEN
				Status := FileOpen_0.status;
				Step := 0;
			END_IF
		2:
			FileRead_0.enable	:= TRUE;
			FileRead_0.ident	:= FileOpen_0.ident;
			FileRead_0.len		:= FileOpen_0.filelen;
			FileRead_0.pDest	:= MemSvgAdr;
			FileRead_0();
			IF FileRead_0.status = 0 THEN
				Step := 3;
			ELSIF FileRead_0.status <> ERR_FUB_BUSY THEN
				Status := FileRead_0.status;
				Step := 0;
			END_IF
		3:
			FileClose_0.enable	:= TRUE;
			FileClose_0.ident	:= FileOpen_0.ident;
			FileClose_0();
			IF FileClose_0.status = 0 THEN
				Step := 4;
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				Status := FileClose_0.status;
				Step := 0;
			END_IF
		4:
			TON_Timeout(IN := FALSE);
			httpService_Download(enable := FALSE, send := FALSE);
			IF httpService_Download.status = ERR_FUB_ENABLE_FALSE THEN
				Step := 5;
			END_IF
		5:
			// Create response header
			response_header_data :=  'Content-Type: application/octet-stream; Content-Transfer-Encoding: binary; Content-Disposition: attachment; filename="';
			brsstrcat(ADR(response_header_data), ADR(ImgName));
			brsstrcat(ADR(response_header_data), ADR('"'));
			// Pre-configure web service for download
			response_header.rawHeader.pData 	:= ADR(response_header_data);
			response_header.rawHeader.dataSize 	:= SIZEOF(response_header_data);		
			response_header.rawHeader.dataLen 	:= brsstrlen(ADR(response_header_data));
			// Start web service
			httpService_Download.enable 			:= TRUE;
			httpService_Download.option 			:= httpOPTION_HTTP_10 + httpOPTION_SERVICE_TYPE_NAME;
			httpService_Download.pResponseData 		:= MemSvgAdr;
			httpService_Download.pResponseHeader	:= ADR(response_header);
			httpService_Download.pServiceName 		:= ADR(ImgName);
			httpService_Download.responseDataLen 	:= FileOpen_0.filelen;
			httpService_Download();
			
			// Timeout if file is not pulled from browser
			TON_Timeout(IN := TRUE, PT := T#3s);
			IF TON_Timeout.Q THEN
				Status := ERR_TIMEOUT_DOWNLOAD;
				Step := 0;
			END_IF

			IF httpService_Download.status = ERR_FUB_BUSY AND visDownloadFileUrl = '' THEN // Set URL
				brsstrcpy(ADR(visDownloadFileUrl), ADR(ImgName));
			ELSIF httpService_Download.status = 0 AND NOT httpService_Download.send AND visDownloadFileUrl <> '' THEN // Start sending data
				httpService_Download.send := TRUE;
			ELSIF httpService_Download.send THEN // Sending data in progress
				Step := 6;
			ELSIF httpService_Download.status <> ERR_FUB_BUSY AND httpService_Download.status <> 0 THEN // Error
				Status := httpService_Download.status;
				Step := 0;
			END_IF
		
		6: // Wait until download is ready
			httpService_Download();
			TON_Timeout(IN := TRUE, PT := T#3s);
			IF TON_Timeout.Q THEN
				Status := ERR_TIMEOUT_DOWNLOAD;
				Step := 0;
			END_IF
		
			IF httpService_Download.phase = httpPHASE_WAITING THEN
				httpService_Download.send := FALSE;
				Status := 0;
				Step := 0;
			ELSIF httpService_Download.status <> ERR_FUB_BUSY THEN
				Status := httpService_Download.status;
				Step := 0;
			END_IF
		100:
	END_CASE
END_FUNCTION_BLOCK