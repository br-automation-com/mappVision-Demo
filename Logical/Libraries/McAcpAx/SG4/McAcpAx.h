/* Automation Studio generated header file */
/* Do not edit ! */
/* McAcpAx 5.10.1 */

#ifndef _MCACPAX_
#define _MCACPAX_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _McAcpAx_VERSION
#define _McAcpAx_VERSION 5.10.1
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif

#ifdef _SG4
#include <McBase.h> 
#include <McAxis.h>
#endif
 
#ifdef _SG3
#include <McBase.h> 
#include <McAxis.h>
#endif
 
#ifdef _SGC
#include <McBase.h> 
#include <McAxis.h>
#endif

/* Datatypes and datatypes of function blocks */
typedef enum McAcpAxDataTypeEnum
{	mcACPAX_PARTYPE_BOOL = 1,
	mcACPAX_PARTYPE_SINT,
	mcACPAX_PARTYPE_INT,
	mcACPAX_PARTYPE_DINT,
	mcACPAX_PARTYPE_USINT,
	mcACPAX_PARTYPE_UINT,
	mcACPAX_PARTYPE_UDINT,
	mcACPAX_PARTYPE_REAL,
	mcACPAX_PARTYPE_VOID = 65535
} McAcpAxDataTypeEnum;

typedef enum McAcpAxProcessParIDModeEnum
{	mcACPAX_PARID_GET = 0,
	mcACPAX_PARID_SET,
	mcACPAX_PARID_GET_NO_NCT
} McAcpAxProcessParIDModeEnum;

typedef enum McAcpAxCycParIDModeEnum
{	mcACPAX_CYCLIC_PARID_READ = 0,
	mcACPAX_CYCLIC_PARID_WRITE
} McAcpAxCycParIDModeEnum;

typedef enum McAcpAxCycParIDRefreshModeEnum
{	mcACPAX_CYCLIC_MULTIPLEXED = 0,
	mcACPAX_CYCLIC_EVERY_RECORD
} McAcpAxCycParIDRefreshModeEnum;

typedef enum McAcpAxTriggerEnum
{	mcACPAX_TRIGGER_1,
	mcACPAX_TRIGGER_2
} McAcpAxTriggerEnum;

typedef enum McAcpAxLimitLoadModeEnum
{	mcACPAX_LL_WITH_FEED_FORWARD = 0,
	mcACPAX_LL_WITHOUT_FEED_FORWARD
} McAcpAxLimitLoadModeEnum;

typedef enum McAcpAxBrakeTestCmdEnum
{	mcACPAX_BRAKE_TEST_INIT = 0,
	mcACPAX_BRAKE_TEST_START = 1,
	mcACPAX_BRAKE_TEST_INIT_START
} McAcpAxBrakeTestCmdEnum;

typedef enum McAcpAxBrakeTestModeEnum
{	mcACPAX_BRAKE_TEST_STANDARD = 0,
	mcACPAX_BRAKE_TEST_SAFETY
} McAcpAxBrakeTestModeEnum;

typedef enum McAcpAxAxisTypeEnum
{	mcACPAX_AXIS_REAL,
	mcACPAX_AXIS_VIRTUAL
} McAcpAxAxisTypeEnum;

typedef enum McAcpAxProductFamilyEnum
{	mcACPAX_ACOPOS,
	mcACPAX_ACOPOS_MULTI,
	mcACPAX_ACOPOS_MICRO,
	mcACPAX_ACOPOS_REMOTE,
	mcACPAX_ACOPOS_MOTOR,
	mcACPAX_ACOPOS_P3
} McAcpAxProductFamilyEnum;

typedef enum McAcpAxModuleTypeEnum
{	mcACPAX_MODULE_INVERTER,
	mcACPAX_MODULE_ACTIVE_SUPPLY,
	mcACPAX_MODULE_PASSIVE_SUPPLY
} McAcpAxModuleTypeEnum;

typedef enum McAcpAxSimulationOnPlcEnum
{	mcACPAX_SIM_STATE_OFF,
	mcACPAX_SIM_STATE_ON,
	mcACPAX_SIM_SET_VALUE_GENERATION,
	mcACPAX_SIM_COMPLETE_CTRL_SYSTEM
} McAcpAxSimulationOnPlcEnum;

typedef enum McAcpAxCtrlModeEnum
{	mcACPAX_CTRL_POSITION = 1,
	mcACPAX_CTRL_POSITION_WITH_FF = 33
} McAcpAxCtrlModeEnum;

typedef enum McAcpAxCtrlParSelectEnum
{	mcACPAX_CTRL_SELECT_ALL_PAR,
	mcACPAX_CTRL_SELECT_POSITION,
	mcACPAX_CTRL_SELECT_SPEED,
	mcACPAX_CTRL_SELECT_FEED_FORWARD,
	mcACPAX_CTRL_SELECT_ADV_PAR_ONLY
} McAcpAxCtrlParSelectEnum;

typedef enum McAcpAxLoopFilterTypeEnum
{	mcACPAX_LOOP_FILTER_NO_TRANSFER,
	mcACPAX_LOOP_FILTER_OFF,
	mcACPAX_LOOP_FILTER_LOWPASS,
	mcACPAX_LOOP_FILTER_NOTCH,
	mcACPAX_LOOP_FILTER_Z_TRANS_FUN,
	mcACPAX_LOOP_FILTER_COMPENSATION,
	mcACPAX_LOOP_FILTER_BIQUAD,
	mcACPAX_LOOP_FILTER_LIM,
	mcACPAX_LOOP_FILTER_LIM_LINEAR,
	mcACPAX_LOOP_FILTER_LIM_R_TIME
} McAcpAxLoopFilterTypeEnum;

typedef enum McAcpAxAutoTuneExSignalEnum
{	mcACPAX_EX_SIGNAL_PRBS = 0,
	mcACPAX_EX_SIGNAL_CHIRP = 1,
	mcACPAX_EX_SIGNAL_CHIRP_TRAPEZ = 2
} McAcpAxAutoTuneExSignalEnum;

typedef enum McAcpAxAutoTuneTestModeEnum
{	mcACPAX_TEST,
	mcACPAX_TEST_POSITION,
	mcACPAX_TEST_SPEED
} McAcpAxAutoTuneTestModeEnum;

typedef enum McAcpAxAutoTuneOrientationEnum
{	mcACPAX_ORIENTATION_HORIZONTAL,
	mcACPAX_ORIENTATION_VERTICAL
} McAcpAxAutoTuneOrientationEnum;

typedef enum McAcpAxFilterTimeModeEnum
{	mcACPAX_FILTER_TIME_USE,
	mcACPAX_FILTER_TIME_TUNE_MODE1,
	mcACPAX_FILTER_TIME_TUNE_MODE2
} McAcpAxFilterTimeModeEnum;

typedef enum McAcpAxLoopFilterModeEnum
{	mcACPAX_LOOP_FILTER_IGNORE,
	mcACPAX_LOOP_FILTER_USE,
	mcACPAX_LOOP_FILTER_TUNE_NOTCH
} McAcpAxLoopFilterModeEnum;

typedef enum McAcpAxIntegrationTimeModeEnum
{	mcACPAX_INTEGRATION_TIME_IGNORE,
	mcACPAX_INTEGRATION_TIME_USE,
	mcACPAX_INTEGRATION_TIME_TUNE
} McAcpAxIntegrationTimeModeEnum;

typedef enum McAcpAxAutoTuneOperatPointEnum
{	mcACPAX_OP_TUNE_STANDSTILL,
	mcACPAX_OP_TUNE_V_CONSTANT
} McAcpAxAutoTuneOperatPointEnum;

typedef enum McAcpAxSimulationModeEnum
{	mcACPAX_SIMULATION_1MASS_AUTO,
	mcACPAX_SIMULATION_1MASS,
	mcACPAX_SIMULATION_2MASS,
	mcACPAX_SIMULATION_SET_GEN_ONLY
} McAcpAxSimulationModeEnum;

