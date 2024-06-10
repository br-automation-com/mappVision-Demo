// --------------------------------------------------------------------------------------------------------------------
// Vision image upload task. This task stores the camera image on the file device media
// Version 2.0
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	gVisionImage.CFG.FileDevice 	:= 'VisionFileDevice';		// File device name where the images are stored
	gVisionImage.CFG.DirName		:= 'Vision';				// Directory used for images

	gVisionImage.CMD.CreateDir	:= TRUE;
	gVisionImage.DAT.ImageSelected	:= '';
	
	brsmemset(ADR(bufferImage), 0, SIZEOF(bufferImage));
	brsmemset(ADR(visCameraImage), 0, SIZEOF(visCameraImage));

END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC

	// -----------------------------------------------------------------------------------------------------------
	// State machine for uploading the image
	// -----------------------------------------------------------------------------------------------------------
	CASE Step OF
		// -----------------------------------------------------------------------------------------------------------
		// Wait for new upload command
		VISTEP_WAIT:
			gVisionImage.DAT.Status := 0;

			// -----------------------------------------------------------------------------------------------------------
			// Create the internal directory VisionImageArchive
			IF gVisionImage.CMD.CreateDir THEN 
				gVisionImage.DAT.Status := 65535;
				Step := VISTEP_CREATE_DIR;
				
				// -----------------------------------------------------------------------------------------------------------
				// Delete image directory
			ELSIF gVisionImage.CMD.DeleteDir THEN
				gVisionImage.DAT.Status := 65535;
				Step := VISTEP_DELETE_DIR;
				
				// -----------------------------------------------------------------------------------------------------------
			// Refresh image data from file device
			ELSIF gVisionImage.CMD.Refresh THEN 
				gVisionImage.DAT.Status := 65535;
				Step := VISTEP_READ_DIR1;
				
			// -----------------------------------------------------------------------------------------------------------
			// Delete image data from file device
			ELSIF gVisionImage.CMD.DeleteImage THEN 
				IF brsstrlen(ADR(gVisionImage.DAT.ImageSelected)) > 0 THEN
					brsstrcpy(ADR(FileNamePict), ADR(gVisionImage.CFG.DirName));
					brsstrcat(ADR(FileNamePict), ADR('/'));
					brsstrcat(ADR(FileNamePict), ADR(gVisionImage.DAT.ImageSelected));
					gVisionImage.DAT.Status := 65535;
					
					FileDelete_0.enable := FALSE;
					FileDelete_0();
					
					Step := VISTEP_DELETE_IMAGE;
				ELSE 
					gVisionImage.CMD.DeleteImage := FALSE;
				END_IF

				// -----------------------------------------------------------------------------------------------------------
				// Save image from camera
			ELSIF gVisionImage.CMD.GetImage THEN
				ViBaseGetImage_0.Execute := FALSE;
				ViBaseGetImage_0();
				httpEncodeBase64_0.enable := FALSE;
				httpEncodeBase64_0();				

				gVisionImage.DAT.Status		:= 65535;
				Step						:= VISTEP_REQUEST1;
				
				// -----------------------------------------------------------------------------------------------------------
				// Save image from camera
			ELSIF gVisionImage.CMD.SaveImage THEN
				// Generate file name if not provided
				IF gVisionImage.CFG.FileName = '' THEN
					// Generate new file name
					DTGetTime_0.enable := 1;
					DTGetTime_0();
					DT_TO_DTStructure(DTGetTime_0.DT1, ADR(DTStructure_0));
					FileNamePict := gVisionImage.CFG.DirName;
					brsstrcat(ADR(FileNamePict), ADR('/'));
					tmpStr := UINT_TO_STRING(DTStructure_0.year);
					brsstrcat(ADR(FileNamePict), ADR(tmpStr));
					brsstrcat(ADR(FileNamePict), ADR('_'));
					tmpStr := USINT_TO_STRING(DTStructure_0.month);
					IF(DTStructure_0.month < 10) THEN
						brsstrcat(ADR(FileNamePict), ADR('0'));
					END_IF
					brsstrcat(ADR(FileNamePict), ADR(tmpStr));
					brsstrcat(ADR(FileNamePict), ADR('_'));
					tmpStr := USINT_TO_STRING(DTStructure_0.day);
					IF(DTStructure_0.day < 10) THEN
						brsstrcat(ADR(FileNamePict), ADR('0'));
					END_IF
					brsstrcat(ADR(FileNamePict), ADR(tmpStr));
					brsstrcat(ADR(FileNamePict), ADR('_'));
					tmpStr := USINT_TO_STRING(DTStructure_0.hour);
					IF(DTStructure_0.hour < 10) THEN
						brsstrcat(ADR(FileNamePict), ADR('0'));
					END_IF
					brsstrcat(ADR(FileNamePict), ADR(tmpStr));
					brsstrcat(ADR(FileNamePict), ADR('_'));
					tmpStr := USINT_TO_STRING(DTStructure_0.minute);
					IF(DTStructure_0.minute < 10) THEN
						brsstrcat(ADR(FileNamePict), ADR('0'));
					END_IF
					brsstrcat(ADR(FileNamePict), ADR(tmpStr));
					brsstrcat(ADR(FileNamePict), ADR('_'));
					tmpStr := USINT_TO_STRING(DTStructure_0.second);
					IF(DTStructure_0.second < 10) THEN
						brsstrcat(ADR(FileNamePict), ADR('0'));
					END_IF
					brsstrcat(ADR(FileNamePict), ADR(tmpStr));
				ELSE
					FileNamePict := gVisionImage.CFG.FileName;
				END_IF

				brsstrcpy(ADR(FileNameSvg), ADR(FileNamePict));
				brsstrcat(ADR(FileNameSvg), ADR('.svg'));
				IF gVisionImage.CFG.ImageType = viBASE_IMAGE_TYPE_JPG THEN
					brsstrcat(ADR(FileNamePict), ADR('.jpg'));
				ELSE
					brsstrcat(ADR(FileNamePict), ADR('.bmp'));
				END_IF

				// Reset all function blocks
				FileCreate_0.enable := FALSE;
				FileCreate_0();
				FileWrite_0.enable := FALSE;
				FileWrite_0();
				FileClose_0.enable := FALSE;
				FileClose_0();
				ViBaseGetImage_0.Execute := FALSE;
				ViBaseGetImage_0();
				httpEncodeBase64_0.enable := FALSE;
				httpEncodeBase64_0();				

				gVisionImage.DAT.Status		:= 65535;
				Step						:= VISTEP_REQUEST1;
				
			// -----------------------------------------------------------------------------------------------------------
			// Reset error
			ELSIF gVisionImage.CMD.ResetError THEN
				gVisionImage.CMD.ResetError := FALSE;
			END_IF
					
			// -----------------------------------------------------------------------------------------------------------
			// Load new image into window
			IF visImageSelectedOld <> gVisionImage.DAT.ImageSelected AND dir_entry > 0 THEN
				brsmemset(ADR(gVisionImage.DAT.ImagePath), 0, SIZEOF(gVisionImage.DAT.ImagePath));
				brsmemset(ADR(tmpStr), 0, SIZEOF(tmpStr));
				gVisionImage.DAT.ImagePath := '/FileDevice:';
				brsstrcat(ADR(gVisionImage.DAT.ImagePath), ADR(gVisionImage.CFG.FileDevice));
				brsstrcat(ADR(gVisionImage.DAT.ImagePath), ADR('/'));
				brsstrcat(ADR(gVisionImage.DAT.ImagePath), ADR(gVisionImage.CFG.DirName));
				brsstrcat(ADR(gVisionImage.DAT.ImagePath), ADR('/'));
				brsstrcat(ADR(gVisionImage.DAT.ImagePath), ADR(gVisionImage.DAT.ImageSelected));
			END_IF
			IF dir_entry = 0 THEN
				brsmemset(ADR(gVisionImage.DAT.ImagePath), 0, SIZEOF(gVisionImage.DAT.ImagePath));
			END_IF
			visImageSelectedOld := gVisionImage.DAT.ImageSelected;

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
				gVisionImage.DAT.Status := DirCreate_0.status;
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
				gVisionImage.DAT.Status := DirDeleteEx_0.status;
				Step := VISTEP_ERR;
			END_IF
			
		// -----------------------------------------------------------------------------------------------------------
		// Read all existing image names from directory
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_READ_DIR1:
			// Clear all memory
			brsmemset(ADR(gVisionImage.DAT.ImagesList), 0, SIZEOF(gVisionImage.DAT.ImagesList));
			brsmemset(ADR(gVisionImage.DAT.ImageSelected), 0, SIZEOF(gVisionImage.DAT.ImageSelected));
			visImageSelectedOld := '';
			gVisionImage.DAT.ImageSelected	:= '';
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
					IF dir_entry <= SIZEOF(gVisionImage.DAT.ImagesList)/SIZEOF(gVisionImage.DAT.ImagesList[0]) - 1 THEN
						// Create list box data
						gVisionImage.DAT.ImagesList[dir_entry] := '{"value":"';
						brsstrcat(ADR(gVisionImage.DAT.ImagesList[dir_entry]), ADR(dir_data.Filename));					
						brsstrcat(ADR(gVisionImage.DAT.ImagesList[dir_entry]), ADR('","text":"'));	
						brsstrcat(ADR(gVisionImage.DAT.ImagesList[dir_entry]), ADR(dir_data.Filename));					
						brsstrcat(ADR(gVisionImage.DAT.ImagesList[dir_entry]), ADR('"}'));	
						dir_entry := dir_entry + 1;
					ELSE
						cmdDeleteOldest := TRUE;
					END_IF
				END_IF
				idx := idx + 1;
			ELSIF DirRead_0.status = fiERR_NO_MORE_ENTRIES THEN
				IF cmdDeleteOldest THEN
					brsstrcpy(ADR(tmpStr), ADR(gVisionImage.CFG.DirName));
					brsstrcat(ADR(tmpStr), ADR('/'));
					brsstrcat(ADR(tmpStr), ADR(file_oldest));
					Step := VISTEP_DELETE_IMAGE;
				ELSE
					TON_VisPause(IN := FALSE);
					Step := VISTEP_READ_DIR3;				
				END_IF
			ELSIF DirRead_0.status <> 65535 THEN
				gVisionImage.DAT.Status := DirRead_0.status;
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
				brsstrcpy(ADR(gVisionImage.DAT.ImageSelected), ADR(file_newest));
				brsmemset(ADR(gVisionImage.CMD), 0, SIZEOF(gVisionImage.CMD));
				Step := VISTEP_WAIT;
			END_IF
			
		// -----------------------------------------------------------------------------------------------------------
		// Delete Image
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_DELETE_IMAGE:
			cmdDeleteOldest			:= FALSE;
			FileDelete_0.enable 	:= 1;
			FileDelete_0.pDevice	:= ADR(gVisionImage.CFG.FileDevice);
			FileDelete_0.pName 		:= ADR(FileNamePict);
			FileDelete_0();
			
			IF FileDelete_0.status = 0 THEN
				Step := VISTEP_READ_DIR1;
			ELSIF FileDelete_0.status <> 65535 THEN
				gVisionImage.DAT.Status := FileDelete_0.status;
				Step := VISTEP_ERR;
			END_IF
			
		// -----------------------------------------------------------------------------------------------------------
		// Get new image
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_REQUEST1:
			ViBaseGetImage_0.MpLink := ADR(gVisionImage.CFG.ComponentLink);
			ViBaseGetImage_0.Execute := TRUE;			
			IF gVisionImage.CMD.GetImage THEN
				ViBaseGetImage_0.Type :=  viBASE_IMAGE_TYPE_JPG;
				ViBaseGetImage_0.QualityLevel := IMAGE_QUALITY;
			ELSE
				ViBaseGetImage_0.Type :=  gVisionImage.CFG.ImageType;
				ViBaseGetImage_0.QualityLevel := gVisionImage.CFG.ImageQuality;
			END_IF
			ViBaseGetImage_0.Timeout := T#10s;
			ViBaseGetImage_0.Buffer := ADR(bufferImage);
			ViBaseGetImage_0.BufferSize := SIZEOF(bufferImage);;
			ViBaseGetImage_0();
			
			IF ViBaseGetImage_0.Busy = 0 THEN
				IF ViBaseGetImage_0.StatusID = 0 THEN
					Step := VISTEP_REQUEST2;
				ELSIF ViBaseGetImage_0.StatusID <> ERR_FUB_BUSY THEN
					gVisionImage.DAT.Status := ViBaseGetImage_0.StatusID;
					Step := VISTEP_ERR;
				END_IF
			END_IF
			
		// -----------------------------------------------------------------------------------------------------------
		// Convert to base64
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_REQUEST2:
			httpEncodeBase64_0.enable    := TRUE;
			httpEncodeBase64_0.pSrc      := ADR(bufferImage);
			httpEncodeBase64_0.srcLen    := ViBaseGetImage_0.BufferLen;
			httpEncodeBase64_0.pDest     := ADR(bufferImage64);
			httpEncodeBase64_0.destSize  := SIZEOF(bufferImage64);
			httpEncodeBase64_0();
			
			IF httpEncodeBase64_0.status = 0 THEN
				Step := VISTEP_REQUEST3;
			ELSIF httpEncodeBase64_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := httpEncodeBase64_0.status;
				Step := VISTEP_ERR;
			END_IF
			
		// -----------------------------------------------------------------------------------------------------------
		// Create SVG data
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_REQUEST3:		
			brsmemset(ADR(visCameraImage), 0, SIZEOF(visCameraImage));
			visCameraImage := '<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="1280px" height="1024px" shape-rendering="geometricPrecision" text-rendering="geometricPrecision" image-rendering="optimizeQuality" fill-rule="nonzero" clip-rule="evenodd" viewBox="0 0 1280 1024" xmlns:xlink="http://www.w3.org/1999/xlink"><image xlink:href="data:image/';
			IF ViBaseGetImage_0.Type = viBASE_IMAGE_TYPE_JPG THEN
				brsstrcat(ADR(visCameraImage), ADR('jpeg'));
			ELSIF ViBaseGetImage_0.Type = viBASE_IMAGE_TYPE_BMP THEN
				brsstrcat(ADR(visCameraImage), ADR('bmp'));
			END_IF
			brsstrcat(ADR(visCameraImage), ADR(';base64,'));
			brsstrcat(ADR(visCameraImage), ADR(bufferImage64));
			brsstrcat(ADR(visCameraImage), ADR('"/>'));
			
			// Finish up when command was get image
			IF gVisionImage.CMD.GetImage THEN
				brsstrcat(ADR(visCameraImage), ADR('</svg>'));
				gVisionImage.CMD.GetImage := FALSE;
				Step := VISTEP_WAIT;
			// Save image to PLC
			ELSE
				bufferAdr := ADR(bufferImage);
				bufferLen := ViBaseGetImage_0.BufferLen;				
				Step := VISTEP_SAVE1;
			END_IF
			
		// -----------------------------------------------------------------------------------------------------------
		// Save image
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_SAVE1:
			FileCreate_0.enable		:= TRUE;
			FileCreate_0.pDevice	:= ADR(gVisionImage.CFG.FileDevice);
			FileCreate_0.pFile		:= ADR(FileNamePict);
			FileCreate_0();
			
			IF FileCreate_0.status = 0 THEN
				Step := VISTEP_SAVE2;
			ELSIF FileCreate_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := FileCreate_0.status;
				Step := VISTEP_ERR;
			END_IF
			
		VISTEP_SAVE2:
			FileWrite_0.enable		:= TRUE;
			FileWrite_0.ident		:= FileCreate_0.ident;
			FileWrite_0.pSrc		:= bufferAdr;
			FileWrite_0.len			:= bufferLen;
			FileWrite_0();
			
			IF FileWrite_0.status = 0 THEN
				Step := VISTEP_SAVE3;
			ELSIF FileWrite_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := FileWrite_0.status;
				Step := VISTEP_ERR;
			END_IF
			
		VISTEP_SAVE3:
			FileClose_0.enable		:= TRUE;
			FileClose_0.ident		:= FileCreate_0.ident;
			FileClose_0();

			IF FileClose_0.status = 0 THEN			
				IF bufferAdr = ADR(bufferImage) THEN
					Step := VISTEP_SVG_CROSSH;
				ELSE
					Step := VISTEP_READ_DIR1;					
				END_IF
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := FileClose_0.status;
				Step := VISTEP_ERR;
			END_IF
			
		// -----------------------------------------------------------------------------------------------------------
		// Prepare the second part after base64 picture data
		VISTEP_SVG_CROSSH: 
			brsmemset(ADR(bufferCrosshair), 0, SIZEOF(bufferCrosshair));
			brsstrcat(ADR(bufferCrosshair), ADR('<defs><symbol id="Fadenkreuz"><desc>Ein einfaches Fadenkreuz</desc><g id="Crosshair"><path style="stroke:#ff0000;stroke-width:5" d="M 40,1 V 30 Z" id="up" /><path style="stroke:#ff0000;stroke-width:5" d="M 40,50 V 80 Z" id="down" /><path style="stroke:#ff0000;stroke-width:5" d="M 30,40 H 0 Z" id="left" /><path style="stroke:#ff0000;stroke-width:5" d="M 80,40 H 50 Z" id="right" /><circle style="fill:none;stroke:#ff0000;stroke-width:5" cx="40" cy="40" r="25" id="circle6" /></g></symbol></defs>'));

			FOR idx := 1 TO MAX_NUM_RESULTS DO
				IF (gVisionImage.DAT.Crosshair[idx].CrosshairX <> 0 AND gVisionImage.DAT.Crosshair[idx].CrosshairY <> 0) AND (brsstrlen(ADR(bufferCrosshair)) < SIZEOF(bufferCrosshair) - 100) THEN
					brsstrcat(ADR(bufferCrosshair), ADR('<use xlink:href="#Fadenkreuz" transform="translate('));
					brsitoa(REAL_TO_DINT(gVisionImage.DAT.Crosshair[idx].CrosshairX), ADR(tmpStr));
					brsstrcat(ADR(bufferCrosshair), ADR(tmpStr));
					brsstrcat(ADR(bufferCrosshair), ADR(','));
					brsitoa(REAL_TO_DINT(gVisionImage.DAT.Crosshair[idx].CrosshairY), ADR(tmpStr));
					brsstrcat(ADR(bufferCrosshair), ADR(tmpStr));
					brsstrcat(ADR(bufferCrosshair), ADR(') rotate('));
					brsitoa(REAL_TO_DINT(gVisionImage.DAT.Crosshair[idx].CrosshairRotate), ADR(tmpStr));
					brsstrcat(ADR(bufferCrosshair), ADR(tmpStr));
					brsstrcat(ADR(bufferCrosshair), ADR(',40,40)"/>'));
				END_IF
			END_FOR
			Step := VISTEP_SVG_CONCAT;
			
		VISTEP_SVG_CONCAT:
			// Reset all function blocks
			FileCreate_0.enable := FALSE;
			FileCreate_0();
			FileWrite_0.enable := FALSE;
			FileWrite_0();
			FileClose_0.enable := FALSE;
			FileClose_0();
			
			brsstrcat(ADR(visCameraImage), ADR(bufferCrosshair));
			brsstrcat(ADR(visCameraImage), ADR('</svg>'));
			bufferAdr := ADR(visCameraImage);
			bufferLen := brsstrlen(ADR(visCameraImage));
			FileNamePict := FileNameSvg;
			
			Step := VISTEP_SAVE1;
			
			// -----------------------------------------------------------------------------------------------------------
			// Error state
			// -----------------------------------------------------------------------------------------------------------
		VISTEP_ERR:
			// Reset all function blocks
			FileCreate_0.enable := FALSE;
			FileCreate_0();
			FileWrite_0.enable := FALSE;
			FileWrite_0();
			FileClose_0.enable := FALSE;
			FileClose_0();
			FileDelete_0.enable := FALSE;
			FileDelete_0();

			ViBaseGetImage_0.Execute := FALSE;
			ViBaseGetImage_0();
			httpEncodeBase64_0.enable := FALSE;
			httpEncodeBase64_0();	
					
			IF gVisionImage.CMD.ResetError THEN
				gVisionImage.CMD.ResetError := FALSE;
				Step := VISTEP_WAIT;				
			END_IF				
			brsmemset(ADR(gVisionImage.CMD), 0, SIZEOF(gVisionImage.CMD));
	END_CASE

END_PROGRAM