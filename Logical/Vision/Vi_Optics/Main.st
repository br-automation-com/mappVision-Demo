PROGRAM _INIT

END_PROGRAM
PROGRAM _CYCLIC
	CASE ReadStep OF // Use AsIODiag library to search the ordnernumber of the selcted/plugged camera (eg. VSS112Q22.041P-000) to get the lens and sensor information
		0: // Wait
			IF cmdReadCameraInfo THEN
				cmdReadCameraInfo			:= FALSE;
				Index						:= 0;
				OrderNr						:= '';
				ReadStep := 1;
			END_IF
		1: // Create DiagInformation
			DiagCreateInfo_0.enable			:= TRUE;
			DiagCreateInfo_0.infoKind		:= asdiagPLUGGED;
			DiagCreateInfo_0();
			IF DiagCreateInfo_0.status = 0 THEN
				ReadStep := 2;
			ELSIF DiagCreateInfo_0.status <> ERR_FUB_BUSY THEN
				ReadStep := 90;
			END_IF
		2: // Read HW-ID and compare with selected camera
			DiagGetNumInfo_0.enable			:= TRUE;
			DiagGetNumInfo_0.ident			:= DiagCreateInfo_0.ident;
			DiagGetNumInfo_0.index			:= Index;
			DiagGetNumInfo_0.infoCode		:= asdiagPLUGGED_MODNO;
			DiagGetNumInfo_0();
			IF DiagGetNumInfo_0.status = 0 THEN
				IF DiagGetNumInfo_0.value = gVisionSensor[visSelectedSensor].HW.ID THEN
					ReadStep := 3;
				ELSE
					Index := Index + 1;
					IF Index >= DiagCreateInfo_0.nrEntries THEN
						ReadStep := 91;
					END_IF
				END_IF
			ELSIF DiagGetNumInfo_0.status <> ERR_FUB_BUSY THEN
				ReadStep					:= 92;
			END_IF
		3: // Read ordernumber
			DiagGetStrInfo_0.enable			:= TRUE;
			DiagGetStrInfo_0.ident			:= DiagCreateInfo_0.ident;
			DiagGetStrInfo_0.index			:= Index;
			DiagGetStrInfo_0.infoCode		:= asdiagPLUGGED_MODULE; // Ordnernumber of the plugged module (eg. VSS112Q22.041P-000)
			DiagGetStrInfo_0.pBuffer		:= ADR(OrderNr);
			DiagGetStrInfo_0.bufferLen		:= SIZEOF(OrderNr) - 1;
			DiagGetStrInfo_0();
			IF DiagGetStrInfo_0.status = 0 THEN
				ReadStep := 10;
			ELSIF DiagGetStrInfo_0.status <> ERR_FUB_BUSY THEN
				ReadStep := 93;
			END_IF
		10:
			DiagDisposeInfo_0.enable		:= TRUE;
			DiagDisposeInfo_0.ident			:= DiagCreateInfo_0.ident;
			DiagDisposeInfo_0();
			IF DiagDisposeInfo_0.status = 0 THEN
				ReadStep := 20;
			ELSIF DiagDisposeInfo_0.status <> ERR_FUB_BUSY THEN
				ReadStep := 94;
			END_IF
		20: // get the info to the actual camara, e.g. VSS112Q22.041P-000
			IF brsstrlen(ADR(OrderNr)) = 18 THEN
				pChar ACCESS ADR(OrderNr) + 8; // Letter for Sensor
				CASE pChar OF
					16#31:  Sensor := SENSOR_1_3_MP; // ASCII '1'
					16#32:  Sensor := SENSOR_1_3_MP; // ASCII '2'
					16#34:  Sensor := SENSOR_3_5_MP; // ASCII '4'
					16#35:  Sensor := SENSOR_5_3_MP; // ASCII '5'
				ELSE
					ReadStep := 95;
				END_CASE
				pChar ACCESS ADR(OrderNr) + 10; // first letter for optics (0 or M)
				CASE pChar OF
					16#30:  Lens := LENS_4_6; // ASCII '0'
					16#4D:  Lens := LENS_12_0_MACRO; // ASCII 'M'
				ELSE
					ReadStep := 96;
				END_CASE
				pChar ACCESS ADR(OrderNr) + 11; // second letter for optics
				CASE pChar OF
					16#30:  Lens := LENS_4_6; // ASCII '0' // no optics
					16#32:  Lens := LENS_4_6; // ASCII '2'
					16#33:  Lens := LENS_6_0; // ASCII '3'
					16#34:  Lens := LENS_8_0; // ASCII '4'
					16#35: // ASCII '5'
						IF Lens = LENS_12_0_MACRO THEN
							// do noting, already selected
						ELSE
							Lens := LENS_12_0;
						END_IF
					16#36:  Lens := LENS_16_0; // ASCII '6'
					16#37:  Lens := LENS_25_0; // ASCII '7'
				ELSE
					ReadStep := 97;
				END_CASE
				Distance_mm	:= UINT_TO_LREAL(gVisionSensor[visSelectedSensor].DAT.Focus) / 100.0;
				ReadStep := 0;
			ELSE
				ReadStep := 98;
			END_IF
		90..99: // auto reset errors
			ReadStep := 0;
	END_CASE

	CASE Sensor OF
		SENSOR_1_3_MP:
			PixelSize_um		:= 4.8;
			ResolutionX			:= 1280;
			ResolutionY			:= 1024;
		SENSOR_3_5_MP:
			PixelSize_um		:= 3.2;
			ResolutionX			:= 2112;
			ResolutionY			:= 1664;
		SENSOR_5_3_MP:
			PixelSize_um		:= 3.2;
			ResolutionX			:= 2592;
			ResolutionY			:= 2048;
	END_CASE
	CASE Lens OF
		LENS_4_6:
			FocalLength_mm		:= 4.6;
			MinObjectDist_mm	:= 25;
			MaxObjectDist_mm	:= 65550;
			Aperture			:= 3.5;
		LENS_6_0:
			FocalLength_mm		:= 6.0;
			MinObjectDist_mm	:= 50;
			MaxObjectDist_mm	:= 65550;
			Aperture			:= 3.5;
		LENS_8_0:
			FocalLength_mm		:= 8.0;
			MinObjectDist_mm	:= 50;
			MaxObjectDist_mm	:= 65500;
			Aperture			:= 3.5;
		LENS_12_0:
			FocalLength_mm		:= 12.0;
			MinObjectDist_mm	:= 75;
			MaxObjectDist_mm	:= 5000;
			Aperture			:= 4.0;
		LENS_16_0:
			FocalLength_mm		:= 16.0;
			MinObjectDist_mm	:= 100;
			MaxObjectDist_mm	:= 1500;
			Aperture			:= 4.0;
		LENS_25_0:
			FocalLength_mm		:= 25.0;
			MinObjectDist_mm	:= 250;
			MaxObjectDist_mm	:= 1500;
			Aperture			:= 4.0;
		LENS_12_0_MACRO:
			FocalLength_mm		:= 12.0;
			MinObjectDist_mm	:= 35;
			MaxObjectDist_mm	:= 65;
			Aperture			:= 4.0;
	END_CASE
	ValidDistance					:= Distance_mm >= MinObjectDist_mm AND Distance_mm <= MaxObjectDist_mm;
	IF ValidDistance THEN
		DistanceLens_mm				:= Distance_mm + DISTANCE_FRONTGLASS_LENS_MM; // The lens is 15mm behind the front glass
		IF Binning THEN
			PixelSizeBinning_um		:= PixelSize_um * 2;
		ELSE
			PixelSizeBinning_um		:= PixelSize_um * 1;
		END_IF
		CircleOfConfusion_mm		:= PixelSizeBinning_um * 1 * SQRT(2.0) / 1000.0;
		HyperFocalDistance_mm		:= (FocalLength_mm * FocalLength_mm) / (Aperture * CircleOfConfusion_mm ) + FocalLength_mm;
	    DepthOfFieldNearPos_mm		:= DistanceLens_mm * (HyperFocalDistance_mm - FocalLength_mm) / (HyperFocalDistance_mm + DistanceLens_mm - 2 * FocalLength_mm) - DISTANCE_FRONTGLASS_LENS_MM;
		IF DistanceLens_mm < HyperFocalDistance_mm THEN
			DepthOfFieldFarPos_mm	:= DistanceLens_mm * (HyperFocalDistance_mm - FocalLength_mm) / (HyperFocalDistance_mm - DistanceLens_mm) - DISTANCE_FRONTGLASS_LENS_MM;
			DepthOfField_mm			:= DepthOfFieldFarPos_mm - DepthOfFieldNearPos_mm;
		ELSE
			DepthOfFieldFarPos_mm	:= -1; // Means "infinite"
			DepthOfField_mm			:= -1; // Means "infinite"
		END_IF
		FieldOfView_X_mm			:= PixelSizeBinning_um / 1000 * ResolutionX *(DistanceLens_mm / FocalLength_mm - 1.0);
		FieldOfView_Y_mm			:= PixelSizeBinning_um / 1000 * ResolutionY *(DistanceLens_mm / FocalLength_mm - 1.0);
		Resolution_mmPerPx			:= FieldOfView_X_mm / ResolutionX;
	ELSE
		DistanceLens_mm				:= 0;
		PixelSizeBinning_um			:= 0;
		CircleOfConfusion_mm		:= 0;
		HyperFocalDistance_mm		:= 0;
	    DepthOfFieldNearPos_mm		:= 0;
		DepthOfFieldFarPos_mm		:= 0;
		DepthOfField_mm				:= 0;
		FieldOfView_X_mm			:= 0;
		FieldOfView_Y_mm			:= 0;
		Resolution_mmPerPx			:= 0;
	END_IF
END_PROGRAM