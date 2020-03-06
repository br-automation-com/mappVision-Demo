// --------------------------------------------------------------------------------------------------------------------
//	Function:	Recipe management with mappRecipe																			
//  Version:	0.4																		
//	Changed:	24.10.2019															
// --------------------------------------------------------------------------------------------------------------------

PROGRAM _INIT
	// ----------------------------------------------------------------------------------------
	// The following settings can be adjusted
	Recipe_01.PAR.RecipeVariable 	:= 'gVisionSensor';		// Top variable structure with recipe data
	IF(DiagCpuIsSimulated()) THEN
		Recipe_01.PAR.DeviceName 	:= 'SIM_DEVICE';		// Device name from the CPU configuration for simulation
	ELSE
		Recipe_01.PAR.DeviceName 	:= 'VisionFileDevice';		// Device name from the CPU configuration for X20CPU
	END_IF
	// ----------------------------------------------------------------------------------------
	this							:= 'Recipe_01';			// Name of the global variable structure and this task name
	Recipe_01.PAR.RecipeDirectory 	:= 'Recipes';			// Directory where the recipes are stored 
	Recipe_01.PAR.MpLink 		:= gRecipeCsv_01; 		// MpLink from mappRecipe configuration in physical view
	
	// ---------------------------------------------------------------------------------------- 
	// Dont change anything below this line
	// ---------------------------------------------------------------------------------------- 

	// ---------------------------------------------------------------------------------------- 
	// Make sure global variable structure and task name are correct
	taskStatus := ST_ident(ADR(this), taskGroup, ADR(taskID));
	pvStatus := PV_xgetadr(ADR(this), ADR(pvADR), ADR(pvLEN));
	// Connect global and local structure
	IF(pvStatus = 0) THEN
		RECIPE ACCESS pvADR;
		brsmemset(ADR(RECIPE.ERR), 0 , SIZEOF(RECIPE.ERR));
		RECIPE.PAR.Initialized := FALSE;
	END_IF
	
	// ----------------------------------------------------------------------------------------
	// Allocate memory for file upload and download
	AsMemPartCreate_0.enable	:= TRUE;
	AsMemPartCreate_0.len		:= REC_UPLOAD_DOWNLOAD_SIZE;
	AsMemPartCreate_0();
	IF AsMemPartCreate_0.status <> 0 THEN
		rec_state := CreateError(ADR(RECIPE), ERR_MEM_ALLOC, "file upload and download alloc failed", rec_state);
	ELSE
		AsMemPartAllocClear_0.enable	:= TRUE;
		AsMemPartAllocClear_0.ident		:= AsMemPartCreate_0.ident;
		AsMemPartAllocClear_0.len		:= REC_UPLOAD_DOWNLOAD_SIZE;
		AsMemPartAllocClear_0();
		IF AsMemPartCreate_0.status <> 0 THEN
			rec_state := CreateError(ADR(RECIPE), ERR_MEM_ALLOC, "file upload and download alloc failed", rec_state);
		END_IF
	END_IF
END_PROGRAM