
FUNCTION CrosshairDetailsText : BOOL
	VAR_INPUT
		strTarget : UDINT;
		strText : UDINT;
		fValue : REAL;
	END_VAR
	VAR
		tmpStr : STRING[50];
	END_VAR
END_FUNCTION

FUNCTION String2DataProvider : BOOL
	VAR_INPUT
		SourceString : UDINT;
		TargetString : UDINT;
	END_VAR
END_FUNCTION
