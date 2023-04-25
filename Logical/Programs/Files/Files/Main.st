
PROGRAM _INIT
	(* Insert code here *)
	this.brdkFileDev.enable := TRUE;
	this.brdkFileDev.setup.plcDrive := F_DRIVE;
	this.brdkFileDev.setup.usbOverrule := FALSE;
	this.brdkFileDev.simulation.pcRootFolder := 'plcSim\MappVisionDemo';
	this.brdkFileDev.simulation.pcHDDrive := C_DRIVE;
	this.brdkFileDev.setup.rootFileDeviceName := 'ROOT_PLC';
	
	this.brdkFileDev.setup.fileDevices[0].name := 'SIM_BLOB';
	this.brdkFileDev.setup.fileDevices[0].path := 'sim/BLOB';
	this.brdkFileDev.setup.fileDevices[1].name := 'SIM_CR';
	this.brdkFileDev.setup.fileDevices[1].path := 'sim/CR';
	this.brdkFileDev.setup.fileDevices[2].name := 'SIM_MATCH';
	this.brdkFileDev.setup.fileDevices[2].path := 'sim/Match';
	this.brdkFileDev.setup.fileDevices[3].name := 'SIM_MEAS';
	this.brdkFileDev.setup.fileDevices[3].path := 'sim/Measurement';
	this.brdkFileDev.setup.fileDevices[4].name := 'SIM_OCR';
	this.brdkFileDev.setup.fileDevices[4].path := 'sim/OCR';
	this.brdkFileDev.setup.fileDevices[5].name := 'SIM_PXCNT';
	this.brdkFileDev.setup.fileDevices[5].path := 'sim/PxCnt';
		
	
	
	this.brdkFileDevUsb.setup.plcDrive := F_DRIVE;
	this.brdkFileDevUsb.setup.usbOverrule := TRUE;
	this.brdkFileDevUsb.simulation.pcRootFolder := 'plcSim\MappVisionDemo';
	this.brdkFileDevUsb.simulation.pcHDDrive := C_DRIVE;
	this.brdkFileDevUsb.simulation.pcUSBDrive := D_DRIVE;
	this.brdkFileDevUsb.setup.rootFileDeviceName := 'ROOT_USB';
	
	this.brdkFileDevUsb.setup.fileDevices[0].name := 'IMG';
	this.brdkFileDevUsb.setup.fileDevices[0].path := 'images';
	this.brdkFileDevUsb.setup.fileDevices[1].name := 'RECIPE';
	this.brdkFileDevUsb.setup.fileDevices[1].path := 'Recipe';
	this.brdkFileDevUsb.setup.fileDevices[2].name := 'VI_DIAG';
	this.brdkFileDevUsb.setup.fileDevices[2].path := 'visionDiag';
	
	this.mpFileManUI.UISetup.FileListScrollWindow := 1;
	this.mpFileManUI.UISetup.FileListSize := FILES_LIST_SIZE;

	this.mappView.simulateConfig.activate := TRUE;
	this.mappView.simulateConfig.appendNumber := FALSE;
	this.mappView.simulateConfig.autoIncrementNumber := FALSE;
	this.mappView.simulateConfig.pDevice := ADR('IMG');
	this.mappView.simulateConfig.useRandomNumbers := FALSE;
	
	hmi.mpFile.File.Filter := '*jpg';

END_PROGRAM


