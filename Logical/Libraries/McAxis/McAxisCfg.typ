TYPE
	McABTEnum :
		( (*Base type selector setting*)
		mcABT_LIN_BD := 0, (*Linear bounded - Linear axis with bounded movement scope*)
		mcABT_LIN := 1, (*Linear - Linear axis*)
		mcABT_LIN_PER := 2, (*Linear periodic - Linear axis with periodic movement scope*)
		mcABT_ROT_BD := 10, (*Rotary bounded - Rotary axis with bounded movement scope*)
		mcABT_ROT := 11, (*Rotary - Rotary axis*)
		mcABT_ROT_PER := 12 (*Rotary periodic - Rotary axis with periodic movement scope*)
		);
	McABTLinBdType : STRUCT (*Type mcABT_LIN_BD settings*)
		MeasurementUnit : McCfgLocLenUnitEnum; (*Measurement unit for the axis*)
		MeasurementResolution : LREAL; (*Possible resolution of measurement unit that can be achieved [Measurement units]*)
		CountDirection : McCfgCntDirEnum; (*Direction of the axis in which the position value is increasing*)
	END_STRUCT;
	McABTLinType : STRUCT (*Type mcABT_LIN settings*)
		MeasurementUnit : McCfgLocLenUnitEnum; (*Measurement unit for the axis*)
		MeasurementResolution : LREAL; (*Possible resolution of measurement unit that can be achieved [Measurement units]*)
		CountDirection : McCfgCntDirEnum; (*Direction of the axis in which the position value is increasing*)
	END_STRUCT;
	McABTLinPerPerSetType : STRUCT (*Possible position value range of a periodic axis*)
		Period : LREAL; (*The value range for axis positions is [0 , Period[ [Measurement units]*)
	END_STRUCT;
	McABTLinPerType : STRUCT (*Type mcABT_LIN_PER settings*)
		MeasurementUnit : McCfgLocLenUnitEnum; (*Measurement unit for the axis*)
		MeasurementResolution : LREAL; (*Possible resolution of measurement unit that can be achieved [Measurement units]*)
		CountDirection : McCfgCntDirEnum; (*Direction of the axis in which the position value is increasing*)
		PeriodSettings : McABTLinPerPerSetType; (*Possible position value range of a periodic axis*)
	END_STRUCT;
	McABTRotBdType : STRUCT (*Type mcABT_ROT_BD settings*)
		MeasurementUnit : McCfgLocRotUnitEnum; (*Measurement unit for the axis*)
		MeasurementResolution : LREAL; (*Possible resolution of measurement unit that can be achieved [Measurement units]*)
		CountDirection : McCfgCntDirEnum; (*Direction of the axis in which the position value is increasing*)
	END_STRUCT;
	McABTRotType : STRUCT (*Type mcABT_ROT settings*)
		MeasurementUnit : McCfgLocRotUnitEnum; (*Measurement unit for the axis*)
		MeasurementResolution : LREAL; (*Possible resolution of measurement unit that can be achieved [Measurement units]*)
		CountDirection : McCfgCntDirEnum; (*Direction of the axis in which the position value is increasing*)
	END_STRUCT;
	McABTRotPerPerSetType : STRUCT (*Possible position value range of a periodic axis*)
		Period : LREAL; (*The value range for axis positions is [0 , Period[ [Measurement units]*)
	END_STRUCT;
	McABTRotPerType : STRUCT (*Type mcABT_ROT_PER settings*)
		MeasurementUnit : McCfgLocRotUnitEnum; (*Measurement unit for the axis*)
		MeasurementResolution : LREAL; (*Possible resolution of measurement unit that can be achieved [Measurement units]*)
		CountDirection : McCfgCntDirEnum; (*Direction of the axis in which the position value is increasing*)
		PeriodSettings : McABTRotPerPerSetType; (*Possible position value range of a periodic axis*)
	END_STRUCT;
	McABTType : STRUCT (*Defines the basic movement possibilities of the axis*)
		Type : McABTEnum; (*Base type selector setting*)
		LinearBounded : McABTLinBdType; (*Type mcABT_LIN_BD settings*)
		Linear : McABTLinType; (*Type mcABT_LIN settings*)
		LinearPeriodic : McABTLinPerType; (*Type mcABT_LIN_PER settings*)
		RotaryBounded : McABTRotBdType; (*Type mcABT_ROT_BD settings*)
		Rotary : McABTRotType; (*Type mcABT_ROT settings*)
		RotaryPeriodic : McABTRotPerType; (*Type mcABT_ROT_PER settings*)
	END_STRUCT;
	McAMLEnum :
		( (*Movement limits selector setting*)
		mcAML_INT := 0, (*Internal - Internal definition of limits*)
		mcAML_INT_PATH_AX := 1, (*Internal path axis - Internal definition of limits with additional settings for a path controlled axis*)
		mcAML_EXT := 2 (*External - External definition of limits*)
		);
	McAMoveLimVelEnum :
		( (*Velocity selector setting*)
		mcAMLV_BASIC := 0, (*Basic -*)
		mcAMLV_ADV := 1 (*Advanced -*)
		);
	McAMoveLimVelType : STRUCT (*Limits for the velocity of the axis*)
		Type : McAMoveLimVelEnum; (*Velocity selector setting*)
		Basic : McCfgLimVelBaseType; (*Type mcAMLV_BASIC settings*)
		Advanced : McCfgLimVelAdvType; (*Type mcAMLV_ADV settings*)
	END_STRUCT;
	McAMoveLimAccEnum :
		( (*Acceleration selector setting*)
		mcAMLA_BASIC := 0, (*Basic -*)
		mcAMLA_ADV := 1 (*Advanced -*)
		);
	McAMoveLimAccType : STRUCT (*Limits for the acceleration of the axis*)
		Type : McAMoveLimAccEnum; (*Acceleration selector setting*)
		Basic : McCfgLimAccBaseType; (*Type mcAMLA_BASIC settings*)
		Advanced : McCfgLimAccAdvType; (*Type mcAMLA_ADV settings*)
	END_STRUCT;
	McAMoveLimDecEnum :
		( (*Deceleration selector setting*)
		mcAMLD_BASIC := 0, (*Basic -*)
		mcAMLD_ADV := 1 (*Advanced -*)
		);
	McAMoveLimDecType : STRUCT (*Limits for the deceleration of the axis*)
		Type : McAMoveLimDecEnum; (*Deceleration selector setting*)
		Basic : McCfgLimDecBaseType; (*Type mcAMLD_BASIC settings*)
		Advanced : McCfgLimDecAdvType; (*Type mcAMLD_ADV settings*)
	END_STRUCT;
	McAMLIntType : STRUCT (*Type mcAML_INT settings*)
		Position : McCfgLimPosType; (*Movement range of the axis via two position boundaries*)
		Velocity : McAMoveLimVelType; (*Limits for the velocity of the axis*)
		Acceleration : McAMoveLimAccType; (*Limits for the acceleration of the axis*)
		Deceleration : McAMoveLimDecType; (*Limits for the deceleration of the axis*)
	END_STRUCT;
	McAMLIntPathAxType : STRUCT (*Type mcAML_INT_PATH_AX settings*)
		Position : McCfgLimPosType; (*Movement range of the axis via two position boundaries*)
		Velocity : McAMoveLimVelType; (*Limits for the velocity of the axis*)
		Acceleration : McAMoveLimAccType; (*Limits for the acceleration of the axis*)
		Deceleration : McAMoveLimDecType; (*Limits for the deceleration of the axis*)
		Jerk : McCfgLimJerkType; (*Jerk limits*)
		Torque : McCfgLimTorqType; (*Torque limits*)
		Force : McCfgLimForType; (*Limits for the force of the axis*)
	END_STRUCT;
	McAMLType : STRUCT (*Various limit values that will be considered for axis movements*)
		Type : McAMLEnum; (*Movement limits selector setting*)
		Internal : McAMLIntType; (*Type mcAML_INT settings*)
		InternalPathAxis : McAMLIntPathAxType; (*Type mcAML_INT_PATH_AX settings*)
		External : McCfgExtLimRefType; (*Type mcAML_EXT settings*)
	END_STRUCT;
	McCfgAxType : STRUCT (*Main data type corresponding to McCfgTypeEnum mcCFG_AX*)
		BaseType : McABTType; (*Defines the basic movement possibilities of the axis*)
		MovementLimits : McAMLType; (*Various limit values that will be considered for axis movements*)
	END_STRUCT;
	McCfgAxBaseTypType : STRUCT (*Main data type corresponding to McCfgTypeEnum mcCFG_AX_BASE_TYP*)
		BaseType : McABTType; (*Defines the basic movement possibilities of the axis*)
	END_STRUCT;
	McCfgAxMoveLimType : STRUCT (*Main data type corresponding to McCfgTypeEnum mcCFG_AX_MOVE_LIM*)
		MovementLimits : McAMLType; (*Various limit values that will be considered for axis movements*)
	END_STRUCT;
END_TYPE