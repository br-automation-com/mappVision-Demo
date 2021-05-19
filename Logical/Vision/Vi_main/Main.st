// --------------------------------------------------------------------------------------------------------------------
// General vision task. This is a support task for the mappVision. The following functions are implemneted
// - Translate some values in text messages
// - Reset camera trigger when inspection is finsihed
// - Load vision application
// - Save diagnostic data
// Version 2.x (Check revision history for details)
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT

END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC
	// -----------------------------------------------------------------------------------------------------------
	// Translate camera status in readable text
	// -----------------------------------------------------------------------------------------------------------
	IF gVisionSensor[idSensor].DAT.Status = 0 THEN // Display only a single 0
		gVisionSensor[idSensor].DAT.StatusText := 'Ready';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000001 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Image acquisition';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000002 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Waiting trigger';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000010 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Searching settings';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000080 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Setting focus';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000090 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Searching settings';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00000800 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Cam CPU not ready';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#00001000 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Cam sensor not ready';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#01000000 OR gVisionSensor[idSensor].DAT.Status = 16#02000000 OR gVisionSensor[idSensor].DAT.Status = 16#03000000 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'OS check/update';
	ELSIF gVisionSensor[idSensor].DAT.Status = 16#80000000 THEN
		gVisionSensor[idSensor].DAT.StatusText := 'Vision cockpit active';
	ELSE 
		// Display the status in hex format 0x02000800
		gVisionSensor[idSensor].DAT.StatusText := '';
		FOR i := 0 TO 28 BY 4 DO
			gVisionSensor[idSensor].DAT.StatusText := CONCAT(MID(HexTab, 1, LIMIT(1, UDINT_TO_INT((SHR(gVisionSensor[idSensor].DAT.Status, i) AND 16#0000000F) + 1), 16)), gVisionSensor[idSensor].DAT.StatusText);
		END_FOR
		gVisionSensor[idSensor].DAT.StatusText := CONCAT('0x', gVisionSensor[idSensor].DAT.StatusText);
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Check if vision cockpit is open
	// -----------------------------------------------------------------------------------------------------------
	gVisionSensor[idSensor].DAT.CockpitIsActive := (gVisionSensor[idSensor].DAT.Status AND 16#8000_0000) > 0;
		
	// -----------------------------------------------------------------------------------------------------------
	// Auto setup handling
	// -----------------------------------------------------------------------------------------------------------
	IF(gVisionSensor[idSensor].CMD.AutoSetupStartStop AND gVisionSensor[idSensor].DAT.Status <> 0) THEN
		AutoSetupRunning[idSensor] := TRUE;
	ELSIF NOT gVisionSensor[idSensor].CMD.AutoSetupStartStop THEN
		AutoSetupRunning[idSensor] := FALSE;
	END_IF
	IF(gVisionSensor[idSensor].CMD.AutoSetupStartStop AND gVisionSensor[idSensor].DAT.Status = 0 AND AutoSetupRunning[idSensor]) THEN // Setup successfully finished
		gVisionSensor[idSensor].DAT.Gain					:= gVisionSensor[idSensor].DAT.AutoSetupGain;
		gVisionSensor[idSensor].DAT.Focus				:= gVisionSensor[idSensor].DAT.AutoSetupFocus;
		gVisionSensor[idSensor].DAT.Exposure				:= gVisionSensor[idSensor].DAT.AutoSetupExposure;
		gVisionSensor[idSensor].CMD.AutoSetupStartStop	:= FALSE;
		AutoSetupRunning[idSensor]						:= FALSE;
		TON_DelayAfterAutoSetup[idSensor].IN					:= TRUE;
	END_IF
	TON_DelayAfterAutoSetup[idSensor](PT := T#50ms);
	IF TON_DelayAfterAutoSetup[idSensor].Q THEN // After the camera tells it is ready, we need to wait still at least ca 20ms, otherwise it does not accept the trigger
		TON_DelayAfterAutoSetup[idSensor].IN := FALSE;
		IF gVisionSensor[idSensor].HW.Ready AND NOT gVisionSensor[idSensor].DAT.ImageProcessingActive THEN
			IF NETTIME_ENABLE THEN
				gVisionSensor[idSensor].DAT.NettimeDelay := NettimeCurrent_us + NETTIME_DEFAULT_DELAY;
			END_IF
			gVisionSensor[idSensor].CMD.ImageTrigger	:= TRUE;
			gVisionSensor[idSensor].DAT.Active			:= TRUE;
		END_IF
	END_IF
		
	// -----------------------------------------------------------------------------------------------------------
	// Reset image trigger, reload web page and store image when process is finished
	// -----------------------------------------------------------------------------------------------------------
	IF ((gVisionSensor[idSensor].DAT.AcquisitionCompletedCnt <> AcquisitionCompletedCntOld[idSensor] OR gVisionSensor[idSensor].DAT.AcquisitionFailedCnt <> AcquisitionFailedCntOld[idSensor]) AND NOT gVisionSensor[idSensor].DAT.ImageProcessingActive AND gVisionSensor[idSensor].HW.Ready) THEN
		AcquisitionCompletedCntOld[idSensor]		:= gVisionSensor[idSensor].DAT.AcquisitionCompletedCnt;
		AcquisitionFailedCntOld[idSensor]			:= gVisionSensor[idSensor].DAT.AcquisitionFailedCnt;
		gVisionSensor[idSensor].CMD.ImageTrigger	:= FALSE;
		gVisionSensor[idSensor].DAT.Active			:= FALSE;
	END_IF

	// -----------------------------------------------------------------------------------------------------------
	// Reset trigger when timed out
	// -----------------------------------------------------------------------------------------------------------
	IF gVisionSensor[idSensor].CMD.ImageTrigger THEN
		TriggerTimeoutSensor[idSensor].IN := TRUE;
		TriggerTimeoutSensor[idSensor].PT := REAL_TO_TIME(gVisionSensor[idSensor].DAT.Timeout * 1.25);
		IF TriggerTimeoutSensor[idSensor].Q THEN
			gVisionSensor[idSensor].CMD.ImageTrigger			:= FALSE;
			gVisionSensor[idSensor].CMD.ImageTriggerReset	:= TRUE;
			gVisionSensor[idSensor].DAT.Active				:= FALSE;
		END_IF
	ELSE
		TriggerTimeoutSensor[idSensor].IN := FALSE;
		gVisionSensor[idSensor].CMD.ImageTriggerReset := FALSE;
	END_IF
	TriggerTimeoutSensor[idSensor]();

	// -----------------------------------------------------------------------------------------------------------
	// Load vision application
	// -----------------------------------------------------------------------------------------------------------
	IF (gVisionSensor[idSensor].CMD.VaSwitchApplication) THEN
		ViBaseLoadApplication_01.MpLink	:= ADR(gVisionSensor[idSensor].CFG.ComponentLink);
		ViBaseLoadApplication_01.Name	:= ADR(gVisionSensor[idSensor].FCT.ApplicationName);
		gVisionSensor[idSensor].FCT.Status := ERR_FUB_BUSY;
		
		// -----------------------------------------------------------------------------------------------------------
		// OK
		IF (ViBaseLoadApplication_01.Done) THEN
			gVisionSensor[idSensor].FCT.Status := ERR_OK;
			gVisionSensor[idSensor].CMD.VaSwitchApplication := FALSE;
			// -----------------------------------------------------------------------------------------------------------
			// Error
		ELSIF (NOT ViBaseLoadApplication_01.Busy AND ViBaseLoadApplication_01.Error) THEN
			gVisionSensor[idSensor].FCT.Status := ViBaseLoadApplication_01.StatusID;
			gVisionSensor[idSensor].CMD.VaSwitchApplication := FALSE;
		END_IF		
	END_IF
	ViBaseLoadApplication_01.Execute := gVisionSensor[idSensor].CMD.VaSwitchApplication;
	ViBaseLoadApplication_01();
	// Dont proceed until loading is finished
	IF (gVisionSensor[idSensor].CMD.VaSwitchApplication) THEN
		RETURN;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Save diagnostic data
	// -----------------------------------------------------------------------------------------------------------
	IF (gVisionSensor[idSensor].CMD.SaveDiagData) THEN
		// Delete old file first
		FDelete.enable := gVisionSensor[idSensor].CMD.SaveDiagData AND NOT ViBaseSaveDiagData_01.Execute;
		FDelete.pDevice := ADR(DEVICE_NAME);
		FDelete.pName := ADR(gVisionSensor[idSensor].DIA.DiagName);
		IF (FDelete.status <> ERR_FUB_BUSY) THEN
			ViBaseSaveDiagData_01.Execute := TRUE;
		END_IF
		// Upload diagnostic information
		ViBaseSaveDiagData_01.MpLink := ADR(gVisionSensor[idSensor].CFG.ComponentLink);
		ViBaseSaveDiagData_01.DeviceName := ADR(DEVICE_NAME);
		ViBaseSaveDiagData_01.FileName := ADR(gVisionSensor[idSensor].DIA.DiagName);
		gVisionSensor[idSensor].DIA.Status := ERR_FUB_BUSY;
		
		// -----------------------------------------------------------------------------------------------------------
		// OK
		IF (ViBaseSaveDiagData_01.Done) THEN
			gVisionSensor[idSensor].DIA.Status := ERR_OK;
			ViBaseSaveDiagData_01.Execute := FALSE;
			gVisionSensor[idSensor].CMD.SaveDiagData := FALSE;
			// -----------------------------------------------------------------------------------------------------------
			// Error
		ELSIF (NOT ViBaseSaveDiagData_01.Busy AND ViBaseSaveDiagData_01.Error) THEN
			gVisionSensor[idSensor].DIA.Status := ViBaseSaveDiagData_01.StatusID;
			ViBaseSaveDiagData_01.Execute := FALSE;
			gVisionSensor[idSensor].CMD.SaveDiagData := FALSE;
		END_IF
	END_IF
	ViBaseSaveDiagData_01();
	FDelete();
	// Dont proceed until loading is finished
	IF (gVisionSensor[idSensor].CMD.SaveDiagData) THEN
		RETURN;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Read camera info
	// -----------------------------------------------------------------------------------------------------------
	CASE OpticsReadStep[idSensor] OF 
		// -----------------------------------------------------------------------------------------------------------
		// Wait
		0: 
			IF gVisionSensor[idSensor].CMD.ReadCameraInfo THEN
				gVisionSensor[idSensor].OPT.OrderNr	:= '';
				Index := 0;
				OpticsReadStep[idSensor]	:= 1;
			END_IF
			// -----------------------------------------------------------------------------------------------------------
			// Create DiagInformation
		1: 
			DiagCreateInfo_0.enable			:= TRUE;
			DiagCreateInfo_0.infoKind		:= asdiagPLUGGED;
			DiagCreateInfo_0();
			IF DiagCreateInfo_0.status = 0 THEN
				OpticsReadStep[idSensor] := 2;
			ELSIF DiagCreateInfo_0.status <> ERR_FUB_BUSY THEN
				OpticsReadStep[idSensor] := 90;
			END_IF
			// -----------------------------------------------------------------------------------------------------------
			// Read HW-ID and compare with selected camera
		2: 
			DiagGetNumInfo_0.enable			:= TRUE;
			DiagGetNumInfo_0.ident			:= DiagCreateInfo_0.ident;
			DiagGetNumInfo_0.index			:= Index;
			DiagGetNumInfo_0.infoCode		:= asdiagPLUGGED_MODNO;
			DiagGetNumInfo_0();
			IF DiagGetNumInfo_0.status = 0 THEN
				IF DiagGetNumInfo_0.value = gVisionSensor[visSelectedSensor].HW.ID THEN
					OpticsReadStep[idSensor] := 3;
				ELSE
					Index := Index + 1;
					IF Index >= DiagCreateInfo_0.nrEntries THEN
						OpticsReadStep[idSensor] := 91;
					END_IF
				END_IF
			ELSIF DiagGetNumInfo_0.status <> ERR_FUB_BUSY THEN
				OpticsReadStep[idSensor] := 92;
			END_IF
			// -----------------------------------------------------------------------------------------------------------
			// Read ordernumber
		3: 
			DiagGetStrInfo_0.enable			:= TRUE;
			DiagGetStrInfo_0.ident			:= DiagCreateInfo_0.ident;
			DiagGetStrInfo_0.index			:= Index;
			DiagGetStrInfo_0.infoCode		:= asdiagPLUGGED_MODULE;
			DiagGetStrInfo_0.pBuffer		:= ADR(gVisionSensor[idSensor].OPT.OrderNr);
			DiagGetStrInfo_0.bufferLen		:= SIZEOF(gVisionSensor[idSensor].OPT.OrderNr) - 1;
			DiagGetStrInfo_0();
			IF DiagGetStrInfo_0.status = 0 THEN
				OpticsReadStep[idSensor] := 10;
			ELSIF DiagGetStrInfo_0.status <> ERR_FUB_BUSY THEN
				OpticsReadStep[idSensor] := 93;
			END_IF
			// -----------------------------------------------------------------------------------------------------------
			// Release info function block
		10:
			DiagDisposeInfo_0.enable		:= TRUE;
			DiagDisposeInfo_0.ident			:= DiagCreateInfo_0.ident;
			DiagDisposeInfo_0();
			IF DiagDisposeInfo_0.status = 0 THEN
				OpticsReadStep[idSensor] := 20;
			ELSIF DiagDisposeInfo_0.status <> ERR_FUB_BUSY THEN
				OpticsReadStep[idSensor] := 94;
			END_IF
			// -----------------------------------------------------------------------------------------------------------
			// Get the info to the actual camara
		20: 
			IF brsstrlen(ADR(gVisionSensor[idSensor].OPT.OrderNr)) = 18 THEN
				pChar ACCESS ADR(gVisionSensor[idSensor].OPT.OrderNr) + 8; 	// Letter for Sensor
				CASE pChar OF
					16#31:  gVisionSensor[idSensor].OPT.Sensor := SENSOR_1_3_MP; // ASCII '1'
					16#32:  gVisionSensor[idSensor].OPT.Sensor := SENSOR_1_3_MP; // ASCII '2'
					16#34:  gVisionSensor[idSensor].OPT.Sensor := SENSOR_3_5_MP; // ASCII '4'
					16#35:  gVisionSensor[idSensor].OPT.Sensor := SENSOR_5_3_MP; // ASCII '5'
					ELSE
						OpticsReadStep[idSensor] := 95;
				END_CASE
				pChar ACCESS ADR(gVisionSensor[idSensor].OPT.OrderNr) + 10; // first letter for optics (0 or M)
				CASE pChar OF
					16#30:  gVisionSensor[idSensor].OPT.Lens := LENS_4_6; // ASCII '0'
					16#4D:  gVisionSensor[idSensor].OPT.Lens := LENS_12_0_MACRO; // ASCII 'M'
					ELSE
						OpticsReadStep[idSensor] := 96;
				END_CASE
				pChar ACCESS ADR(gVisionSensor[idSensor].OPT.OrderNr) + 11; // second letter for optics
				CASE pChar OF
					16#30:  gVisionSensor[idSensor].OPT.Lens := LENS_4_6; // ASCII '0' // no optics
					16#32:  gVisionSensor[idSensor].OPT.Lens := LENS_4_6; // ASCII '2'
					16#33:  gVisionSensor[idSensor].OPT.Lens := LENS_6_0; // ASCII '3'
					16#34:  gVisionSensor[idSensor].OPT.Lens := LENS_8_0; // ASCII '4'
					16#35: // ASCII '5'
					IF gVisionSensor[idSensor].OPT.Lens = LENS_12_0_MACRO THEN
						// do noting, already selected
					ELSE
						gVisionSensor[idSensor].OPT.Lens := LENS_12_0;
					END_IF
					16#36:  gVisionSensor[idSensor].OPT.Lens := LENS_16_0; // ASCII '6'
					16#37:  gVisionSensor[idSensor].OPT.Lens := LENS_25_0; // ASCII '7'
					ELSE
						OpticsReadStep[idSensor] := 97;
				END_CASE
				gVisionSensor[idSensor].OPT.Distance_mm := gVisionSensor[idSensor].DAT.Focus/100;
				gVisionSensor[idSensor].CMD.ReadCameraInfo := FALSE;
				OpticsReadStep[idSensor] := 0;
			ELSE
				OpticsReadStep[idSensor] := 98;
			END_IF
		90..99: // auto reset errors
			gVisionSensor[idSensor].CMD.ReadCameraInfo := FALSE;
			OpticsReadStep[idSensor] := 0;
	END_CASE

	// -----------------------------------------------------------------------------------------------------------
	// Set sensor parameter
	CASE gVisionSensor[idSensor].OPT.Sensor OF
		SENSOR_1_3_MP:
			gVisionSensor[idSensor].OPT.PixelSize_um		:= 4.8;
			gVisionSensor[idSensor].OPT.ResolutionX			:= 1280;
			gVisionSensor[idSensor].OPT.ResolutionY			:= 1024;
		SENSOR_3_5_MP:
			gVisionSensor[idSensor].OPT.PixelSize_um		:= 3.2;
			gVisionSensor[idSensor].OPT.ResolutionX			:= 2112;
			gVisionSensor[idSensor].OPT.ResolutionY			:= 1664;
		SENSOR_5_3_MP:
			gVisionSensor[idSensor].OPT.PixelSize_um		:= 3.2;
			gVisionSensor[idSensor].OPT.ResolutionX			:= 2592;
			gVisionSensor[idSensor].OPT.ResolutionY			:= 2048;
	END_CASE
	
	// -----------------------------------------------------------------------------------------------------------
	// Set lens parameter
	CASE gVisionSensor[idSensor].OPT.Lens OF
		LENS_4_6:
			gVisionSensor[idSensor].OPT.FocalLength_mm		:= 4.6;
			gVisionSensor[idSensor].OPT.MinObjectDist_mm	:= 25;
			gVisionSensor[idSensor].OPT.MaxObjectDist_mm	:= 65550;
			gVisionSensor[idSensor].OPT.Aperture			:= 3.5;
		LENS_6_0:
			gVisionSensor[idSensor].OPT.FocalLength_mm		:= 6.0;
			gVisionSensor[idSensor].OPT.MinObjectDist_mm	:= 50;
			gVisionSensor[idSensor].OPT.MaxObjectDist_mm	:= 65550;
			gVisionSensor[idSensor].OPT.Aperture			:= 3.5;
		LENS_8_0:
			gVisionSensor[idSensor].OPT.FocalLength_mm		:= 8.0;
			gVisionSensor[idSensor].OPT.MinObjectDist_mm	:= 50;
			gVisionSensor[idSensor].OPT.MaxObjectDist_mm	:= 65500;
			gVisionSensor[idSensor].OPT.Aperture			:= 3.5;
		LENS_12_0:
			gVisionSensor[idSensor].OPT.FocalLength_mm		:= 12.0;
			gVisionSensor[idSensor].OPT.MinObjectDist_mm	:= 75;
			gVisionSensor[idSensor].OPT.MaxObjectDist_mm	:= 5000;
			gVisionSensor[idSensor].OPT.Aperture			:= 4.0;
		LENS_16_0:
			gVisionSensor[idSensor].OPT.FocalLength_mm		:= 16.0;
			gVisionSensor[idSensor].OPT.MinObjectDist_mm	:= 100;
			gVisionSensor[idSensor].OPT.MaxObjectDist_mm	:= 1500;
			gVisionSensor[idSensor].OPT.Aperture			:= 4.0;
		LENS_25_0:
			gVisionSensor[idSensor].OPT.FocalLength_mm		:= 25.0;
			gVisionSensor[idSensor].OPT.MinObjectDist_mm	:= 250;
			gVisionSensor[idSensor].OPT.MaxObjectDist_mm	:= 1500;
			gVisionSensor[idSensor].OPT.Aperture			:= 4.0;
		LENS_12_0_MACRO:
			gVisionSensor[idSensor].OPT.FocalLength_mm		:= 12.0;
			gVisionSensor[idSensor].OPT.MinObjectDist_mm	:= 35;
			gVisionSensor[idSensor].OPT.MaxObjectDist_mm	:= 65;
			gVisionSensor[idSensor].OPT.Aperture			:= 4.0;
	END_CASE
	gVisionSensor[idSensor].OPT.ValidDistance := gVisionSensor[idSensor].OPT.Distance_mm >= gVisionSensor[idSensor].OPT.MinObjectDist_mm AND gVisionSensor[idSensor].OPT.Distance_mm <= gVisionSensor[idSensor].OPT.MaxObjectDist_mm;
	IF gVisionSensor[idSensor].OPT.ValidDistance THEN
		gVisionSensor[idSensor].OPT.DistanceLens_mm				:= gVisionSensor[idSensor].OPT.Distance_mm + DISTANCE_FRONTGLASS_LENS_MM; // The lens is 15mm behind the front glass
		IF gVisionSensor[idSensor].OPT.Binning THEN
			gVisionSensor[idSensor].OPT.PixelSizeBinning_um		:= gVisionSensor[idSensor].OPT.PixelSize_um * 2;
		ELSE
			gVisionSensor[idSensor].OPT.PixelSizeBinning_um		:= gVisionSensor[idSensor].OPT.PixelSize_um * 1;
		END_IF
		gVisionSensor[idSensor].OPT.CircleOfConfusion_mm		:= gVisionSensor[idSensor].OPT.PixelSizeBinning_um * 1 * SQRT(2.0) / 1000.0;
		gVisionSensor[idSensor].OPT.HyperFocalDistance_mm		:= (gVisionSensor[idSensor].OPT.FocalLength_mm * gVisionSensor[idSensor].OPT.FocalLength_mm) / (gVisionSensor[idSensor].OPT.Aperture * gVisionSensor[idSensor].OPT.CircleOfConfusion_mm) + gVisionSensor[idSensor].OPT.FocalLength_mm;
		gVisionSensor[idSensor].OPT.DepthOfFieldNearPos_mm		:= gVisionSensor[idSensor].OPT.DistanceLens_mm * (gVisionSensor[idSensor].OPT.HyperFocalDistance_mm - gVisionSensor[idSensor].OPT.FocalLength_mm) / (gVisionSensor[idSensor].OPT.HyperFocalDistance_mm + gVisionSensor[idSensor].OPT.DistanceLens_mm - 2 * gVisionSensor[idSensor].OPT.FocalLength_mm) - DISTANCE_FRONTGLASS_LENS_MM;
		IF gVisionSensor[idSensor].OPT.DistanceLens_mm < gVisionSensor[idSensor].OPT.HyperFocalDistance_mm THEN
			gVisionSensor[idSensor].OPT.DepthOfFieldFarPos_mm	:= gVisionSensor[idSensor].OPT.DistanceLens_mm * (gVisionSensor[idSensor].OPT.HyperFocalDistance_mm - gVisionSensor[idSensor].OPT.FocalLength_mm) / (gVisionSensor[idSensor].OPT.HyperFocalDistance_mm - gVisionSensor[idSensor].OPT.DistanceLens_mm) - DISTANCE_FRONTGLASS_LENS_MM;
			gVisionSensor[idSensor].OPT.DepthOfField_mm			:= gVisionSensor[idSensor].OPT.DepthOfFieldFarPos_mm - gVisionSensor[idSensor].OPT.DepthOfFieldNearPos_mm;
		ELSE
			gVisionSensor[idSensor].OPT.DepthOfFieldFarPos_mm	:= -1; // Means "infinite"
			gVisionSensor[idSensor].OPT.DepthOfField_mm			:= -1; // Means "infinite"
		END_IF
		gVisionSensor[idSensor].OPT.FieldOfView_X_mm			:= gVisionSensor[idSensor].OPT.PixelSizeBinning_um / 1000 * gVisionSensor[idSensor].OPT.ResolutionX *(gVisionSensor[idSensor].OPT.DistanceLens_mm / gVisionSensor[idSensor].OPT.FocalLength_mm - 1.0);
		gVisionSensor[idSensor].OPT.FieldOfView_Y_mm			:= gVisionSensor[idSensor].OPT.PixelSizeBinning_um / 1000 * gVisionSensor[idSensor].OPT.ResolutionY *(gVisionSensor[idSensor].OPT.DistanceLens_mm / gVisionSensor[idSensor].OPT.FocalLength_mm - 1.0);
		gVisionSensor[idSensor].OPT.Resolution_mmPerPx			:= gVisionSensor[idSensor].OPT.FieldOfView_X_mm / gVisionSensor[idSensor].OPT.ResolutionX;
	ELSE
		gVisionSensor[idSensor].OPT.PixelSizeBinning_um	:= 0;
		gVisionSensor[idSensor].OPT.DistanceLens_mm				:= 0;
		gVisionSensor[idSensor].OPT.CircleOfConfusion_mm		:= 0;
		gVisionSensor[idSensor].OPT.HyperFocalDistance_mm		:= 0;
		gVisionSensor[idSensor].OPT.DepthOfFieldNearPos_mm		:= 0;
		gVisionSensor[idSensor].OPT.DepthOfFieldFarPos_mm		:= 0;
		gVisionSensor[idSensor].OPT.DepthOfField_mm				:= 0;
		gVisionSensor[idSensor].OPT.FieldOfView_X_mm			:= 0;
		gVisionSensor[idSensor].OPT.FieldOfView_Y_mm			:= 0;
		gVisionSensor[idSensor].OPT.Resolution_mmPerPx			:= 0;
	END_IF
	
	// Proceed with next sensor
	idSensor := idSensor + 1;
	IF (idSensor > MAX_NUM_CAMS) THEN
		idSensor := 1;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Reset Light trigger
	// -----------------------------------------------------------------------------------------------------------
	IF (gVisionLight[idLight].DAT.FlashCompletedCnt <> FlashCompletedCntOld[idLight] OR gVisionLight[idLight].DAT.FlashFailedCnt <> FlashFailedCntOld[idLight]) THEN
		FlashCompletedCntOld[idLight]			:= gVisionLight[idLight].DAT.FlashCompletedCnt;
		FlashFailedCntOld[idLight]				:= gVisionLight[idLight].DAT.FlashFailedCnt;
		gVisionLight[idLight].CMD.FlashTrigger	:= FALSE;
	END_IF
		
	// -----------------------------------------------------------------------------------------------------------
	// Reset trigger when timed out
	// -----------------------------------------------------------------------------------------------------------
	IF gVisionLight[idLight].CMD.FlashTrigger THEN
		TriggerTimeoutLight[idLight].IN := TRUE;
		TriggerTimeoutLight[idLight].PT := REAL_TO_TIME(gVisionLight[idLight].DAT.Timeout * 1.25);
		IF TriggerTimeoutLight[idLight].Q THEN
			gVisionLight[idLight].CMD.FlashTrigger		:= FALSE;
			gVisionLight[idLight].CMD.FlashTriggerReset	:= TRUE;
		END_IF
	ELSE
		TriggerTimeoutLight[idLight].IN := FALSE;
		gVisionLight[idLight].CMD.FlashTriggerReset := FALSE;
	END_IF
	TriggerTimeoutLight[idLight]();

	// Proceed with next light
	idLight := idLight + 1;
	IF (idLight > MAX_NUM_LIGHTS) THEN
		idLight := 1;
	END_IF
	

END_PROGRAM
