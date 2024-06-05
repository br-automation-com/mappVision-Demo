// --------------------------------------------------------------------------------------------------------------------
// Vision image upload task. This task stores the camera image on the file device media
// Version 2.0
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	gVisionImage.CFG.FileDevice 	:= 'VisionFileDevice';		// File device name where the images are stored
	gVisionImage.CFG.DirName		:= 'Vision';				// Directory used for images

	gVisionImage.CMD.CreateDir	:= TRUE;
	gVisionImage.DAT.ImageSelected	:= '';

	brsmemcpy(ADR(b64key), ADR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'), SIZEOF(b64key));
	
	// Create memory for uploading and transforming image
	// Size: a 5MP picture in bmp format has less than 6.000.000 Bytes. A SVG with bas64 conversion maximum the 4/3 size.
	MemUploadSize		:= 6000000;
	MemSvgHeaderSize	:= 2000;
	MemSvgCrosshSize	:= 18000;
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
					Step := VISTEP_DELETE_IMAGE;
				ELSE 
					gVisionImage.CMD.DeleteImage := FALSE;
				END_IF

				// -----------------------------------------------------------------------------------------------------------
				// Save image from camera
			ELSIF gVisionImage.CMD.GetImage THEN
				FileNamePict := gVisionImage.CFG.DirName;
				brsstrcat(ADR(FileNamePict), ADR('/last_image.bmp'));

				ViBaseGetImage_0.Execute := FALSE;
				ViBaseGetImage_0();

				gVisionImage.DAT.Status		:= 65535;
				Step						:= VISTEP_DELETE_IMAGE;
				
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
				ELSE
					FileNamePict := gVisionImage.CFG.FileName;
				END_IF

				brsstrcpy(ADR(FileNameSvg), ADR(FileNamePict));
				brsstrcat(ADR(FileNameSvg), ADR('.svg'));
				brsstrcat(ADR(FileNamePict), ADR('.bmp'));

				ViBaseGetImage_0.Execute := FALSE;
				ViBaseGetImage_0();

				gVisionImage.DAT.Status		:= 65535;
				Step						:= VISTEP_DELETE_IMAGE;
				
			// -----------------------------------------------------------------------------------------------------------
			// Reset error
			ELSIF gVisionImage.CMD.ResetError THEN
				gVisionImage.CMD.ResetError := FALSE;
			END_IF
					
			// -----------------------------------------------------------------------------------------------------------
			// Load new image into window
			IF visImageSelectedOld <> gVisionImage.DAT.ImageSelected AND dir_entry > 0 THEN
				brsmemset(ADR(gVisionImage.DAT.ImagePath), 0, SIZEOF(gVisionImage.DAT.ImagePath));
				brsmemset(ADR(tmpStr1), 0, SIZEOF(tmpStr1));
				gVisionImage.DAT.ImagePath := '/FileDevice:';
				brsstrcat(ADR(gVisionImage.DAT.ImagePath), ADR(gVisionImage.CFG.FileDevice));
				brsstrcat(ADR(gVisionImage.DAT.ImagePath), ADR('/'));
				brsstrcat(ADR(gVisionImage.DAT.ImagePath), ADR(gVisionImage.CFG.DirName));
				brsstrcat(ADR(gVisionImage.DAT.ImagePath), ADR('/'));
				brsstrcat(ADR(gVisionImage.DAT.ImagePath), ADR(gVisionImage.DAT.ImageSelected));
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
				gVisionImage.DAT.Status := 0;
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
			
			IF (FileDelete_0.status = 0 OR FileDelete_0.status = fiERR_FILE_NOT_FOUND) AND (gVisionImage.CMD.GetImage OR gVisionImage.CMD.SaveImage) THEN
				Step := VISTEP_REQUEST;
			ELSIF FileDelete_0.status = 0 THEN
				Step := VISTEP_READ_DIR1;
			ELSIF FileDelete_0.status <> 65535 THEN
				gVisionImage.DAT.Status := FileDelete_0.status;
				Step := VISTEP_ERR;
			END_IF
			
		// -----------------------------------------------------------------------------------------------------------
		// Get new image
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_REQUEST:
			ViBaseGetImage_0.MpLink := ADR(gVisionImage.CFG.ComponentLink);
			ViBaseGetImage_0.Execute := TRUE;
			ViBaseGetImage_0.Type :=  viBASE_IMAGE_TYPE_BMP;
			//ViBaseGetImage_0.QualityLevel := ;
			ViBaseGetImage_0.Timeout := T#10s;
			ViBaseGetImage_0.Buffer := MemUpload;
			ViBaseGetImage_0.BufferSize := MemUploadSize;
			ViBaseGetImage_0();
			
			IF ViBaseGetImage_0.Busy = 0 THEN
				IF ViBaseGetImage_0.StatusID = 0 THEN
					Step := VISTEP_SAVE1;
				ELSIF ViBaseGetImage_0.StatusID <> ERR_FUB_BUSY THEN
					gVisionImage.DAT.Status := ViBaseGetImage_0.StatusID;
					Step := VISTEP_ERR;
				END_IF
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
			FileWrite_0.offset		:= 0;
			FileWrite_0.pSrc		:= MemUpload;
			FileWrite_0.len			:= ViBaseGetImage_0.BufferLen;
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
				image_idx := image_idx + 1;
				brsitoa(image_idx, ADR(tmpStr1));
				gVisionImage.DAT.ImageLast := '/FileDevice:';
				brsstrcat(ADR(gVisionImage.DAT.ImageLast), ADR(gVisionImage.CFG.FileDevice));
				brsstrcat(ADR(gVisionImage.DAT.ImageLast), ADR('/'));
				brsstrcat(ADR(gVisionImage.DAT.ImageLast), ADR(gVisionImage.CFG.DirName));
				brsstrcat(ADR(gVisionImage.DAT.ImageLast), ADR('/last_image.bmp?'));
				brsstrcat(ADR(gVisionImage.DAT.ImageLast), ADR(tmpStr1));
				
				IF gVisionImage.CMD.SaveImage THEN
					Step := VISTEP_SVG_PREPARE;
				ELSE
					gVisionImage.CMD.GetImage := FALSE;
					Step := VISTEP_WAIT;					
				END_IF
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := FileClose_0.status;
				Step := VISTEP_ERR;
			END_IF
			
		// -----------------------------------------------------------------------------------------------------------
		// Create SVG file with image and crosshair/texts
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_SVG_PREPARE:
			b64neededOutput	:= (ViBaseGetImage_0.BufferLen/3)*4 + BOOL_TO_UDINT(UDINT_TO_BOOL(ViBaseGetImage_0.BufferLen MOD 3))*4;
			IF b64neededOutput < MemSvgSize - MemSvgHeaderSize - MemSvgCrosshSize THEN
				brsmemset(MemSvg, 0, MemSvgSize); // clear complete memory
				// Prepare the svg header up to the base64 picture data
				brsstrcpy(MemSvg, ADR(SvgTexts.Header1));
				brsstrcat(MemSvg, ADR(FileNameSvg));
				brsstrcat(MemSvg, ADR(SvgTexts.Header2));
				brsstrcat(MemSvg, ADR('bmp'));
				brsstrcat(MemSvg, ADR(SvgTexts.Header3));
				Step := VISTEP_SVG_BAS64_1;
			ELSE
				gVisionImage.DAT.Status := ERR_BUFF_TOO_SMALL;
				Step := VISTEP_ERR;
			END_IF
			
		// -----------------------------------------------------------------------------------------------------------
		// Code picture data with Base64 to embedd the picture into a svg file
		VISTEP_SVG_BAS64_1: 
			b64AdrInBuffer	:= MemUpload; 						// Original bmp or jpg picture
			b64AdrOutBuffer	:= MemSvg + brsstrlen(MemSvg); 		// Write to the end of the actual svg data
			b64actposIN		:= b64AdrInBuffer;
			b64actposOUT	:= b64AdrOutBuffer;
			Step := VISTEP_SVG_BAS64_2;
			
		VISTEP_SVG_BAS64_2:
			FOR i := 0 TO CONVERT_CYCLES DO
				IF b64actposIN < b64AdrInBuffer + ViBaseGetImage_0.BufferLen THEN
					b64blockLen := UDINT_TO_USINT(LIMIT(0, b64AdrInBuffer + ViBaseGetImage_0.BufferLen - b64actposIN, 3));
					b64in ACCESS b64actposIN;
					b64out ACCESS b64actposOUT;
					b64out[0]		:= b64key[ SHR(b64in[0],2) ];
					IF b64blockLen = 1 THEN
						b64out[1]	:= b64key[ SHL((b64in[0] AND 16#03),4)];
						b64out[2]	:= 61;
						b64out[3]	:= 61;
					ELSIF b64blockLen = 2 THEN
						b64out[1]	:= b64key[ SHL((b64in[0] AND 16#03),4) OR SHR(b64in[1],4) ];
						b64out[2]	:= b64key[ SHL((b64in[1] AND 16#0F),2)];
						b64out[3]	:= 61;
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
				IF gVisionImage.DAT.Crosshair[i].CrosshairX <> 0 AND gVisionImage.DAT.Crosshair[i].CrosshairY <> 0 THEN
					brsstrcat(MemSvgCrossh, ADR(SvgTexts.Crosshair1));
					brsitoa(REAL_TO_DINT(gVisionImage.DAT.Crosshair[i].CrosshairX), ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(','));
					brsitoa(REAL_TO_DINT(gVisionImage.DAT.Crosshair[i].CrosshairY), ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(') rotate('));
					brsitoa(REAL_TO_DINT(gVisionImage.DAT.Crosshair[i].CrosshairRotate), ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(tmpStr1));
					brsstrcat(MemSvgCrossh, ADR(',40,40)"/>'));
				END_IF
			END_FOR
			FOR i := 1 TO MAX_NUM_RESULTS DO
				IF gVisionImage.DAT.Crosshair[i].CrosshairX <> 0 AND gVisionImage.DAT.Crosshair[i].CrosshairY <> 0 THEN
					brsstrcat(MemSvgCrossh, ADR('$r$n$t'));
					brsstrcat(MemSvgCrossh, ADR(gVisionImage.DAT.Crosshair[i].Text));
				END_IF
			END_FOR
			brsstrcat(MemSvgCrossh, ADR(SvgTexts.SvgClose));
			Step := VISTEP_SVG_CONCAT;
			
		VISTEP_SVG_CONCAT:
			brsstrcat(MemSvg, MemSvgCrossh);
			Step := VISTEP_SVG_SAVE1;
			
		// -----------------------------------------------------------------------------------------------------------
		// Save SVG file
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_SVG_SAVE1:
			FileCreate_0.enable		:= TRUE;
			FileCreate_0.pDevice	:= ADR(gVisionImage.CFG.FileDevice);
			FileCreate_0.pFile		:= ADR(FileNameSvg);
			FileCreate_0();
			
			IF FileCreate_0.status = 0 THEN
				Step := VISTEP_SVG_SAVE2;
			ELSIF FileCreate_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := FileCreate_0.status;
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
				gVisionImage.DAT.Status := FileWrite_0.status;
				Step := VISTEP_ERR;
			END_IF
			
		VISTEP_SVG_SAVE3:
			FileClose_0.enable		:= TRUE;
			FileClose_0.ident		:= FileCreate_0.ident;
			FileClose_0();
			
			IF FileClose_0.status = 0 THEN
				Step := VISTEP_READ_DIR1;
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := FileClose_0.status;
				Step := VISTEP_ERR;
			END_IF
			
		// -----------------------------------------------------------------------------------------------------------
		// Error state
		// -----------------------------------------------------------------------------------------------------------
		VISTEP_ERR:
			// Reset all commands and wait or ack
			ViBaseGetImage_0.Execute	:= TRUE;
			ViBaseGetImage_0();
					
			IF gVisionImage.CMD.ResetError THEN
				gVisionImage.CMD.ResetError := FALSE;
				gVisionImage.DAT.Status := 0;
				Step := VISTEP_WAIT;				
			END_IF				
			brsmemset(ADR(gVisionImage.CMD), 0, SIZEOF(gVisionImage.CMD));
	END_CASE

END_PROGRAM