// --------------------------------------------------------------------------------------------------------------------
// Vision image upload task
// - Stores the camera image on the file device media
// - Download of the image in the browser
// - Creates a html file to "resize" thei image for the mappview visualization (every size of the picuture matches the visu size)
// - Draw crosshairs
// Version 2.1
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	IF RemCfgImage.ConvertCycles = 0 THEN 							// Invalid --> use default values
		gVisionImage.CFG.FileDevice 	:= DEVICE_NAME;				// File device name where the images are stored
		gVisionImage.CFG.DirName		:= 'Vision';				// Directory used for images
		gVisionImage.CFG.CameraIP		:= '192.168.200.';			// IP adress of the camera (see PLK settings)
		gVisionImage.CFG.EthDevice		:= 'IF2';					// Device path of the PLCs ETH address
		gVisionImage.CFG.ConvertCycles	:= 10000;					// Conversioncycles per step (TK8 call). Use higer value on high performance CPU, use lower values on low performance CPU or in case of cycle time violations
		gVisionImage.CFG.Format			:= 0;						// Image type, use 0 for JPEG, 1 for bitmap
		gVisionImage.CFG.QualityJPG		:= 80;						// Quality for JPG images, larger numbers produce better images. Allowed values: 0 to 100, but values < ca 10 makes no sense
		gVisionImage.CFG.UploadBmpJpg	:= TRUE;
		gVisionImage.CFG.UploadSVG		:= TRUE;
	ELSE
		brsmemcpy(ADR(gVisionImage.CFG), ADR(RemCfgImage), SIZEOF(RemCfgImage)); // Restore default values from remanent memory
	END_IF
	gVisionImage.CMD.CreateDir	:= TRUE;
	visSelectedImage			:= '';
	// Call FBKs which interanally alloc memory once in the INIT
	ViDownloadImage_0();
	ViSaveImgOnPlc_0();
