// --------------------------------------------------------------------------------------------------------------------
// Vision image upload task. This task stores the camera image on the file device media
// Version 2.0
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	IF RemCfgImage.ConvertCycles = 0 THEN 							// Invalid --> use default values
		gVisionImage.CFG.FileDevice 	:= 'VisionFileDevice';		// File device name where the images are stored
		gVisionImage.CFG.DirName		:= 'Vision';				// Directory used for images
		gVisionImage.CFG.CameraIP		:= '192.168.200.';			// IP adress of the camera
		gVisionImage.CFG.ConvertCycles	:= 10000;					// Conversioncycles per Step (TK8 call). Use higer value on high performance CPU, use
																	// lower values on low performance CPU (e.g. Compact-S) or in case of cycle time violations
		gVisionImage.CFG.Format			:= 0;						// Image type, use 0 for JPEG, 1 for bitmap
		gVisionImage.CFG.QualityJPG		:= 80;						// Quality for JPG images, larger numbers produce better images
		gVisionImage.CFG.UploadBmpJpg	:= TRUE;
		gVisionImage.CFG.UploadSVG		:= TRUE;
	ELSE
		brsmemcpy(ADR(gVisionImage.CFG), ADR(RemCfgImage), SIZEOF(RemCfgImage)); // Restore default values from remanent memory
	END_IF
	gVisionImage.CMD.CreateDir	:= TRUE;
	visSelectedImage			:= '';

	RequestHeader.keepAlive		:= 'timeout=5, max=100';
	brsmemcpy(ADR(b64key), ADR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'), SIZEOF(b64key));
	
	// Create memory for uploading and transforming image
	// Size: a 5MP picture in bmp format has less than 6.000.000 Bytes. A SVG with bas64 conversion maximum the 4/3 size.
	MemUploadSize		:= 6000000;		// Upload of the picture data with httpClient
	MemSvgHeaderSize	:= 2000; 		// Fileheader, ...
	MemSvgCrosshSize	:= 18000; 		// Crosshairs, Texts, ...
	MemSvgSize			:= MemUploadSize * 4 / 3 + MemSvgHeaderSize + MemSvgCrosshSize;
	AsMemPartCreate_0.enable	:= TRUE;
	AsMemPartCreate_0.len		:= MemUploadSize + MemSvgSize + MemSvgCrosshSize + 1000; // 1000 Bytes for AsMemPart stuff/header
	AsMemPartCreate_0();
	IF AsMemPartCreate_0.status = 0 THEN
		AsMemPartAllocClear_0.enable	:= TRUE;
		AsMemPartAllocClear_0.ident		:= AsMemPartCreate_0.ident;
		AsMemPartAllocClear_0.len		:= MemUploadSize;
		AsMemPartAllocClear_0();
		IF AsMemPartAllocClear_0.status = 0 THEN
			MemUpload := AsMemPartAllocClear_0.mem;
		END_IF
		AsMemPartAllocClear_0.len		:= MemSvgSize;
		AsMemPartAllocClear_0();
		IF AsMemPartAllocClear_0.status = 0 THEN
			MemSvg := AsMemPartAllocClear_0.mem;
		END_IF
		AsMemPartAllocClear_0.len		:= MemSvgCrosshSize;
		AsMemPartAllocClear_0();
		IF AsMemPartAllocClear_0.status = 0 THEN
			MemSvgCrossh := AsMemPartAllocClear_0.mem;
		END_IF
	END_IF
	ACTION_InitTexts;
END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC
	
//	IF(test = 1) THEN
//		ViBaseSaveDiagInfo_01.Execute := TRUE;
//		ViBaseSaveDiagInfo_01.MpLink := ADR(gCameraCodeReading);
//		ViBaseSaveDiagInfo_01.DeviceName := ADR('VisionFileDevice');
//		ViBaseSaveDiagInfo_01.FileName := ADR('test');
//		ViBaseSaveDiagInfo_01();
//	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// State machine for uploading the image
	// -----------------------------------------------------------------------------------------------------------
	CASE Step OF
		// -----------------------------------------------------------------------------------------------------------
		// Wait for new upload command
		VISTEP_WAIT:
			// -----------------------------------------------------------------------------------------------------------
			// Create the internal directory VisionImageArchive
			IF gVisionImage.CMD.CreateDir THEN 
				gVisionImage.STA.Status := 65535;
				Step := VISTEP_CREATE_DIR;
			// -----------------------------------------------------------------------------------------------------------
			// Delete image directory
			ELSIF gVisionImage.CMD.DeleteDir THEN
				gVisionImage.STA.Status := 65535;
				Step := VISTEP_DELETE_DIR;
			// -----------------------------------------------------------------------------------------------------------
			// Refresh image data from file device
			ELSIF gVisionImage.CMD.Refresh THEN 
				gVisionImage.STA.Status := 65535;
				Step := VISTEP_READ_DIR1;
			// -----------------------------------------------------------------------------------------------------------
			// Delete image data from file device
			ELSIF gVisionImage.CMD.Delete THEN 
				IF brsstrlen(ADR(visSelectedImage)) > 0 THEN
					brsstrcpy(ADR(tmpStr1), ADR(gVisionImage.CFG.DirName));
					brsstrcat(ADR(tmpStr1), ADR('/'));
					brsstrcat(ADR(tmpStr1), ADR(visSelectedImage));
					gVisionImage.STA.Status := 65535;
					Step := VISTEP_DELETE_IMAGE;
				ELSE 
					gVisionImage.CMD.Delete := FALSE;
				END_IF
			// -----------------------------------------------------------------------------------------------------------
			// Download image data from file device
			ELSIF gVisionImage.CMD.Download THEN // Download image data from file device
				IF brsstrlen(ADR(visSelectedImage)) > 0 THEN
					brsstrcpy(ADR(tmpStr1), ADR(gVisionImage.CFG.DirName));
					brsstrcat(ADR(tmpStr1), ADR('/'));
					brsstrcat(ADR(tmpStr1), ADR(visSelectedImage));
					gVisionImage.STA.Status := 65535;
					visDownloadFileUrl := '';
					Step := VISTEP_DOWNLOAD_IMAGE;
				ELSE // If no pictures are available, don't try to delete pictures
				END_IF
			// -----------------------------------------------------------------------------------------------------------
			// Load image from camera
			ELSIF gVisionImage.CMD.Save THEN
				// Do nothing, because of no picture is needed
				IF NOT gVisionImage.CFG.UploadBmpJpg AND NOT gVisionImage.CFG.UploadSVG THEN 
					gVisionImage.CMD.Save := FALSE;
				ELSE
					// Generate new file name
					DTGetTime_0.enable := 1;
					DTGetTime_0();
					DT_TO_DTStructure(DTGetTime_0.DT1, ADR(DTStructure_0));
					FileNamePict := gVisionImage.CFG.DirName;
					brsstrcat(ADR(FileNamePict), ADR('/'));
					tmpStr1 := UINT_TO_STRING(DTStructure_0.year);
					brsstrcat(ADR(FileNamePict), ADR(tmpStr1));
					brsstrcat(ADR(FileNamePict), ADR('_'));
					tmpStr1 := USINT_TO_STRING(DTStructure_0.month);
					IF(DTStructure_0.month < 10) THEN
						brsstrcat(ADR(FileNamePict), ADR('0'));
					END_IF
					brsstrcat(ADR(FileNamePict), ADR(tmpStr1));
					brsstrcat(ADR(FileNamePict), ADR('_'));
					tmpStr1 := USINT_TO_STRING(DTStructure_0.day);
					IF(DTStructure_0.day < 10) THEN
						brsstrcat(ADR(FileNamePict), ADR('0'));
					END_IF
					brsstrcat(ADR(FileNamePict), ADR(tmpStr1));
					brsstrcat(ADR(FileNamePict), ADR('_'));
					tmpStr1 := USINT_TO_STRING(DTStructure_0.hour);
					IF(DTStructure_0.hour < 10) THEN
						brsstrcat(ADR(FileNamePict), ADR('0'));
					END_IF
					brsstrcat(ADR(FileNamePict), ADR(tmpStr1));
					brsstrcat(ADR(FileNamePict), ADR('_'));
					tmpStr1 := USINT_TO_STRING(DTStructure_0.minute);
					IF(DTStructure_0.minute < 10) THEN
						brsstrcat(ADR(FileNamePict), ADR('0'));
					END_IF
					brsstrcat(ADR(FileNamePict), ADR(tmpStr1));
					brsstrcat(ADR(FileNamePict), ADR('_'));
					tmpStr1 := USINT_TO_STRING(DTStructure_0.second);
					IF(DTStructure_0.second < 10) THEN
						brsstrcat(ADR(FileNamePict), ADR('0'));
					END_IF
					brsstrcat(ADR(FileNamePict), ADR(tmpStr1));
					brsstrcat(ADR(FileNamePict), ADR('.'));
					brsstrcpy(ADR(FileNameSvg), ADR(FileNamePict)); // Same filename but differend ending
					IF gVisionImage.CFG.Format = 0 THEN
						brsstrcat(ADR(FileNamePict), ADR('jpg'));
					ELSE
						brsstrcat(ADR(FileNamePict), ADR('bmp'));
					END_IF
					brsstrcat(ADR(FileNameSvg), ADR('svg'));
					// Set default parameters
					gVisionImage.STA.Status		:= 65535;
					Step						:= VISTEP_REQUEST1;
				END_IF
			// -----------------------------------------------------------------------------------------------------------
			// Reset error
			ELSIF gVisionImage.CMD.ResetError THEN
				gVisionImage.CMD.ResetError := FALSE;
				// no error, so do nothing else
			END_IF
					
			// -----------------------------------------------------------------------------------------------------------
			// Load new image into window
			IF visSelectedImageOld <> visSelectedImage AND dir_entry > 0 THEN
				brsmemset(ADR(visImagePath), 0, SIZEOF(visImagePath));
				brsmemset(ADR(tmpStr1), 0, SIZEOF(tmpStr1));
				visImagePath := '/FileDevice:';
				brsstrcat(ADR(visImagePath), ADR(gVisionImage.CFG.FileDevice));
				brsstrcat(ADR(visImagePath), ADR('/'));
				brsstrcat(ADR(visImagePath), ADR(gVisionImage.CFG.DirName));
				brsstrcat(ADR(visImagePath), ADR('/'));
				brsstrcat(ADR(visImagePath), ADR(visSelectedImage));
			END_IF
			visSelectedImageOld := visSelectedImage;
			
			// -----------------------------------------------------------------------------------------------------------
			// Disable buttons when command is pending
			IF Step = VISTEP_WAIT THEN 
				visEnableButtons_1 := TRUE;
			ELSE
				visEnableButtons_1 := FALSE;
			END_IF
			
			// -----------------------------------------------------------------------------------------------------------
			// Enable delete and download button in mappView
			IF visEnableButtons_1 AND dir_entry > 0 AND Step = VISTEP_WAIT THEN
				visEnableButtons_2 := TRUE;
			ELSE
				brsmemset(ADR(visImagePath), 0, SIZEOF(visImagePath));
				visEnableButtons_2 := FALSE;
			END_IF

		// -----------------------------------------------------------------------------------------------------------
		// Create directory on User-Partition, if not exists
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_CREATE_DIR:
			DirCreate_0.enable	:= TRUE;
			DirCreate_0.pDevice	:= ADR(gVisionImage.CFG.FileDevice);
			DirCreate_0.pName	:= ADR(gVisionImage.CFG.DirName);
			DirCreate_0();
			IF DirCreate_0.status = 0 OR DirCreate_0.status = fiERR_DIR_ALREADY_EXIST THEN
				Step := VISTEP_READ_DIR1;
			ELSIF DirCreate_0.status <> 65535 THEN
				gVisionImage.STA.Status := DirCreate_0.status;
				Step := VISTEP_ERR;
			END_IF
		// -----------------------------------------------------------------------------------------------------------
		// Delete directory on User-Partition
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_DELETE_DIR:
			DirDeleteEx_0.enable	:= TRUE;
			DirDeleteEx_0.pDevice	:= ADR(gVisionImage.CFG.FileDevice);
			DirDeleteEx_0.pName		:= ADR(gVisionImage.CFG.DirName);
			DirDeleteEx_0();
			IF DirDeleteEx_0.status = 0 THEN
				Step := VISTEP_CREATE_DIR;
			ELSIF DirDeleteEx_0.status <> 65535 THEN
				gVisionImage.STA.Status := DirDeleteEx_0.status;
				Step := VISTEP_ERR;
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Download file
		// --------------------------------------------------------------------------------------------------------------------
		VISTEP_DOWNLOAD_IMAGE:						
			// ----------------------------------------------------------------------------------------
			// Initialize file open structure
			FOpen.enable	:= TRUE;
			FOpen.pDevice 	:= ADR(gVisionImage.CFG.FileDevice);
			FOpen.pFile		:= ADR(tmpStr1);
			FOpen();
			
			// ----------------------------------------------------------------------------------------
			// OK
			IF (FOpen.status = 0) THEN
				// Make sure file fits into memory
				IF(FOpen.filelen <= MemUploadSize) THEN
					// Clear memory and reset web service
					brsmemset(MemUpload, 0, MemUploadSize);
					WebserviceDownload.enable := FALSE;
					WebserviceDownload();
					Step := VISTEP_DOWNLOAD_IMAGE_1;
					// File is too large
				ELSE
					gVisionImage.STA.Status := ERR_MEM_DOWNLOAD;
					Step := VISTEP_ERR;
				END_IF;
				// Error
			ELSIF (FOpen.status <> ERR_FUB_BUSY) THEN
				gVisionImage.STA.Status := FOpen.status;
				Step := VISTEP_ERR;
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Download file
		// --------------------------------------------------------------------------------------------------------------------
		VISTEP_DOWNLOAD_IMAGE_1:			
			// ----------------------------------------------------------------------------------------
			// Initialize file read structure
			FRead.enable	:= TRUE;
			FRead.ident		:= FOpen.ident;
			FRead.len		:= FOpen.filelen;
			FRead.pDest		:= MemUpload;
			FRead();
			
			// ----------------------------------------------------------------------------------------
			// OK
			IF (FRead.status = 0) THEN
				Step := VISTEP_DOWNLOAD_IMAGE_2;
				// Error
			ELSIF (FRead.status <> ERR_FUB_BUSY) THEN
				gVisionImage.STA.Status := FRead.status;
				Step := VISTEP_ERR;
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Download file
		// --------------------------------------------------------------------------------------------------------------------
		VISTEP_DOWNLOAD_IMAGE_2:			
			// ----------------------------------------------------------------------------------------
			// Initialize file close structure
			FileClose_0.enable	:= TRUE;
			FileClose_0.ident	:= FOpen.ident;
			FileClose_0();
			
			// ----------------------------------------------------------------------------------------
			// OK
			IF (FileClose_0.status = 0) THEN
				download_timeout.IN := 0;
				download_timeout();
				Step := VISTEP_DOWNLOAD_IMAGE_3;
				// Error
			ELSIF (FileClose_0.status <> ERR_FUB_BUSY) THEN
				gVisionImage.STA.Status := FileClose_0.status;
				Step := VISTEP_ERR;
			END_IF		
		// --------------------------------------------------------------------------------------------------------------------
		// Download file - web service
		// --------------------------------------------------------------------------------------------------------------------
		VISTEP_DOWNLOAD_IMAGE_3:			
			// ----------------------------------------------------------------------------------------
			// Create response header
			response_header_data :=  'Content-Type: application/octet-stream; Content-Transfer-Encoding: binary; Content-Disposition: attachment; filename="';
			brsstrcat(ADR(response_header_data), ADR(visSelectedImage));
			brsstrcat(ADR(response_header_data), ADR('"'));
			
			// ----------------------------------------------------------------------------------------
			// Pre-configure web service for download
			response_header.rawHeader.pData 	:= ADR(response_header_data);
			response_header.rawHeader.dataSize 	:= SIZEOF(response_header_data);		
			response_header.rawHeader.dataLen 	:= brsstrlen(ADR(response_header_data));
			
			// ----------------------------------------------------------------------------------------
			// Start web service
			WebserviceDownload.enable 			:= TRUE;
			WebserviceDownload.option 			:= httpOPTION_HTTP_10 + httpOPTION_SERVICE_TYPE_NAME;
			WebserviceDownload.pResponseData 	:= MemUpload;
			WebserviceDownload.pResponseHeader	:= ADR(response_header);
			WebserviceDownload.pServiceName 	:= ADR(visSelectedImage);
			WebserviceDownload.responseDataLen 	:= FOpen.filelen;
			WebserviceDownload();
			
			// ----------------------------------------------------------------------------------------
			// Timeout if file is not pulled from browser
			download_timeout.IN := 1;
			download_timeout.PT := 300;
			download_timeout();
			IF(download_timeout.Q) THEN
				gVisionImage.STA.Status := ERR_TIMEOUT_DOWNLOAD;
				Step := VISTEP_ERR;
			END_IF

			// ----------------------------------------------------------------------------------------
			// Set URL
			IF (WebserviceDownload.status = ERR_FUB_BUSY AND visDownloadFileUrl = '') THEN
				brsstrcat(ADR(visDownloadFileUrl), ADR(visSelectedImage));
				// Start sending data
			ELSIF (WebserviceDownload.status = 0 AND WebserviceDownload.send = FALSE AND visDownloadFileUrl <> '') THEN
				WebserviceDownload.send := TRUE;
			// Sending data finished
			ELSIF (WebserviceDownload.send = TRUE) THEN
				Step := VISTEP_DOWNLOAD_IMAGE_4;
			// Error
			ELSIF (WebserviceDownload.status <> ERR_FUB_BUSY AND WebserviceDownload.status <> 0) THEN
				gVisionImage.STA.Status := WebserviceDownload.status;
				Step := VISTEP_ERR;
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Download file - web service
		// --------------------------------------------------------------------------------------------------------------------
		VISTEP_DOWNLOAD_IMAGE_4:			
			WebserviceDownload();
			download_timeout();
			IF(download_timeout.Q) THEN
				gVisionImage.STA.Status := ERR_TIMEOUT_DOWNLOAD;
				Step := VISTEP_ERR;
			END_IF
			
			// ----------------------------------------------------------------------------------------
			// Start sending data
			IF (WebserviceDownload.phase = httpPHASE_WAITING) THEN
				visDownloadFileUrl := '';
				WebserviceDownload.send := FALSE;
				gVisionImage.CMD.Download := FALSE;
				gVisionImage.STA.Status := 0;
				Step := VISTEP_WAIT;
			// Error
			ELSIF (WebserviceDownload.status <> ERR_FUB_BUSY) THEN
				gVisionImage.STA.Status := WebserviceDownload.status;
				Step := VISTEP_ERR;
			END_IF
		// -----------------------------------------------------------------------------------------------------------
		// Read all existing image names from directory
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_READ_DIR1:
			// Clear all memory
			brsmemset(ADR(gVisionImage.DATA.Images), 0, SIZEOF(gVisionImage.DATA.Images));
			brsmemset(ADR(visSelectedImage), 0, SIZEOF(visSelectedImage));
			visSelectedImageOld := '';
			visSelectedImage	:= '';
			dir_entry			:= 0;
			idx					:= 0;
			file_newest			:= '';
			file_oldest			:= '';
			date_newest			:= UDINT_TO_DT(0);
			date_oldest			:= DT#2100-06-06-12:00:00;
			cmdDeleteOldest		:= FALSE;
			Step := VISTEP_READ_DIR2;		
		// -----------------------------------------------------------------------------------------------------------
		// Proceed with next entry
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_READ_DIR2: 
			DirRead_0.enable 	:= 1;
			DirRead_0.pDevice 	:= ADR(gVisionImage.CFG.FileDevice);
			DirRead_0.pPath		:= ADR(gVisionImage.CFG.DirName);
			DirRead_0.entry 	:= idx;
			DirRead_0.option 	:= fiFILE;
			DirRead_0.pData 	:= ADR(dir_data);
			DirRead_0.data_len 	:= SIZEOF(dir_data);
			DirRead_0();
			IF DirRead_0.status = 0 THEN
				// Make sure file is an image and we have space to store them
				IF  brsstrcmp(ADR(dir_data.Filename) + brsstrlen(ADR(dir_data.Filename)) - 4, ADR('.bmp')) = 0 OR
				    brsstrcmp(ADR(dir_data.Filename) + brsstrlen(ADR(dir_data.Filename)) - 4, ADR('.jpg')) = 0 OR
					brsstrcmp(ADR(dir_data.Filename) + brsstrlen(ADR(dir_data.Filename)) - 4, ADR('.svg')) = 0 THEN
					// Find newest and oldest file
					IF dir_data.Date > date_newest THEN
						brsstrcpy(ADR(file_newest), ADR(dir_data.Filename));
						date_newest := dir_data.Date;
					END_IF
					IF dir_data.Date < date_oldest THEN
						brsstrcpy(ADR(file_oldest), ADR(dir_data.Filename));
						date_oldest := dir_data.Date;
					END_IF
					IF dir_entry <= SIZEOF(gVisionImage.DATA.Images)/SIZEOF(gVisionImage.DATA.Images[0]) - 1 THEN
						// Create list box data
						gVisionImage.DATA.Images[dir_entry] := '{"value":"';
						brsstrcat(ADR(gVisionImage.DATA.Images[dir_entry]), ADR(dir_data.Filename));					
						brsstrcat(ADR(gVisionImage.DATA.Images[dir_entry]), ADR('","text":"'));	
						brsstrcat(ADR(gVisionImage.DATA.Images[dir_entry]), ADR(dir_data.Filename));					
						brsstrcat(ADR(gVisionImage.DATA.Images[dir_entry]), ADR('"}'));	
						dir_entry := dir_entry + 1;
					ELSE
						cmdDeleteOldest := TRUE;
					END_IF
				END_IF
				idx := idx + 1;
			ELSIF DirRead_0.status = fiERR_NO_MORE_ENTRIES THEN // Finish up when last entry was reached
				IF cmdDeleteOldest THEN // Delete oldest file if there are too many entries
					brsstrcpy(ADR(tmpStr1), ADR(gVisionImage.CFG.DirName));
					brsstrcat(ADR(tmpStr1), ADR('/'));
					brsstrcat(ADR(tmpStr1), ADR(file_oldest));
					Step := VISTEP_DELETE_IMAGE;
				ELSE
					TON_VisPause(IN := FALSE);
					Step := VISTEP_READ_DIR3;				
				END_IF
			ELSIF DirRead_0.status <> 65535 THEN
				gVisionImage.STA.Status := DirRead_0.status;
				Step := VISTEP_ERR;
			END_IF
		// -----------------------------------------------------------------------------------------------------------
		// Wait for vis before setting last file
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_READ_DIR3:
			TON_VisPause.IN := TRUE;
			TON_VisPause.PT := T#250ms;
			TON_VisPause();
			IF TON_VisPause.Q THEN
				brsstrcpy(ADR(visSelectedImage), ADR(file_newest));
				brsmemset(ADR(gVisionImage.CMD), 0, SIZEOF(gVisionImage.CMD));
				gVisionImage.STA.Status := 0;
				Step := VISTEP_WAIT;
			END_IF
		// -----------------------------------------------------------------------------------------------------------
		// Delete Image
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_DELETE_IMAGE:
			cmdDeleteOldest			:= FALSE;
			FileDelete_0.enable 	:= 1;
			FileDelete_0.pDevice	:= ADR(gVisionImage.CFG.FileDevice);
			FileDelete_0.pName 		:= ADR(tmpStr1);
			FileDelete_0();
			IF FileDelete_0.status = 0 THEN
				Step := VISTEP_READ_DIR1; // Refresh --> Read dir again
			ELSIF FileDelete_0.status <> 65535 THEN
				gVisionImage.STA.Status := FileDelete_0.status;
				Step := VISTEP_ERR;
			END_IF
		// -----------------------------------------------------------------------------------------------------------
		// Start new request, reset timeout timer
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_REQUEST1:
			DiagStartTime := clock_ms();
			// Create URI
			tmpStr1 := '/';
			IF gVisionImage.CFG.Format = 0 THEN
				brsstrcat(ADR(tmpStr1), ADR('jpg'));
			ELSE
				brsstrcat(ADR(tmpStr1), ADR('bmp'));
			END_IF
			IF gVisionImage.CFG.Format = 0 THEN
				brsitoa(gVisionImage.CFG.QualityJPG, ADR(tmpStr2));
				brsstrcat(ADR(tmpStr1), ADR('?q='));
				brsstrcat(ADR(tmpStr1), ADR(tmpStr2));				
			END_IF
			// Reset timer and HTTP client
			TON_ReloadTimeout(IN := FALSE);
			httpClient_0.enable	:= FALSE;
			httpClient_0();
			IF httpClient_0.status = ERR_FUB_ENABLE_FALSE THEN
				httpClient_0.abort	:= FALSE;
				Step := VISTEP_REQUEST2;
			END_IF
		// -----------------------------------------------------------------------------------------------------------
		// Wait for response
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_REQUEST2: 
			tmpStr3 := gVisionImage.CFG.CameraIP;
			brsitoa(visSelectedSensor, ADR(tmpStr2));
			brsstrcat(ADR(tmpStr3), ADR(tmpStr2));
			
			TON_ReloadTimeout.PT := T#10s;
			TON_ReloadTimeout.IN := TRUE;
			TON_ReloadTimeout(); // Time out when no response after 10s
			httpClient_0.enable				:= TRUE;
			httpClient_0.send				:= TRUE;
			httpClient_0.method 			:= httpMETHOD_GET;
			httpClient_0.option 			:= httpOPTION_HTTP_11;
			httpClient_0.hostPort			:= 8080;
			httpClient_0.pHost 				:= ADR(tmpStr3);
			httpClient_0.pUri 				:= ADR(tmpStr1);
			httpClient_0.pResponseData 		:= MemUpload;
			httpClient_0.responseDataSize	:= MemUploadSize;
			httpClient_0.pRequestHeader		:= ADR(RequestHeader);
			httpClient_0();
			IF httpClient_0.status = 0 AND httpClient_0.responseDataLen <> 0 THEN
				UploadImgSize		:= httpClient_0.responseDataLen;
				httpClient_0.send	:= FALSE;
				httpClient_0();
				IF gVisionImage.CFG.UploadBmpJpg THEN
					Step := VISTEP_SAVE1;
				ELSE
					Step := VISTEP_SVG_PREPARE;
				END_IF
			ELSIF httpClient_0.status <> ERR_FUB_BUSY AND httpClient_0.status <> 0 THEN
				gVisionImage.STA.Status := httpClient_0.status;
				Step := VISTEP_ERR;
			ELSIF TON_ReloadTimeout.Q THEN // Timout! httpClient takes too long, so abort
				gVisionImage.STA.Status := ERR_NO_IMAGE;
				Step := VISTEP_ERR;
			END_IF
		// -----------------------------------------------------------------------------------------------------------
		// Save bmp/jpg file
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_SAVE1:
			DiagTime.BeginSaveBMPJPG := clock_ms() - DiagStartTime;
			FileCreate_0.enable		:= TRUE;
			FileCreate_0.pDevice	:= ADR(gVisionImage.CFG.FileDevice);
			FileCreate_0.pFile		:= ADR(FileNamePict);
			FileCreate_0();
			IF FileCreate_0.status = 0 THEN
				Step := VISTEP_SAVE2;
			ELSIF FileCreate_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.STA.Status := FileCreate_0.status;
				Step := VISTEP_ERR;
			END_IF	
		VISTEP_SAVE2:
			FileWrite_0.enable		:= TRUE;
			FileWrite_0.ident		:= FileCreate_0.ident;
			FileWrite_0.offset		:= 0;
			FileWrite_0.pSrc		:= MemUpload;
			FileWrite_0.len			:= UploadImgSize;
			FileWrite_0();
			IF FileWrite_0.status = 0 THEN
				Step := VISTEP_SAVE3;
			ELSIF FileWrite_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.STA.Status := FileWrite_0.status;
				Step := VISTEP_ERR;
			END_IF	
		VISTEP_SAVE3:
			FileClose_0.enable		:= TRUE;
			FileClose_0.ident		:= FileCreate_0.ident;
			FileClose_0();
			IF FileClose_0.status = 0 THEN
				DiagTime.EndSaveBMPJPG := clock_ms() - DiagStartTime;
				IF gVisionImage.CFG.UploadSVG THEN
					Step := VISTEP_SVG_PREPARE;
				ELSE
					Step := VISTEP_READ_DIR1;
				END_IF
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.STA.Status := FileClose_0.status;
				Step := VISTEP_ERR;
			END_IF
		// -----------------------------------------------------------------------------------------------------------
		// Create SVG file with image and crosshair/texts
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_SVG_PREPARE:
			DiagTime.BeginSVG := clock_ms() - DiagStartTime;
			b64neededOutput	:= (UploadImgSize/3)*4 + BOOL_TO_UDINT(UDINT_TO_BOOL(UploadImgSize MOD 3))*4;
			IF b64neededOutput < MemSvgSize - MemSvgHeaderSize - MemSvgCrosshSize THEN
				brsmemset(MemSvg, 0, MemSvgSize); // clear complete memory
				// Prepare the svg header up to the base64 picture data
				brsstrcpy(MemSvg, ADR(SvgTexts.Header1));
				brsstrcat(MemSvg, ADR(FileNameSvg));
				brsstrcat(MemSvg, ADR(SvgTexts.Header2));
				IF gVisionImage.CFG.Format = 0 THEN
					brsstrcat(MemSvg, ADR('jpg'));
				ELSE
					brsstrcat(MemSvg, ADR('bmp'));
				END_IF
				brsstrcat(MemSvg, ADR(SvgTexts.Header3));
				Step := VISTEP_SVG_BAS64_1;
			ELSE
				gVisionImage.STA.Status := ERR_BUFF_TOO_SMALL;
				Step := VISTEP_ERR;
			END_IF
		// -----------------------------------------------------------------------------------------------------------
		// Code picture data with Base64 to embedd the picture into a svg file
		VISTEP_SVG_BAS64_1: 
			b64AdrInBuffer	:= MemUpload; // Original bmp or jpg picture
			b64AdrOutBuffer	:= MemSvg + brsstrlen(MemSvg); // Write to the end of the actual svg data
			b64actposIN		:= b64AdrInBuffer;
			b64actposOUT	:= b64AdrOutBuffer;
			Step := VISTEP_SVG_BAS64_2;
		VISTEP_SVG_BAS64_2:
			FOR i := 0 TO gVisionImage.CFG.ConvertCycles DO
				IF b64actposIN < b64AdrInBuffer + UploadImgSize THEN
					b64blockLen := UDINT_TO_USINT(LIMIT(0, b64AdrInBuffer + UploadImgSize - b64actposIN, 3));
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
					Step := VISTEP_SVG_CROSSH;
					EXIT;
				END_IF
				
			END_FOR
		// -----------------------------------------------------------------------------------------------------------
		// Prepare the second part after base64 picture data
		VISTEP_SVG_CROSSH: 
			brsmemset(MemSvgCrossh, 0, MemSvgCrosshSize);
			brsstrcat(MemSvgCrossh, ADR(SvgTexts.Header4));
			brsstrcat(MemSvgCrossh, ADR(SvgTexts.CrosshairDefinition));
			FOR i := 1 TO MAX_NUM_RESULTS DO
				IF gVisionImage.DATA.Crosshair[i].CrosshairX <> 0 AND gVisionImage.DATA.Crosshair[i].CrosshairY <> 0 THEN
					brsstrcat(MemSvgCrossh, ADR(SvgTexts.Crosshair1));
					brsitoa(REAL_TO_DINT(gVisionImage.DATA.Crosshair[i].CrosshairX), ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(','));
					brsitoa(REAL_TO_DINT(gVisionImage.DATA.Crosshair[i].CrosshairY), ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(') rotate('));
					brsitoa(REAL_TO_DINT(gVisionImage.DATA.Crosshair[i].CrosshairRotate), ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(',40,40)"/>'));
				END_IF
			END_FOR
			FOR i := 1 TO MAX_NUM_RESULTS DO
				IF gVisionImage.DATA.Crosshair[i].CrosshairX <> 0 AND gVisionImage.DATA.Crosshair[i].CrosshairY <> 0 THEN
					brsstrcat(MemSvgCrossh, ADR('$r$n$t'));
					brsstrcat(MemSvgCrossh, ADR(gVisionImage.DATA.Crosshair[i].Text));
				END_IF
			END_FOR
			brsstrcat(MemSvgCrossh, ADR(SvgTexts.SvgClose));
			Step := VISTEP_SVG_CONCAT;
		VISTEP_SVG_CONCAT:
			brsstrcat(MemSvg, MemSvgCrossh);
			Step := VISTEP_SVG_SAVE1;
		VISTEP_SVG_SAVE1:
			DiagTime.BeginSVGSave := clock_ms() - DiagStartTime;
			FileCreate_0.enable		:= TRUE;
			FileCreate_0.pDevice	:= ADR(gVisionImage.CFG.FileDevice);
			FileCreate_0.pFile		:= ADR(FileNameSvg);
			FileCreate_0();
			IF FileCreate_0.status = 0 THEN
				Step := VISTEP_SVG_SAVE2;
			ELSIF FileCreate_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.STA.Status := FileCreate_0.status;
				Step := VISTEP_ERR;
			END_IF
		VISTEP_SVG_SAVE2:
			FileWrite_0.enable		:= TRUE;
			FileWrite_0.ident		:= FileCreate_0.ident;
			FileWrite_0.offset		:= 0;
			FileWrite_0.pSrc		:= MemSvg;
			FileWrite_0.len			:= brsstrlen(MemSvg);
			FileWrite_0();
			IF FileWrite_0.status = 0 THEN
				Step := VISTEP_SVG_SAVE3;
			ELSIF FileWrite_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.STA.Status := FileWrite_0.status;
				Step := VISTEP_ERR;
			END_IF
		VISTEP_SVG_SAVE3:
			FileClose_0.enable		:= TRUE;
			FileClose_0.ident		:= FileCreate_0.ident;
			FileClose_0();
			IF FileClose_0.status = 0 THEN
				DiagTime.EndSVGSave := clock_ms() - DiagStartTime;
				Step := VISTEP_READ_DIR1;
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.STA.Status := FileClose_0.status;
				Step := VISTEP_ERR;
			END_IF
		// -----------------------------------------------------------------------------------------------------------
		// Error state
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_ERR:
			// Reset all commands and wait or ack
			httpClient_0.enable	:= TRUE;
			httpClient_0.send	:= FALSE;
			httpClient_0.abort	:= TRUE;
			httpClient_0();
			
			WebserviceDownload.enable := FALSE;
			WebserviceDownload();
			
			IF gVisionImage.CMD.ResetError THEN
				httpClient_0.abort := FALSE;
				httpClient_0();
				gVisionImage.CMD.ResetError := FALSE;
				gVisionImage.STA.Status := 0;
				Step := VISTEP_WAIT;				
			END_IF				
			brsmemset(ADR(gVisionImage.CMD), 0, SIZEOF(gVisionImage.CMD));
	END_CASE

	brsmemcpy(ADR(RemCfgImage), ADR(gVisionImage.CFG), SIZEOF(RemCfgImage));
END_PROGRAM