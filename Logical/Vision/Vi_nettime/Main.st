// --------------------------------------------------------------------------------------------------------------------
// This task calculates the nettime depending on a drive velocity
// - This task must run at the same cycle as the Powerlink bus
// - Make sure that nettime is selected in the vision application (Image aquisition -> Aquisition configuration -> Trigger Source -> Trigger delay
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT

END_PROGRAM

PROGRAM _CYCLIC
	
	// --------------------------------------------------------------------------------------------------------------------
	// Main state machine
	// --------------------------------------------------------------------------------------------------------------------
	IF(gVisionNettime.CMD.Activate) THEN
		// --------------------------------------------------------------------------------------------------------------------
		// Calculate Powerlink cycle time
		gVisionNettime.DAT.PowerlinkCycle := NettimeCurrent - OldNettime;
		OldNettime := NettimeCurrent;
		
		// --------------------------------------------------------------------------------------------------------------------
		// Make sure we are moving and on speed
		IF(gVisionNettime.DAT.AxisInVelocity AND gVisionNettime.DAT.AxisVelocity > 0) THEN
			// --------------------------------------------------------------------------------------------------------------------
			// Check if axis is before the image or if it is after the image position
			IF (gVisionNettime.CFG.AxisPositionTrigger >= gVisionNettime.DAT.AxisPosition) THEN
				// Calculate the distance [units] between the image position and the actual position
				gVisionNettime.DAT.AxisPositionDelta := gVisionNettime.CFG.AxisPositionTrigger - gVisionNettime.DAT.AxisPosition;
			ELSE
				// Calculate the distance [units] between the image position and the actual position taking in account the period 
				gVisionNettime.DAT.AxisPositionDelta := (gVisionNettime.CFG.AxisPeriod - gVisionNettime.DAT.AxisPosition) + gVisionNettime.CFG.AxisPositionTrigger;
			END_IF
			
			// --------------------------------------------------------------------------------------------------------------------
			// Calculate the time difference [microsec] when reaching the image position
			gVisionNettime.DAT.AxisTimeDelta := LREAL_TO_DINT((gVisionNettime.DAT.AxisPositionDelta / gVisionNettime.DAT.AxisVelocity) * 1000000);
			
			// --------------------------------------------------------------------------------------------------------------------
			// Wait for the moment that axis is in the send trigger window depend on delay by topology and the actual powerlink cycle
			IF (gVisionNettime.DAT.AxisTimeDelta >= USINT_TO_SINT(gVisionNettime.CFG.PowerlinkDelay) * gVisionNettime.DAT.PowerlinkCycle) AND 
			   (gVisionNettime.DAT.AxisTimeDelta <= USINT_TO_SINT(gVisionNettime.CFG.PowerlinkDelay + 2)*gVisionNettime.DAT.PowerlinkCycle) THEN
				
				// --------------------------------------------------------------------------------------------------------------------
				// Axis has reached the position to send a command, 2x Powerlink cycle time + 1x task class cycle time
				gVisionNettime.DAT.NettimeNext := NettimeCurrent + gVisionNettime.DAT.AxisTimeDelta;
				gVisionNettime.DAT.NettimeDelta := gVisionNettime.DAT.AxisTimeDelta;
				
				// --------------------------------------------------------------------------------------------------------------------
				// Transfer nettime to sensor and fire trigger
				IF gVisionSensor[visSelectedSensor].HW.Ready AND NOT gVisionSensor[visSelectedSensor].STA.ImageProcessingActive THEN
					gVisionSensor[visSelectedSensor].CFG.NettimeDelay := gVisionNettime.DAT.NettimeNext;
					gVisionSensor[visSelectedSensor].CMD.ImageTrigger := TRUE;
				ELSE
					gVisionNettime.DAT.Overflow := gVisionNettime.DAT.Overflow + 1;
				END_IF
			END_IF
		END_IF
	END_IF

END_PROGRAM


