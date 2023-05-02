// --------------------------------------------------------------------------------------------------------------------
// Motion sample for using nettime
// --------------------------------------------------------------------------------------------------------------------
PROGRAM _INIT
	this.mpAxisBasic_0.Enable			:= TRUE;
	this.mpAxisBasic_0.MpLink			:= ADR(gAxis_1);
	this.mpAxisBasic_0.Parameters		:= ADR(this.mpAxisBasicPar_0);
	this.mpAxisBasic_0();
	this.mpAxisBasicPar_0.Homing.Mode	:= mcHOMING_DEFAULT;
	
	gVisionNettime.CMD.Activate					:= TRUE;
	hmi.in.recipe.axisPeriod				:= 360; // Needs also to be set in the axis configuration
	hmi.in.recipe.axisPositionTrigger		:= 0;
	hmi.in.recipe.axisPositionDelayCycles	:= 1; 	// Number of PLK cycles which the axis position is old when it comes to this task (Time from encoder to now in this task)
	hmi.in.recipe.visionPreTriggerCycles	:= 4; 	// Number of powerlink cycles the trigger has to be send ahead
	// For camera only 4 is good value, for backlight use 12 with a 800us Powerlink cylce
	
END_PROGRAM

// -----------------------------------------------------------------------------------------------------------
// Cyclic part
// -----------------------------------------------------------------------------------------------------------	
PROGRAM _CYCLIC
	
// -----------------------------------------------------------------------------------------------------------
// Mapp Motion Axis control
// -----------------------------------------------------------------------------------------------------------	
	this.mpAxisBasic_0.Power				:= this.mpAxisBasic_0.Active AND this.mpAxisBasic_0.Info.ReadyToPowerOn AND hmi.in.cmd.power;
	this.mpAxisBasic_0.ErrorReset			:= hmi.in.cmd.errReset;
	this.mpAxisBasic_0.Home					:= this.mpAxisBasic_0.PowerOn AND NOT this.mpAxisBasic_0.IsHomed XOR hmi.in.cmd.home;
	this.mpAxisBasic_0.MoveVelocity			:= this.mpAxisBasic_0.PowerOn AND this.mpAxisBasic_0.IsHomed AND hmi.in.cmd.run;
	
	IF this.mpAxisBasic_0.PowerOn AND this.mpAxisBasic_0.IsHomed AND hmi.in.cmd.moveAbs THEN
		this.mpAxisBasic_0.MoveAbsolute		:= TRUE;
		this.mpAxisBasicPar_0.Position		:= gVisionNettime.CFG.AxisPositionTrigger;
	END_IF
	hmi.in.cmd.moveAbs					:= FALSE;
	
	
	IF hmi.in.recipe.velocity <> this.mpAxisBasicPar_0.Velocity OR hmi.in.recipe.acceleration <> this.mpAxisBasicPar_0.Acceleration THEN
		this.mpAxisBasicPar_0.Velocity		:= hmi.in.recipe.velocity;
		this.mpAxisBasicPar_0.Acceleration	:= hmi.in.recipe.acceleration;
		this.mpAxisBasicPar_0.Deceleration	:= hmi.in.recipe.acceleration;
		this.mpAxisBasic_0.Update			:= TRUE;
	END_IF
	
	this.mpAxisBasic_0();
	
	IF hw.in.nettime > this.nettimeLastCycle_us THEN
		this.powerlinkCycle_us	:= hw.in.nettime - this.nettimeLastCycle_us;
	ELSE
		this.powerlinkCycle_us	:= -2147483648-hw.in.nettime + 2147483647-this.nettimeLastCycle_us; // handle wrap around
	END_IF
	this.nettimeLastCycle_us		:= hw.in.nettime;
	
	
	hmi.out.inVelocity 	:= gAxis.status.inVelocity	:= 	this.mpAxisBasic_0.InVelocity;
	hmi.out.veleocity 	:= gAxis.status.velocity	:= 	this.mpAxisBasic_0.Velocity;
	hmi.out.inPostion 								:=	this.mpAxisBasic_0.InPosition;
	// When the MpAxis gives us the read position, it is old. So calculate the "now" position
	hmi.out.positon 	:= gAxis.status.position	:= 	LREAL_TO_REAL(this.mpAxisBasic_0.Position) + this.mpAxisBasic_0.Velocity * DINT_TO_REAL(this.powerlinkCycle_us) * hmi.in.recipe.axisPositionDelayCycles / 1000000; ;
	
	IF this.mpAxisBasic_0.UpdateDone THEN
		this.mpAxisBasic_0.Update := FALSE;
	END_IF
	
	IF this.mpAxisBasic_0.InPosition THEN
		this.mpAxisBasic_0.MoveAbsolute		:= FALSE;
	END_IF
	
	// -----------------------------------------------------------------------------------------------------------
	// Calulate time to camera trigger point
	// -----------------------------------------------------------------------------------------------------------	
	
	// calculate axis postion in the current period 
	IF this.axisPositionNow > hmi.in.recipe.axisPeriod THEN // modulo correction
		this.axisPositionNow		:= hmi.out.positon- hmi.in.recipe.axisPeriod;
	ELSIF this.axisPositionNow < 0 THEN // modulo correction
		this.axisPositionNow		:= hmi.out.positon + hmi.in.recipe.axisPeriod;
	END_IF
		
	// calculate differen (triggerPosDelta) in current axis postion to the trigger postion 
	IF this.mpAxisBasic_0.Velocity > 0 THEN
		this.triggerPosDelta		:= hmi.in.recipe.axisPositionTrigger - this.axisPositionNow;
	ELSE
		this.triggerPosDelta		:= this.axisPositionNow - hmi.in.recipe.axisPositionTrigger;
	END_IF
		
	IF this.triggerPosDelta < 0 THEN // modulo correction
		this.triggerPosDelta		:= this.triggerPosDelta + hmi.in.recipe.axisPositionTrigger;
	END_IF

	IF hmi.out.veleocity > 0 THEN
		// convert position difference to a time difference (the time until the axis is at the trigger postion with the current velocity)
		gAxis.status.triggerTimeDelta 	:= LREAL_TO_DINT((this.triggerPosDelta / this.mpAxisBasic_0.Velocity) * 1000000);
	END_IF
	
	gAxis.status.nettime 		  		:= hw.in.nettime;
	gAxis.status.powerlinkCycleTime 	:= this.powerlinkCycle_us;
	
	hmi.out.triggerPosDelta 	:= this.triggerPosDelta;
	hmi.out.powerlinkCycle_us 	:= this.powerlinkCycle_us;
	hmi.out.triggerTimeDelta 	:= this.triggerTimeDelta;
	
	this.mpRecipeRegVar.Enable 		:= gRecipe.out.active;
	this.mpRecipeRegVar.MpLink 		:= gRecipe.out.mpLink;
	this.mpRecipeRegVar.ConfirmSave := this.mpRecipeRegVar.SaveNotification;
	this.mpRecipeRegVar.Category 	:= ADR('Recipe');
	this.mpRecipeRegVar.PVName 		:= ADR('::Axis:hmi.in.recipe');
	this.mpRecipeRegVar();
	
	// Clear ready for init (auto load) if data structures have not been registred
	IF NOT this.mpRecipeRegVar.Active THEN
		gRecipe.in.readyForInit := FALSE;
	END_IF
		

END_PROGRAM