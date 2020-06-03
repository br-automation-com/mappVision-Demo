
{REDUND_ERROR} FUNCTION_BLOCK ViDownloadImage (*TODO: Hier einen Kommentar eingeben*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL;
		FileDevice : STRING[80];
		FileName : {REDUND_UNREPLICABLE} STRING[80];
		ImgName : STRING[80];
		MemAdr : UDINT;
		MemSize : UDINT;
		AdrVisDownloadFileUrl : UDINT;
	END_VAR
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		FileOpen_0 : FileOpen;
		FileRead_0 : FileRead;
		FileClose_0 : FileClose;
		httpService_Download : httpService;
		Step : INT;
		response_header : httpResponseHeader_t;
		response_header_data : STRING[300];
		TON_Timeout : TON;
		visDownloadFileUrl : REFERENCE TO STRING[200];
	END_VAR
END_FUNCTION_BLOCK