typedef enum McAELEnum
{	mcAEL_ONE_ENC = 0,
	mcAEL_TWO_ENC = 1,
	mcAEL_NO_ENC = 10
} McAELEnum;

typedef enum McAELAllEncEnum
{	mcAELAE_ENC_X6A = 0,
	mcAELAE_ENC_X6B = 1,
	mcAELAE_ENC = 2,
	mcAELAE_ENC_SS1X11 = 3,
	mcAELAE_ENC_SS2X11 = 4,
	mcAELAE_ENC_X11A = 5,
	mcAELAE_ENC_SS3X11 = 6,
	mcAELAE_ENC_SS4X11 = 7,
	mcAELAE_ENC_X41 = 8,
	mcAELAE_ENC_SS1X41X = 9,
	mcAELAE_ENC_X42 = 10,
	mcAELAE_ENC_SS1X42X = 11,
	mcAELAE_ENC_X43 = 12,
	mcAELAE_ENC_SS1X43X = 13
} McAELAllEncEnum;

typedef enum McAELTwoEncPosEncCmnScCntDirEnum
{	mcAELTEPECSCD_STD = 0,
	mcAELTEPECSCD_INV = 1
} McAELTwoEncPosEncCmnScCntDirEnum;

typedef enum McACModEnum
{	mcACM_POS_CTRL = 0,
	mcACM_POS_CTRL_TORQ_FF = 1,
	mcACM_V_FREQ_CTRL = 2
} McACModEnum;

typedef enum McACLFSEnum
{	mcACLFS_NOT_USE = 0,
	mcACLFS_LP_2ND_ORD = 1,
	mcACLFS_NOTCH = 2,
	mcACLFS_BIQUAD = 3,
	mcACLFS_DISC_TIME_TRAN_FUN = 4,
	mcACLFS_LIM = 5,
	mcACLFS_LIN_LIM = 6,
	mcACLFS_RISE_TIME_LIM = 7,
	mcACLFS_COMP = 8
} McACLFSEnum;

typedef enum McACLFSLLimEnum
{	mcACLFSLLim_ACP_PARID = 0,
	mcACLFSLLim_FIX_VAL = 1
} McACLFSLLimEnum;

typedef enum McACMPCFFFFwdEnum
{	mcACMPCFFFF_STD = 0,
	mcACMPCFFFF_CYC_VAL_FROM_AX_GRP = 1
} McACMPCFFFFwdEnum;

typedef enum McACMVFCVFTypEnum
{	mcACMVFCVFT_LIN = 129,
	mcACMVFCVFT_CONST_LD_TORQ = 131,
	mcACMVFCVFT_QUAD = 130
} McACMVFCVFTypEnum;

typedef enum McACMVFCVFAutCfgEnum
{	mcACMVFCVFAC_MOT_PAR_BASED = 1,
	mcACMVFCVFAC_NOT_USE = 0
} McACMVFCVFAutCfgEnum;

typedef enum McAHModEnum
{	mcAHM_DIR = 0,
	mcAHM_ABS_SW = 1,
	mcAHM_SW_GATE = 2,
	mcAHM_LIM_SW = 3,
	mcAHM_ABS = 4,
	mcAHM_ABS_CORR = 5,
	mcAHM_DIST_C_MARKS = 6,
	mcAHM_DIST_C_MARKS_CORR = 7,
	mcAHM_BLK_TORQ = 8,
	mcAHM_BLK_LAG_ERR = 9,
	mcAHM_RES_POS = 10,
	mcAHM_NOT_USE = 100
} McAHModEnum;

typedef enum McAHModDirRefPEnum
{	mcAHMDRP_NOT_USE = 0,
	mcAHMDRP_USE = 1
} McAHModDirRefPEnum;

typedef enum McAHModHomeDirEnum
{	mcAHMHD_POS = 0,
	mcAHMHD_NEG = 1
} McAHModHomeDirEnum;

typedef enum McAHModKeepDirEnum
{	mcAHMKD_NO = 0,
	mcAHMKD_YES = 1
} McAHModKeepDirEnum;

typedef enum McAHModSwEdgEnum
{	mcAHMSE_POS = 0,
	mcAHMSE_NEG = 1
} McAHModSwEdgEnum;

typedef enum McAHModRefPEnum
{	mcAHMRP_NOT_USE = 0,
	mcAHMRP_USE = 1
} McAHModRefPEnum;

typedef enum McAHModStartDirEnum
{	mcAHMSD_POS = 0,
	mcAHMSD_NEG = 1
} McAHModStartDirEnum;

typedef enum McASRQstopEnum
{	mcASRQ_DEC_LIM = 0,
	mcASRQ_DEC_LIM_W_JERK_FLTR = 1,
	mcASRQ_TORQ_LIM = 2,
	mcASRQ_INDUCT_HALT = 3
} McASRQstopEnum;

typedef enum McASRDrvErrEnum
{	mcASRDE_DEC_LIM = 0,
	mcASRDE_INDUCT_HALT = 1,
	mcASRDE_COAST_TO_STANDSTILL = 2
} McASRDrvErrEnum;

typedef enum McAMELVelErrMonEnum
{	mcAMELVEM_AUT_1 = 0,
	mcAMELVEM_AUT_2 = 1,
	mcAMELVEM_USRDEF = 2,
	mcAMELVEM_NOT_USE = 3
} McAMELVelErrMonEnum;

typedef enum McAJFEnum
{	mcAJF_NOT_USE = 0,
	mcAJF_USE = 1
} McAJFEnum;

typedef enum McADIAllSrcEnum
{	mcADIAS_NOT_USE = 0,
	mcADIAS_DIG_IN_X8TRG_1 = 1,
	mcADIAS_DIG_IN_X8TRG_2 = 2,
	mcADIAS_DIG_IN_SS1X41X1 = 3,
	mcADIAS_DIG_IN_SS1X41X2 = 4,
	mcADIAS_DIG_IN_SS1X41X3 = 5,
	mcADIAS_DIG_IN_SS1X41X4 = 6,
	mcADIAS_DIG_IN_SS1X41X5 = 7,
	mcADIAS_DIG_IN_SS1X41X6 = 8,
	mcADIAS_DIG_IN_SS1X41X7 = 9,
	mcADIAS_DIG_IN_SS1X41X8 = 10,
	mcADIAS_DIG_IN_SS1X41X9 = 11,
	mcADIAS_DIG_IN_SS1X41X10 = 12
} McADIAllSrcEnum;

typedef enum McADILvlEnum
{	mcADIL_HIGH = 0,
	mcADIL_LOW = 1
} McADILvlEnum;

typedef enum McADIQstopInEnum
{	mcADIQI_TRG_2 = 0,
	mcADIQI_TRG_1 = 1,
	mcADIQI_POS_LIM_SW = 2,
	mcADIQI_NEG_LIM_SW = 3,
	mcADIQI_HOME_SW = 4,
	mcADIQI_NOT_USE = 5
} McADIQstopInEnum;

typedef enum McASPMEnum
{	mcASPM_SET_VAL_GEN = 0,
	mcASPM_COMPL = 1
} McASPMEnum;

typedef enum McASLMEnum
{	mcASLM_ONE_MASS_MOT_BASED = 0,
	mcASLM_ONE_MASS = 1,
	mcASLM_TWO_MASS = 2
} McASLMEnum;

typedef enum McASAMEnum
{	mcASAM_NOT_USE = 0,
	mcASAM_SET_VAL_GEN = 1,
	mcASAM_COMPL = 2
} McASAMEnum;

typedef struct McAcpAxLoopFilterLowPassType
{	float CutOffFrequency;
} McAcpAxLoopFilterLowPassType;

