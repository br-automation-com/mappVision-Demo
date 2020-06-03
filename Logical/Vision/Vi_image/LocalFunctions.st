FUNCTION_BLOCK ViDownloadImage
	visDownloadFileUrl ACCESS AdrVisDownloadFileUrl;
	IF NOT Enable THEN
		Status := ERR_FUB_ENABLE_FALSE;
	END_IF
	CASE Step OF
		0:
			Step := 10;
			Status := ERR_FUB_BUSY;
		10:
			FileOpen_0.enable	:= TRUE;
			FileOpen_0.pDevice 	:= ADR(FileDevice);
			FileOpen_0.pFile	:= ADR(FileName);
			FileOpen_0();
			IF FileOpen_0.status = 0 THEN
				IF FileOpen_0.filelen <= MemSize THEN // Make sure file fits into memory
					brsmemset(MemAdr, 0, MemSize);
					Step := 1;
				ELSE // File is too large
					Status := ERR_MEM_DOWNLOAD;
					Step := 0;
				END_IF
			ELSIF FileOpen_0.status <> ERR_FUB_BUSY THEN
				Status := FileOpen_0.status;
				Step := 0;
			END_IF
		1:			
			FileRead_0.enable	:= TRUE;
			FileRead_0.ident	:= FileOpen_0.ident;
			FileRead_0.len		:= FileOpen_0.filelen;
			FileRead_0.pDest	:= MemAdr;
			FileRead_0();
			IF FileRead_0.status = 0 THEN
				Step := 2;
			ELSIF FileRead_0.status <> ERR_FUB_BUSY THEN
				Status := FileRead_0.status;
				Step := 0;
			END_IF
		2:			
			FileClose_0.enable	:= TRUE;
			FileClose_0.ident	:= FileOpen_0.ident;
			FileClose_0();
			IF FileClose_0.status = 0 THEN
				TON_Timeout.IN := FALSE;
				TON_Timeout();
				Step := 3;
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				Status := FileClose_0.status;
				Step := 0;
			END_IF		
		3:
			httpService_Download.enable := FALSE;
			httpService_Download();
			Step := 4;
		4:
			// Create response header
			response_header_data :=  'Content-Type: application/octet-stream; Content-Transfer-Encoding: binary; Content-Disposition: attachment; filename="';
			brsstrcat(ADR(response_header_data), ADR(ImgName));
			brsstrcat(ADR(response_header_data), ADR('"'));
			// Pre-configure web service for download
			response_header.rawHeader.pData 	:= ADR(response_header_data);
			response_header.rawHeader.dataSize 	:= SIZEOF(response_header_data);		
			response_header.rawHeader.dataLen 	:= brsstrlen(ADR(response_header_data));
			
			// ----------------------------------------------------------------------------------------
			// Start web service
			httpService_Download.enable 			:= TRUE;
			httpService_Download.option 			:= httpOPTION_HTTP_10 + httpOPTION_SERVICE_TYPE_NAME;
			httpService_Download.pResponseData 		:= MemAdr;
			httpService_Download.pResponseHeader	:= ADR(response_header);
			httpService_Download.pServiceName 		:= ADR(ImgName);
			httpService_Download.responseDataLen 	:= FileOpen_0.filelen;
			httpService_Download();
			
			// ----------------------------------------------------------------------------------------
			// Timeout if file is not pulled from browser
			TON_Timeout.IN := TRUE;
			TON_Timeout.PT := T#3s;
			TON_Timeout();
			IF TON_Timeout.Q THEN
				Status := ERR_TIMEOUT_DOWNLOAD;
				Step := 0;
			END_IF

			// ----------------------------------------------------------------------------------------
			// Set URL
			IF httpService_Download.status = ERR_FUB_BUSY AND visDownloadFileUrl = '' THEN
				brsstrcpy(ADR(visDownloadFileUrl), ADR(ImgName));
				// Start sending data
			ELSIF httpService_Download.status = 0 AND NOT httpService_Download.send AND visDownloadFileUrl <> '' THEN
				httpService_Download.send := TRUE;
			// Sending data finished
			ELSIF httpService_Download.send THEN
				Step := 5;
			// Error
			ELSIF httpService_Download.status <> ERR_FUB_BUSY AND httpService_Download.status <> 0 THEN
				Status := httpService_Download.status;
				Step := 0;
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Download file - web service
		// --------------------------------------------------------------------------------------------------------------------
		5:
			httpService_Download();
			TON_Timeout();
			IF TON_Timeout.Q THEN
				Status := ERR_TIMEOUT_DOWNLOAD;
				Step := 0;
			END_IF
			
			// ----------------------------------------------------------------------------------------
			// Start sending data
			IF httpService_Download.phase = httpPHASE_WAITING THEN
				//visDownloadFileUrl := '';
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