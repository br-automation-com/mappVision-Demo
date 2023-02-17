
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
	
END_ACTION