typedef struct McAcpAxLoopFilterNotchType
{	float CenterFrequency;
	float Bandwidth;
} McAcpAxLoopFilterNotchType;

typedef struct McAcpAxLoopFilterZTransFunType
{	float A0;
	float A1;
	float B0;
	float B1;
	float B2;
} McAcpAxLoopFilterZTransFunType;

typedef struct McAcpAxLoopFilterCompType
{	unsigned short MultiplicationFactorParID;
	unsigned short AdditiveValueParID;
} McAcpAxLoopFilterCompType;

typedef struct McAcpAxLoopFilterBiquadType
{	float FrequencyNumerator;
	float DampingNumerator;
	float FrequencyDenominator;
	float DampingDenominator;
} McAcpAxLoopFilterBiquadType;

typedef struct McAcpAxLoopFilterLimType
{	float PositiveLimit;
	float NegativeLimit;
	unsigned short PositiveLimitParID;
	unsigned short NegativeLimitParID;
} McAcpAxLoopFilterLimType;

typedef struct McAcpAxLoopFilterLimLinearType
{	unsigned short InputParID;
	float InputLimit;
	float Gradient;
} McAcpAxLoopFilterLimLinearType;

typedef struct McAcpAxLoopFilterLimRiseTimeType
{	float RiseTime;
	float NormalizedLimit;
} McAcpAxLoopFilterLimRiseTimeType;

typedef struct McAcpAxLoopFilterParType
{	enum McAcpAxLoopFilterTypeEnum Type;
	struct McAcpAxLoopFilterLowPassType LowPass;
	struct McAcpAxLoopFilterNotchType Notch;
	struct McAcpAxLoopFilterZTransFunType ZTransferFunction;
	struct McAcpAxLoopFilterCompType Compensation;
	struct McAcpAxLoopFilterBiquadType Biquad;
	struct McAcpAxLoopFilterLimType Limiter;
	struct McAcpAxLoopFilterLimLinearType LimiterLinear;
	struct McAcpAxLoopFilterLimRiseTimeType LimiterRiseTime;
} McAcpAxLoopFilterParType;

typedef struct McAcpAxAdvCtrlParType
{	struct McAcpAxLoopFilterParType LoopFilter1;
	struct McAcpAxLoopFilterParType LoopFilter2;
	struct McAcpAxLoopFilterParType LoopFilter3;
} McAcpAxAdvCtrlParType;

typedef struct McAcpAxAutoTuneFeedFwdType
{	enum McDirectionEnum Direction;
	enum McAcpAxAutoTuneOrientationEnum Orientation;
	double MaxDistance;
	double MaxPositionError;
	float Velocity;
	float Acceleration;
	float MaxCurrentPercent;
	float MaxVelocityPercent;
} McAcpAxAutoTuneFeedFwdType;

typedef struct McAcpAxFeedForwardParType
{	float TorqueLoad;
	float TorquePositive;
	float TorqueNegative;
	float SpeedTorqueFactor;
	float Inertia;
	float AccelerationFilterTime;
} McAcpAxFeedForwardParType;

typedef struct McAcpAxAutoTuneFeedFwdOutType
{	float Quality;
	struct McAcpAxFeedForwardParType FeedForward;
} McAcpAxAutoTuneFeedFwdOutType;

typedef struct McAcpAxHomingParType
{	enum McHomingModeEnum HomingMode;
	double Position;
	float StartVelocity;
	float HomingVelocity;
	float Acceleration;
	enum McDirectionEnum SwitchEdge;
	enum McDirectionEnum StartDirection;
	enum McDirectionEnum HomingDirection;
	enum McSwitchEnum ReferencePulse;
	enum McSwitchEnum KeepDirection;
	float ReferencePulseBlockingDistance;
	float TorqueLimit;
	float BlockDetectionPositionError;
	float PositionErrorStopLimit;
	unsigned long RestorePositionVariableAddress;
} McAcpAxHomingParType;

typedef struct McAcpAxProcessParIDType
{	unsigned short ParID;
	unsigned long VariableAddress;
	enum McAcpAxDataTypeEnum DataType;
} McAcpAxProcessParIDType;

typedef struct McAcpAxCycParIDType
{	unsigned short ParID;
	unsigned long VariableAddress;
	enum McAcpAxDataTypeEnum DataType;
	enum McAcpAxCycParIDRefreshModeEnum RefreshMode;
} McAcpAxCycParIDType;

typedef struct McAcpAxTriggerStopType
{	enum McAcpAxTriggerEnum TriggerSource;
	enum McEdgeEnum TriggerEdge;
	double TriggerDistance;
	enum McSwitchEnum ForceTriggerDistance;
} McAcpAxTriggerStopType;

typedef struct McAcpAxAdvLimitLoadParType
{	unsigned short LoadPosAccelParID;
	unsigned short LoadPosDecelParID;
	unsigned short LoadNegAccelParID;
	unsigned short LoadNegDecelParID;
} McAcpAxAdvLimitLoadParType;

typedef struct McAcpAxBrakeParType
{	enum McSwitchEnum AutomaticControl;
	enum McSwitchEnum RestrictedBrakeControl;
	enum McSwitchEnum ControlMonitoring;
	enum McSwitchEnum MovementMonitoring;
	enum McSwitchEnum VoltageMonitoring;
	enum McSwitchEnum TestAtPowerOn;
	enum McSwitchEnum TestAtPowerOff;
	enum McSwitchEnum AutomaticInductionStop;
	enum McSwitchEnum EnableSBTRequestBySMC;
	float ControlMonitoringFilterTime;
} McAcpAxBrakeParType;

typedef struct McAcpAxBrakeTestParType
{	enum McAcpAxBrakeTestModeEnum Mode;
	float Torque;
	float Duration;
	double PositionLimit;
} McAcpAxBrakeTestParType;

typedef struct McAcpAxSimulationMass1Type
{	float Inertia;
	float StaticFriction;
	float ViscousFriction;
} McAcpAxSimulationMass1Type;

typedef struct McAcpAxSimulationMass2Type
{	float Inertia;
	float StaticFriction;
	float ViscousFriction;
	float Stiffness;
	float Damping;
} McAcpAxSimulationMass2Type;

typedef struct McAcpAxSimulationParType
{	enum McAcpAxSimulationModeEnum Mode;
	unsigned short AdditiveLoadParID;
	struct McAcpAxSimulationMass1Type Mass1;
	struct McAcpAxSimulationMass2Type Mass2;
} McAcpAxSimulationParType;

typedef struct McAcpAxRestorePosType
{	signed long Data[18];
} McAcpAxRestorePosType;

typedef struct McAcpAxAxisInfoType
{	enum McAcpAxAxisTypeEnum AxisType;
	unsigned long ChannelNumber;
	enum McAcpAxSimulationOnPlcEnum AcoposSimulationOnPlcMode;
} McAcpAxAxisInfoType;

typedef struct McAcpAxModuleInfoType
{	enum McAcpAxProductFamilyEnum ProductFamily;
	enum McAcpAxModuleTypeEnum ModuleType;
	enum McNetworkTypeEnum NetworkType;
	unsigned long NodeNumber;
	enum McAcpAxSimulationOnPlcEnum AcoposSimulationOnPlc;
} McAcpAxModuleInfoType;

typedef struct McAcpAxPosCtrlParType
{	float ProportionalGain;
	float IntegrationTime;
	float PredictionTime;
	float TotalDelayTime;
} McAcpAxPosCtrlParType;

typedef struct McAcpAxSpeedCtrlParType
{	float ProportionalGain;
	float IntegrationTime;
	float FilterTime;
} McAcpAxSpeedCtrlParType;