END_PROGRAM
PROGRAM _CYCLIC
	CASE Step OF
		VISTEP_WAIT: // Wait for new upload command
			IF gVisionImage.CMD.CreateDir THEN // Create the image directory on user partition (if it does not exist)
				gVisionImage.CMD.CreateDir := FALSE;
				gVisionImage.DAT.Status := ERR_FUB_BUSY;
				Step := VISTEP_CREATE_DIR;
			ELSIF gVisionImage.CMD.DeleteDir THEN // Delete image directory on user partition including all images
				gVisionImage.CMD.DeleteDir := FALSE;
				gVisionImage.DAT.Status := ERR_FUB_BUSY;
				Step := VISTEP_DELETE_DIR;
			ELSIF gVisionImage.CMD.DeleteImage THEN // Delete one image from the image directory on the user partition
				gVisionImage.CMD.DeleteImage := FALSE;
				IF brsstrlen(ADR(visSelectedImage)) > 0 THEN
					brsstrcpy(ADR(FileNameComplete), ADR(gVisionImage.CFG.DirName));
					brsstrcat(ADR(FileNameComplete), ADR('/'));
					brsstrcat(ADR(FileNameComplete), ADR(visSelectedImage));
					gVisionImage.DAT.Status := ERR_FUB_BUSY;
					Step := VISTEP_DELETE_IMAGE;
				ELSE // No image selected --> do nothing, just reset the cmd
					gVisionImage.CMD.DeleteImage := FALSE;
				END_IF
			ELSIF gVisionImage.CMD.Refresh THEN // Refresh image list from the image directory on the user partition
				gVisionImage.CMD.Refresh := FALSE;
				gVisionImage.DAT.Status := ERR_FUB_BUSY;
				Step := VISTEP_REFRESH_IMG_LIST;
			ELSIF gVisionImage.CMD.DownloadImage THEN // Download image from plc to webbrowser
				gVisionImage.CMD.DownloadImage := FALSE;
				IF brsstrlen(ADR(visSelectedImage)) > 0 THEN
					brsstrcpy(ADR(FileNameComplete), ADR(gVisionImage.CFG.DirName));
					brsstrcat(ADR(FileNameComplete), ADR('/'));
					brsstrcat(ADR(FileNameComplete), ADR(visSelectedImage));
					gVisionImage.DAT.Status := ERR_FUB_BUSY;
					Step := VISTEP_DOWNLOAD_IMAGE;
				ELSE // If no pictures are available, don't try to delete pictures
				END_IF
			ELSIF gVisionImage.CMD.SaveImageOnPLC THEN // Save image from camera to PLC
				gVisionImage.CMD.SaveImageOnPLC := FALSE;
				IF NOT gVisionImage.CFG.UploadBmpJpg AND NOT gVisionImage.CFG.UploadSVG THEN // Do nothing, because of no picture is needed
					gVisionImage.CMD.SaveImageOnPLC := FALSE;
				ELSE
					gVisionImage.DAT.Status		:= ERR_FUB_BUSY;
					Step						:= VISTEP_SAVE_IMG_ON_PLC;
				END_IF
			ELSIF gVisionImage.CMD.ResetError THEN // Reset error
				gVisionImage.CMD.ResetError := FALSE; // no error, so do nothing else (in case of an error, Step is VISTEP_ERR
			END_IF

			// Load new image into window
			IF visSelectedImageOld <> visSelectedImage AND ViRefreshImageList_0.DirEntries > 0 THEN
				brsmemset(ADR(visImagePath), 0, SIZEOF(visImagePath));
				visImagePath := '/FileDevice:';
				brsstrcat(ADR(visImagePath), ADR(gVisionImage.CFG.FileDevice));
				brsstrcat(ADR(visImagePath), ADR('/'));
				brsstrcat(ADR(visImagePath), ADR(gVisionImage.CFG.DirName));
				brsstrcat(ADR(visImagePath), ADR('/'));
				brsstrcat(ADR(visImagePath), ADR(visSelectedImage));
			ELSIF ViRefreshImageList_0.DirEntries = 0 THEN
				brsmemset(ADR(visImagePath), 0, SIZEOF(visImagePath));
			END_IF
			visSelectedImageOld := visSelectedImage;
			
			visEnableButtons_1 := Step = VISTEP_WAIT; // Disable buttons when command is pending: Save, Refresh, DeleteAll
			visEnableButtons_2 := visEnableButtons_1 AND ViRefreshImageList_0.DirEntries > 0 AND Step = VISTEP_WAIT; // Enable DeleteOneImage and DownloadImage button in mappView when no

		VISTEP_CREATE_DIR: // Create the image directory on user partition (if it does not exist)
			DirCreate_0.enable		:= TRUE;
			DirCreate_0.pDevice		:= ADR(gVisionImage.CFG.FileDevice);
			DirCreate_0.pName		:= ADR(gVisionImage.CFG.DirName);
			DirCreate_0();
			IF DirCreate_0.status = 0 OR DirCreate_0.status = fiERR_DIR_ALREADY_EXIST THEN
				Step := VISTEP_REFRESH_IMG_LIST;
			ELSIF DirCreate_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := DirCreate_0.status;
				Step := VISTEP_ERR;
			END_IF
		
		VISTEP_DELETE_DIR: // Delete image directory on user partition including all images
			DirDeleteEx_0.enable	:= TRUE;
			DirDeleteEx_0.pDevice	:= ADR(gVisionImage.CFG.FileDevice);
			DirDeleteEx_0.pName		:= ADR(gVisionImage.CFG.DirName);
			DirDeleteEx_0();
			IF DirDeleteEx_0.status = 0 THEN
				Step := VISTEP_CREATE_DIR;
			ELSIF DirDeleteEx_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := DirDeleteEx_0.status;
				Step := VISTEP_ERR;
			END_IF
		
		VISTEP_DELETE_IMAGE: // Delete one image from the image directory on the user partition
			FileDelete_0.enable 	:= TRUE;
			FileDelete_0.pDevice	:= ADR(gVisionImage.CFG.FileDevice);
			FileDelete_0.pName 		:= ADR(FileNameComplete);
			FileDelete_0();
			IF FileDelete_0.status = 0 THEN
				Step := VISTEP_REFRESH_IMG_LIST;
			ELSIF FileDelete_0.status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := FileDelete_0.status;
				Step := VISTEP_ERR;
			END_IF

		VISTEP_REFRESH_IMG_LIST: // Refresh image list from the image directory on the user partition
			ViRefreshImageList_0.Enable				:= TRUE;
			ViRefreshImageList_0.VisionImage		:= ADR(gVisionImage);
			ViRefreshImageList_0.ImageList			:= ADR(visImageList);
			ViRefreshImageList_0.visSelectedImage	:= ADR(visSelectedImage);
			ViRefreshImageList_0();
			IF ViRefreshImageList_0.Status = 0 THEN
				gVisionImage.DAT.Status := 0;
				Step := VISTEP_WAIT;
			ELSIF ViRefreshImageList_0.Status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := ViRefreshImageList_0.Status;
				Step := VISTEP_ERR;
			END_IF

		VISTEP_DOWNLOAD_IMAGE: // Download image from plc to webbrowser
			ViDownloadImage_0.Enable				:= TRUE;
			ViDownloadImage_0.FileDevice			:= gVisionImage.CFG.FileDevice;
			ViDownloadImage_0.FileName				:= FileNameComplete;
			ViDownloadImage_0.ImgName				:= visSelectedImage;
			ViDownloadImage_0.visDownloadFileUrl	:= ADR(visDownloadFileUrl);
			ViDownloadImage_0();
			IF ViDownloadImage_0.Status = 0 THEN
				gVisionImage.DAT.Status := 0;
				Step := VISTEP_WAIT;
			ELSIF ViDownloadImage_0.Status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := ViDownloadImage_0.Status;
				Step := VISTEP_ERR;
			END_IF
			
		VISTEP_SAVE_IMG_ON_PLC: // Save image from camera to PLC
			ViSaveImgOnPlc_0.Enable				:= TRUE;
			ViSaveImgOnPlc_0.CFG				:= gVisionImage.CFG;
			ViSaveImgOnPlc_0.PowerlinkNode		:= gVisionSensor[LIMIT(1, visSelectedSensor, MAX_NUM_CAMS)].CFG.PowerlinkNode;
			ViSaveImgOnPlc_0.CrossHairInfo		:= ADR(ViDrawCrosshair_0.CrossHairInfo);
			ViSaveImgOnPlc_0();
			IF ViSaveImgOnPlc_0.Status = 0 THEN
				Step := VISTEP_REFRESH_IMG_LIST;
			ELSIF ViSaveImgOnPlc_0.Status <> ERR_FUB_BUSY THEN
				gVisionImage.DAT.Status := ViSaveImgOnPlc_0.Status;
				Step := VISTEP_ERR;
			END_IF

		VISTEP_ERR: // Error state
			IF gVisionImage.CMD.ResetError THEN
				gVisionImage.CMD.ResetError := FALSE;
				gVisionImage.DAT.Status := 0;
				Step := VISTEP_WAIT;
			END_IF
			brsmemset(ADR(gVisionImage.CMD), 0, SIZEOF(gVisionImage.CMD));
	END_CASE

	// Draw the crosshairs on the mainpage
	ViDrawCrosshair_0.SelectedSensor		:= visSelectedSensor;
	ViDrawCrosshair_0.CmdRefreshCrosshair	:= gVisionImage.CMD.RefreshCrosshair;
	ViDrawCrosshair_0.VisionSensor			:= ADR(gVisionSensor[visSelectedSensor]);
	ViDrawCrosshair_0.CodeTypes				:= ADR(CodeTypes);
	ViDrawCrosshair_0.VisionDisabled		:= gVisionImage.DAT.VisionDisabled;
	ViDrawCrosshair_0.visCrossHair			:= ADR(visCrossHair);
	ViDrawCrosshair_0();
	gVisionImage.CMD.RefreshCrosshair		:= FALSE;

	// Create directory and files for showing the images on the mainpage in mappview visu
	IF NOT ViCreateWebDirFile_0.Done THEN
		ViCreateWebDirFile_0.Enable				:= TRUE;
		ViCreateWebDirFile_0.FileDevUser		:= gVisionImage.CFG.FileDevice;
		ViCreateWebDirFile_0.EthDevice			:= gVisionImage.CFG.EthDevice;
		ViCreateWebDirFile_0.visWebViewerPath	:= ADR(visWebViewerPath);
		ViCreateWebDirFile_0();
	END_IF
	visWebViewerQuery := 'jpg?q=30&node=';
	brsitoa(gVisionSensor[visSelectedSensor].CFG.PowerlinkNode, ADR(tmpStr));
	brsstrcat(ADR(visWebViewerQuery), ADR(tmpStr));
	
	// Show camera image on VC4 visualization
	ViShowImgOnVC4_0.Enable				:= ViCreateWebDirFile_0.Done; // Wait until the directory "web" is created
	ViShowImgOnVC4_0.RefreshImage		:= visVC4RefreshImg;
	ViShowImgOnVC4_0.CFG				:= gVisionImage.CFG;
	ViShowImgOnVC4_0.PowerlinkNode		:= gVisionSensor[LIMIT(1, visSelectedSensor, MAX_NUM_CAMS)].CFG.PowerlinkNode;
	ViShowImgOnVC4_0.ImgWidthInVC4_px	:= 500; // Pixel
	ViShowImgOnVC4_0();
	IF ViShowImgOnVC4_0.RefreshDone THEN
		visVC4RefreshImg := FALSE;
	END_IF
	
	brsmemcpy(ADR(RemCfgImage), ADR(gVisionImage.CFG), SIZEOF(RemCfgImage)); // Save settings to remanent variable
END_PROGRAM