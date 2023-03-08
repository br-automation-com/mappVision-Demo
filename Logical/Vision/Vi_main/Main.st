// --------------------------------------------------------------------------------------------------------------------
// General vision task. This is a support task for the mappVision. The following functions are implemneted
// - Translate some values in text messages
// - Reset camera trigger when inspection is finsihed
// - Load vision application
// - Save diagnostic data
// Version 2.x (Check revision history for details)
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT

	FOR idx:= START_IDX TO NUM_CAMS BY 1 DO 
		setupPointersAction;
		
		this.path := 'IF3.ST';
		tmpStr := USINT_TO_STRING(idx);
		brsstrcat(ADR(this.path),ADR(tmpStr));
		
		hmi.out.wsPort := 18000+idx*10;
		this.mappView.enable := TRUE;
		this.mappView.wsPort := hmi.out.wsPort;
		this.mappView.simulateConfig.activate := DiagCpuIsSimulated();
		this.mappView.simulateConfig.pFile := ADR('img');
		this.mappView.simulateConfig.useRandomNumbers := TRUE;
		this.mappView.simulateConfig.appendNumber := TRUE;
		this.mappView.simulateConfig.minNumber := 1;
		this.mappView.simulateConfig.minNumber := 3;
		
		this.visionDiagFileDevice := 'VI_DIAG'; // File device is created in Files program (changes to USB if such is pluged in)
		
		hmi.out.camera.plNodeNr := idx;
		hmi.in.recipe.cam.focus := 200;
		hmi.in.recipe.cam.exposureTime := 100;
		
		hmi.in.cmd.resetInfo := TRUE; 
		
		// -----------------------------------------------------------------------------------------------------------
		// Set camera specific data 
		// -----------------------------------------------------------------------------------------------------------
		CASE idx OF
			1:
				this.mappView.pMappLink := ADR(gCameraBlob);
				this.mappView.simulateConfig.pDevice := ADR('SIM_BLOB');
				hmi.out.camera.visionFunction := 'BLOB';
			2:	
				this.mappView.pMappLink := ADR(gCameraCodeReading);
				this.mappView.simulateConfig.pDevice := ADR('SIM_CR');
				hmi.out.camera.visionFunction := 'Code Reader';
				(*hmi.out.VF.numResults*)
			3:	
				this.mappView.pMappLink := ADR(gCameraMatch);
				this.mappView.simulateConfig.pDevice := ADR('SIM_MATCH');
				hmi.out.camera.visionFunction := 'Matching';
			4:	
				this.mappView.pMappLink := ADR(gCameraMeasurement);
				this.mappView.simulateConfig.pDevice := ADR('SIM_MEAS');
				hmi.out.camera.visionFunction := 'Measurement';
			5:	
				this.mappView.pMappLink := ADR(gCameraOCR);
				this.mappView.simulateConfig.pDevice := ADR('SIM_OCR');
				hmi.out.camera.visionFunction := 'OCR';
			6:	
				this.mappView.pMappLink := ADR(gCameraPxl);
				this.mappView.simulateConfig.pDevice := ADR('SIM_PXCNT');
				hmi.out.camera.visionFunction := 'Pixel Counter';
		END_CASE
		
	END_FOR
	