typedef struct McAcpAxAutoTuneExSignalType
{	enum McAcpAxAutoTuneExSignalEnum SignalType;
	unsigned long SignalOrder;
	float DelayTime;
	float SignalStartFrequency;
	float SignalStopFrequency;
	float SignalTime;
} McAcpAxAutoTuneExSignalType;

typedef struct McAcpAxAutoTuneParType
{	enum McAcpAxAutoTuneOrientationEnum Orientation;
	float MaxCurrentPercent;
	double MaxDistance;
	double MaxPositionError;
} McAcpAxAutoTuneParType;

typedef struct McAcpAxAutoTuneSpeedCtrlOutType
{	float Quality;
	float EstimatedInertia;
	float ProportionalGain;
	float IntegrationTime;
	float FilterTime;
	struct McAcpAxLoopFilterParType LoopFilter1;
} McAcpAxAutoTuneSpeedCtrlOutType;

typedef struct McAcpAxAutoTuneLoopFilterOutType
{	float Quality;
	struct McAcpAxLoopFilterParType LoopFilter1;
	struct McAcpAxLoopFilterParType LoopFilter2;
	struct McAcpAxLoopFilterParType LoopFilter3;
} McAcpAxAutoTuneLoopFilterOutType;

typedef struct McAcpAxAutoTunePosCtrlOutType
{	float Quality;
	float ProportionalGain;
} McAcpAxAutoTunePosCtrlOutType;

typedef struct McAcpAxAutoTuneTestOutType
{	float Quality;
} McAcpAxAutoTuneTestOutType;

typedef struct McAcpAxAutoTuneLoopFiltersType
{	enum McAcpAxLoopFilterModeEnum LoopFilter1Mode;
	enum McAcpAxLoopFilterModeEnum LoopFilter2Mode;
	enum McAcpAxLoopFilterModeEnum LoopFilter3Mode;
} McAcpAxAutoTuneLoopFiltersType;

typedef struct McAcpAxAdvAutoTuneSpeedCtrlType
{	enum McAcpAxLoopFilterModeEnum LoopFilter1Mode;
	enum McAcpAxFilterTimeModeEnum FilterTimeMode;
	enum McAcpAxIntegrationTimeModeEnum IntegrationTimeMode;
	enum McAcpAxAutoTuneOperatPointEnum OperatingPoint;
	float Velocity;
	float Acceleration;
	float MaxProportionalGain;
	float ProportionalGainPercent;
	float ResonanceFactor;
	float InertiaEstimationLowerFrequency;
	float InertiaEstimationUpperFrequency;
	struct McAcpAxAutoTuneExSignalType ExcitationSignal;
} McAcpAxAdvAutoTuneSpeedCtrlType;

typedef struct McAcpAxAdvAutoTuneLoopFilterType
{	enum McAcpAxAutoTuneOperatPointEnum OperatingPoint;
	float Velocity;
	float Acceleration;
	float ResonanceFactor;
	struct McAcpAxAutoTuneExSignalType ExcitationSignal;
} McAcpAxAdvAutoTuneLoopFilterType;

typedef struct McAcpAxAdvAutoTunePosCtrlType
{	enum McAcpAxAutoTuneOperatPointEnum OperatingPoint;
	float Velocity;
	float Acceleration;
	float MaxProportionalGain;
	float ProportionalGainPercent;
	struct McAcpAxAutoTuneExSignalType ExcitationSignal;
} McAcpAxAdvAutoTunePosCtrlType;

typedef struct McAcpAxAdvAutoTuneTestType
{	struct McAcpAxAutoTuneExSignalType ExcitationSignal;
} McAcpAxAdvAutoTuneTestType;

typedef struct McAcpAxAdvCamAutSetParType
{	enum McCamAutParLockCmdEnum ParLock;
} McAcpAxAdvCamAutSetParType;

typedef struct McAcpAxCamAutEventParType
{	enum McCamAutEventTypeEnum Type;
	enum McCamAutEventTransitionEnum Transition;
	enum McSwitchEnum SynchronousUpdate;
	unsigned char NextState;
} McAcpAxCamAutEventParType;

typedef struct McAcpAxCamAutCompParType
{	double MasterCompDistance;
	double SlaveCompDistance;
	double MasterCamLeadIn;
	double MinMasterCompDistance;
	double MinSlaveCompDistance;
	double MaxSlaveCompDistance;
	float MinSlaveCompVelocity;
	float MaxSlaveCompVelocity;
	float MaxSlaveCompAccel1;
	float MaxSlaveCompAccel2;
	float SlaveCompJoltTime;
} McAcpAxCamAutCompParType;

typedef struct McAcpAxCamAutAdvStateParType
{	unsigned short RepeatCounterInit;
	enum McSwitchEnum RepeatCounterSetTransfer;
	unsigned short RepeatCounterSet;
	struct McAxisType* MasterAxis;
	unsigned short MasterParID;
} McAcpAxCamAutAdvStateParType;

typedef struct McAcpAxCamAutStateParType
{	unsigned short CamID;
	signed long MasterFactor;
	signed long SlaveFactor;
	enum McCamAutCompModeEnum CompensationMode;
	struct McAcpAxCamAutCompParType CompensationParameters;
	struct McAcpAxCamAutAdvStateParType AdvancedParameters;
	struct McAcpAxCamAutEventParType Event[5];
} McAcpAxCamAutStateParType;

typedef struct McAcpAxCamAutCtrlSettingsType
{	enum McCamAutCrossLeftBoundEnum CrossLeftBoundary;
	enum McCamAutCamChangeImmedEnum CamChangeImmediately;
} McAcpAxCamAutCtrlSettingsType;

typedef struct McAcpAxCamAutMsgSettingsType
{	enum McCamAutErrorsInStandbyEnum ErrorsInStandby;
	enum McCamAutExceedingLimitsEnum ExceedingLimits;
} McAcpAxCamAutMsgSettingsType;

typedef struct McAcpAxCamAutTriggerAndLatchType
{	float Trigger1Delay;
	float Trigger2Delay;
	unsigned short SlaveLatchParID;
} McAcpAxCamAutTriggerAndLatchType;

typedef struct McAcpAxCamAutStartStateParType
{	unsigned char StartState;
	double MasterStartRelPos;
} McAcpAxCamAutStartStateParType;

typedef struct McAcpAxCamAutAddAxesType
{	struct McAxisType* AdditiveMasterAxis;
	unsigned short AdditiveMasterParID;
	struct McAxisType* AdditiveSlaveAxis;
	unsigned short AdditiveSlaveParID;
} McAcpAxCamAutAddAxesType;

typedef struct McAcpAxCamAutCommonFactorsType
{	unsigned short SlaveFactorParID;
} McAcpAxCamAutCommonFactorsType;

typedef struct McAcpAxCamAutAdvParType
{	struct McAcpAxCamAutStartStateParType StartStateParam;
	struct McAcpAxCamAutAddAxesType AdditiveAxes;
	enum McCamAutMaStartPosModeEnum MasterStartPosMode;
	struct McAcpAxCamAutCtrlSettingsType ControlSettings;
	struct McAcpAxCamAutMsgSettingsType MessageSettings;
	struct McAcpAxCamAutTriggerAndLatchType TriggerAndLatch;
	unsigned short EventParID1;
	unsigned short EventParID2;
	unsigned short EventParID3;
	unsigned short EventParID4;
	double StartIntervalPos1;
	double StartIntervalPos2;
	double StartIntervalPos3;
	double StartIntervalPos4;
	struct McAcpAxCamAutCommonFactorsType Factors;
} McAcpAxCamAutAdvParType;

typedef struct McAcpAxCamAutMasterParType
{	struct McAxisType* MasterAxis;
	unsigned short MasterParID;
	double MasterStartPosition;
	double MasterStartInterval;
	float MaxMasterVelocity;
} McAcpAxCamAutMasterParType;

