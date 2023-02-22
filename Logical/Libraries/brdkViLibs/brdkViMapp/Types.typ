
TYPE
	BRDKVIMAPP_TRIGGERMODE_ENM : 
		( (*Enum for selection of vision application trigger mode*)
		BRDKVIMAPP_TRIGGERMODE_DELAY := 0, (*Camera is trigged using a delay time for delayNetime IO*)
		BRDKVIMAPP_TRIGGERMODE_NETTIME := 1 (*Camera is trigged using a netime for delayNetime IO*)
		);
	brdkViMapp_VF_typ : 	STRUCT  (*mappView vision function type.*)
		widgetModels : STRING[150000]; (*Models of widgets in vision function.*)
		ROI : STRING[150000]; (*Region of Interest.*)
		models : STRING[150000]; (*Vision function models*)
		params : STRING[1000]; (*Parameters of vision function.*)
	END_STRUCT;
	BRDKVIMAPP_COMPILEROPTION_ENM : 
		( (*Enum for selstion of vision application compiler mode*)
		BRDKVIMAPP_COMPILER_INTERPRETED := 0, (*The vision application is using interpreted compiler (slower execution of vision function, but faster boot up time)*)
		BRDKVIMAPP_COMPILER_STARTUP_COMP := 1 (*The vision application is using startup compiler (faster execution of vision function, but slower boot up time)*)
		);
END_TYPE
