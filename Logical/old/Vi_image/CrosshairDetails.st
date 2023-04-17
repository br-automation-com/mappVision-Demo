FUNCTION CrosshairDetailsValue
	IF NOT TextAlignment THEN // left
		tmpStr:= '<tspan text-anchor="start" class="text" x="10" dy="32">';
	ELSE // right
		tmpStr:= '<tspan text-anchor="end" class="text" x="1270" dy="32">';
	END_IF
	brsstrcat(strTarget, ADR(tmpStr));
	brsstrcat(strTarget, strText);
	brsftoa(fValue, ADR(tmpStr));
	brsstrcat(strTarget, ADR(tmpStr));
	brsstrcat(strTarget, ADR('</tspan> '));
	CrosshairDetailsValue := TRUE;
END_FUNCTION
FUNCTION CrosshairDetailsText
	IF NOT TextAlignment THEN // left
		tmpStr:= '<tspan text-anchor="start" class="text" x="10" dy="32">';
	ELSE // right
		tmpStr:= '<tspan text-anchor="end" class="text" x="1270" dy="32">';
	END_IF
	brsstrcat(strTarget, ADR(tmpStr));
	brsstrcat(strTarget, strText);
	brsstrcat(strTarget, adrText);
	brsstrcat(strTarget, ADR('</tspan> '));
	CrosshairDetailsText := TRUE;
END_FUNCTION