typedef struct McAcpAxCamAutCommonParType
{	struct McAcpAxCamAutMasterParType Master;
	struct McAcpAxCamAutAdvParType AdvancedParameters;
} McAcpAxCamAutCommonParType;

typedef struct McAcpAxCamAutParType
{	struct McAcpAxCamAutCommonParType Common;
	struct McAcpAxCamAutStateParType State[15];
} McAcpAxCamAutParType;

typedef struct McAcpAxCamAutDefineType
{	plcstring DataObjectName[33];
	unsigned long DataAddress;
} McAcpAxCamAutDefineType;

typedef struct McAcpAxAdvPhasingParType
{	unsigned short VelocityParID;
	unsigned short PosVelocityTriggerParID;
	unsigned short NegVelocityTriggerParID;
} McAcpAxAdvPhasingParType;

typedef struct McAcpAxAdvOffsetParType
{	unsigned short VelocityParID;
	unsigned short PosVelocityTriggerParID;
	unsigned short NegVelocityTriggerParID;
} McAcpAxAdvOffsetParType;

typedef struct McAcpAxLoadSimInputDataType
{	double Position;
	float Velocity;
	float Acceleration;
} McAcpAxLoadSimInputDataType;

typedef struct McAcpAxCtrlParType
{	enum McAcpAxCtrlModeEnum Mode;
	struct McAcpAxPosCtrlParType PositionController;
	struct McAcpAxSpeedCtrlParType SpeedController;
	struct McAcpAxFeedForwardParType FeedForward;
	enum McAcpAxCtrlParSelectEnum ParameterSelector;
} McAcpAxCtrlParType;

typedef struct McAcpAxAdvAutoTuneFeedFwdType
{	struct McAcpAxAutoTuneExSignalType ExcitationSignal;
} McAcpAxAdvAutoTuneFeedFwdType;

typedef struct McAMEType
{	struct McCfgGearBoxType Gearbox;
	struct McCfgRotToLinTrfType RotaryToLinearTransformation;
} McAMEType;

typedef struct McAELOneEncMotAndPosEncType
{	enum McAELAllEncEnum Type;
} McAELOneEncMotAndPosEncType;

typedef struct McAELOneEncType
{	struct McAELOneEncMotAndPosEncType MotorAndPositionEncoder;
} McAELOneEncType;

typedef struct McAELTwoEncMotEncType
{	enum McAELAllEncEnum Type;
} McAELTwoEncMotEncType;

typedef struct McAELTwoEncPosEncCmnScType
{	struct McCfgGearBoxType Gearbox;
	struct McCfgRotToLinTrfType RotaryToLinearTransformation;
	enum McAELTwoEncPosEncCmnScCntDirEnum CountDirection;
} McAELTwoEncPosEncCmnScType;

typedef struct McAELTwoEncPosEncCmnType
{	struct McAELTwoEncPosEncCmnScType Scaling;
} McAELTwoEncPosEncCmnType;

typedef struct McAELTwoEncPosEncType
{	enum McAELAllEncEnum Type;
	struct McAELTwoEncPosEncCmnType Common;
} McAELTwoEncPosEncType;

typedef struct McAELTwoEncType
{	struct McAELTwoEncMotEncType MotorEncoder;
	struct McAELTwoEncPosEncType PositionEncoder;
	float PositionDifferenceLimit;
} McAELTwoEncType;

typedef struct McAELType
{	enum McAELEnum Type;
	struct McAELOneEncType OneEncoder;
	struct McAELTwoEncType TwoEncoders;
} McAELType;

typedef struct McACPCType
{	float ProportionalGain;
	float IntegrationTime;
	float PredictionTime;
	float TotalDelayTime;
} McACPCType;

typedef struct McACSCType
{	float ProportionalGain;
	float IntegrationTime;
	float FilterTime;
} McACSCType;

typedef struct McACLFSLP2ndOrdType
{	float CutOffFrequency;
} McACLFSLP2ndOrdType;

typedef struct McACLFSNotchType
{	float CenterFrequency;
	float Bandwidth;
} McACLFSNotchType;

typedef struct McACLFSBiquadType
{	float FrequencyNumerator;
	float DampingNumerator;
	float FrequencyDenominator;
	float DampingDenominator;
} McACLFSBiquadType;

typedef struct McACLFSDiscTimeTranFunType
{	float a0DenominatorPolynomial;
	float a1DenominatorPolynomial;
	float b0NumeratorPolynomial;
	float b1NumeratorPolynomial;
	float b2NumeratorPolynomial;
} McACLFSDiscTimeTranFunType;

typedef struct McACLFSLLimAcpParIDType
{	unsigned short ParID;
} McACLFSLLimAcpParIDType;

typedef struct McACLFSLLimFixValType
{	float Value;
} McACLFSLLimFixValType;

typedef struct McACLFSLLimType
{	enum McACLFSLLimEnum Type;
	struct McACLFSLLimAcpParIDType ACOPOSParID;
	struct McACLFSLLimFixValType FixedValue;
} McACLFSLLimType;

typedef struct McACLFSLimType
{	struct McACLFSLLimType PositiveLimit;
	struct McACLFSLLimType NegativeLimit;
} McACLFSLimType;

typedef struct McACLFSLinLimType
{	unsigned short InputParID;
	float InputLimit;
	float Gradient;
} McACLFSLinLimType;

typedef struct McACLFSRiseTimeLimType
{	float RiseTime;
	float NormalizedLimit;
} McACLFSRiseTimeLimType;

typedef struct McACLFSCompType
{	unsigned short MultiplicationFactorParID;
	unsigned short AdditiveValueParID;
} McACLFSCompType;

typedef struct McACLFSType
{	enum McACLFSEnum Type;
	struct McACLFSLP2ndOrdType Lowpass2ndOrder;
	struct McACLFSNotchType Notch;
	struct McACLFSBiquadType Biquad;
	struct McACLFSDiscTimeTranFunType DiscreteTimeTransferFunction;
	struct McACLFSLimType Limiter;
	struct McACLFSLinLimType LinearLimitation;
	struct McACLFSRiseTimeLimType RiseTimeLimitation;
	struct McACLFSCompType Compensation;
} McACLFSType;

typedef struct McACLFType
{	struct McACLFSType LoopFilter[3];
} McACLFType;

typedef struct McACMPCType
{	struct McACPCType Position;
	struct McACSCType Speed;
	struct McACLFType LoopFilters;
} McACMPCType;

typedef struct McACPCFFType
{	float ProportionalGain;
	float IntegrationTime;
	float TotalDelayTime;
} McACPCFFType;

typedef struct McACMPCFFFFwdStdType
{	float TorqueLoad;
	float TorquePositive;
	float TorqueNegative;
	float SpeedTorqueFactor;
	float Inertia;
	float AccelerationFilterTime;
} McACMPCFFFFwdStdType;

typedef struct McACMPCFFFFwdType
{	enum McACMPCFFFFwdEnum Type;
	struct McACMPCFFFFwdStdType Standard;
} McACMPCFFFFwdType;

typedef struct McACMPCFFType
{	struct McACPCFFType Position;
	struct McACSCType Speed;
	struct McACMPCFFFFwdType FeedForward;
	struct McACLFType LoopFilters;
} McACMPCFFType;

typedef struct McACMVFCVFAutCfgNotUseType
{	float BoostVoltage;
	float RatedVoltage;
	float RatedFrequency;
} McACMVFCVFAutCfgNotUseType;

typedef struct McACMVFCVFAutCfgType
{	enum McACMVFCVFAutCfgEnum Type;
	struct McACMVFCVFAutCfgNotUseType NotUsed;
} McACMVFCVFAutCfgType;

typedef struct McACMVFCVFType
{	enum McACMVFCVFTypEnum Type;
	struct McACMVFCVFAutCfgType AutomaticConfiguration;
	float SlipCompensation;
	float TotalDelayTime;
} McACMVFCVFType;

