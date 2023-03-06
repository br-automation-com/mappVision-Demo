
ACTION hmiAction: 

	IF DiagCpuIsSimulated() OR (NOT hw.camera.in.common.moduleOk AND this.brdkViBase_imgTrigger_0.simulate.alwaysSimulateNonePresentCamera) THEN
		hmi.out.camera.connected :=  TRUE;
		hmi.out.camera.simulated := TRUE;
	ELSE
		
		hmi.out.camera.simulated := FALSE;
		IF hw.camera.in.common.moduleOk THEN
			hmi.out.camera.connected :=  TRUE;
		ELSE
			hmi.out.camera.connected :=  FALSE;
		END_IF	
	END_IF
	hmi.out.camera.processing := hw.camera.in.status.imageProcessingActive;
	hmi.out.camera.ready := this.brdkViBase_imgTrigger_0.ready AND NOT hmi.in.cmd.repetitiveTrigger;
	
	brsmemcpy(ADR(hmi.out.camera.hw),ADR(hw.camera.in.status),SIZEOF(hmi.out.camera.hw));
	brsmemcpy(ADR(hmi.out.camera.common),ADR(hw.camera.in.common),SIZEOF(hmi.out.camera.common));
	
	//OCR result data conversion from USINT structure into one STRING
	
	FOR idx:=START_IDX TO NUM_CAMS DO
		
		//Conversion of individual USINT values into strings
		FOR j:=0 TO SIZEOF(hwInstance[idx].VF.ocr.in.common.numResults)-1 DO
			FOR k:=0 TO hwInstance[idx].VF.ocr.in.results[j].data[k] DO
	  			hmiInstance[idx].out.VF.ocrData[k] := USINT_TO_STRING(hwInstance[idx].VF.ocr.in.results[j].data[k]);
			END_FOR;
		END_FOR;
		
		//Concatenation of individual strings
		FOR k:=0 TO SIZEOF(hwInstance[idx].VF.ocr.in.results[j].data[k])-1 DO
			brsstrcat(ADR(hmiInstance[idx].out.VF.ocrDataResult), ADR(hmiInstance[i].out.VF.ocrData[k]));
		END_FOR;	  

	END_FOR;

	
END_ACTION
