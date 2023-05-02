PROGRAM _INIT
	(* Insert code here *)
	gRecipe.out.mpLink :=  ADR(gRecipeCsv_01);
	this.mpRecipe.DeviceName := ADR('RECIPE');
	this.mpRecipe.Category := ADR('Recipe');
	this.mpRecipe.MpLink := gRecipe.out.mpLink;

	this.mpRecipeUi.MpLink := gRecipe.out.mpLink;
	this.mpRecipeUi.UIConnect := ADR(hmi.mpRecipe);
	this.mpRecipeUi.UISetup.Confirmation.RecipeCreate 	:= FALSE;
	this.mpRecipeUi.UISetup.Confirmation.RecipeDelete 	:= FALSE;
	this.mpRecipeUi.UISetup.Confirmation.RecipeLoad 	:= FALSE;
	this.mpRecipeUi.UISetup.Confirmation.RecipeRename 	:= FALSE;
	this.mpRecipeUi.UISetup.Confirmation.RecipeSave 	:= FALSE;
	this.mpRecipeUi.UISetup.RecipeListScrollWindow		:= 5;
	this.mpRecipeUi.UISetup.RecipeListSize 				:= 10;
	
	
	IF  brsstrlen(ADR(retain.lastLoadedName)) > 0 THEN
		gRecipe.out.init := TRUE;
	END_IF
	
	this.autoLoadTon.PT := t#2s;
END_PROGRAM

PROGRAM _CYCLIC
	
	// if a data log should be saved instead (trigged from a program)
	IF gRecipe.in.cmd.saveData THEN
		gRecipe.in.cmd.saveData := FALSE;
		this.mpRecipe.DeviceName := ADR('DATA');
		this.mpRecipe.Category := ADR('Data');
		this.mpRecipe.FileName := ADR(gRecipe.in.filename);
		this.mpRecipe.Save := TRUE;
	END_IF
	
	// delay timer for auto load to ensure that all programs have run and had the chance to reset readyForInit if not ready
	this.autoLoadTon(IN := gRecipe.in.readyForInit);
	IF this.autoLoadTon.Q THEN
		this.mpRecipe.FileName 	:= ADR(retain.lastLoadedName);
		this.mpRecipe.Load 		:= TRUE;
		this.autoLoadTon.IN 	:= FALSE;
		gRecipe.out.init 		:= FALSE;
	END_IF
	
	// Set ready for init if init is needed. All programs will reset it they are not ready (reg var not done)
	gRecipe.in.readyForInit := gRecipe.out.init;
	
	this.mpRecipe(Enable 				:= gFiles.output.ready);
	this.mpRecipeUi(Enable 				:= this.mpRecipe.Active);
	gRecipe.out.active 					:= this.mpRecipe.Active;
	
	IF hmi.out.lastLoaded 	 <> this.mpRecipe.Info.LastLoadedRecipe AND brsstrcmp(this.mpRecipe.Category,ADR('Recipe')) = 0 THEN
		 hmi.out.lastLoaded	:= retain.lastLoadedName 	:= this.mpRecipe.Info.LastLoadedRecipe;
		this.mpRecipe.UpdateNotification := TRUE;
	ELSE
		this.mpRecipe.UpdateNotification := FALSE;
	END_IF
	
	hmi.out.selectedName 	:= hmi.mpRecipe.Recipe.List.Names[hmi.mpRecipe.Recipe.List.SelectedIndex];
	
	IF this.mpRecipe.CommandDone THEN
		this.mpRecipe.DeviceName := ADR('RECIPE');
		this.mpRecipe.Category := ADR('Recipe');
		this.mpRecipe.FileName := 0;
		this.mpRecipe.Save := FALSE;
	END_IF
	
	
	hmi.out.viewUrl := 'FileDevice:';
	brsstrcat(ADR(hmi.out.viewUrl),this.mpRecipe.DeviceName);
	brsstrcat(ADR(hmi.out.viewUrl),ADR('/'));
	brsstrcat(ADR(hmi.out.viewUrl),ADR(hmi.out.selectedName));
	
	
	// Handle download of recipe files (will crated an js code that is embedded in an paper widget (SVG) that automatically triggers a download of the file
	IF hmi.in.download THEN
		hmi.in.download 	:= FALSE;
		this.delayTon.IN 	:= TRUE;
		this.delayTon.PT 	:= T#400ms;
	
		hmi.out.downloadSrc := '<script>function onSvgLoad() {const link = document.createElement("a");link.href = "/FileDevice:';
		brsstrcat(ADR(hmi.out.downloadSrc),this.mpRecipe.DeviceName);
		brsstrcat(ADR(hmi.out.downloadSrc),ADR('/'));
		brsstrcat(ADR(hmi.out.downloadSrc),ADR(hmi.out.selectedName));	
		brsstrcat(ADR(hmi.out.downloadSrc),ADR('";link.download="'));
		brsstrcat(ADR(hmi.out.downloadSrc),ADR(hmi.out.selectedName));
		brsstrcat(ADR(hmi.out.downloadSrc),ADR('";link.click();}; onSvgLoad(); </script>'));
	END_IF
	// reset the embedded JS such that when enter the page its not downloaded again.
	IF this.delayTon.Q THEN
		this.delayTon.IN := FALSE;
		hmi.out.downloadSrc := '';
	END_IF
	this.delayTon();
	
	
	hmi.out.enableBtn := brsstrlen(ADR(hmi.mpRecipe.Recipe.List.Names[0])) > 0;
END_PROGRAM

PROGRAM _EXIT
	this.mpRecipe(Enable 	:= FALSE);
	this.mpRecipeUi(Enable 	:= FALSE);
	gRecipe.out.active 		:= FALSE;
END_PROGRAM

