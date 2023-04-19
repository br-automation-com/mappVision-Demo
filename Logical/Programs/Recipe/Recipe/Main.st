PROGRAM _INIT
	(* Insert code here *)
	gRecipe.out.mpLink :=  ADR(gRecipeCsv_01);
	this.mpRecipe.DeviceName := ADR('RECIPE');
	
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
	
END_PROGRAM

PROGRAM _CYCLIC
	this.mpRecipe(Enable 				:= gFiles.output.ready);
	this.mpRecipeUi(Enable 				:= this.mpRecipe.Active);
	gRecipe.out.active 					:= this.mpRecipe.Active;
	this.mpRecipe.UpdateNotification 	:= this.oldName <> this.mpRecipe.Info.LastLoadedRecipe;
		
	this.oldName 			:= this.mpRecipe.Info.LastLoadedRecipe;
	hmi.out.selectedName 	:= hmi.mpRecipe.Recipe.List.Names[hmi.mpRecipe.Recipe.List.SelectedIndex];
	
	hmi.out.viewUrl := 'FileDevice:';
	brsstrcat(ADR(hmi.out.viewUrl),this.mpRecipe.DeviceName);
	brsstrcat(ADR(hmi.out.viewUrl),ADR('/'));
	brsstrcat(ADR(hmi.out.viewUrl),ADR(hmi.out.selectedName));
	
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

