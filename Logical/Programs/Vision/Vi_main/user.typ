
TYPE
	user_stat_point_typ : 	STRUCT 
		y : MTDataStatistics := (MovingWindowLength:=50,Update:=TRUE);
		x : MTDataStatistics := (MovingWindowLength:=50,Update:=TRUE);
	END_STRUCT;
	user_stat_typ : 	STRUCT 
		distance : MTDataStatistics := (MovingWindowLength:=50,Update:=TRUE);
		point : ARRAY[0..1]OF user_stat_point_typ;
	END_STRUCT;
	user_points_typ : 	STRUCT 
		p1 : brdkViBase_2d_typ;
		p2 : brdkViBase_2d_typ;
	END_STRUCT;
	user_typ : 	STRUCT 
		p2 : brdkViBase_2d_typ;
		convert : LREAL;
		distanceMM : LREAL := 95;
		distance : LREAL;
		p1 : brdkViBase_2d_typ;
		statistic : user_stat_typ;
		currentPoints : user_points_typ;
		basePoints : user_points_typ;
		data : user_data_typ;
		mpRecipeRegVar : MpRecipeRegParSync;
		dataPvName : STRING[255];
	END_STRUCT;
	user_data_stat_typ : 	STRUCT 
		var : REAL;
		std : REAL;
		data : ARRAY[0..49]OF LREAL;
		num : REAL;
		mean : REAL;
		max : REAL;
		min : {REDUND_UNREPLICABLE} REAL;
	END_STRUCT;
	user_data_typ : 	STRUCT 
		distance : user_data_stat_typ;
		p2 : user_data_stat_point_typ;
		p1 : user_data_stat_point_typ;
	END_STRUCT;
	user_data_stat_point_typ : 	STRUCT 
		x : user_data_stat_typ;
		y : user_data_stat_typ;
	END_STRUCT;
END_TYPE
