// --------------------------------------------------------------------------------------------------------------------********
//	Cylic task for recipe management
// --------------------------------------------------------------------------------------------------------------------********

// --------------------------------------------------------------------------------------------------------------------********
// Cyclic task																	
// --------------------------------------------------------------------------------------------------------------------********
PROGRAM _CYCLIC
	// --------------------------------------------------------------------------------------------------------------------
	// Make sure task name and global structure correct
	IF(pvStatus <> 0) THEN
		RETURN;
	END_IF
	IF(taskStatus <> 0) THEN
		rec_state := CreateError(ADR(RECIPE), ERR_REC_TASK_NAME, "Task name is incorrect", rec_state);
		RETURN;
	END_IF
	
	// --------------------------------------------------------------------------------------------------------------------
	// Make sure we dont exceed maximum number of web clients
	IF(RECIPE.PAR.VisuSlotID > REC_MAX_CLIENTS_ID) THEN
		rec_state := CreateError(ADR(RECIPE), ERR_REC_TOO_MANY_CLIENTS, "More than 3 clients try to connect to recipe managment", rec_state);
		RETURN;
	END_IF
	
	// --------------------------------------------------------------------------------------------------------------------
	// Cyclic function calls
	MpRecipeCsv_0();
	MpRecipeXml_0();
	
	// ----------------------------------------------------------------------------------------
	// Web service driver for file upload
	WebServiceUpload.enable 			:= TRUE;
	WebServiceUpload.option 			:= httpOPTION_HTTP_11 + httpOPTION_SERVICE_TYPE_NAME;	
	WebServiceUpload.pRequestData  		:= AsMemPartAllocClear_0.mem;
	WebServiceUpload.requestDataSize 	:= REC_UPLOAD_DOWNLOAD_SIZE;
	WebServiceUpload.pResponseData 		:= ADR(upload_response);
	WebServiceUpload.responseDataLen 	:= brsstrlen(ADR(upload_response));
	WebServiceUpload();

	// Reset send command 
	IF(WebServiceUpload.send = TRUE)  THEN		
		WebServiceUpload.send := FALSE;
	// Send response when page is loaded or data is posted
	ELSIF(WebServiceUpload.status = ERR_OK AND WebServiceUpload.send = FALSE) THEN 
		WebServiceUpload.send := TRUE;
	// New upload data arrived
	ELSIF(WebServiceUpload.send = FALSE AND WebServiceUpload.requestDataLen > 0 AND RECIPE.CMD.Upload = FALSE) THEN
		// Add delay so that upload can finish
		upload_delay.PT := WebServiceUpload.requestDataLen/100000*5;
		upload_delay.IN := TRUE;
		upload_delay();
	END_IF
	// Check new uploaded data
	IF(upload_delay.Q AND RECIPE.CMD.Upload = FALSE) THEN
		upload_delay.IN := FALSE;
		upload_delay();
		RECIPE.CMD.Upload := TRUE;
	END_IF
	
	// --------------------------------------------------------------------------------------------------------------------****
	// Recipe management state machine																						
	// --------------------------------------------------------------------------------------------------------------------****	
	CASE rec_state OF
		// --------------------------------------------------------------------------------------------------------------------
		// Wait for command																				
		// --------------------------------------------------------------------------------------------------------------------
		REC_WAIT:
			// Set OK state
			RECIPE.StatusNo := ERR_OK;
			// --------------------------------------------------------------------------------------------------------------------
			// Track filter change and data refresh																				
			IF ((brwcscmp(ADR(RecipeFilterOld[VisuSlotID]), ADR(RECIPE.VIS[VisuSlotID].RecipeFilter)) <> 0) OR (RecipeNumOld[VisuSlotID] <> RECIPE.DAT.RecipeNum)) THEN
				brsmemset(ADR(RECIPE.VIS[VisuSlotID].RecipeNames), 0, SIZEOF(RECIPE.VIS[VisuSlotID].RecipeNames));
				idy := 0;
				IF(RECIPE.DAT.RecipeNum > 0) THEN
					FOR idx:=0 TO RECIPE.DAT.RecipeNum - 1 DO
						// -------------------------------------------------------------------------------- 		
						// Verify that file name contains filter											
						IF (brwcslen(ADR(RECIPE.VIS[VisuSlotID].RecipeFilter)) = 0 OR IsInstrW(ADR(RECIPE.DAT.RecipeNames[idx]), ADR(RECIPE.VIS[VisuSlotID].RecipeFilter))) THEN	
							WString2DataProvider(ADR(RECIPE.DAT.RecipeNames[idx]), ADR(tmpWStr1));
							RECIPE.VIS[VisuSlotID].RecipeNames[idy] := tmpWStr1;
							idy := idy + 1;
						END_IF
					END_FOR;
					brwcscpy(ADR(RecipeFilterOld[VisuSlotID]), ADR(RECIPE.VIS[VisuSlotID].RecipeFilter));
				END_IF
				RecipeNumOld[VisuSlotID] := RECIPE.DAT.RecipeNum;
				RECIPE.VIS[VisuSlotID].RecipeNum := idy;
			END_IF
			
			// ------------------------------------------------------------------------------------------------
			// Handle double click for file open
			IF(RECIPE.VIS[VisuSlotID].RecipeDoubleClick > 0) THEN
				DoubleClickRecipeName[VisuSlotID].PT := 50;
				DoubleClickRecipeName[VisuSlotID].IN := TRUE;
				DoubleClickRecipeName[VisuSlotID]();
				// Open selected file
				IF(RECIPE.VIS[VisuSlotID].RecipeDoubleClick > 1) THEN
					DoubleClickRecipeName[VisuSlotID].IN := FALSE;
					DoubleClickRecipeName[VisuSlotID]();
					RECIPE.VIS[VisuSlotID].RecipeDoubleClick := 0;
					RECIPE.PAR.VisuSlotID := VisuSlotID;
					RECIPE.PAR.RecipeName := RECIPE.VIS[VisuSlotID].RecipeSelect;
					RECIPE.CMD.View := TRUE;
				END_IF
			END_IF
			IF(DoubleClickRecipeName[VisuSlotID].Q) THEN
				DoubleClickRecipeName[VisuSlotID].IN := FALSE;
				DoubleClickRecipeName[VisuSlotID]();
				IF(RECIPE.VIS[VisuSlotID].RecipeDoubleClick > 0) THEN
					RECIPE.VIS[VisuSlotID].RecipeDoubleClick := RECIPE.VIS[VisuSlotID].RecipeDoubleClick - 1;
				END_IF
			END_IF
			
			// Cylce through the client web seesions
			VisuSlotID := VisuSlotID + 1;
			IF(VisuSlotID > REC_MAX_CLIENTS_ID) THEN
				VisuSlotID := 0;
			END_IF
			
			// --------------------------------------------------------------------------------------------------------------------
			// Disable buttons in visualization when number of recipes is 0
			IF(RECIPE.DAT.RecipeNum = 0) THEN
				RECIPE.PAR.VisuEnableCommand := FALSE;
			ELSE
				RECIPE.PAR.VisuEnableCommand := TRUE;
			END_IF
							
			// ---------------------------------------------------------------------------------------- 
			// Command init/refresh																			
			IF (RECIPE.CMD.Init = TRUE) THEN
				// Reset data structure and trigger name refresh for vis
				brsmemset(ADR(RECIPE.DAT), 0, SIZEOF(RECIPE.DAT));
				brsmemset(ADR(RecipeIDs), 0, SIZEOF(RecipeIDs));
				brsmemset(ADR(RecipeNumOld), 16#FF, SIZEOF(RecipeNumOld));
				// Register recipe name variable first if unicode is used
				IF(REC_USE_UNICODE) THEN
					rec_state := REC_REG_NAME;
				ELSE
					rec_state := REC_REG_VAR;
				END_IF
				pvCnt := 1;
			// ---------------------------------------------------------------------------------------- 
			// Command new recipe
			ELSIF (RECIPE.CMD.New = TRUE AND RECIPE.PAR.RecipeName <> "") THEN
				// Show current state																		
				animation := WorkingStatus(ADR(RECIPE), ADR("creating recipe..."), animation);
				// Verify that we still have space in list												
				IF (RECIPE.DAT.RecipeNum > REC_REC_NUM) THEN
					rec_state := CreateError(ADR(RECIPE), ERR_REC_REC_NUM, "maximum number of recipes reached", rec_state);
					RETURN;
				END_IF
				// Make sure recipe does not already exist
				IF(FindRecName(ADR(RECIPE), RECIPE.PAR.RecipeName) <> REC_DOES_NOT_EXIST) THEN
					tmpWStr1 := "recipe name ";
					brwcscat(ADR(tmpWStr1), ADR(RECIPE.PAR.RecipeName));
					brwcscat(ADR(tmpWStr1), ADR(" already exists"));
					rec_state := CreateError(ADR(RECIPE), ERR_REC_NAME_EXISTS, tmpWStr1, rec_state);
					RETURN;
				END_IF
				// Reset selected recipe, copy recipe name to local variable
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].RecipeSelect := "";
				rec_state := REC_GEN_FILE_NAME;
			// ---------------------------------------------------------------------------------------- 
			// Command load recipe
			ELSIF (RECIPE.CMD.Load = TRUE AND RECIPE.PAR.RecipeName <> "") THEN
				// Show current state																		
				animation := WorkingStatus(ADR(RECIPE), ADR("loading recipe..."), animation);
				// Copy recipe name to local variable
				rec_state := REC_GEN_FILE_NAME;
				// ---------------------------------------------------------------------------------------- 
			// Command save recipe
			ELSIF (RECIPE.CMD.Save = TRUE AND (RECIPE.PAR.RecipeName <> "" OR RECIPE.PAR.RecipeNameNew <> "")) THEN
				// Show current state																		
				animation := WorkingStatus(ADR(RECIPE), ADR("saving recipe..."), animation);
				IF(RECIPE.PAR.RecipeName = "") THEN
					RECIPE.PAR.RecipeName := RECIPE.PAR.RecipeNameNew;
				END_IF
				// Copy recipe name to local variable
				rec_state := REC_GEN_FILE_NAME;
			// ---------------------------------------------------------------------------------------- 
			// Command view recipe
			ELSIF (RECIPE.CMD.View = TRUE AND RECIPE.PAR.RecipeName <> "") THEN
				// Copy recipe name to local variable																		
				rec_state := REC_GEN_FILE_NAME;				
			// ---------------------------------------------------------------------------------------- 
			// Command delete recipe
			ELSIF (RECIPE.CMD.Delete = TRUE AND RECIPE.PAR.RecipeName <> "") THEN
				// Show current state, copy recipe name to local variable																		
				animation := WorkingStatus(ADR(RECIPE), ADR("deleting recipe..."), animation);
				rec_state := REC_GEN_FILE_NAME;
			// ---------------------------------------------------------------------------------------- 
			// Command download recipe
			ELSIF (RECIPE.CMD.Download = TRUE AND RECIPE.PAR.RecipeName <> "") THEN
				// Show current state, copy recipe name to local variable																		
				animation := WorkingStatus(ADR(RECIPE), ADR("downloading recipe..."), animation);
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].DownloadFileUrl := '';
				rec_state := REC_GEN_FILE_NAME;
			// ---------------------------------------------------------------------------------------- 
			// Command upload recipe
			ELSIF (RECIPE.CMD.Upload = TRUE) THEN
				// Make sure that unicode support is turned off
				IF(REC_USE_UNICODE = FALSE) THEN
					// Show current state, copy recipe name to local variable																		
					animation := WorkingStatus(ADR(RECIPE), ADR("uploading recipe..."), animation);
					rec_state := REC_UPLOAD;
				ELSE
					rec_state := CreateError(ADR(RECIPE), ERR_UNICODE_UPLOAD, "upload is not supported when using unicode recipes", rec_state);
				END_IF
			// ---------------------------------------------------------------------------------------- 
			// Rename recipe
			ELSIF (RECIPE.CMD.Rename = TRUE AND RECIPE.PAR.RecipeName <> "" AND RECIPE.PAR.RecipeNameNew <> "") THEN
				// Show current state																		
				animation := WorkingStatus(ADR(RECIPE), ADR("renaming recipe..."), animation);
				// Make sure new recipe name does not already exist
				IF(FindRecName(ADR(RECIPE), RECIPE.PAR.RecipeNameNew) <> REC_DOES_NOT_EXIST) THEN
					tmpWStr1 := "new recipe name ";
					brwcscat(ADR(tmpWStr1), ADR(RECIPE.PAR.RecipeNameNew));
					brwcscat(ADR(tmpWStr1), ADR(" already exists"));
					rec_state := CreateError(ADR(RECIPE), ERR_REC_NAME_EXISTS, tmpWStr1, rec_state);
					RETURN;
				END_IF
				// Reset selected recipe, copy recipe name to local variable
				brsmemset(ADR(RecipeNumOld), 16#FF, SIZEOF(RecipeNumOld));
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].RecipeSelect := "";
				RecipeNameNew := RECIPE.PAR.RecipeNameNew;
				rec_state := REC_GEN_FILE_NAME;
			// ---------------------------------------------------------------------------------------- 
			// Reset error
			ELSIF (RECIPE.CMD.ErrorReset = TRUE) THEN
				rec_state := REC_ERROR;				
			END_IF			
			RecipeName := RECIPE.PAR.RecipeName;

			// ---------------------------------------------------------------------------------------- 
			// Check parameters																					
			IF (RECIPE.CMD.Init OR RECIPE.CMD.New OR RECIPE.CMD.Load OR RECIPE.CMD.Save OR RECIPE.CMD.Rename OR RECIPE.CMD.Delete OR RECIPE.CMD.View OR RECIPE.CMD.Download OR RECIPE.CMD.Upload) THEN
				// Set busy state
				RECIPE.StatusNo := ERR_FUB_BUSY;
				// Make sure recipe mangament was intialized
				IF (NOT RECIPE.CMD.Init AND NOT RECIPE.PAR.Initialized) THEN
					rec_state := CreateError(ADR(RECIPE), ERR_REC_NOT_INITIALIZED, "recipe management is not initiialized", REC_WAIT);
				END_IF
				// Make sure recipe name is valid
				IF((RECIPE.CMD.New OR RECIPE.CMD.Load OR RECIPE.CMD.Save OR RECIPE.CMD.Rename OR RECIPE.CMD.Delete OR RECIPE.CMD.View) AND RecipeName = "") THEN
					rec_state := CreateError(ADR(RECIPE), ERR_REC_NAME_EMPTY, "recipe name is empty", REC_WAIT);
				END_IF
				// Make sure new recipe name is valid
				IF((RECIPE.CMD.Rename) AND RecipeNameNew = "") THEN
					rec_state := CreateError(ADR(RECIPE), ERR_REC_NAME_EMPTY, "new recipe name is empty", REC_WAIT);
				END_IF
				// Make sure device name is valid
				IF(DeviceName = '') THEN
					rec_state := CreateError(ADR(RECIPE), ERR_REC_DEV_NAME_EMPTY, "device name is empty", REC_WAIT);
				END_IF
				// Make sure variable name has at least one entry
				IF(REC_VAR_LIST[1] = '') THEN
					rec_state := CreateError(ADR(RECIPE), ERR_REC_VAR_NAME_EMPTY, "variable name is empty", REC_WAIT);
				END_IF

				RECIPE.PAR.VisuEnableCommand := FALSE;
			END_IF	
		// --------------------------------------------------------------------------------------------------------------------
		// Register recipe name																
		// --------------------------------------------------------------------------------------------------------------------
		REC_REG_NAME:
			// Generate string for local recipe name
			tmpStr1 := REC_THIS_TASK;
			brsstrcat(ADR(tmpStr1), ADR(':RecipeName'));
			
			MpRecipeRegPar_0.Enable := TRUE;
			MpRecipeRegPar_0.MpLink := ADR(MpComGetLink_0.MpLink);
			MpRecipeRegPar_0.PVName := ADR(tmpStr1);
			MpRecipeRegPar_0.Category := ADR(REC_THIS_TASK);
										
			// ---------------------------------------------------------------------------------------- 		
			// OK																																				
			IF (MpRecipeRegPar_0.Active AND NOT MpRecipeRegPar_0.Error) THEN
				rec_state := REC_REG_VAR;
			// Error
			ELSIF (MpRecipeRegPar_0.Error) THEN
				rec_state := CreateError(ADR(RECIPE), MpRecipeRegPar_0.StatusID, "error trying to register recipe name", rec_state);
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Register variable structure																
		// --------------------------------------------------------------------------------------------------------------------
		REC_REG_VAR:
			MpRecipeRegPar_1[pvCnt].Enable := TRUE;
			MpRecipeRegPar_1[pvCnt].MpLink := ADR(MpComGetLink_0.MpLink);
			MpRecipeRegPar_1[pvCnt].PVName := ADR(REC_VAR_LIST[pvCnt]);	
			MpRecipeRegPar_1[pvCnt].Category := ADR(REC_THIS_TASK);
										
			// ---------------------------------------------------------------------------------------- 		
			// OK																																				
			IF (MpRecipeRegPar_1[pvCnt].Active AND NOT MpRecipeRegPar_1[pvCnt].Error) THEN
				// Register next variable
				IF (pvCnt < SIZEOF(REC_VAR_LIST)/SIZEOF(REC_VAR_LIST[1]))  THEN
					pvCnt := pvCnt + 1;
					// Finish when variable data is empty
					IF (REC_VAR_LIST[pvCnt] = '') THEN
						rec_state := REC_CREATE_DIR;
					END_IF
				ELSE
					rec_state := REC_CREATE_DIR;
				END_IF
			// Error
			ELSIF (MpRecipeRegPar_1[pvCnt].Error) THEN
				tmpWStr1 := "error trying to register variable name ";
				brwcsconv(ADR(tmpWStr2), ADR(REC_VAR_LIST[pvCnt]), brwU8toUC);
				brwcscat(ADR(tmpWStr1), ADR(tmpWStr2));
				rec_state := CreateError(ADR(RECIPE), MpRecipeRegPar_1[pvCnt].StatusID, tmpWStr1, rec_state);
			END_IF	
		// --------------------------------------------------------------------------------------------------------------------
		// Create recipe directory																
		// --------------------------------------------------------------------------------------------------------------------
		REC_CREATE_DIR:
			DCreate.enable 	:= TRUE;
			DCreate.pDevice	:= ADR(DeviceName);
			DCreate.pName := ADR(REC_DIRECTORY);
			DCreate();
										
			// ---------------------------------------------------------------------------------------- 		
			// OK																																				
			IF (DCreate.status = OK OR DCreate.status = fiERR_DIR_ALREADY_EXIST) THEN
				// Reset command and RETURN to wait state												
				rec_state := REC_READ_DIR;
			// Error 		
			ELSIF (DCreate.status <> ERR_FUB_BUSY) THEN
				// File device is wrong
				IF(DCreate.status = fiERR_DEVICE_MANAGER) THEN
					rec_state := CreateError(ADR(RECIPE), DCreate.status, "error creating recipe directory, check file device name", rec_state);
				ELSE
					rec_state := CreateError(ADR(RECIPE), DCreate.status, "error creating recipe directory", rec_state);
				END_IF			
			END_IF			
		// --------------------------------------------------------------------------------------------------------------------
		// Read directory information																	
		// --------------------------------------------------------------------------------------------------------------------
		REC_READ_DIR:
			// Show current state																		
			animation := WorkingStatus(ADR(RECIPE), ADR("reading recipes..."), animation);
			// ---------------------------------------------------------------------------------------- 
			// Clear all entrys																			
			brsmemset(ADR(RECIPE.DAT), 0, SIZEOF(RECIPE.DAT));
			RECIPE.DAT.RecipeNum := 0;
			// ---------------------------------------------------------------------------------------- 		
			// Set values and get device dir															
			DInfo.enable 	:= TRUE;
			DInfo.pDevice	:= ADR(DeviceName);
			DInfo();
						
			// ---------------------------------------------------------------------------------------- 		
			// OK																																				
			IF (DInfo.status = OK) THEN
				rec_state := REC_READ_DIR_1;
			ELSIF (DInfo.status = fiERR_DEVICE_MANAGER) THEN
				tmpWStr1 := "file device ";
				brwcsconv(ADR(tmpWStr2), ADR(DeviceName), brwU8toUC);
				brwcscat(ADR(tmpWStr1), ADR(tmpWStr2));
				brwcscat(ADR(tmpWStr1), ADR(" is unavailable"));
				rec_state := CreateError(ADR(RECIPE), DInfo.status, tmpWStr1, rec_state);
			ELSIF (DInfo.status = fiERR_DIR_NOT_EXIST) THEN
				tmpWStr1 := "file ";
				brwcsconv(ADR(tmpWStr2), ADR(REC_DIRECTORY), brwU8toUC);
				brwcscat(ADR(tmpWStr1), ADR(tmpWStr2));
				brwcscat(ADR(tmpWStr1), ADR(" is unavailable"));
				rec_state := CreateError(ADR(RECIPE), DInfo.status, tmpWStr1, rec_state);
				// Error																	
			ELSIF (DInfo.status <> ERR_FUB_BUSY) THEN
				rec_state := CreateError(ADR(RECIPE), DInfo.status, "error dir info", rec_state);
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Open directory 																				
		// --------------------------------------------------------------------------------------------------------------------
		REC_READ_DIR_1:														
			DOpen.enable 	:= TRUE;
			DOpen.pDevice	:= ADR(DeviceName);
			DOpen.pName 	:= ADR(REC_DIRECTORY);
			DOpen();
						
			// ---------------------------------------------------------------------------------------- 		
			// OK																																				
			IF (DOpen.status = OK) THEN
				rec_state := REC_READ_DIR_2;
			// Create error message for missing directory
			ELSIF (DInfo.status = fiERR_DIR_NOT_EXIST) THEN
				tmpWStr1 := "directory ";
				brwcsconv(ADR(tmpWStr2), ADR(REC_DIRECTORY), brwU8toUC);
				brwcscat(ADR(tmpWStr1), ADR(tmpWStr2));
				brwcscat(ADR(tmpWStr1), ADR(" is unavailable"));
				rec_state := CreateError(ADR(RECIPE), DInfo.status, tmpWStr1, rec_state);				
			// Error
			ELSIF (DOpen.status <> ERR_FUB_BUSY) THEN
				rec_state := CreateError(ADR(RECIPE), DOpen.status, "error dir open", rec_state);
			END_IF;
		// --------------------------------------------------------------------------------------------------------------------
		// Read file directory information																
		// --------------------------------------------------------------------------------------------------------------------
		REC_READ_DIR_2:													
			DRead.enable 	:= TRUE;
			DRead.ident		:= DOpen.ident;
			DRead.pData 	:= ADR(lDirReadData);
			DRead.data_len 	:= SIZEOF(lDirReadData);
			DRead();
										
			// ---------------------------------------------------------------------------------------- 		
			// OK																																				
			IF (DRead.status = OK AND lDirReadData.Mode = fiFILE) THEN
				animation := WorkingStatus(ADR(RECIPE), ADR("initializing recipe managment..."), animation);
				// Make sure file name does not exceed maximum string size
				IF (brsstrlen(ADR(lDirReadData.Filename)) < REC_NAME_LENGTH) THEN
					// Copy dir info to string
					brsmemset(ADR(RECIPE.PAR.RecipeID), 0, SIZEOF(RECIPE.PAR.RecipeID));
					brsstrcpy(ADR(RECIPE.PAR.RecipeID), ADR(lDirReadData.Filename));
					// Make sure file extension is CSV or XML
					IF(brsstrlen(ADR(RECIPE.PAR.RecipeID)) > 4 AND ((REC_RECIPE_TYPE = typeCSV AND brsmemcmp(ADR(RECIPE.PAR.RecipeID) + (brsstrlen(ADR(RECIPE.PAR.RecipeID)) - 4), ADR('.csv'), 4) = 0) OR (REC_RECIPE_TYPE = typeXML AND brsmemcmp(ADR(RECIPE.PAR.RecipeID) + (brsstrlen(ADR(RECIPE.PAR.RecipeID)) - 4), ADR('.xml'), 4) = 0))) THEN
						brsmemset(ADR(RECIPE.PAR.RecipeID) + (brsstrlen(ADR(RECIPE.PAR.RecipeID)) - 4), 0, 4);
						// ------------------------------------------------------------------------------------ 		
						// Verify that we still have space in list												
						IF (RECIPE.DAT.RecipeNum <= REC_REC_NUM) THEN
							// -------------------------------------------------------------------- 		
							// Read recipe name from recipe data in next rec_state when using unicode
							IF(REC_USE_UNICODE) THEN
								RecipeIDs[brsatoi(ADR(RECIPE.PAR.RecipeID))] := TRUE;
								rec_state := REC_GEN_FILE_NAME;
								// Generate recipe name from file name
							ELSE
								brwcsconv(ADR(RecipeName), ADR(RECIPE.PAR.RecipeID), brwU8toUC);
								// Generate ASCII data, insert recipe into list
								InsertRecName(ADR(RECIPE), RecipeName, RECIPE.PAR.RecipeID);
							END_IF
							// Error
						ELSE
							rec_state := CreateError(ADR(RECIPE), ERR_REC_REC_NUM, "maximum number of recipes reached", rec_state);
						END_IF
					END_IF
				ELSE
					has_oversized_items := TRUE;
				END_IF
			// Last entry reached
			ELSIF (DRead.status = fiERR_NO_MORE_ENTRIES) THEN 
				rec_state := REC_READ_DIR_3;
			// Error		
			ELSIF (DRead.status <> ERR_FUB_BUSY AND DRead.status <> OK) THEN
				rec_state := CreateError(ADR(RECIPE), DRead.status, "error recipe list read", rec_state);
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Close directory information																	
		// --------------------------------------------------------------------------------------------------------------------
		REC_READ_DIR_3:														
			DClose.enable 	:= TRUE;
			DClose.ident	:= DOpen.ident;
			DClose();
										
			// ---------------------------------------------------------------------------------------- 		
			// OK																																				
			IF (DClose.status = OK) THEN
				// Reset command and RETURN to wait state												
				RECIPE.StatusText := "initializing complete";
				RECIPE.CMD.Init	:= FALSE;
				RECIPE.PAR.RecipeID := '';
				RECIPE.PAR.Initialized := TRUE;
				DClose.ident	:= 0;
				// Create error message for oversized items
				IF(has_oversized_items) THEN
					rec_state := CreateError(ADR(RECIPE), ERR_REC_NAME_LENGTH, "one or more recipe names exceeds maximum length", rec_state);
				ELSE
					rec_state := REC_WAIT;
				END_IF
			// Error 		
			ELSIF (DClose.status <> ERR_FUB_BUSY) THEN
				rec_state := CreateError(ADR(RECIPE), DClose.status, "error dir close", rec_state);
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Generate recipe name	full path and file name																
		// --------------------------------------------------------------------------------------------------------------------
		REC_GEN_FILE_NAME:
			// Find recipe entry
			RecipeIndex := FindRecName(ADR(RECIPE), RecipeName);
			
			// Generate file name when using unicode strings
			IF(REC_USE_UNICODE) THEN
				// Ignore during init process
				IF(NOT RECIPE.CMD.Init) THEN
					// Find empty slot for new recipe
					IF(RECIPE.CMD.New) THEN
						RecipeIndex := 0;
						WHILE (RecipeIDs[RecipeIndex] = TRUE AND RecipeIndex <= REC_REC_NUM) DO
							RecipeIndex := RecipeIndex + 1;
						END_WHILE;
						// Make sure we found empty slot
						IF(RecipeIndex <= REC_REC_NUM AND RecipeIDs[RecipeIndex] = FALSE) THEN
							brsitoa(RecipeIndex, ADR(RECIPE.PAR.RecipeID));
						ELSE
							rec_state := CreateError(ADR(RECIPE), ERR_REC_REC_NUM, "no empty slot found", rec_state);
							RETURN;
						END_IF
						// Find recipe name in list	for all other command				
					ELSE
						// Recipe name was found
						IF(RecipeIndex <> REC_DOES_NOT_EXIST) THEN
							RECIPE.PAR.RecipeID := RECIPE.DAT.RecipeIDs[RecipeIndex];
							// Recipe name was lost
						ELSE
							tmpWStr1 := "recipe name was not found ";
							brwcscat(ADR(tmpWStr1), ADR(RecipeName));
							rec_state := CreateError(ADR(RECIPE), ERR_REC_NAME_LOST, tmpWStr1, rec_state);
							RETURN;
						END_IF
					END_IF
				END_IF
			// Use recipe name as file name when using standard strings
			ELSE
				brwcsconv(ADR(RECIPE.PAR.RecipeID), ADR(RecipeName), brwUCtoU8);
			END_IF
			
			// Generate recipe path and extension
			RecipeFullFileName := REC_DIRECTORY;
			brsstrcat(ADR(RecipeFullFileName), ADR('/'));
			brsstrcat(ADR(RecipeFullFileName), ADR(RECIPE.PAR.RecipeID));

			// Add file extension
			IF(REC_RECIPE_TYPE = typeCSV) THEN
				brsstrcat(ADR(RecipeFullFileName), ADR('.csv'));
			ELSE
				brsstrcat(ADR(RecipeFullFileName), ADR('.xml'));
			END_IF
			
			// Save recipe under new name
			IF(RECIPE.CMD.Rename) THEN
				RecipeName := RecipeNameNew;	
			END_IF		
		
			// Proceed with next rec_state
			IF(RECIPE.CMD.Delete) THEN
				rec_state := REC_DELETE;
			ELSIF(RECIPE.CMD.View) THEN
				rec_state := REC_VIEW;
			ELSIF(RECIPE.CMD.Rename AND NOT REC_USE_UNICODE) THEN
				rec_state := REC_RENAME;
			ELSIF(RECIPE.CMD.Download) THEN
				rec_state := REC_DOWNLOAD;
			ELSE
				rec_state := REC_LOAD_SAVE;
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Load or save recipe data																	
		// --------------------------------------------------------------------------------------------------------------------
		REC_LOAD_SAVE:
			
			IF(REC_RECIPE_TYPE = typeCSV) THEN
				MpRecipeCsv_0.Enable := TRUE;
				MpRecipeCsv_0.MpLink := ADR(MpComGetLink_0.MpLink);
				MpRecipeCsv_0.DeviceName := ADR(DeviceName);
				MpRecipeCsv_0.FileName := ADR(RecipeFullFileName);
				MpRecipeCsv_0.Category := ADR(REC_THIS_TASK);
				MpRecipeCsv_0.Save := RECIPE.CMD.Save OR RECIPE.CMD.New OR RECIPE.CMD.Rename;
				MpRecipeCsv_0.Load := RECIPE.CMD.Load OR RECIPE.CMD.Init;

				MpRecipeDone := MpRecipeCsv_0.CommandDone;
				MpRecipeError := MpRecipeCsv_0.Error;
				MpRecipeStatusID := MpRecipeCsv_0.StatusID;
			ELSE
				MpRecipeXml_0.Enable := TRUE;
				MpRecipeXml_0.MpLink := ADR(MpComGetLink_0.MpLink);
				MpRecipeXml_0.DeviceName := ADR(DeviceName);
				MpRecipeXml_0.FileName := ADR(RecipeFullFileName);
				MpRecipeXml_0.Category := ADR(REC_THIS_TASK);
				MpRecipeXml_0.Save := RECIPE.CMD.Save OR RECIPE.CMD.New OR RECIPE.CMD.Rename;
				MpRecipeXml_0.Load := RECIPE.CMD.Load OR RECIPE.CMD.Init;

				MpRecipeDone := MpRecipeXml_0.CommandDone;
				MpRecipeError := MpRecipeXml_0.Error;
				MpRecipeStatusID := MpRecipeXml_0.StatusID;
			END_IF
										
			// ---------------------------------------------------------------------------------------- 		
			// OK																																				
			IF (MpRecipeDone AND NOT MpRecipeError AND MpRecipeStatusID = 0) THEN
				// Reset command and RETURN to wait state
				MpRecipeCsv_0.Load := FALSE;
				MpRecipeCsv_0.Save := FALSE;
				MpRecipeXml_0.Load := FALSE;
				MpRecipeXml_0.Save := FALSE;
				
				// Continue renaming recipe 
				IF(RECIPE.CMD.Rename) THEN
					IF(REC_USE_UNICODE) THEN
						// Remove name from recipe list	and add it again										
						RemoveRecName(ADR(RECIPE), RecipeIndex);
						InsertRecName(ADR(RECIPE), RecipeName, RECIPE.PAR.RecipeID);

						RECIPE.VIS[RECIPE.PAR.VisuSlotID].RecipeSelect := RecipeName;
						tmpWStr1 := "renamed recipe";
						RECIPE.CMD.Rename := 0;
					ELSE
						rec_state := REC_DELETE;
						RETURN;
					END_IF
				END_IF
				// Continue reading recipe names
				IF(RECIPE.CMD.Init) THEN
					InsertRecName(ADR(RECIPE), RecipeName, RECIPE.PAR.RecipeID);
					rec_state := REC_READ_DIR_2;
					RETURN;
				END_IF
				// Finish new recipe 
				IF(RECIPE.CMD.New) THEN
					IF(REC_USE_UNICODE) THEN
						RecipeIDs[brsatoi(ADR(RECIPE.PAR.RecipeID))] := TRUE;
					END_IF
					InsertRecName(ADR(RECIPE), RecipeName, RECIPE.PAR.RecipeID);
					RECIPE.VIS[RECIPE.PAR.VisuSlotID].RecipeSelect := RecipeName;
					tmpWStr1 := "created new recipe";
					RECIPE.CMD.New	:= FALSE;
				END_IF
				// Finish load recipe 
				IF(RECIPE.CMD.Load) THEN
					tmpWStr1 := "loaded recipe";
					RECIPE.CMD.Load	:= FALSE;
				END_IF
				// Finish save recipe 
				IF(RECIPE.CMD.Save) THEN
					tmpWStr1 := "saved recipe";
					RECIPE.CMD.Save	:= FALSE;
				END_IF
				// Complete status string
				CreateMessage(ADR(RECIPE.StatusText), ADR(tmpWStr1), ADR(RecipeName), RECIPE.PAR.VisuSlotID);
				rec_state := REC_WAIT;	
			// Error		
			ELSIF (MpRecipeStatusID = mpRECIPE_ERR_CONFIG_INVALID) THEN
				rec_state := CreateError(ADR(RECIPE), MpRecipeStatusID, "mapp configuration is invalid, check REC_MPLINK constant", rec_state);
			ELSIF (MpRecipeStatusID = mpRECIPE_WRN_LOAD_WITH_WARN) THEN
				rec_state := CreateError(ADR(RECIPE), MpRecipeStatusID, "warning recipe read/write/new, check PLC logbook for details", rec_state);
			ELSIF (MpRecipeStatusID = mpRECIPE_WRN_NO_PV_FOUND) THEN
				tmpWStr1 := "error recipe file contains no data ";
				brwcsconv(ADR(tmpWStr2), ADR(RecipeFullFileName), brwU8toUC);
				brwcscat(ADR(tmpWStr1), ADR(tmpWStr2));
				rec_state := CreateError(ADR(RECIPE), MpRecipeStatusID, tmpWStr1, rec_state);
			ELSIF (MpRecipeError OR MpRecipeStatusID <> 0) THEN
				tmpWStr1 := "error recipe read/write/new ";
				brwcscat(ADR(tmpWStr1), ADR(RecipeName));
				rec_state := CreateError(ADR(RECIPE), MpRecipeStatusID, tmpWStr1, rec_state);
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Delete selected recipe																			
		// --------------------------------------------------------------------------------------------------------------------
		REC_DELETE:		
			// ---------------------------------------------------------------------------------------- 		
			// Initialize file delete structure 														
			FDelete.enable		:= TRUE;
			FDelete.pDevice 	:= ADR(DeviceName);
			FDelete.pName		:= ADR(RecipeFullFileName);
			FDelete();
										
			// ---------------------------------------------------------------------------------------- 		
			// OK																																				
			IF (FDelete.status = OK) THEN
				// Remove name from recipe list											
				RemoveRecName(ADR(RECIPE), RecipeIndex);
				// Mark recipe ID as free
				IF(REC_USE_UNICODE) THEN
					RecipeIDs[brsatoi(ADR(RECIPE.PAR.RecipeID))] := FALSE;
				END_IF
				
				CreateMessage(ADR(RECIPE.StatusText), ADR("deleted recipe"), ADR(RecipeName), RECIPE.PAR.VisuSlotID);
				RECIPE.CMD.Delete := 0;
				rec_state := REC_WAIT;
			// Error 		
			ELSIF (FDelete.status <> ERR_FUB_BUSY) THEN
				tmpWStr1 := "error deleting recipe ";
				brwcscat(ADR(tmpWStr1), ADR(RecipeName));
				rec_state := CreateError(ADR(RECIPE), FDelete.status, tmpWStr1, rec_state);
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Rename selected recipe																			
		// --------------------------------------------------------------------------------------------------------------------
		REC_RENAME:
			// Generate recipe path and extension
			tmpStr1 := REC_DIRECTORY;
			brsstrcat(ADR(tmpStr1), ADR('/'));
			brwcsconv(ADR(tmpStr2), ADR(RecipeNameNew), brwUCtoU8);
			brsstrcat(ADR(tmpStr1), ADR(tmpStr2));

			// Add file extension
			IF(REC_RECIPE_TYPE = typeCSV) THEN
				brsstrcat(ADR(tmpStr1), ADR('.csv'));
			ELSE
				brsstrcat(ADR(tmpStr1), ADR('.xml'));
			END_IF
			
			// ---------------------------------------------------------------------------------------- 		
			// Initialize file delete structure 														
			FRename.enable		:= TRUE;
			FRename.pDevice 	:= ADR(DeviceName);
			FRename.pName		:= ADR(RecipeFullFileName);
			FRename.pNewName	:= ADR(tmpStr1);
			FRename();	
			
			// ---------------------------------------------------------------------------------------- 		
			// OK																																				
			IF (FRename.status = OK) THEN
				// Remove name from recipe list	and add it again										
				brsmemmove(ADR(RECIPE.DAT.RecipeNames[RecipeIndex]),ADR(RECIPE.DAT.RecipeNames[RecipeIndex+1]), (RECIPE.DAT.RecipeNum) * SIZEOF(RECIPE.DAT.RecipeNames[0]));
				brsmemmove(ADR(RECIPE.DAT.RecipeIDs[RecipeIndex]),ADR(RECIPE.DAT.RecipeIDs[RecipeIndex+1]), (RECIPE.DAT.RecipeNum) * SIZEOF(RECIPE.DAT.RecipeIDs[0]));
				RECIPE.DAT.RecipeNum := RECIPE.DAT.RecipeNum - 1;
				
				// Use the same name for unicode
				IF(REC_USE_UNICODE) THEN
					InsertRecName(ADR(RECIPE), RecipeNameNew, RECIPE.PAR.RecipeID);
				// Use the new name for ASCII
				ELSE
					InsertRecName(ADR(RECIPE), RecipeNameNew, tmpStr2);
				END_IF

				RECIPE.VIS[RECIPE.PAR.VisuSlotID].RecipeSelect := RecipeNameNew;
				CreateMessage(ADR(RECIPE.StatusText), ADR("renamed recipe"), ADR(RecipeName), RECIPE.PAR.VisuSlotID);
				RECIPE.CMD.Rename := FALSE;
				rec_state := REC_WAIT;
			// Error 		
			ELSIF (FRename.status <> ERR_FUB_BUSY) THEN
				tmpWStr1 := "error renaming recipe ";
				brwcscat(ADR(tmpWStr1), ADR(RecipeName));
				rec_state := CreateError(ADR(RECIPE), FRename.status, tmpWStr1, rec_state);
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// View selected file																			
		// --------------------------------------------------------------------------------------------------------------------
		REC_VIEW:
			IF(RECIPE.DAT.RecipeNum > 0) THEN
				FOR idx:=0 TO SIZEOF(REC_VIEW_FILTER)/SIZEOF(REC_VIEW_FILTER[0]) - 1 DO
					IF(brsstrlen(ADR(RecipeFullFileName)) >= brsstrlen(ADR(REC_VIEW_FILTER[idx])) AND REC_VIEW_FILTER[idx] <> '') THEN
						// -------------------------------------------------------------------------------- 		
						// Verify that file name contains filter											
						IF(brsmemcmp(ADR(RecipeFullFileName) + brsstrlen(ADR(RecipeFullFileName)) - brsstrlen(ADR(REC_VIEW_FILTER[idx])) , ADR(REC_VIEW_FILTER[idx]), brsstrlen(ADR(REC_VIEW_FILTER[idx]))) = 0) THEN
							RECIPE.VIS[RECIPE.PAR.VisuSlotID].ViewFilePath := '/FileDevice:';
							brsstrcat(ADR(RECIPE.VIS[RECIPE.PAR.VisuSlotID].ViewFilePath), ADR(DeviceName));
							brsstrcat(ADR(RECIPE.VIS[RECIPE.PAR.VisuSlotID].ViewFilePath), ADR("/"));
							brsstrcat(ADR(RECIPE.VIS[RECIPE.PAR.VisuSlotID].ViewFilePath), ADR(RecipeFullFileName));
							RECIPE.CMD.View := FALSE;
							RECIPE.VIS[RECIPE.PAR.VisuSlotID].ViewFile := TRUE;
							rec_state := REC_WAIT;
							RETURN;
						END_IF
					END_IF
				END_FOR;
				RECIPE.StatusText := "error this file extension is not supported for viewing";
				RECIPE.CMD.View := FALSE;
				rec_state := REC_WAIT;
			END_IF			
		// --------------------------------------------------------------------------------------------------------------------
		// Download recipe - open recipe file
		// --------------------------------------------------------------------------------------------------------------------
		REC_DOWNLOAD:						
			// ----------------------------------------------------------------------------------------
			// Initialize file open structure
			FOpen.enable	:= TRUE;
			FOpen.pDevice 	:= ADR(DeviceName);
			FOpen.pFile		:= ADR(RecipeFullFileName);
			FOpen();
			
			// ----------------------------------------------------------------------------------------
			// OK
			IF (FOpen.status = OK) THEN
				// Make sure file fits into memory
				IF(FOpen.filelen <= REC_UPLOAD_DOWNLOAD_SIZE) THEN
					// Clear memory and reset web service
					brsmemset(AsMemPartAllocClear_0.mem, 0, REC_UPLOAD_DOWNLOAD_SIZE);
					WebserviceDownload.enable := FALSE;
					WebserviceDownload();
					rec_state := REC_DOWNLOAD_1;
					// File is too large
				ELSE
					tmpWStr1 := "download file exceeds maximum buffer size of ";
					brsitoa(REC_UPLOAD_DOWNLOAD_SIZE, ADR(tmpStr2));
					brwcsconv(ADR(tmpWStr2),ADR(tmpStr2), brwU8toUC);
					brwcscat(ADR(tmpWStr1), ADR(tmpWStr2));
					brwcscat(ADR(tmpWStr1), ADR(" bytes"));				
					rec_state := CreateError(ADR(RECIPE), ERR_MEM_DOWNLOAD, tmpWStr1, rec_state);
				END_IF;
			// Error
			ELSIF (FOpen.status <> ERR_FUB_BUSY) THEN
				rec_state := CreateError(ADR(RECIPE), FOpen.status, "error opening file for download", rec_state);
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Download recipe - read recipe file
		// --------------------------------------------------------------------------------------------------------------------
		REC_DOWNLOAD_1:			
			// ----------------------------------------------------------------------------------------
			// Initialize file read structure
			FRead.enable	:= TRUE;
			FRead.ident		:= FOpen.ident;
			FRead.len		:= FOpen.filelen;
			FRead.pDest		:= AsMemPartAllocClear_0.mem;
			FRead();
			
			// ----------------------------------------------------------------------------------------
			// OK
			IF (FRead.status = OK) THEN
				rec_state := REC_DOWNLOAD_2;
			// Error
			ELSIF (FRead.status <> ERR_FUB_BUSY) THEN
				rec_state := CreateError(ADR(RECIPE), FRead.status, "error reading file for download", rec_state);
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Download recipe - close recipe file
		// --------------------------------------------------------------------------------------------------------------------
		REC_DOWNLOAD_2:			
			// ----------------------------------------------------------------------------------------
			// Initialize file close structure
			FClose.enable	:= TRUE;
			FClose.ident	:= FOpen.ident;
			FClose();
			
			// ----------------------------------------------------------------------------------------
			// OK
			IF (FClose.status = OK) THEN
				download_timeout.IN := 0;
				download_timeout();
				rec_state := REC_DOWNLOAD_3;
			// Error
			ELSIF (FClose.status <> ERR_FUB_BUSY) THEN
				rec_state := CreateError(ADR(RECIPE), FClose.status, "error closing file for download", rec_state);
			END_IF		
		// --------------------------------------------------------------------------------------------------------------------
		// Download recipe - web service
		// --------------------------------------------------------------------------------------------------------------------
		REC_DOWNLOAD_3:			
			// ----------------------------------------------------------------------------------------
			// Create response header
			response_header_data :=  'Content-Type: application/octet-stream; Content-Transfer-Encoding: binary; Content-Disposition: attachment; filename="';
			brwcsconv(ADR(tmpStr1), ADR(RecipeName), brwUCtoU8);
			// Add file extension to file name
			IF(REC_RECIPE_TYPE = typeCSV) THEN
				brsstrcat(ADR(tmpStr1), ADR('.csv'));
			ELSE
				brsstrcat(ADR(tmpStr1), ADR('.xml'));
			END_IF
			ReplaceString(ADR(tmpStr1), ADR(' '), ADR('%20'), FALSE);
			brsstrcat(ADR(response_header_data), ADR(tmpStr1));
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
			WebserviceDownload.pResponseData 	:= AsMemPartAllocClear_0.mem;
			WebserviceDownload.pResponseHeader	:= ADR(response_header);
			WebserviceDownload.pServiceName 	:= ADR(tmpStr1);
			WebserviceDownload.responseDataLen 	:= FOpen.filelen;
			WebserviceDownload();
			
			// ----------------------------------------------------------------------------------------
			// Timeout if file is not pulled from browser
			download_timeout.IN := TRUE;
			download_timeout.PT := 300;
			download_timeout();
			IF(download_timeout.Q) THEN
				rec_state := CreateError(ADR(RECIPE), ERR_TIMEOUT_DOWNLOAD, "error download response timed out", rec_state);
			END_IF

			// ----------------------------------------------------------------------------------------
			// Set URL
			IF (WebserviceDownload.status = ERR_FUB_BUSY AND RECIPE.VIS[RECIPE.PAR.VisuSlotID].DownloadFileUrl = '') THEN
				brsstrcat(ADR(RECIPE.VIS[RECIPE.PAR.VisuSlotID].DownloadFileUrl), ADR(tmpStr1));
			// Start sending data
			ELSIF (WebserviceDownload.status = OK AND WebserviceDownload.send = FALSE AND RECIPE.VIS[RECIPE.PAR.VisuSlotID].DownloadFileUrl <> '') THEN
				WebserviceDownload.send := TRUE;
			// Sending data finished
			ELSIF (WebserviceDownload.send = TRUE) THEN
				WebserviceDownload.send := FALSE;
				rec_state := REC_DOWNLOAD_4;
			// Error
			ELSIF (WebserviceDownload.status <> ERR_FUB_BUSY AND WebserviceDownload.status <> OK) THEN
				rec_state := CreateError(ADR(RECIPE), WebserviceDownload.status, "error sending web response", rec_state);
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Download recipe - web service
		// --------------------------------------------------------------------------------------------------------------------
		REC_DOWNLOAD_4:			
			WebserviceDownload();
			
			// ----------------------------------------------------------------------------------------
			// Start sending data
			IF (WebserviceDownload.phase = httpPHASE_WAITING) THEN 
				CreateMessage(ADR(RECIPE.StatusText), ADR("downloaded recipe"), ADR(RecipeName), RECIPE.PAR.VisuSlotID);
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].DownloadFileUrl := '';
				WebserviceDownload.send := FALSE;
				RECIPE.CMD.Download := FALSE;
				rec_state := REC_WAIT;
			// Error
			ELSIF (WebserviceDownload.status <> ERR_FUB_BUSY) THEN
				rec_state := CreateError(ADR(RECIPE), WebserviceDownload.status, "error sending web response", rec_state);
			END_IF
		//**********************************************************************************************
		// Upload file - verify parameters
		//**********************************************************************************************
		REC_UPLOAD:
			
			// Make sure data fits into memory
			IF(WebServiceUpload.requestDataLen < REC_UPLOAD_DOWNLOAD_SIZE) THEN
				// Find file name start
				file_name_start := FindInMem(AsMemPartAllocClear_0.mem, WebServiceUpload.requestDataLen, ADR('filename="'), brsstrlen(ADR('filename="')), FALSE);
				IF(file_name_start > 0) THEN
					file_name_start := file_name_start + brsstrlen(ADR('filename="'));
					// Find end of file name
					file_name_len := FindInMem(AsMemPartAllocClear_0.mem+file_name_start, WebServiceUpload.requestDataLen-file_name_start, ADR('"$r$n'), brsstrlen(ADR('"$r$n')), FALSE);
					IF(file_name_len > 0) THEN
						// Make sure file name is not too long
						IF(file_name_len <= REC_NAME_LENGTH) THEN
							// Store file name
							brsmemset(ADR(item_name), 0, SIZEOF(item_name));
							brsmemcpy(ADR(item_name), AsMemPartAllocClear_0.mem+file_name_start, file_name_len);
							// Find start of data
							file_data_start := FindInMem(AsMemPartAllocClear_0.mem, WebServiceUpload.requestDataLen, ADR('Content-Type:'), brsstrlen(ADR('Content-Type:')), FALSE);
							IF(file_data_start > 0) THEN
								file_data_start := file_data_start + brsstrlen(ADR('Content-Type:'));
								// Find end of data
								file_data_start := FindInMem(AsMemPartAllocClear_0.mem+file_data_start, WebServiceUpload.requestDataLen-file_data_start, ADR('$r$n$r$n'), brsstrlen(ADR('$r$n$r$n')), FALSE) + brsstrlen(ADR('$r$n$r$n'))+file_data_start;
								file_data_len := FindInMem(AsMemPartAllocClear_0.mem+file_data_start, WebServiceUpload.requestDataLen-file_data_start, ADR('$r$n------'), brsstrlen(ADR('$r$n------')), TRUE);
								// When file name and data is correct procceed with saving data to file
								IF(file_data_len > 0) THEN
									rec_state := REC_UPLOAD_1;
									RETURN;
								ELSE
									rec_state := CreateError(ADR(RECIPE), ERR_SIZE_DATA_UPLOAD, "data end not found in upload response", rec_state);
								END_IF
							// Data start not found in upload response
							ELSE
								rec_state := CreateError(ADR(RECIPE), ERR_POS_DATA_UPLOAD, "data start not found in upload response", rec_state);
							END_IF
						// File name is too long in upload response
						ELSE
							rec_state := CreateError(ADR(RECIPE), ERR_LEN_NAME_UPLOAD, "file name is too long in upload response", rec_state);
						END_IF
					// File name end not found in upload response
					ELSE
						rec_state := CreateError(ADR(RECIPE), ERR_SIZE_NAME_UPLOAD, "file name end not found in upload response", rec_state);
					END_IF
				// File name start not found in upload response
				ELSE
					rec_state := CreateError(ADR(RECIPE), ERR_POS_NAME_UPLOAD, "file name position not found in upload response", rec_state);
				END_IF
			// Upload file exceeds maximum buffer size
			ELSE
				tmpWStr1 := "upload file exceeds maximum buffer size of ";
				brsitoa(REC_UPLOAD_DOWNLOAD_SIZE, ADR(tmpStr2));
				brwcsconv(ADR(tmpWStr2),ADR(tmpStr2), brwU8toUC);
				brwcscat(ADR(tmpWStr1), ADR(tmpWStr2));
				brwcscat(ADR(tmpWStr1), ADR(" bytes"));
				rec_state := CreateError(ADR(RECIPE), ERR_MEM_UPLOAD, tmpWStr1, rec_state);
			END_IF
			// Reset upload buffer and function block
			brsmemset(AsMemPartAllocClear_0.mem, 0, REC_UPLOAD_DOWNLOAD_SIZE);
			RECIPE.VIS[RECIPE.PAR.VisuSlotID].ReloadUpload := TRUE;
			WebServiceUpload.enable := FALSE;
			WebServiceUpload();
		//**********************************************************************************************
		// Upload file - Check if file exists
		//**********************************************************************************************
		REC_UPLOAD_1:					
			// ----------------------------------------------------------------------------------------
			// Checking for files with the same name
			RECIPE.VIS[RECIPE.PAR.VisuSlotID].UploadOverwriteResponse := 0;
			tmpStr1 := item_name;
			ReplaceString(ADR(tmpStr1), ADR('.csv'), ADR(''), TRUE);
			ReplaceString(ADR(tmpStr1), ADR('.xml'), ADR(''), TRUE);
			
			FOR idx:=0 TO RECIPE.DAT.RecipeNum DO	
				IF(RECIPE.CMD.Upload = TRUE AND RECIPE.DAT.RecipeIDs[idx] = tmpStr1) THEN
					RECIPE.VIS[RECIPE.PAR.VisuSlotID].UploadOverwriteRequest := TRUE;
					rec_state := REC_UPLOAD_2;
					RETURN;	 
				END_IF;
			END_FOR;
			
			// Generate recipe path and extension
			RecipeFullFileName := REC_DIRECTORY;
			brsstrcat(ADR(RecipeFullFileName), ADR('/'));
			brsstrcat(ADR(RecipeFullFileName), ADR(item_name));
			rec_state := REC_UPLOAD_4;
		//**********************************************************************************************
		// Upload file - Wait for message box response
		//**********************************************************************************************
		REC_UPLOAD_2:
			// Overwrite file
			IF(RECIPE.VIS[RECIPE.PAR.VisuSlotID].UploadOverwriteResponse = YES) THEN
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].UploadOverwriteRequest := FALSE;
				// Generate recipe path and extension
				RecipeFullFileName := REC_DIRECTORY;
				brsstrcat(ADR(RecipeFullFileName), ADR('/'));
				brsstrcat(ADR(RecipeFullFileName), ADR(item_name));
			
				rec_state := REC_UPLOAD_3;
			// Do not overwrite file
			ELSIF(RECIPE.VIS[RECIPE.PAR.VisuSlotID].UploadOverwriteResponse = NO) THEN
				// Reset upload command
				brsmemset(AsMemPartAllocClear_0.mem, 0, REC_UPLOAD_DOWNLOAD_SIZE);
				WebServiceUpload.enable := FALSE;
				WebServiceUpload();
				RECIPE.CMD.Upload := 0;
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].ReloadUpload := TRUE;
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].UploadOverwriteRequest	:= FALSE;
				rec_state := REC_WAIT;
			END_IF
		// --------------------------------------------------------------------------------------------------------------------
		// Upload recipe - delete existing recipe																			
		// --------------------------------------------------------------------------------------------------------------------
		REC_UPLOAD_3:		
			// ---------------------------------------------------------------------------------------- 		
			// Initialize file delete structure 														
			FDelete.enable		:= TRUE;
			FDelete.pDevice 	:= ADR(DeviceName);
			FDelete.pName		:= ADR(RecipeFullFileName);
			FDelete();
										
			// ---------------------------------------------------------------------------------------- 		
			// OK																																				
			IF (FDelete.status = OK) THEN
				rec_state := REC_UPLOAD_4;
			// Error 		
			ELSIF (FDelete.status <> ERR_FUB_BUSY) THEN
				tmpWStr1 := "error deleting recipe ";
				brwcscat(ADR(tmpWStr1), ADR(RecipeName));
				rec_state := CreateError(ADR(RECIPE), FDelete.status, tmpWStr1, rec_state);
			END_IF
			//**********************************************************************************************
			// Upload file
			//**********************************************************************************************
		REC_UPLOAD_4:		
			// ----------------------------------------------------------------------------------------
			// Initialize file create structure
			FCreate.enable	:= TRUE;
			FCreate.pDevice := ADR(DeviceName);
			FCreate.pFile	:= ADR(RecipeFullFileName);
			FCreate();
			
			// ----------------------------------------------------------------------------------------
			// OK
			IF (FCreate.status = OK) THEN
				rec_state := REC_UPLOAD_5;
			// Error
			ELSIF (FCreate.status <> ERR_FUB_BUSY) THEN
				rec_state := CreateError(ADR(RECIPE), FCreate.status, "error creating file from upload", rec_state);
				// Reset upload buffer and function block
				brsmemset(AsMemPartAllocClear_0.mem, 0, REC_UPLOAD_DOWNLOAD_SIZE);
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].ReloadUpload := TRUE;
				WebServiceUpload.enable := FALSE;
				WebServiceUpload();
				FCreate.enable	:= FALSE;
				FCreate();
			END_IF
		//**********************************************************************************************
		// Upload file
		//**********************************************************************************************
		REC_UPLOAD_5:
			
			// ----------------------------------------------------------------------------------------
			// Initialize file write structure
			FWrite.enable	:= TRUE;
			FWrite.ident	:= FCreate.ident;
			FWrite.len		:= file_data_len;
			FWrite.pSrc		:= AsMemPartAllocClear_0.mem + file_data_start;
			FWrite();
			
			// ----------------------------------------------------------------------------------------
			// OK
			IF (FWrite.status = OK) THEN
				rec_state := REC_UPLOAD_6;
			// Error
			ELSIF (FWrite.status <> ERR_FUB_BUSY) THEN
				rec_state := CreateError(ADR(RECIPE), FWrite.status, "error writing file from upload", rec_state);
			END_IF
		//**********************************************************************************************
		// Upload file
		//**********************************************************************************************
		REC_UPLOAD_6:
			// ----------------------------------------------------------------------------------------
			// Initialize file close structure
			FClose.enable	:= TRUE;
			FClose.ident	:= FCreate.ident;
			FClose();
			
			// ----------------------------------------------------------------------------------------
			// OK
			IF (FClose.status = OK) THEN
				brsmemset(AsMemPartAllocClear_0.mem, 0, REC_UPLOAD_DOWNLOAD_SIZE);
				WebServiceUpload.enable := FALSE;
				WebServiceUpload();
				RECIPE.CMD.Upload := FALSE;
				RECIPE.CMD.Init := TRUE;
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].ReloadUpload := TRUE;
				rec_state := REC_WAIT;
			// Error
			ELSIF (FClose.status <> ERR_FUB_BUSY) THEN
				rec_state := CreateError(ADR(RECIPE), FClose.status, "error closing file from upload", rec_state);
			END_IF			
		// --------------------------------------------------------------------------------------------------------------------
		// Error 
		// --------------------------------------------------------------------------------------------------------------------					
		REC_ERROR:
			RECIPE.StatusText := "error state triggered on web client ID ";
			tmpWStr1 := DINT_TO_WSTRING(RECIPE.PAR.VisuSlotID);
			brwcscat(ADR(RECIPE.StatusText), ADR(tmpWStr1));
			// --------------------------------------------------------------------------------------------------------------------											
			// Make sure we dont exceed maximum number of web clients
			IF(RECIPE.PAR.VisuSlotID <= REC_MAX_CLIENTS_ID) THEN
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].ShowMessageBoxError := TRUE;
			END_IF
			// --------------------------------------------------------------------------------------------------------------------	
			// Return to idle state
			IF RECIPE.CMD.ErrorReset THEN
				// Clear download memory and reset web service
				brsmemset(AsMemPartAllocClear_0.mem, 0, REC_UPLOAD_DOWNLOAD_SIZE);
				WebserviceDownload.enable := FALSE;
				WebserviceDownload();
				WebServiceUpload.enable := FALSE;
				WebServiceUpload();
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].UploadOverwriteRequest := FALSE;
				
				// Reset function blocks
				MpRecipeCsv_0.Enable := FALSE;
				MpRecipeCsv_0.Save := FALSE;
				MpRecipeCsv_0.Load := FALSE;
				
				MpRecipeXml_0.Enable := FALSE;
				MpRecipeXml_0.Save := FALSE;
				MpRecipeXml_0.Load := FALSE;
				
				MpRecipeRegPar_0.Enable := FALSE;
				FOR idx:=1 TO REC_VAR_NUM DO
					MpRecipeRegPar_1[idx].Enable := FALSE;
					IF(REC_VAR_LIST[idx] = '') THEN
						EXIT;
					END_IF
				END_FOR;
				
				// Reset error structure
				brsmemset(ADR(RECIPE.ERR), 0, SIZEOF(RECIPE.ERR));
				RECIPE.StatusText := "";
				RECIPE.CMD.ErrorReset := FALSE;
				RECIPE.VIS[RECIPE.PAR.VisuSlotID].ShowMessageBoxError := FALSE;
				rec_state := REC_WAIT;
			END_IF;	
			brsmemset(ADR(RECIPE.CMD), 0, SIZEOF(RECIPE.CMD));
	END_CASE
	// --------------------------------------------------------------------------------------------------------------------
	// Cyclic function calls
	MpRecipeRegPar_0();
	FOR idx:=1 TO REC_VAR_NUM DO
		MpRecipeRegPar_1[idx]();
		IF(REC_VAR_LIST[idx] = '') THEN
			EXIT;
		END_IF
	END_FOR;
	MpRecipeCsv_0();
	MpRecipeXml_0();

END_PROGRAM