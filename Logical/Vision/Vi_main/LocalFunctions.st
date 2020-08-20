//******************************************************************************************************
// Create crosshair text
//******************************************************************************************************
FUNCTION CrosshairDetailsText
	tmpStr:= '<tspan class="text" x="10" dy="32">';
	brsstrcat(strTarget, ADR(tmpStr));
	brsstrcat(strTarget, strText);
	brsftoa(fValue, ADR(tmpStr));
	brsstrcat(strTarget, ADR(tmpStr));
	brsstrcat(strTarget, ADR('</tspan> '));
	
	CrosshairDetailsText := TRUE;
END_FUNCTION

//******************************************************************************************************
// Create mappView data provider string
//******************************************************************************************************
FUNCTION String2DataProvider
	brsstrcpy(TargetString, ADR('{"value":"'));
	brsstrcat(TargetString, SourceString);
	brsstrcat(TargetString, ADR('","text":"')); 
	brsstrcat(TargetString, SourceString);
	brsstrcat(TargetString, ADR('"}'));
	String2DataProvider := TRUE;
END_FUNCTION

//******************************************************************************************************
// Create vision application list
//******************************************************************************************************
FUNCTION_BLOCK VaGetList
	IF (NOT Enable) THEN
		State := STATE_WAIT;
	END_IF
	
	CASE State OF
		// ----------------------------------------------------------------------------------------
		// Wait state
		STATE_WAIT:
			Status := ERR_FUB_ENABLE_FALSE;
			
			// Start new list
			IF EDGEPOS(Enable) THEN
				Status := ERR_FUB_BUSY;
				VaApplicationCnt := 0;
				PrevIndex := 16#FFFF;
				State := STATE_NEXT_OBJ;
				brsmemset(ADR(VaApplicationCnt),0, SIZEOF(VaApplicationCnt));
			END_IF
			// ----------------------------------------------------------------------------------------
		// Get next module		
		STATE_NEXT_OBJ:
			// Get next module
			ModuleStatus := MO_list(PrevIndex,ADR(PrevIndex),ADR(ModuleList));
			
			// ----------------------------------------------------------------------------------------
			// OK
			IF ModuleStatus = ERR_OK AND ModuleList.type = 16#88 THEN
				State := STATE_VA_NAME;
			// ----------------------------------------------------------------------------------------
			// Last module reached
			ELSIF ModuleStatus = ERR_BUR_NOENTRY THEN
				Status := ERR_OK;
				State := STATE_WAIT;
			// ----------------------------------------------------------------------------------------
			// Error
			ELSIF ModuleStatus <> ERR_OK THEN
				Status := ModuleStatus;
				State := STATE_WAIT;
			END_IF
		// ----------------------------------------------------------------------------------------
		// Find vision application anme			
		STATE_VA_NAME:
			FOR i:=0 TO 400 DO
				IF (brsmemcmp(ModuleList.adress+i, ADR('" Type="visionapplication"'), SIZEOF('" Type="visionapplication"')-1) = 0) THEN
					FOR j:=i-1 TO 1 BY -1 DO
						IF (brsmemcmp(ModuleList.adress+j, ADR('"'), SIZEOF('"')-1) = 0) THEN
							brsmemcpy(ADR(VaApplicationNames[VaApplicationCnt]), ModuleList.adress+j+1, i-j-1);
							VaApplicationCnt := VaApplicationCnt + 1;
							// Make sure we dont exceed array limit
							IF VaApplicationCnt > MAX_IDX_VA_LIST THEN
								Status := ERR_VA_LIST_NUM;
								State := STATE_WAIT;
								EXIT;
							END_IF
							EXIT;
						END_IF
					END_FOR
					EXIT;
				END_IF
			END_FOR						
			State := STATE_NEXT_OBJ;					
	END_CASE
	  
END_FUNCTION_BLOCK 
