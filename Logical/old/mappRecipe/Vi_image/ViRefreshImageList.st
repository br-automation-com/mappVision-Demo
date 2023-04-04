FUNCTION_BLOCK ViRefreshImageList
	IF NOT Enable THEN
		Status := ERR_FUB_ENABLE_FALSE;
		Step := 0;
		RETURN;
	END_IF
	CASE Step OF
		0:
			Status := ERR_FUB_BUSY;
			Step := 1;
		1: // Reset everything
			brsmemset(ADR(VisionImage.DAT.Images), 0, SIZEOF(VisionImage.DAT.Images));
			brsmemset(ADR(ImageList), 0, SIZEOF(ImageList));
			brsmemset(ADR(visSelectedImage), 0, SIZEOF(visSelectedImage));
			visSelectedImageOld := '';
			visSelectedImage	:= '';
			DirEntries			:= 0;
			idx					:= 0;
			file_newest			:= '';
			file_oldest			:= '';
			date_newest			:= UDINT_TO_DT(0);
			date_oldest			:= DT#2100-06-06-12:00:00;
			cmdDeleteOldest		:= FALSE;
			Step := 2;
		2: // Proceed with next entry
			DirRead_0.enable 	:= TRUE;
			DirRead_0.pDevice 	:= ADR(VisionImage.CFG.FileDevice);
			DirRead_0.pPath		:= ADR(VisionImage.CFG.DirName);
			DirRead_0.entry 	:= idx;
			DirRead_0.option 	:= fiFILE;
			DirRead_0.pData 	:= ADR(dir_data);
			DirRead_0.data_len 	:= SIZEOF(dir_data);
			DirRead_0();
			IF DirRead_0.status = ERR_OK THEN
				// Make sure file is an image and we have space to store it
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
					IF DirEntries <= SIZEOF(ImageList)/SIZEOF(ImageList[0]) - 1 THEN
						brsstrcpy(ADR(VisionImage.DAT.Images[DirEntries]), ADR(dir_data.Filename));
						// Create list box data
						ImageList[DirEntries] := '{"value":"';
						brsstrcat(ADR(ImageList[DirEntries]), ADR(dir_data.Filename));
						brsstrcat(ADR(ImageList[DirEntries]), ADR('","text":"'));
						brsstrcat(ADR(ImageList[DirEntries]), ADR(dir_data.Filename));
						brsstrcat(ADR(ImageList[DirEntries]), ADR('"}'));
						DirEntries := DirEntries + 1;
					ELSE
						cmdDeleteOldest := TRUE; // the oldest needs to be deleted. But first we have to search for all images to detect the oldest image. So now don't change the step
					END_IF
				END_IF
				idx := idx + 1;
			ELSIF DirRead_0.status = fiERR_NO_MORE_ENTRIES THEN // Finish up when last entry was reached
				IF cmdDeleteOldest THEN // Delete oldest file if there are too many entries
					cmdDeleteOldest := FALSE;
					brsstrcpy(ADR(DeleteFileName), ADR(VisionImage.CFG.DirName));
					brsstrcat(ADR(DeleteFileName), ADR('/'));
					brsstrcat(ADR(DeleteFileName), ADR(file_oldest));
					Step := 10;
				ELSE
					TON_VisPause(IN := FALSE);
					Step := 3;
				END_IF
			ELSIF DirRead_0.status <> ERR_FUB_BUSY THEN
				Status := DirRead_0.status;
				Step := 0;
			END_IF
		3: // Wait for vis before setting last file
			TON_VisPause(IN := TRUE, PT := T#250ms);
			IF TON_VisPause.Q THEN
				brsstrcpy(ADR(visSelectedImage), ADR(file_newest));
				Status := 0;
				Step := 0;
			END_IF
		
		10: // Delete oldest image
			FileDelete_0.enable 	:= TRUE;
			FileDelete_0.pDevice	:= ADR(VisionImage.CFG.FileDevice);
			FileDelete_0.pName 		:= ADR(DeleteFileName);
			FileDelete_0();
			IF FileDelete_0.status = ERR_OK THEN
				Step := 0; // Refresh --> Read dir again, don't change the Status to 0!
			ELSIF FileDelete_0.status <> ERR_FUB_BUSY THEN
				Status := FileDelete_0.status;
				Step := 0;
			END_IF
	END_CASE
END_FUNCTION_BLOCK