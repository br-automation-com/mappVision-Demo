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
		
		this.recipePVName := '::Vi_main:hmiInstance[';
		brsstrcat(ADR(this.recipePVName),ADR(tmpStr));
		brsstrcat(ADR(this.recipePVName),ADR('].in.recipe'));
	
		this.user.dataPvName := '::Vi_main:localInstance[';
		brsstrcat(ADR(this.user.dataPvName),ADR(tmpStr));
		brsstrcat(ADR(this.user.dataPvName),ADR('].user.data'));
	
		
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
		
		hmi.in.cmd.resultTabIndex := 5;
		CASE idx OF
			1:
				this.mappView.pMappLink := ADR(gCameraBlob);
				this.mappView.simulateConfig.pDevice := ADR('SIM_BLOB');
				hmi.out.camera.visionFunction := 'BLOB';
				hmi.out.usedVF.BLOB := TRUE;
				hmi.in.cmd.resultTabIndex := MIN(hmi.in.cmd.resultTabIndex,idx-1);
			2:	
				this.mappView.pMappLink := ADR(gCameraCodeReading);
				this.mappView.simulateConfig.pDevice := ADR('SIM_CR');
				hmi.out.camera.visionFunction := 'Code Reader';
				hmi.out.usedVF.codeReader := TRUE;
				hmi.in.cmd.resultTabIndex := MIN(hmi.in.cmd.resultTabIndex,idx-1);
				(*hmi.out.VF.numResults*)
			3:	
				this.mappView.pMappLink := ADR(gCameraMatch);
				this.mappView.simulateConfig.pDevice := ADR('SIM_MATCH');
				hmi.out.camera.visionFunction := 'Matching';
				hmi.out.usedVF.matching := TRUE;
				hmi.in.cmd.resultTabIndex := MIN(hmi.in.cmd.resultTabIndex,idx-1);
			4:	
				this.mappView.pMappLink := ADR(gCameraMeasurement);
				this.mappView.simulateConfig.pDevice := ADR('SIM_MEAS');
				hmi.out.camera.visionFunction := 'Measurement';
				hmi.out.usedVF.measurement := TRUE;
				hmi.in.cmd.resultTabIndex := MIN(hmi.in.cmd.resultTabIndex,idx-1);
			5:	
				this.mappView.pMappLink := ADR(gCameraOCR);
				this.mappView.simulateConfig.pDevice := ADR('SIM_OCR');
				hmi.out.camera.visionFunction := 'OCR';
				hmi.out.usedVF.OCR := TRUE;
				hmi.in.cmd.resultTabIndex := MIN(hmi.in.cmd.resultTabIndex,idx-1);
			6:	
				this.mappView.pMappLink := ADR(gCameraPxl);
				this.mappView.simulateConfig.pDevice := ADR('SIM_PXCNT');
				hmi.out.camera.visionFunction := 'Pixel Counter';
				hmi.out.usedVF.pixelCounter := TRUE;
				hmi.in.cmd.resultTabIndex := MIN(hmi.in.cmd.resultTabIndex,idx-1);
			
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
		
			// set Camera flash options based on current camera
			hmi.out.camera.flashLightOptions[0] := '{"value":"0","text":"None"}';  
		
			CASE hmi.in.cameraInfo.LED_color OF
				BRDKVIBASE_LED_COLOR_3_BLUE:
					hmi.out.camera.flashLightOptions[1] := '{"value":"3","text":"Blue"}';  
				BRDKVIBASE_LED_COLOR_8_RED:
					hmi.out.camera.flashLightOptions[1] := '{"value":"1","text":"Red"}';  
				BRDKVIBASE_LED_COLOR_A_UV:
					hmi.out.camera.flashLightOptions[1] := '{"value":"210","text":"Ultraviolet"}';  
				BRDKVIBASE_LED_COLOR_D_IR:
					hmi.out.camera.flashLightOptions[1] := '{"value":"100","text":"Infrared"}';  
				BRDKVIBASE_LED_COLOR_F_W:
					hmi.out.camera.flashLightOptions[1] := '{"value":"99","text":"White"}';  
				BRDKVIBASE_LED_COLOR_Q_RGBL:
					hmi.out.camera.flashLightOptions[1] := '{"value":"1","text":"Red"}';  
					hmi.out.camera.flashLightOptions[2] := '{"value":"2","text":"Green"}';  
					hmi.out.camera.flashLightOptions[3] := '{"value":"3","text":"Blue"}';  
					hmi.out.camera.flashLightOptions[4] := '{"value":"4","text":"Lime"}';  
			
				BRDKVIBASE_LED_COLOR_R_RBIRW:
					hmi.out.camera.flashLightOptions[1] := '{"value":"1","text":"Red"}';  
					hmi.out.camera.flashLightOptions[2] := '{"value":"3","text":"Blue"}';  
					hmi.out.camera.flashLightOptions[3] := '{"value":"99","text":"White"}';  
					hmi.out.camera.flashLightOptions[4] := '{"value":"100","text":"Infrared"}';  
			END_CASE	
		END_IF		

		
		
		IF hw.io.in.nettime > this.axisTrig.nettimeLastCycle_us THEN
			this.axisTrig.powerlinkCycle_us	:= hw.io.in.nettime - this.axisTrig.nettimeLastCycle_us;
		ELSE
			this.axisTrig.powerlinkCycle_us	:= -2147483648-hw.io.in.nettime + 2147483647-this.axisTrig.nettimeLastCycle_us; // handle wrap around
		END_IF
		this.axisTrig.nettimeLastCycle_us	:= hw.io.in.nettime;
		
		hmi.in.recipe.showOnlyLastImage
		
		// -----------------------------------------------------------------------------------------------------------
		// Image trigger (camera and lights)
		// -----------------------------------------------------------------------------------------------------------
		hmi.in.recipe.cam.flashColor := STRING_TO_USINT(hmi.in.recipe.cam.flashColorStr);
		hw.camera.out.par.focus 			:= hmi.in.recipe.cam.focus;
		hw.camera.out.par.flashSegment	 	:= hmi.in.recipe.cam.flashSegment;
		hw.camera.out.par.flashColor 		:= hmi.in.recipe.cam.flashColor;
		hw.camera.out.par.exposureTime 		:= hmi.in.recipe.cam.exposureTime;
		hw.camera.out.par.chromaticLock 	:= hmi.in.recipe.cam.chromaticLock;
		hw.camera.out.par.gainLevel 		:= hmi.in.recipe.cam.gainLevel;

		//-------------------------------------------------------------------------
		
		// Copy recipe data (e.g. enable, maximal number of results, etc.)
		hw.VF.blob.out			:=hmi.in.recipe.BLOB;	
		hw.VF.codeReader.out	:= hmi.in.recipe.CR;
		hw.VF.matching.out		:=hmi.in.recipe.match;
		hw.VF.measurement.out	:=hmi.in.recipe.meassurement;
		hw.VF.ocr.out			:=hmi.in.recipe.OCR;
		hw.VF.pixelCnt.out		:=hmi.in.recipe.pxCnt;
		
		hmi.out.camera.processingTime:=hw.camera.in.status.cameraProcessingTime;
		
		CASE idx OF
			1:
				hmi.out.VF.processingTime := hw.VF.blob.in.common.functionProcessingTime;
				hmi.out.VF.numResults := hw.VF.blob.in.common.numResults;
			2:
				hmi.out.VF.processingTime := hw.VF.codeReader.in.common.functionProcessingTime;
				hmi.out.VF.numResults := hw.VF.codeReader.in.common.numResults;
			3:
				hmi.out.VF.processingTime := hw.VF.matching.in.common.functionProcessingTime;
				hmi.out.VF.numResults := hw.VF.matching.in.common.numResults;
			4:
				hmi.out.VF.processingTime := hw.VF.measurement.in.common.functionProcessingTime;
				hmi.out.VF.numResults := hw.VF.measurement.in.common.numResults;
			5:
				hmi.out.VF.processingTime := hw.VF.ocr.in.common.functionProcessingTime;
				hmi.out.VF.numResults := hw.VF.ocr.in.common.numResults;
			6:
				hmi.out.VF.processingTime := hw.VF.pixelCnt.in.common.functionProcessingTime;
				hmi.out.VF.numResults := hw.VF.pixelCnt.in.common.numResults;
		END_CASE;	
				
		//-------------------------------------------------------------------------
		
		this.ioTrigger(CLK := hw.io.in.commonTrigger OR hw.io.in.individualTrigger);
		// check if camera is ready for an image trigger and MappView have been updated
		IF this.brdkViBase_imgTrigger_0.ready AND NOT this.brdkViBase_imgTrigger_0.busy AND this.mappView.status = 0 THEN 
			
			
			// Hmi manual trigger
			IF hmi.in.cmd.trigger OR hmi.in.recipe.repetitiveTrigger THEN
				hmi.in.cmd.trigger 							:= FALSE;
				
				this.brdkViBase_imgTrigger_0.trigger 		:= TRUE;
				this.brdkViBase_imgTrigger_0.delayNettime 	:= hw.io.in.nettime + gAxis.status.powerlinkCycleTime * 12+10000; // Calc nettime close to currnet time
				this.currentTriggerNum := 1;
			// Axis trigger 
			ELSIF hmi.in.recipe.enableAxisTrigger AND 
					gAxis.status.triggerTimeDelta >= (commonHmi.in.recipe.visionPreTriggerCycles * this.axisTrig.powerlinkCycle_us) AND
					gAxis.status.triggerTimeDelta <= ((commonHmi.in.recipe.visionPreTriggerCycles + 1) * this.axisTrig.powerlinkCycle_us) THEN
				
				this.brdkViBase_imgTrigger_0.trigger := TRUE;
				this.brdkViBase_imgTrigger_0.delayNettime := gAxis.status.nettime + gAxis.status.triggerTimeDelta; // Use time calculated in Axis program
			ELSIF hmi.in.recipe.enableIoTrigger AND this.ioTrigger.Q THEN
				
				this.brdkViBase_imgTrigger_0.trigger := TRUE;
				this.brdkViBase_imgTrigger_0.delayNettime := gAxis.status.nettime + hmi.in.recipe.ioTriggerDelay ; // Use time calculated in Axis program
				
			ELSIF this.currentTriggerNum < hmi.in.recipe.numTrigger THEN
			
				this.brdkViBase_imgTrigger_0.trigger 		:= TRUE;
				this.brdkViBase_imgTrigger_0.delayNettime 	:= hw.io.in.nettime + gAxis.status.powerlinkCycleTime * 12+10000; // Calc nettime close to currnet time
		
				this.currentTriggerNum := 		this.currentTriggerNum +1;
			
			END_IF
		END_IF
		
		this.brdkViBase_imgTrigger_0.searchAcquisitonSettings := hmi.in.cmd.autoSearch;
		this.brdkViBase_imgTrigger_0.pCameraHw := ADR(hw.camera);
		this.brdkViBase_imgTrigger_0.numLights := NUM_LIGHTS;
		this.brdkViBase_imgTrigger_0.pLightHw := ADR(hw.lights);
		this.brdkViBase_imgTrigger_0.useCamColorForLight := hmi.in.recipe.useCamLedColorForLight;
		this.brdkViBase_imgTrigger_0.useCamExpTimeForLight := hmi.in.recipe.useCamExpTimeForLight;
		this.brdkViBase_imgTrigger_0.simulate.enable := DiagCpuIsSimulated();
		this.brdkViBase_imgTrigger_0.simulate.alwaysSimulateNonePresentLights := TRUE;
		this.brdkViBase_imgTrigger_0.simulate.imgProcessingDelay := T#300ms;
		this.brdkViBase_imgTrigger_0();
		
		// Manual Light trigger
		FOR i:=START_IDX TO NUM_LIGHTS BY 1 DO
			hmi.out.lights[i].plNodeNr := idx*16+UINT_TO_USINT(i-1);
			IF hmi.in.cmd.lights[i].flashTrigger THEN
				hw.lights[i].out.cmd.flashTrigger := TRUE;
				hw.lights[i].out.par.nettime := hw.io.in.nettime + gAxis.status.powerlinkCycleTime * commonHmi.in.recipe.visionPreTriggerCycles;
			END_IF
			
			IF 	hw.lights[i].out.cmd.flashTrigger AND hw.lights[i].out.par.nettime <= hw.io.in.nettime THEN
				hw.lights[i].out.cmd.flashTrigger := FALSE;
			END_IF
		END_FOR
		
		
		
		
		
		// -----------------------------------------------------------------------------------------------------------
		// New image ready and results
		// -----------------------------------------------------------------------------------------------------------		
		// New image (hight for one scan)
		IF this.brdkViBase_imgTrigger_0.newImage THEN
			
			this.mappView.updateImage := hmi.in.recipe.showAllImages OR this.currentTriggerNum = hmi.in.recipe.numTrigger; // Trigger an update of the image on hmi
			this.DTGetTime_0(enable := TRUE);
			
			processResultsAction; // Process results action

			
		END_IF
		
		
		
			
		
		
		// -----------------------------------------------------------------------------------------------------------
		// Selection of specific result
		// -----------------------------------------------------------------------------------------------------------	
		IF hmi.in.cmd.click THEN
			styleStringGeneration;	
			hmi.in.cmd.click := FALSE;

			//VF 
			brdkStrSubStr(ADR(tmpVF),ADR(hmi.in.cmd.elemId),1,1);
			//ID 
			brsstrcpy(ADR(tmpID),ADR(hmi.in.cmd.elemId)+2);
				
			hmi.in.cmd.intElemId := STRING_TO_USINT(tmpID);	
		END_IF
		
		IF hmi.in.cmd.intElemId <> this.oldIntElemID THEN
			this.oldIntElemID := hmi.in.cmd.intElemId;
			processResultsAction;
		END_IF
		
		// -----------------------------------------------------------------------------------------------------------
		// Auto search vision acquistion settings done (save found settings in recipe structure) 
		// -----------------------------------------------------------------------------------------------------------
		
		// search Auto Focus done (hight for one scan)
		IF this.brdkViBase_imgTrigger_0.searchAcquisitonSettingsDone THEN
			hmi.in.cmd.autoSearch 			:= FALSE;
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
			this.mappView.imageFormat := commonHmi.in.recipe.imageFormat;
		END_IF
		this.mappView.jpegQuality := commonHmi.in.recipe.jpegQuality;
		this.mappView();
		
		
		// -----------------------------------------------------------------------------------------------------------
		// Save image to file devive F:/images
		// -----------------------------------------------------------------------------------------------------------
		CASE this.saveState OF
			0:
				
				IF (hmi.in.cmd.saveImage OR (this.mappView.newSvgReady AND commonHmi.in.recipe.saveAllImages))  AND gFiles.output.ready THEN
					hmi.in.cmd.saveImage := FALSE;
					
					// create filename with VF name and current date of the image
					brsstrcpy(ADR(this.tmpFileName),ADR(hmi.out.camera.visionFunction));
					brsstrcat(ADR(this.tmpFileName),ADR('-'));
					brdkViBase_dateTimeToString(this.DTGetTime_0.DT1,'%Y-%m-%d-%H-%M-%S',ADR(this.tmpFileName));
					
					
					brsstrcpy(ADR(this.brdkFileWrite.fileName),ADR(this.tmpFileName));
					
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
					
					this.saveState := 10;
				END_IF
			10:
				
				IF this.brdkFileWrite.done THEN
					gFiles.input.refresh := TRUE;
					this.brdkFileWrite.enable := FALSE;
					this.saveState := 20;
				END_IF
			
			20:
				brsstrcpy(ADR(this.brdkFileWrite.fileName),ADR(this.tmpFileName));
					
				brsstrcat(ADR(this.brdkFileWrite.fileName),ADR('.svg'));
				this.brdkFileWrite.enable := TRUE;
				this.brdkFileWrite.dataLength := brsstrlen(ADR(hmi.out.svgOverlay));
				this.brdkFileWrite.pData := ADR(hmi.out.svgOverlay);
				this.brdkFileWrite.overwrite := TRUE;
				this.brdkFileWrite.fileDevice := 'IMG';
				
				this.saveState := 30;
			
			30:
				IF this.brdkFileWrite.done THEN
					gFiles.input.refresh := TRUE;
					this.brdkFileWrite.enable := FALSE;
					this.saveState := 0;
				END_IF
				
		END_CASE
		
				
		this.brdkFileWrite();
		
		

			
			
		// -----------------------------------------------------------------------------------------------------------
		// Save diagnostic data
		// -----------------------------------------------------------------------------------------------------------
		IF hmi.in.cmd.saveDiagnositc AND gFiles.output.ready THEN
			hmi.in.cmd.saveDiagnositc 			:= FALSE;

			// Delete old file first
			this.fileDelete.enable 					:= TRUE;
			this.fileDelete.pDevice 				:= ADR(this.visionDiagFileDevice);
			this.fileDelete.pName 					:= ADR(hmi.in.diagnosticFilename);
			
			// Upload diagnostic information
			this.viBaseSaveDiagData_0.MpLink 		:= this.mappView.pMappLink;
			this.viBaseSaveDiagData_0.DeviceName 	:= ADR(this.visionDiagFileDevice);
			this.viBaseSaveDiagData_0.FileName 		:= ADR(hmi.in.diagnosticFilename);
			hmi.out.camera.saveDiagStatus 			:= UINT_TO_DINT(ERR_FUB_BUSY);
		END_IF
		
		// file delete done or error (if file do not exsist)
		IF (this.fileDelete.enable AND this.fileDelete.status = ERR_OK) THEN
			this.fileDelete.enable 				:= FALSE;
			this.viBaseSaveDiagData_0.Execute 	:= TRUE;
		END_IF
		
		// Done	
		IF (this.viBaseSaveDiagData_0.Done) THEN
			hmi.out.camera.saveDiagStatus		:= UINT_TO_DINT(ERR_OK);
			this.viBaseSaveDiagData_0.Execute 	:= FALSE;
		END_IF		
	
		// Error
		IF (NOT this.viBaseSaveDiagData_0.Busy AND this.viBaseSaveDiagData_0.Error) THEN
			hmi.out.camera.saveDiagStatus		:= this.viBaseSaveDiagData_0.StatusID;
			this.viBaseSaveDiagData_0.Execute 	:= FALSE;
		END_IF
		
		this.viBaseSaveDiagData_0();
		this.fileDelete();
		
		
		// -----------------------------------------------------------------------------------------------------------
		// Get Vision application list from camera
		// -----------------------------------------------------------------------------------------------------------
		
		// trigger
		IF hmi.in.cmd.vaList.refresh THEN
			hmi.in.cmd.vaList.refresh 	:= FALSE;
			
			this.getVaList.Execute 		:= TRUE;
			this.getVaList.Format 		:= viBASE_FORMAT_PLAIN_TEXT;
			this.getVaList.List 		:= ADR(hmi.out.vaList.list);
			this.getVaList.ListLen 		:= SIZEOF(hmi.out.vaList.list);
			this.getVaList.MpLink 		:= this.mappView.pMappLink;
		END_IF
		
		// Done
		IF this.getVaList.Done THEN
			this.getVaList.Execute 		:= FALSE;
			hmi.out.vaList.length 		:= this.getVaList.NrEntries;
		END_IF
		
		// Error
		IF this.getVaList.Error THEN
			this.getVaList.Execute 		:= FALSE;
			hmi.out.vaList.lastError 	:= this.getVaList.StatusID;
		END_IF
		
		this.getVaList();
		
		// -----------------------------------------------------------------------------------------------------------
		// Load vision application
		// -----------------------------------------------------------------------------------------------------------
		
		// Trigger
		IF hmi.in.cmd.vaList.load AND brsstrlen(ADR(hmi.out.vaList.list[hmi.in.cmd.vaList.selectedIndex])) > 5 THEN
			hmi.in.cmd.vaList.load 						:= FALSE;
		
			this.viBaseLoadApplication_0.Execute 	:= TRUE;
			this.viBaseLoadApplication_0.MpLink		:= this.mappView.pMappLink;
			this.viBaseLoadApplication_0.Name		:= ADR(hmi.out.vaList.list[hmi.in.cmd.vaList.selectedIndex]);
			hmi.out.camera.vaLoad 					:= UINT_TO_DINT(ERR_FUB_BUSY);	
		ELSE
			hmi.in.cmd.vaList.load := FALSE;
		END_IF
		
		// Done
		IF (this.viBaseLoadApplication_0.Done) THEN
			hmi.in.cmd.vaList.selectedIndex := 0;
			this.viBaseLoadApplication_0.Execute 	:= FALSE;
			hmi.out.camera.vaLoad 					:= UINT_TO_DINT(ERR_OK);
		END_IF
		
		// Error
		IF (NOT this.viBaseLoadApplication_0.Busy AND this.viBaseLoadApplication_0.Error) THEN
			this.viBaseLoadApplication_0.Execute 	:= FALSE;
			hmi.out.camera.vaLoad 					:= this.viBaseLoadApplication_0.StatusID;
		END_IF
		
		this.viBaseLoadApplication_0();
		
		
		// -----------------------------------------------------------------------------------------------------------
		// HMI stuff
		// -----------------------------------------------------------------------------------------------------------
		hmiAction;	
		
		// -----------------------------------------------------------------------------------------------------------
		// Recipe handling (register recipse data structure
		// ----------------------------------------------------------------------------------------------------------- 
		this.mpRecipeRegVar.Enable 		:= gRecipe.out.active;
		this.mpRecipeRegVar.MpLink 		:= gRecipe.out.mpLink;
		this.mpRecipeRegVar.ConfirmSave := this.mpRecipeRegVar.SaveNotification;
		this.mpRecipeRegVar.Category 	:= ADR('Recipe');
		this.mpRecipeRegVar.PVName 		:= ADR(this.recipePVName);
		this.mpRecipeRegVar();
		
		
		this.user.mpRecipeRegVar.Enable 		:= gRecipe.out.active;
		this.user.mpRecipeRegVar.MpLink 	:= gRecipe.out.mpLink;
		this.user.mpRecipeRegVar.ConfirmSave := this.user.mpRecipeRegVar.SaveNotification;
		this.user.mpRecipeRegVar.Category 	:= ADR('Data');
		this.user.mpRecipeRegVar.PVName 	:= ADR(this.user.dataPvName);
		this.user.mpRecipeRegVar();
		
		
	END_FOR
	

	
	// -----------------------------------------------------------------------------------------------------------
	//Configure the pointers (this,hmi,hw etc.) show the correct data for that watch index 
	// -----------------------------------------------------------------------------------------------------------
	watchIdx := LIMIT(START_IDX,watchIdx,NUM_CAMS);
	idx := watchIdx;
	setupPointersAction;

	
END_PROGRAM