typedef struct McACMVFCType
{	struct McACMVFCVFType VoltageFrequency;
} McACMVFCType;

typedef struct McACModType
{	enum McACModEnum Type;
	struct McACMPCType PositionController;
	struct McACMPCFFType PositionControllerTorqueFf;
	struct McACMVFCType VoltageFrequencyControl;
} McACModType;

typedef struct McACType
{	struct McACModType Mode;
} McACType;

typedef struct McAHModDirRefPUseType
{	float HomingVelocity;
	float Acceleration;
	enum McAHModHomeDirEnum HomingDirection;
	enum McAHModKeepDirEnum KeepDirection;
	double ReferencePulseBlockingDistance;
} McAHModDirRefPUseType;

typedef struct McAHModDirRefPType
{	enum McAHModDirRefPEnum Type;
	struct McAHModDirRefPUseType Used;
} McAHModDirRefPType;

typedef struct McAHModDirType
{	double Position;
	struct McAHModDirRefPType ReferencePulse;
} McAHModDirType;

typedef struct McAHModRefPUseType
{	double ReferencePulseBlockingDistance;
} McAHModRefPUseType;

typedef struct McAHModRefPType
{	enum McAHModRefPEnum Type;
	struct McAHModRefPUseType Used;
} McAHModRefPType;

typedef struct McAHModAbsSwType
{	double Position;
	float StartVelocity;
	float HomingVelocity;
	float Acceleration;
	enum McAHModSwEdgEnum SwitchEdge;
	enum McAHModHomeDirEnum HomingDirection;
	enum McAHModKeepDirEnum KeepDirection;
	struct McAHModRefPType ReferencePulse;
} McAHModAbsSwType;

typedef struct McAHModSwGateType
{	double Position;
	float StartVelocity;
	float HomingVelocity;
	float Acceleration;
	enum McAHModSwEdgEnum SwitchEdge;
	enum McAHModStartDirEnum StartDirection;
	enum McAHModHomeDirEnum HomingDirection;
	enum McAHModKeepDirEnum KeepDirection;
	struct McAHModRefPType ReferencePulse;
} McAHModSwGateType;

typedef struct McAHModLimSwType
{	double Position;
	float StartVelocity;
	float HomingVelocity;
	float Acceleration;
	enum McAHModSwEdgEnum SwitchEdge;
	enum McAHModHomeDirEnum HomingDirection;
	enum McAHModKeepDirEnum KeepDirection;
	struct McAHModRefPType ReferencePulse;
} McAHModLimSwType;

typedef struct McAHModAbsType
{	double Position;
} McAHModAbsType;

typedef struct McAHModAbsCorrType
{	double Position;
} McAHModAbsCorrType;

typedef struct McAHModDistCMarksType
{	double Position;
	float HomingVelocity;
	float Acceleration;
	enum McAHModHomeDirEnum HomingDirection;
	enum McAHModKeepDirEnum KeepDirection;
} McAHModDistCMarksType;

typedef struct McAHModDistCMarksCorrType
{	double Position;
	float HomingVelocity;
	float Acceleration;
	enum McAHModHomeDirEnum HomingDirection;
	enum McAHModKeepDirEnum KeepDirection;
} McAHModDistCMarksCorrType;

typedef struct McAHModBlkTorqType
{	double Position;
	float StartVelocity;
	float HomingVelocity;
	float Acceleration;
	enum McAHModStartDirEnum StartDirection;
	enum McAHModHomeDirEnum HomingDirection;
	struct McAHModRefPType ReferencePulse;
	float TorqueLimit;
	double PositionErrorStopLimit;
} McAHModBlkTorqType;

typedef struct McAHModBlkLagErrType
{	double Position;
	float StartVelocity;
	float HomingVelocity;
	float Acceleration;
	enum McAHModStartDirEnum StartDirection;
	enum McAHModHomeDirEnum HomingDirection;
	struct McAHModRefPType ReferencePulse;
	float TorqueLimit;
	double PositionErrorStopLimit;
	double BlockDetectionPositionError;
} McAHModBlkLagErrType;

typedef struct McAHModType
{	enum McAHModEnum Type;
	struct McAHModDirType Direct;
	struct McAHModAbsSwType AbsoluteSwitch;
	struct McAHModSwGateType SwitchGate;
	struct McAHModLimSwType LimitSwitch;
	struct McAHModAbsType Absolute;
	struct McAHModAbsCorrType AbsoluteCorrection;
	struct McAHModDistCMarksType DistanceCodedMarks;
	struct McAHModDistCMarksCorrType DistanceCodedMarksCorrection;
	struct McAHModBlkTorqType BlockTorque;
	struct McAHModBlkLagErrType BlockLagError;
} McAHModType;

typedef struct McAHType
{	struct McAHModType Mode;
	plcstring RestorePositionVariable[251];
} McAHType;

typedef struct McASRQstopDecLimWJerkFltrType
{	float JerkTime;
} McASRQstopDecLimWJerkFltrType;

typedef struct McASRQstopType
{	enum McASRQstopEnum Type;
	struct McASRQstopDecLimWJerkFltrType DecelerationLimitWithJerkFilter;
} McASRQstopType;

typedef struct McASRDrvErrType
{	enum McASRDrvErrEnum Type;
} McASRDrvErrType;

typedef struct McASRType
{	struct McASRQstopType Quickstop;
	struct McASRDrvErrType DriveError;
} McASRType;

typedef struct McAMELVelErrMonUsrDefType
{	float VelocityError;
} McAMELVelErrMonUsrDefType;

typedef struct McAMELVelErrMonType
{	enum McAMELVelErrMonEnum Type;
	struct McAMELVelErrMonUsrDefType UserDefined;
} McAMELVelErrMonType;

typedef struct McAMELType
{	double PositionError;
	struct McAMELVelErrMonType VelocityErrorMonitoring;
} McAMELType;

typedef struct McAJFUseType
{	float JerkTime;
} McAJFUseType;

typedef struct McAJFType
{	enum McAJFEnum Type;
	struct McAJFUseType Used;
} McAJFType;

typedef struct McADIHomeSwSrcType
{	enum McADIAllSrcEnum Type;
} McADIHomeSwSrcType;

typedef struct McADIHomeSwType
{	struct McADIHomeSwSrcType Source;
	enum McADILvlEnum Level;
} McADIHomeSwType;

typedef struct McADIPosLimSwSrcType
{	enum McADIAllSrcEnum Type;
} McADIPosLimSwSrcType;

typedef struct McADIPosLimSwType
{	struct McADIPosLimSwSrcType Source;
	enum McADILvlEnum Level;
} McADIPosLimSwType;

typedef struct McADINegLimSwSrcType
{	enum McADIAllSrcEnum Type;
} McADINegLimSwSrcType;

typedef struct McADINegLimSwType
{	struct McADINegLimSwSrcType Source;
	enum McADILvlEnum Level;
} McADINegLimSwType;

typedef struct McADITrg1SrcType
{	enum McADIAllSrcEnum Type;
} McADITrg1SrcType;

typedef struct McADITrg1Type
{	struct McADITrg1SrcType Source;
	enum McADILvlEnum Level;
} McADITrg1Type;

typedef struct McADITrg2SrcType
{	enum McADIAllSrcEnum Type;
} McADITrg2SrcType;

typedef struct McADITrg2Type
{	struct McADITrg2SrcType Source;
	enum McADILvlEnum Level;
} McADITrg2Type;

typedef struct McADIQstopType
{	enum McADIQstopInEnum Input;
} McADIQstopType;

typedef struct McADIType
{	struct McADIHomeSwType HomingSwitch;
	struct McADIPosLimSwType PositiveLimitSwitch;
	struct McADINegLimSwType NegativeLimitSwitch;
	struct McADITrg1Type Trigger1;
	struct McADITrg2Type Trigger2;
	struct McADIQstopType Quickstop;
} McADIType;

