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
