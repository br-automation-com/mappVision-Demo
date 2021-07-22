FUNCTION_BLOCK ViCreateWebDirFile
	IF NOT Enable THEN
		Status := ERR_FUB_ENABLE_FALSE;
		Step := 0;
		RETURN;
	END_IF
	CASE Step OF
		0:
			Status := ERR_FUB_BUSY;
			Done := FALSE;
			Step := 1;
		1: // Init
			ACTION_CreateHtmlFile;
			FileDevSystem		:= 'CF';
			FileDevSystemPara	:= '/DEVICE=C:/';
			DirNameWeb			:= 'web';
			FileNameVisImgHtml	:= 'web/VisionImg.html';
			FileNameEyeSystem	:= 'ADDONS/DATA/IAT_Data/wwwRoot/BRVisu/Media/VisionEye.png';
			FileNameEyeUser		:= 'web/VisionEye.png';
			Step := 2;
		2: // Check if web directory already exists
			DirInfo_0(enable := TRUE, pDevice := ADR(FileDevUser), pPath := ADR(DirNameWeb));
			IF DirInfo_0.status = ERR_OK THEN
				Step := 9;
			ELSIF DirInfo_0.status = fiERR_DIR_NOT_EXIST THEN
				Step := 3;
			ELSIF DirInfo_0.status <> ERR_FUB_BUSY THEN
				Status := DirInfo_0.status;
				Step := 0;
			END_IF
		3: // Create web directory if it does not exist
			DirCreate_0(enable := TRUE, pDevice := ADR(FileDevUser), pName := ADR(DirNameWeb));
			IF DirCreate_0.status = ERR_OK THEN
				Step := 10;
			ELSIF DirCreate_0.status <> ERR_FUB_BUSY THEN
				Status := DirCreate_0.status;
				Step := 0;
			END_IF
		9: // Try to delete the html file. This is necessary, because of when settings are changed, the file needs to be recreated.
			FileDelete_0(enable := TRUE, pDevice := ADR(FileDevUser), pName := ADR(FileNameVisImgHtml));
			IF FileDelete_0.status = ERR_OK OR FileDelete_0.status = fiERR_FILE_NOT_FOUND THEN
				Step := 10;
			ELSIF FileDelete_0.status <> ERR_FUB_BUSY THEN
				Status := FileDelete_0.status;
				Step := 0;
			END_IF
		10: // Check if html page exists
			FileCreate_0(enable := TRUE, pDevice := ADR(FileDevUser), pFile := ADR(FileNameVisImgHtml));
			IF FileCreate_0.status = ERR_OK THEN
				brsstrcpy(ADR(FileWriteData), ADR(HtmlFileContent1));
				brsstrcat(ADR(FileWriteData), ADR(EthIP));
				brsstrcat(ADR(FileWriteData), ADR(HtmlFileContent2));
				Step := 11;
			ELSIF FileCreate_0.status = fiERR_EXIST THEN
				Step := 20;
			ELSIF FileCreate_0.status <> ERR_FUB_BUSY THEN
				Status := FileCreate_0.status;
				Step := 0;
			END_IF
		11: // Write content
			FileWrite_0(enable := TRUE, ident := FileCreate_0.ident, offset := 0, pSrc := ADR(FileWriteData), len := brsstrlen(ADR(FileWriteData)));
			IF FileWrite_0.status = ERR_OK THEN
				Step := 12;
			ELSIF FileWrite_0.status <> ERR_FUB_BUSY THEN
				Status := FileWrite_0.status;
				Step := 0;
			END_IF
		12: // Close file
			FileClose_0(enable := TRUE, ident := FileCreate_0.ident);
			IF FileClose_0.status = ERR_OK THEN
				Step := 20;
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				Status := FileClose_0.status;
				Step := 0;
			END_IF
		
		20: // Create FileDevice to System partition
			DevLink_0(enable := TRUE, pDevice := ADR(FileDevSystem), pParam := ADR(FileDevSystemPara));
			IF DevLink_0.status = ERR_OK THEN
				Step := 21;
			ELSIF DevLink_0.status <> ERR_FUB_BUSY THEN
				Status := DevLink_0.status;
				Step := 0;
			END_IF
		21: // Copy VisionEye.png from mappView folder (System partition) to webserver dir
			FileCopy_0(enable := TRUE, pSrcDev := ADR(FileDevSystem), pSrc := ADR(FileNameEyeSystem), pDestDev := ADR(FileDevUser), pDest := ADR(FileNameEyeUser));
			IF FileCopy_0.status <> ERR_FUB_BUSY THEN
				Status := FileCopy_0.status;
				Step := 22;
			END_IF
		22: // Delete DevLink
			DevUnlink_0(enable := TRUE, handle := DevLink_0.handle);
			IF DevUnlink_0.status = ERR_OK THEN
				Step := 30;
			ELSIF DevUnlink_0.status <> ERR_FUB_BUSY THEN
				Status := DevUnlink_0.status;
				Step := 0;
			END_IF
		30: // Create path for webviewer widget
			visWebViewerPath := 'http://'; // Create path for webviewer widget
			brsstrcat(ADR(visWebViewerPath), ADR(EthIP));
			Done := TRUE;
			Status := ERR_OK;
			Step := 0;
	END_CASE
END_FUNCTION_BLOCK