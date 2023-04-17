// --------------------------------------------------------------------------------------------------------------------
//	Function:	Recipe management with mappRecipe																			
//  Version:	0.8																	
//	Changed:	31.03.2022															
// --------------------------------------------------------------------------------------------------------------------

PROGRAM _INIT
	// ----------------------------------------------------------------------------------------

	// ---------------------------------------------------------------------------------------- 
	// Dont change anything below this line
	// ---------------------------------------------------------------------------------------- 

	// ---------------------------------------------------------------------------------------- 
	// Make sure global variable structure and task name are correct
	taskStatus := ST_ident(ADR(REC_THIS_TASK), taskGroup, ADR(taskID));
	pvStatus := PV_xgetadr(ADR(REC_THIS_TASK), ADR(pvADR), ADR(pvLEN));
	// Connect global and local structure
	IF(pvStatus = 0) THEN
		RECIPE ACCESS pvADR;
		brsmemset(ADR(RECIPE.ERR), 0 , SIZEOF(RECIPE.ERR));
		RECIPE.PAR.Initialized := FALSE;
	END_IF

	// ---------------------------------------------------------------------------------------- 
	// Get mapp link information
	MpComGetLink_0.Enable := TRUE;
	MpComGetLink_0.ComponentName := ADR(REC_MPLINK);
	MpComGetLink_0();
	// Create error
	IF(MpComGetLink_0.Error) THEN
		rec_state := CreateError(ADR(RECIPE), ERR_REC_MPLINK, "mplink name is incorrect", rec_state);
	END_IF

	// ----------------------------------------------------------------------------------------
	// Allocate memory for file upload and download
	AsMemPartCreate_0.enable	:= TRUE;
	AsMemPartCreate_0.len		:= REC_UPLOAD_DOWNLOAD_SIZE;
	AsMemPartCreate_0();
	IF AsMemPartCreate_0.status <> 0 THEN
		rec_state := CreateError(ADR(RECIPE), ERR_MEM_ALLOC, "file upload and download memory alloc failed", rec_state);
	ELSE
		AsMemPartAllocClear_0.enable	:= TRUE;
		AsMemPartAllocClear_0.ident		:= AsMemPartCreate_0.ident;
		AsMemPartAllocClear_0.len		:= REC_UPLOAD_DOWNLOAD_SIZE;
		AsMemPartAllocClear_0();
		IF AsMemPartAllocClear_0.status <> 0 THEN
			rec_state := CreateError(ADR(RECIPE), ERR_MEM_ALLOC, "file upload and download memory clear failed", rec_state);
		END_IF
	END_IF
	
	// ----------------------------------------------------------------------------------------
	// Generate HTML messages for web upload
	upload_response	:= '<html><body><form action="/uploadA.html" name="form_upload" method="post" enctype="multipart/form-data" >
	<label for="file-upload" style="font-weight:bold;font-family: sans-serif;font-size:16px;padding:15px 50px;10px;10px;" class="custom-file-upload">Upload</label>
	<input type="file" id="file-upload" style="display:none;" onchange="form.submit()" name="file_selected" content-type="application/octet-stream" />
	</form><body></html> ';
	WebServiceUpload.pServiceName := ADR('uploadA.html');
END_PROGRAM