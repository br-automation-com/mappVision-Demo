	
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
	
	
	
	IF this.mpRecipeRegVar.UpdateNotification THEN
		
		hmi.in.cmd.flashSegment.top := hmi.in.recipe.cam.flashSegment.0;
		hmi.in.recipe.cam.flashSegment.1;
		hmi.in.cmd.flashSegment.left := 	hmi.in.recipe.cam.flashSegment.2;
		hmi.in.cmd.flashSegment.right := 	hmi.in.recipe.cam.flashSegment.3;
	
	ELSE
		hmi.in.recipe.cam.flashSegment.0 := hmi.in.cmd.flashSegment.top;
		hmi.in.recipe.cam.flashSegment.1 := hmi.in.cmd.flashSegment.bottom;
		hmi.in.recipe.cam.flashSegment.2 := hmi.in.cmd.flashSegment.left;
		hmi.in.recipe.cam.flashSegment.3 := hmi.in.cmd.flashSegment.right;
	END_IF
	
	FOR i:=START_IDX TO NUM_LIGHTS DO
		hmi.out.lights[i].common:=hw.lights[i].in.common;
		hmi.out.lights[i].status:=hw.lights[i].in.status;
		hw.lights[i].out.par.flashAngle:=hmi.in.recipe.lights[i].flashAngle;
		hw.lights[i].out.par.nettime:=this.brdkViBase_imgTrigger_0.delayNettime;
		
		IF hmi.in.recipe.useCamLedColorForLight THEN
			hw.lights[i].out.par.flashColor:=hmi.in.recipe.cam.flashColor;
		ELSE	
			hw.lights[i].out.par.flashColor:=hmi.in.recipe.lights[i].flashColor;
		END_IF;
		
		IF hmi.in.recipe.useCamExpTimeForLight THEN
			hw.lights[i].out.par.exposureTime:=hmi.in.recipe.cam.exposureTime;
		ELSE	
			hw.lights[i].out.par.exposureTime:=hmi.in.recipe.lights[i].exposureTime;
		END_IF;
		
		
	END_FOR; 
	
	IF hmi.in.cmd.intElemId > 0 THEN
		
		IF hmi.in.cmd.intElemId <= hw.VF.blob.in.common.numResults THEN
			brdkViBase_blob_hw2hmi(hw.VF.blob.in.results[hmi.in.cmd.intElemId-1],hmi.out.VF.blob);
		END_IF
		
		IF hmi.in.cmd.intElemId <= hw.VF.codeReader.in.common.numResults THEN
			brdkViBase_cr_hw2hmi(hw.VF.codeReader.in.results[hmi.in.cmd.intElemId-1],hmi.out.VF.codeReader);
		END_IF
		
		IF hmi.in.cmd.intElemId <= hw.VF.matching.in.common.numResults THEN
			brdkViBase_match_hw2hmi(hw.VF.matching.in.results[hmi.in.cmd.intElemId-1],hmi.out.VF.match);
		END_IF
		
		IF hmi.in.cmd.intElemId <= hw.VF.measurement.in.common.numResults THEN
			brdkViBase_meas_hw2hmi(hw.VF.measurement.in.results[hmi.in.cmd.intElemId-1],hmi.out.VF.measurement);
		END_IF
		
		IF hmi.in.cmd.intElemId <= hw.VF.ocr.in.common.numResults THEN
			brdkViBase_ocr_hw2hmi(hw.VF.ocr.in.results[hmi.in.cmd.intElemId-1],hmi.out.VF.ocr);
		END_IF
			
		IF hmi.in.cmd.intElemId <= hw.VF.pixelCnt.in.common.numResults THEN
			brdkViBase_pxCnt_hw2hmi(hw.VF.pixelCnt.in.results[hmi.in.cmd.intElemId-1],hmi.out.VF.pixelCnt);
		END_IF
	ELSE
		// clear if 0
		brsmemset(ADR(hmi.out.VF.pixelCnt),0,SIZEOF(hmi.out.VF.pixelCnt));
		brsmemset(ADR(hmi.out.VF.ocr),0,SIZEOF(hmi.out.VF.ocr));
		brsmemset(ADR(hmi.out.VF.measurement),0,SIZEOF(hmi.out.VF.measurement));
		brsmemset(ADR(hmi.out.VF.match),0,SIZEOF(hmi.out.VF.match));
		brsmemset(ADR(hmi.out.VF.blob),0,SIZEOF(hmi.out.VF.blob));
		brsmemset(ADR(hmi.out.VF.codeReader),0,SIZEOF(hmi.out.VF.codeReader));
	END_IF
	
	
END_ACTION
