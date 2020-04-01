// --------------------------------------------------------------------------------------------------------------------
// This task calculates the nettime depending on a drive velocity
// - This task must run at the same cycle as the Powerlink bus
// - Make sure that nettime is selected in the vision application (Image aquisition -> Aquisition configuration -> Trigger Source -> Trigger delay
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	gVisionNettime.CMD.Activate					:= TRUE;
	gVisionNettime.CFG.AxisPeriod				:= 360; // Needs also to be set in the axis configuration
	gVisionNettime.CFG.AxisPositionTrigger		:= 0;
	gVisionNettime.CFG.AxisPositionDelay_Cycles	:= 1; // Number of PLK cycles which the axis position is old when it comes to this task (Time from encoder to now in this task)
	gVisionNettime.CFG.VisionPreTrigger_Cycles	:= 4; // Number of powerlink cycles the trigger has to be send ahead, 4 is a good value.
END_PROGRAM

PROGRAM _CYCLIC
	PowerlinkCycle_us			:= NettimeCurrent_us - NettimeLastCycle_us;
	NettimeLastCycle_us			:= NettimeCurrent_us;
	IF gVisionNettime.CMD.Activate AND gVisionNettime.DAT.AxisInVelocity AND gVisionNettime.DAT.AxisVelocity > 0 THEN
		AxisPositionNow			:= gVisionNettime.DAT.AxisPosition + gVisionNettime.DAT.AxisVelocity * PowerlinkCycle_us * gVisionNettime.CFG.AxisPositionDelay_Cycles / 1000000; // When the MpAxis gives us the read position, it is old. So calculate the "now" position
		IF AxisPositionNow > gVisionNettime.CFG.AxisPeriod THEN // modulo correction
			AxisPositionNow		:= AxisPositionNow - gVisionNettime.CFG.AxisPeriod;
		ELSIF AxisPositionNow < 0 THEN // modulo correction
			AxisPositionNow		:= AxisPositionNow + gVisionNettime.CFG.AxisPeriod;
		END_IF
		IF gVisionNettime.DAT.AxisVelocity > 0 THEN
			TriggerPosDelta		:= gVisionNettime.CFG.AxisPositionTrigger - AxisPositionNow;
			ELSE
			TriggerPosDelta		:= AxisPositionNow - gVisionNettime.CFG.AxisPositionTrigger;
		END_IF
		IF TriggerPosDelta < 0 THEN // modulo correction
			TriggerPosDelta	:= TriggerPosDelta + gVisionNettime.CFG.AxisPeriod;
			END_IF
		TriggerTimeDelta_us := LREAL_TO_DINT((TriggerPosDelta / gVisionNettime.DAT.AxisVelocity) * 1000000);
			// Wait for the moment that axis is in the send trigger window depend on delay by topology and the actual powerlink cycle
		IF (TriggerTimeDelta_us >= (gVisionNettime.CFG.VisionPreTrigger_Cycles)     * PowerlinkCycle_us) AND
		   (TriggerTimeDelta_us <= (gVisionNettime.CFG.VisionPreTrigger_Cycles + 1) * PowerlinkCycle_us) THEN
			gVisionNettime.DAT.NettimeNext_us	:= NettimeCurrent_us + TriggerTimeDelta_us;
			gVisionNettime.DAT.NettimeDelta_us	:= TriggerTimeDelta_us;
				// Transfer nettime to sensor and fire trigger
				IF gVisionSensor[visSelectedSensor].HW.Ready AND NOT gVisionSensor[visSelectedSensor].STA.ImageProcessingActive THEN
					gVisionSensor[visSelectedSensor].CMD.ImageTrigger	:= TRUE;
					gVisionSensor[visSelectedSensor].CFG.NettimeDelay	:= gVisionNettime.DAT.NettimeNext_us;
				ELSE
					gVisionNettime.DAT.Overflow := gVisionNettime.DAT.Overflow + 1;
				END_IF
			END_IF
		END_IF
END_PROGRAM