PROGRAM _CYCLIC
	(* Insert code here *)
	 
	// Create file devices 
	this.brdkFileDev();
	
	IF EDGEPOS(this.brdkFileDev.ready) THEN
		this.brdkFileDevUsb.enable := TRUE;
	END_IF
	
	hmi.mpFile.File.Refresh := hmi.mpFile.File.Refresh OR gFiles.input.refresh;
	gFiles.input.refresh := FALSE;
	this.brdkFileDevUsb();
	
	gFiles.output.fileDevice := 'ROOT';
	gFiles.output.ready := this.brdkFileDevUsb.ready;
	
	// Use MpFile to handle the images files
	hmi.mpFile.DeviceList.DeviceNames[0] := 'IMG';
	
	this.mpFileManUI.Enable := this.brdkFileDevUsb.ready;
	this.mpFileManUI.MpLink := ADR(gFileManagerUI);
	this.mpFileManUI.UIConnect := ADR(hmi.mpFile);
	IF hmi.mpFile.File.List.PageDown OR hmi.mpFile.File.List.PageUp OR hmi.mpFile.File.List.StepDown OR hmi.mpFile.File.List.StepUp THEN
		this.setIdx := TRUE;
	END_IF
		
	IF NOT hmi.mpFile.File.List.Items[hmi.in.cmd.selectedIdx].IsSelected THEN
		IF this.setIdx THEN
			this.setIdx := FALSE;
		ELSE
			
			FOR i := 0 TO this.mpFileManUI.UISetup.FileListSize BY 1 DO 
				hmi.mpFile.File.List.Items[i].IsSelected := i = hmi.in.cmd.selectedIdx;
			END_FOR
		END_IF
		
	END_IF
	
	
	this.mpFileManUI();
	
	FOR i:= 0 TO this.mpFileManUI.UISetup.FileListSize BY 1 DO
		hmi.out.fileNames[i] := hmi.mpFile.File.List.Items[i].Name;
	END_FOR
	
	IF this.setIdx THEN
		FOR i := 0 TO this.mpFileManUI.UISetup.FileListSize BY 1 DO 
			IF hmi.mpFile.File.List.Items[i].IsSelected THEN
				hmi.in.cmd.selectedIdx := i;
			END_IF
		END_FOR
	END_IF
	
	
	
	// Load image and overlay when the selected image changes.
	IF hmi.mpFile.File.List.Items[hmi.in.cmd.selectedIdx].Name <> this.lastFileName THEN
		this.fileName := hmi.mpFile.File.List.Items[hmi.in.cmd.selectedIdx].Name;
		brsstrcpy(ADR(this.fileType),ADR(this.fileName)+brsstrlen(ADR(this.fileName))-3);
		
		brsstrcpy(ADR(this.fileName)+brsstrlen(ADR(this.fileName))-4,ADR(''));
		this.mappView.simulateConfig.pFile := ADR(this.fileName);
		
		IF this.fileType = 'jpg' THEN
			this.mappView.imageFormat := BRDKVIIMG_IMG_TYPE_JPEG;
		ELSE
			this.mappView.imageFormat := BRDKVIIMG_IMG_TYPE_BMP;
		END_IF
		
		this.mappView.updateImage := TRUE;
		this.brdkFileRead.enable := TRUE;
		
		this.brdkFileRead.fileDevice := hmi.mpFile.DeviceList.DeviceNames[hmi.mpFile.DeviceList.SelectedIndex];
		this.brdkFileRead.fileName := hmi.mpFile.File.List.Items[hmi.in.cmd.selectedIdx].Name;
		brsstrcpy(ADR(this.brdkFileRead.fileName)+brsstrlen(ADR(this.brdkFileRead.fileName))-3,ADR('svg'));
		this.brdkFileRead.pData := ADR(hmi.out.svg);
		this.brdkFileRead.dataLength := SIZEOF(hmi.out.svg);

	END_IF
	
	this.lastFileName := hmi.mpFile.File.List.Items[hmi.in.cmd.selectedIdx].Name;
	this.brdkFileRead();
	
	IF this.brdkFileRead.done OR this.brdkFileRead.status = fiERR_FILE_NOT_FOUND THEN
		this.brdkFileRead.enable := FALSE;
	END_IF
	
	IF hmi.mpFile.MessageBox.Type =  mpFILE_MSG_CONFIRM_DELETE THEN
		hmi.mpFile.MessageBox.Confirm := TRUE;
	END_IF
	
	IF hmi.in.cmd.download THEN
		hmi.in.cmd.download	:= FALSE;
		this.delayTon.IN 	:= TRUE;
		this.delayTon.PT 	:= T#400ms;
	
		hmi.out.downloadSrc := '<script>function onSvgLoad() {const link = document.createElement("a");link.href = "/FileDevice:';
		brsstrcat(ADR(hmi.out.downloadSrc),ADR(this.brdkFileRead.fileDevice));
		brsstrcat(ADR(hmi.out.downloadSrc),ADR('/'));
		brsstrcat(ADR(hmi.out.downloadSrc),ADR(hmi.mpFile.File.List.Items[hmi.in.cmd.selectedIdx].Name));	
		brsstrcat(ADR(hmi.out.downloadSrc),ADR('";link.download="'));
		brsstrcat(ADR(hmi.out.downloadSrc),ADR(hmi.mpFile.File.List.Items[hmi.in.cmd.selectedIdx].Name));
		brsstrcat(ADR(hmi.out.downloadSrc),ADR('";link.click();}; onSvgLoad(); </script>'));
	END_IF
	
	IF this.delayTon.Q THEN
		this.delayTon.IN := FALSE;
		hmi.out.downloadSrc := '';
	END_IF
	this.delayTon();

	
	hmi.out.loadFileStatus := this.brdkFileRead.description;
	
	this.mappView.enable := this.brdkFileDevUsb.ready;
	this.mappView.wsPort :=  18100;
	//	this.mappView.pSvgImage := ADR(hmi.out.img);
	//	this.mappView.maxSvgImageLength := SIZEOF(hmi.out.img);
	this.mappView();

END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	this.brdkFileDev(	enable := FALSE);	 
	this.brdkFileDevUsb(enable := FALSE);	 
	this.mappView(		enable := FALSE);	 
	this.mpFileManUI(	Enable := FALSE);	 

END_PROGRAM