END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC
	

				
	FOR idx:= START_IDX TO NUM_CAMS BY 1 DO 
		setupPointersAction;
		
		// -----------------------------------------------------------------------------------------------------------
		// Translate camera status in readable text
		// -----------------------------------------------------------------------------------------------------------
		brdkViBase_camStatusToString(hw.camera.in.status.cameraStatus,ADR(hmi.out.camera.statusText));
		
		// -----------------------------------------------------------------------------------------------------------
		// Check if vision cockpit is open
		// -----------------------------------------------------------------------------------------------------------
		hmi.out.camera.mappVisionActive := (hw.camera.in.status.cameraStatus AND 16#8000_0000) > 0;
	
		// -----------------------------------------------------------------------------------------------------------
		// Read camera hardware info
		// -----------------------------------------------------------------------------------------------------------
		

		IF hmi.in.cmd.resetInfo THEN
			hmi.in.cmd.resetInfo := FALSE;
			hmi.in.cameraInfo.distance := hmi.in.recipe.cam.focus;
			this.brdkViBase_getCameraInfo_0.execute := TRUE;
		END_IF
		
		this.brdkViBase_getCameraInfo_0.pDevicePath := ADR(this.path);
		this.brdkViBase_getCameraInfo_0.pInfo := ADR(hmi.in.cameraInfo);
		this.brdkViBase_getCameraInfo_0();
		
		IF hw.camera.out.par.focus <> hmi.in.recipe.cam.focus THEN
			hmi.in.cameraInfo.distance := hmi.in.recipe.cam.focus;
		END_IF
	
		
		
		IF hmi.in.cameraInfo.orderNr <> '' AND this.brdkViBase_getCameraInfo_0.status = ERR_OK THEN
			brdkViBase_calcOpticInfo(hmi.in.cameraInfo, hmi.out.camera.opticInfo); // calculate optic info based on defined info
		END_IF		

		
		
		IF hw.io.in.nettime > this.axisTrig.nettimeLastCycle_us THEN
			this.axisTrig.powerlinkCycle_us	:= hw.io.in.nettime - this.axisTrig.nettimeLastCycle_us;
		ELSE
			this.axisTrig.powerlinkCycle_us	:= -2147483648-hw.io.in.nettime + 2147483647-this.axisTrig.nettimeLastCycle_us; // handle wrap around
		END_IF
		this.axisTrig.nettimeLastCycle_us	:= hw.io.in.nettime;
		
	
		
		// -----------------------------------------------------------------------------------------------------------
		// Image trigger (camera and lights)
		// -----------------------------------------------------------------------------------------------------------
		hw.camera.out.par.focus 			:= hmi.in.recipe.cam.focus;
		hw.camera.out.par.flashSegment 		:= hmi.in.recipe.cam.flashSegment;
		hw.camera.out.par.flashColor 		:= hmi.in.recipe.cam.flashColor;
		hw.camera.out.par.exposureTime 		:= hmi.in.recipe.cam.exposureTime;
		hw.camera.out.par.chromaticLock 	:= hmi.in.recipe.cam.chromaticLock;
		hw.camera.out.par.gainLevel 		:= hmi.in.recipe.cam.gainLevel;
		
		
		// check if camera is ready for an image trigger and MappView have been updated
		IF this.brdkViBase_imgTrigger_0.ready AND NOT this.brdkViBase_imgTrigger_0.busy AND this.mappView.status = 0 THEN 
			
			// Hmi manual trigger
			IF hmi.in.cmd.trigger OR hmi.in.cmd.repetitiveTrigger THEN
				hmi.in.cmd.trigger 							:= FALSE;
				
				this.brdkViBase_imgTrigger_0.trigger 		:= TRUE;
				this.brdkViBase_imgTrigger_0.delayNettime 	:= hw.io.in.nettime + gAxis.status.powerlinkCycleTime * commonRecipe.visionPreTriggerCycles; // Calc nettime close to currnet time
			
			// Axis trigger 
			ELSIF commonRecipe.enableAxisTrigger AND 
					gAxis.status.triggerTimeDelta >= (commonRecipe.visionPreTriggerCycles * this.axisTrig.powerlinkCycle_us) AND
					gAxis.status.triggerTimeDelta <= ((commonRecipe.visionPreTriggerCycles + 1) * this.axisTrig.powerlinkCycle_us) THEN
				
				this.brdkViBase_imgTrigger_0.trigger := TRUE;
				this.brdkViBase_imgTrigger_0.delayNettime := gAxis.status.nettime + gAxis.status.triggerTimeDelta; // Use time calculated in Axis program
				
			END_IF
		END_IF
		
		this.brdkViBase_imgTrigger_0.searchAcquisitonSettings := hmi.in.cmd.autoSearch;
		this.brdkViBase_imgTrigger_0.pCameraHw := ADR(hw.camera);
		this.brdkViBase_imgTrigger_0.numLights := NUM_LIGHTS;
		this.brdkViBase_imgTrigger_0.pLightHw := ADR(hw.lights);
		this.brdkViBase_imgTrigger_0.useCamColorForLight := TRUE;
		this.brdkViBase_imgTrigger_0.useCamExpTimeForLight := TRUE;
		this.brdkViBase_imgTrigger_0.delayNettime := gVisionSensor[gSelectedSensor].DAT.NettimeDelay;
		this.brdkViBase_imgTrigger_0.simulate.enable := DiagCpuIsSimulated();
		this.brdkViBase_imgTrigger_0.simulate.alwaysSimulateNonePresentLights := TRUE;
		this.brdkViBase_imgTrigger_0.simulate.imgProcessingDelay := T#300ms;
		this.brdkViBase_imgTrigger_0();
		
		
		// -----------------------------------------------------------------------------------------------------------
		// New image ready and results
		// -----------------------------------------------------------------------------------------------------------		
		// New image (hight for one scan)
		IF this.brdkViBase_imgTrigger_0.newImage THEN
			
			this.mappView.updateImage := TRUE; // Trigger an update of the image on hmi
			this.DTGetTime_0(enable := TRUE);
			
			processResultsAction; // Process results action
			
		END_IF
		
		
		// -----------------------------------------------------------------------------------------------------------
		// Selection of specific result
		// -----------------------------------------------------------------------------------------------------------	
		IF hmi.in.cmd.click THEN
			hmi.in.cmd.click := FALSE;
		
			//this.tmp2D.x := hmi.in.cmd.x; //Click X coordinate
			//this.tmp2D.y := hmi.in.cmd.y; // Click Y coordinate
			//VF 
			brdkStrSubStr(ADR(tmpVF),ADR(hmi.in.cmd.elemId),1,1);
			//ID 
			brsstrcpy(ADR(tmpID),ADR(hmi.in.cmd.elemId)+2);
				
			hmi.in.cmd.intElemId := STRING_TO_USINT(tmpID);
		
		END_IF
		
		// -----------------------------------------------------------------------------------------------------------
		// Auto search vision acquistion settings done (save found settings in recipe structure) 
		// -----------------------------------------------------------------------------------------------------------
		
		// search Auto Focus done (hight for one scan)
		IF this.brdkViBase_imgTrigger_0.searchAcquisitonSettingsDone THEN
			hmi.in.recipe.cam.gainLevel 	:=	 hw.camera.in.status.gainLevel;
			hmi.in.recipe.cam.focus		 	:=	 hw.camera.in.status.focus;
			hmi.in.recipe.cam.exposureTime 	:=	 hw.camera.in.status.exposureTime;
			this.brdkViBase_imgTrigger_0.searchAcquisitonSettings := FALSE;
		END_IF
		
		
		
		// -----------------------------------------------------------------------------------------------------------
		// MappView get image to show om hmi
		// -----------------------------------------------------------------------------------------------------------
		
		IF DiagCpuIsSimulated() THEN
			this.mappView.imageFormat := BRDKVIIMG_IMG_TYPE_JPEG;
		ELSE	
			this.mappView.imageFormat := commonRecipe.imageFormat;
		END_IF
		this.mappView.jpegQuality := commonRecipe.jpegQuality;
		this.mappView();
		
		
		// -----------------------------------------------------------------------------------------------------------
		// Save image to file devive F:/images
		// -----------------------------------------------------------------------------------------------------------
		
		IF hmi.in.cmd.saveImage AND gFiles.output.ready THEN
			hmi.in.cmd.saveImage := FALSE;
			
			// create filename with VF name and current date of the image
			brsstrcpy(ADR(this.brdkFileWrite.fileName),ADR(hmi.out.camera.visionFunction));
			brsstrcat(ADR(this.brdkFileWrite.fileName),ADR('-'));
			brdkViBase_dateTimeToString(this.DTGetTime_0.DT1,'%d-%m-%Y',ADR(this.brdkFileWrite.fileName));
			CASE this.mappView.imageFormat OF
				BRDKVIIMG_IMG_TYPE_JPEG:
					brsstrcat(ADR(this.brdkFileWrite.fileName),ADR('.jpg'));
				BRDKVIIMG_IMG_TYPE_BMP:
					brsstrcat(ADR(this.brdkFileWrite.fileName),ADR('.bmp'));
			END_CASE
			
				
			this.brdkFileWrite.enable := TRUE;
			this.brdkFileWrite.dataLength := this.mappView.internal.getImage.destLen;
			this.brdkFileWrite.pData := this.mappView.internal.getImage.pDest;
			this.brdkFileWrite.overwrite := TRUE;
			this.brdkFileWrite.fileDevice := 'IMG';
		END_IF
		
		this.brdkFileWrite();
		
		IF this.brdkFileWrite.done THEN
			this.brdkFileWrite.enable := FALSE;
		END_IF
		
			
			
		
			
			
			
			
		
		// -----------------------------------------------------------------------------------------------------------
		// Save diagnostic data
		// -----------------------------------------------------------------------------------------------------------
		IF hmi.in.cmd.saveDiagnositc AND gFiles.output.ready THEN
			// Delete old file first
			this.fileDelete.enable := hmi.in.cmd.saveDiagnositc AND NOT this.viBaseSaveDiagData_0.Execute;
			this.fileDelete.pDevice := ADR(this.visionDiagFileDevice);
			this.fileDelete.pName := ADR(hmi.in.diagnosticFilename);
			IF (this.fileDelete.status <> ERR_FUB_BUSY) THEN
				this.viBaseSaveDiagData_0.Execute := TRUE;
			END_IF
			
			// Upload diagnostic information
			this.viBaseSaveDiagData_0.MpLink 	:= this.mappView.pMappLink;
			this.viBaseSaveDiagData_0.DeviceName := ADR(this.visionDiagFileDevice);
			this.viBaseSaveDiagData_0.FileName 	:= ADR(hmi.in.diagnosticFilename);
			hmi.out.status 					:= UINT_TO_DINT(ERR_FUB_BUSY);
			
			// -----------------------------------------------------------------------------------------------------------
			// OK
			IF (this.viBaseSaveDiagData_0.Done) THEN
				hmi.out.status 						:= UINT_TO_DINT(ERR_OK);
				this.viBaseSaveDiagData_0.Execute 	:= FALSE;
				hmi.in.cmd.saveDiagnositc 			:= FALSE;
				
			// -----------------------------------------------------------------------------------------------------------
			// Error
			ELSIF (NOT this.viBaseSaveDiagData_0.Busy AND this.viBaseSaveDiagData_0.Error) THEN
				hmi.out.status 					:= this.viBaseSaveDiagData_0.StatusID;
				this.viBaseSaveDiagData_0.Execute 	:= FALSE;
				hmi.in.cmd.saveDiagnositc 		:= FALSE;
			END_IF
		END_IF
		
		this.viBaseSaveDiagData_0();
		this.fileDelete();
		
		
		
		// -----------------------------------------------------------------------------------------------------------
		// Load vision application
		// -----------------------------------------------------------------------------------------------------------
		IF (hmi.in.cmd.loadVA) THEN
			this.viBaseLoadApplication_0.MpLink	:= this.mappView.pMappLink;
			this.viBaseLoadApplication_0.Name	:= ADR(hmi.in.vaName);
			hmi.out.status := UINT_TO_DINT(ERR_FUB_BUSY);
			
			// -----------------------------------------------------------------------------------------------------------
			// OK
			IF (this.viBaseLoadApplication_0.Done) THEN
				hmi.out.status := UINT_TO_DINT(ERR_OK);
				hmi.in.cmd.loadVA := FALSE;
		
			// -----------------------------------------------------------------------------------------------------------
			// Error
			ELSIF (NOT this.viBaseLoadApplication_0.Busy AND this.viBaseLoadApplication_0.Error) THEN
				hmi.out.status := this.viBaseLoadApplication_0.StatusID;
				hmi.in.cmd.loadVA := FALSE;
			END_IF		
		END_IF
		
		this.viBaseLoadApplication_0.Execute := hmi.in.cmd.loadVA;
		this.viBaseLoadApplication_0();
		
		
		// -----------------------------------------------------------------------------------------------------------
		// HMI stuff
		// -----------------------------------------------------------------------------------------------------------
		hmiAction;	
		
	END_FOR
	
	// -----------------------------------------------------------------------------------------------------------
	//Configure the pointers (this,hmi,hw etc.) show the correct data for that watch index 
	// -----------------------------------------------------------------------------------------------------------
	watchIdx := LIMIT(START_IDX,watchIdx,NUM_CAMS);
	idx := watchIdx;
	setupPointersAction;

	
END_PROGRAM