typedef struct McASLMOneMassMotBasedType
{	unsigned short AdditiveLoadParID;
} McASLMOneMassMotBasedType;

typedef struct McASLMOneMassType
{	float Inertia;
	float StaticFriction;
	float ViscousFriction;
	unsigned short AdditiveLoadParID;
} McASLMOneMassType;

typedef struct McASLMTwoMassMass1Type
{	float Inertia;
	float StaticFriction;
	float ViscousFriction;
} McASLMTwoMassMass1Type;

typedef struct McASLMTwoMassMass2Type
{	float Inertia;
	float StaticFriction;
	float ViscousFriction;
	float Stiffness;
	float Damping;
	unsigned short AdditiveLoadParID;
} McASLMTwoMassMass2Type;

typedef struct McASLMTwoMassType
{	struct McASLMTwoMassMass1Type Mass1;
	struct McASLMTwoMassMass2Type Mass2;
} McASLMTwoMassType;

typedef struct McASLMType
{	enum McASLMEnum Type;
	struct McASLMOneMassMotBasedType OneMassMotorBased;
	struct McASLMOneMassType OneMass;
	struct McASLMTwoMassType TwoMasses;
} McASLMType;

typedef struct McASPMComplType
{	struct McASLMType LoadModel;
} McASPMComplType;

typedef struct McASPMType
{	enum McASPMEnum Type;
	struct McASPMComplType Complete;
} McASPMType;

typedef struct McASAMComplType
{	struct McASLMType LoadModel;
} McASAMComplType;

typedef struct McASAMType
{	enum McASAMEnum Type;
	struct McASAMComplType Complete;
} McASAMType;

typedef struct McASType
{	struct McASPMType ModeOnPLC;
	struct McASAMType ModeOnACOPOS;
} McASType;

typedef struct McAAFType
{	struct McCfgUnboundedArrayType FeatureReference;
} McAAFType;

typedef struct McCfgAcpAxType
{	struct McCfgReferenceType AxisReference;
	struct McAMEType MechanicalElements;
	struct McAELType EncoderLink;
	struct McACType Controller;
	struct McAHType Homing;
	struct McASRType StopReaction;
	struct McAMELType MovementErrorLimits;
	struct McAJFType JerkFilter;
	struct McADIType DigitalInputs;
	struct McASType Simulation;
	struct McAAFType AxisFeatures;
} McCfgAcpAxType;

typedef struct McCfgAcpAxRefType
{	struct McCfgReferenceType AxisReference;
} McCfgAcpAxRefType;

typedef struct McCfgAcpMechElmType
{	struct McAMEType MechanicalElements;
} McCfgAcpMechElmType;

typedef struct McCfgAcpEncLinkType
{	struct McAELType EncoderLink;
} McCfgAcpEncLinkType;

typedef struct McCfgAcpCtrlType
{	struct McACType Controller;
} McCfgAcpCtrlType;

typedef struct McCfgAcpHomeType
{	struct McAHType Homing;
} McCfgAcpHomeType;

typedef struct McCfgAcpStopReacType
{	struct McASRType StopReaction;
} McCfgAcpStopReacType;

typedef struct McCfgAcpMoveErrLimType
{	struct McAMELType MovementErrorLimits;
} McCfgAcpMoveErrLimType;

typedef struct McCfgAcpJerkFltrType
{	struct McAJFType JerkFilter;
} McCfgAcpJerkFltrType;

typedef struct McCfgAcpDigInType
{	struct McADIType DigitalInputs;
} McCfgAcpDigInType;

typedef struct McCfgAcpSimType
{	struct McASType Simulation;
} McCfgAcpSimType;

typedef struct McCfgAcpAxFeatType
{	struct McAAFType AxisFeatures;
} McCfgAcpAxFeatType;

typedef struct MC_BR_ControllerSetPar_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	struct McAcpAxCtrlParType Parameters;
	struct McAcpAxAdvCtrlParType AdvancedParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} MC_BR_ControllerSetPar_AcpAx_typ;

typedef struct MC_BR_AutoTuneFeedForward_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	struct McAcpAxAutoTuneFeedFwdType Parameters;
	struct McAcpAxAdvAutoTuneFeedFwdType AdvancedParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcpAxAutoTuneFeedFwdOutType Output;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AutoTuneFeedForward_AcpAx_typ;

typedef struct MC_BR_InitHome_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	struct McAcpAxHomingParType HomingParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} MC_BR_InitHome_AcpAx_typ;

typedef struct MC_BR_ProcessParID_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	unsigned long DataAddress;
	unsigned long NumberOfParIDs;
	enum McAcpAxProcessParIDModeEnum Mode;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} MC_BR_ProcessParID_AcpAx_typ;

typedef struct MC_BR_CyclicProcessParID_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	unsigned long DataAddress;
	unsigned long NumberOfParIDs;
	enum McAcpAxCycParIDModeEnum Mode;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_CyclicProcessParID_AcpAx_typ;

typedef struct MC_BR_MoveAbsoluteTrgStop_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	double Position;
	float Velocity;
	float Acceleration;
	float Deceleration;
	enum McDirectionEnum Direction;
	enum McBufferModeEnum BufferMode;
	struct McAcpAxTriggerStopType TriggerStopParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Active;
	plcbit CommandAborted;
	plcbit Error;
	plcbit StoppedAtTargetPosition;
} MC_BR_MoveAbsoluteTrgStop_AcpAx_typ;

typedef struct MC_BR_MoveAdditiveTrgStop_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	double Distance;
	float Velocity;
	float Acceleration;
	float Deceleration;
	enum McBufferModeEnum BufferMode;
	struct McAcpAxTriggerStopType TriggerStopParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Active;
	plcbit CommandAborted;
	plcbit Error;
	plcbit StoppedAtTargetPosition;
} MC_BR_MoveAdditiveTrgStop_AcpAx_typ;

typedef struct MC_BR_MoveVelocityTrgStop_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	float Velocity;
	float Acceleration;
	float Deceleration;
	enum McDirectionEnum Direction;
	enum McBufferModeEnum BufferMode;
	struct McAcpAxTriggerStopType TriggerStopParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Active;
	plcbit CommandAborted;
	plcbit Error;
	plcbit InVelocity;
} MC_BR_MoveVelocityTrgStop_AcpAx_typ;

typedef struct MC_BR_LimitLoad_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	float LoadPosAccel;
	float LoadPosDecel;
	float LoadNegAccel;
	float LoadNegDecel;
	enum McAcpAxLimitLoadModeEnum Mode;
	struct McAcpAxAdvLimitLoadParType AdvancedParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit InitData;
	/* VAR_OUTPUT (digital) */
	plcbit Busy;
	plcbit Ready;
	plcbit Active;
	plcbit Error;
	plcbit DataInitialized;
} MC_BR_LimitLoad_AcpAx_typ;

typedef struct MC_BR_BrakeSetPar_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	struct McAcpAxBrakeParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} MC_BR_BrakeSetPar_AcpAx_typ;

typedef struct MC_BR_BrakeTest_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	enum McAcpAxBrakeTestCmdEnum Command;
	struct McAcpAxBrakeTestParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	double PositionError;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} MC_BR_BrakeTest_AcpAx_typ;

typedef struct MC_BR_LoadSimulationSetPar_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	struct McAcpAxSimulationParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} MC_BR_LoadSimulationSetPar_AcpAx_typ;

typedef struct MC_BR_LoadSimulationGetPar_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcpAxSimulationParType Parameters;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} MC_BR_LoadSimulationGetPar_AcpAx_typ;

typedef struct MC_BR_GetDriveInfo_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcpAxAxisInfoType AxisInfo;
	struct McAcpAxModuleInfoType ModuleInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} MC_BR_GetDriveInfo_AcpAx_typ;

