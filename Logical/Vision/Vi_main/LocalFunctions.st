//******************************************************************************************************
// Create crosshair text
//******************************************************************************************************
FUNCTION CrosshairDetailsText
	tmpStr:= '<tspan class="text" x=10 dy=32>';
	brsstrcat(strTarget, ADR(tmpStr));
	brsstrcat(strTarget, strText);
	brsftoa(fValue, ADR(tmpStr));
	brsstrcat(strTarget, ADR(tmpStr));			
	brsstrcat(strTarget, ADR('</tspan> '));
	
	CrosshairDetailsText := TRUE;
END_FUNCTION

