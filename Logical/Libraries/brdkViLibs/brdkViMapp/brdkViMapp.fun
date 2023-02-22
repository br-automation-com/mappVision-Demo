
FUNCTION brdkViMapp_getVfDataSet : BOOL (*Function to get the vision function data set*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision function name*)
		VFidx : USINT := 1; (*Index of vision function in the vision application file.*)
		pParam : UDINT; (*pointer to string (need to be a very long string) or 0 if disregarded*)
		pROI : UDINT; (*pointer to string (need to be a very long string) or 0 if disregarded*)
		pWidgetModels : UDINT; (*pointer to string (need to be a very long string) or 0 if disregarded*)
		pModels : UDINT; (*pointer to string (need to be a very long string) or 0 if disregarded*)
		maxLen : UDINT; (*Max length of the strings*)
		pError : UDINT; (*Pointer to error when failing to get parameters of the vision function.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViMapp_setVfDataSet : BOOL (*Function to set the vision function data set*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision application name*)
		VFidx : USINT := 1; (*Index of vision function in the vision application file.*)
		pParam : UDINT; (*Pointer to string containing parameters of the vision function (need to be a very long string)*)
		pROI : UDINT; (*Pointer to string containing Region of Interest(s) (need to be a very long string)*)
		pWidgetModels : UDINT; (*Pointer to string of Widget Models (need to be a very long string)*)
		pModels : UDINT; (*pointer to string (need to be a very long string)*)
		pError : UDINT; (*Pointer to error  string, with error desciption*)
	END_VAR
END_FUNCTION

FUNCTION brdkViMapp_setCompilerOption : BOOL (*Function to set the compiler option in the vision application*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision application name*)
		option : BRDKVIMAPP_COMPILEROPTION_ENM;
		pError : UDINT; (*Pointer to error  string, with error desciption*)
	END_VAR
END_FUNCTION

FUNCTION brdkViMapp_getCompilerOption : BOOL (*Function to get the compiler option in the vision application*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision application name*)
		option : REFERENCE TO BRDKVIMAPP_COMPILEROPTION_ENM;
		pError : UDINT; (*Pointer to error  string, with error desciption*)
	END_VAR
END_FUNCTION

FUNCTION brdkViMapp_setTriggerMode : BOOL (*Function to set the trigger mode for the vision application*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision application name*)
		mode : BRDKVIMAPP_TRIGGERMODE_ENM; (*Compiler option of the camera, *)
		pError : UDINT; (*Pointer to error  string, with error desciption*)
	END_VAR
END_FUNCTION

FUNCTION brdkViMapp_getTriggerMode : BOOL (*Function to get the trigger mode for the vision application*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision application name*)
		mode : REFERENCE TO BRDKVIMAPP_TRIGGERMODE_ENM; (*Compiler option of the camera, *)
		pError : UDINT; (*Pointer to error  string, with error desciption*)
	END_VAR
END_FUNCTION

FUNCTION brdkViMapp_setFlipImgHorizontal : BOOL (*Function to set the image flip horisontal for the vision application*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision application name*)
		flip : BOOL; (*If true the image is fliped horizontal*)
		pError : UDINT; (*Pointer to error  string, with error desciption*)
	END_VAR
END_FUNCTION

FUNCTION brdkViMapp_getFlipImgHorizontal : BOOL (*Function to get the value of flip horizontal for the vision application*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision application name*)
		flip : REFERENCE TO BOOL; (*If true the image is fliped horizontal*)
		pError : UDINT; (*Pointer to error  string, with error desciption*)
	END_VAR
END_FUNCTION

FUNCTION brdkViMapp_setFlipImgVertical : BOOL (*Function to set the image flip vertical for the vision application*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision application name*)
		flip : BOOL; (*If true the image is fliped vertical*)
		pError : UDINT; (*Pointer to error  string, with error desciption*)
	END_VAR
END_FUNCTION

FUNCTION brdkViMapp_getFlipImgVertical : BOOL (*Function to get the value of flip vertical for the vision application*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision application name*)
		flip : REFERENCE TO BOOL; (*If true the image is fliped vertical*)
		pError : UDINT; (*Pointer to error  string, with error desciption*)
	END_VAR
END_FUNCTION