typedef struct MC_BR_AutoTuneSpeedCtrl_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	struct McAcpAxAutoTuneParType Parameters;
	struct McAcpAxAdvAutoTuneSpeedCtrlType AdvancedParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcpAxAutoTuneSpeedCtrlOutType Output;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AutoTuneSpeedCtrl_AcpAx_typ;

typedef struct MC_BR_AutoTuneLoopFilters_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	struct McAcpAxAutoTuneLoopFiltersType LoopFilters;
	struct McAcpAxAutoTuneParType Parameters;
	struct McAcpAxAdvAutoTuneLoopFilterType AdvancedParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcpAxAutoTuneLoopFilterOutType Output;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AutoTuneLoopFilters_AcpAx_typ;

typedef struct MC_BR_AutoTunePositionCtrl_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	struct McAcpAxAutoTuneParType Parameters;
	struct McAcpAxAdvAutoTunePosCtrlType AdvancedParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcpAxAutoTunePosCtrlOutType Output;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AutoTunePositionCtrl_AcpAx_typ;

typedef struct MC_BR_AutoTuneTest_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	enum McAcpAxAutoTuneTestModeEnum Mode;
	struct McAcpAxAutoTuneParType Parameters;
	struct McAcpAxAdvAutoTuneTestType AdvancedParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcpAxAutoTuneTestOutType Output;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AutoTuneTest_AcpAx_typ;

typedef struct MC_BR_CamAutomatSetPar_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Slave;
	enum McCamAutSetParCmdEnum Command;
	struct McAcpAxCamAutDefineType CamAutomat;
	struct McAcpAxAdvCamAutSetParType AdvancedParameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} MC_BR_CamAutomatSetPar_AcpAx_typ;

typedef struct MC_BR_CamAutomatGetPar_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Slave;
	enum McCamAutGetParCmdEnum Command;
	struct McAcpAxCamAutDefineType CamAutomat;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} MC_BR_CamAutomatGetPar_AcpAx_typ;

typedef struct MC_BR_PhasingVelocity_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Slave;
	float Acceleration;
	struct McAcpAxAdvPhasingParType AdvancedParameters;
	float CyclicVelocity;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	double ActualPhaseShift;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
	plcbit VelocityAttained;
} MC_BR_PhasingVelocity_AcpAx_typ;

typedef struct MC_BR_OffsetVelocity_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Slave;
	float Acceleration;
	struct McAcpAxAdvPhasingParType AdvancedParameters;
	float CyclicVelocity;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	double ActualOffsetShift;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
	plcbit VelocityAttained;
} MC_BR_OffsetVelocity_AcpAx_typ;

typedef struct MC_BR_WrLoadSimTorque_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	float Torque;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_WrLoadSimTorque_AcpAx_typ;

typedef struct MC_BR_RdLoadSimTorque_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	float Torque;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_RdLoadSimTorque_AcpAx_typ;

typedef struct MC_BR_WrLoadSimPosition_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	double Position;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_WrLoadSimPosition_AcpAx_typ;

typedef struct MC_BR_WrLoadSimTwoEncPos_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	double MotorPosition;
	double LoadPosition;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_WrLoadSimTwoEncPos_AcpAx_typ;

typedef struct MC_BR_RdLoadSimInputData_AcpAx
{
	/* VAR_INPUT (analog) */
	struct McAxisType* Axis;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcpAxLoadSimInputDataType LoadSimInputData;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_RdLoadSimInputData_AcpAx_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void MC_BR_ControllerSetPar_AcpAx(struct MC_BR_ControllerSetPar_AcpAx* inst);
_BUR_PUBLIC void MC_BR_AutoTuneFeedForward_AcpAx(struct MC_BR_AutoTuneFeedForward_AcpAx* inst);
_BUR_PUBLIC void MC_BR_InitHome_AcpAx(struct MC_BR_InitHome_AcpAx* inst);
_BUR_PUBLIC void MC_BR_ProcessParID_AcpAx(struct MC_BR_ProcessParID_AcpAx* inst);
_BUR_PUBLIC void MC_BR_CyclicProcessParID_AcpAx(struct MC_BR_CyclicProcessParID_AcpAx* inst);
_BUR_PUBLIC void MC_BR_MoveAbsoluteTrgStop_AcpAx(struct MC_BR_MoveAbsoluteTrgStop_AcpAx* inst);
_BUR_PUBLIC void MC_BR_MoveAdditiveTrgStop_AcpAx(struct MC_BR_MoveAdditiveTrgStop_AcpAx* inst);
_BUR_PUBLIC void MC_BR_MoveVelocityTrgStop_AcpAx(struct MC_BR_MoveVelocityTrgStop_AcpAx* inst);
_BUR_PUBLIC void MC_BR_LimitLoad_AcpAx(struct MC_BR_LimitLoad_AcpAx* inst);
_BUR_PUBLIC void MC_BR_BrakeSetPar_AcpAx(struct MC_BR_BrakeSetPar_AcpAx* inst);
_BUR_PUBLIC void MC_BR_BrakeTest_AcpAx(struct MC_BR_BrakeTest_AcpAx* inst);
_BUR_PUBLIC void MC_BR_LoadSimulationSetPar_AcpAx(struct MC_BR_LoadSimulationSetPar_AcpAx* inst);
_BUR_PUBLIC void MC_BR_LoadSimulationGetPar_AcpAx(struct MC_BR_LoadSimulationGetPar_AcpAx* inst);
_BUR_PUBLIC void MC_BR_GetDriveInfo_AcpAx(struct MC_BR_GetDriveInfo_AcpAx* inst);
_BUR_PUBLIC void MC_BR_AutoTuneSpeedCtrl_AcpAx(struct MC_BR_AutoTuneSpeedCtrl_AcpAx* inst);
_BUR_PUBLIC void MC_BR_AutoTuneLoopFilters_AcpAx(struct MC_BR_AutoTuneLoopFilters_AcpAx* inst);
_BUR_PUBLIC void MC_BR_AutoTunePositionCtrl_AcpAx(struct MC_BR_AutoTunePositionCtrl_AcpAx* inst);
_BUR_PUBLIC void MC_BR_AutoTuneTest_AcpAx(struct MC_BR_AutoTuneTest_AcpAx* inst);
_BUR_PUBLIC void MC_BR_CamAutomatSetPar_AcpAx(struct MC_BR_CamAutomatSetPar_AcpAx* inst);
_BUR_PUBLIC void MC_BR_CamAutomatGetPar_AcpAx(struct MC_BR_CamAutomatGetPar_AcpAx* inst);
_BUR_PUBLIC void MC_BR_PhasingVelocity_AcpAx(struct MC_BR_PhasingVelocity_AcpAx* inst);
_BUR_PUBLIC void MC_BR_OffsetVelocity_AcpAx(struct MC_BR_OffsetVelocity_AcpAx* inst);
_BUR_PUBLIC void MC_BR_WrLoadSimTorque_AcpAx(struct MC_BR_WrLoadSimTorque_AcpAx* inst);
_BUR_PUBLIC void MC_BR_RdLoadSimTorque_AcpAx(struct MC_BR_RdLoadSimTorque_AcpAx* inst);
_BUR_PUBLIC void MC_BR_WrLoadSimPosition_AcpAx(struct MC_BR_WrLoadSimPosition_AcpAx* inst);
_BUR_PUBLIC void MC_BR_WrLoadSimTwoEncPos_AcpAx(struct MC_BR_WrLoadSimTwoEncPos_AcpAx* inst);
_BUR_PUBLIC void MC_BR_RdLoadSimInputData_AcpAx(struct MC_BR_RdLoadSimInputData_AcpAx* inst);


#ifdef __cplusplus
};
#endif
#endif /* _MCACPAX_ */

