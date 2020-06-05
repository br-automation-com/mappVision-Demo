
FUNCTION_BLOCK VaGetList
	VAR_INPUT
		Enable : BOOL;
	END_VAR
	VAR_OUTPUT
		VaApplicationCnt : USINT;
		VaApplicationNames : ARRAY[0..19] OF STRING[40];
		Status : UINT;
	END_VAR
	VAR
		State : USINT;
	END_VAR
	VAR CONSTANT
		STATE_WAIT : USINT := 0;
		STATE_NEXT_OBJ : USINT := 1;
		STATE_VA_NAME : USINT := 2;
	END_VAR
	VAR
		i : UINT;
		j : UINT;
		PrevIndex : UINT;
		ModuleList : MO_List_typ;
		ModuleStatus : UINT;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

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
