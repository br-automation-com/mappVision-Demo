/* Automation Studio generated header file */
/* Do not edit ! */
/* MTData 5.22.0 */

#ifndef _MTDATA_
#define _MTDATA_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _MTData_VERSION
#define _MTData_VERSION 5.22.0
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "MTTypes.h"
		#include "astime.h"
		#include "sys_lib.h"
		#include "brsystem.h"
#endif

#ifdef _SG4
		#include "MTTypes.h"
		#include "astime.h"
		#include "sys_lib.h"
		#include "brsystem.h"
#endif

#ifdef _SGC
		#include "MTTypes.h"
		#include "astime.h"
		#include "sys_lib.h"
		#include "brsystem.h"
#endif



/* Constants */
#ifdef _REPLACE_CONST
 #define mtBCD_WRN_DATA_WINDOW_INVALID (-2131753988)
 #define mtBCD_ERR_LIMITS_INVALID (-1058012162)
 #define mtBCD_ERR_DATA_WINDOW_INVALID (-1058012163)
 #define mtBCD_ERR_DATA_NB_VALUES_HIGH (-1058012164)
#else
 _GLOBAL_CONST signed long mtBCD_WRN_DATA_WINDOW_INVALID;
 _GLOBAL_CONST signed long mtBCD_ERR_LIMITS_INVALID;
 _GLOBAL_CONST signed long mtBCD_ERR_DATA_WINDOW_INVALID;
 _GLOBAL_CONST signed long mtBCD_ERR_DATA_NB_VALUES_HIGH;
#endif




/* Datatypes and datatypes of function blocks */
typedef struct MTDataCapabilityInternalType
{	float CycleTime;
	double LowerLimit;
	double UpperLimit;
	double Mean;
	double Mean2;
	double StdDeviation;
	double Tolerance;
	double CpkLower;
	double CpkUpper;
	unsigned long NumberOfValues;
	plcbit InhibitUpdate;
	plcbit ParametersValid;
	plcbit EnableOld;
	plcbit ResetOld;
	plcbit Hold;
} MTDataCapabilityInternalType;

typedef struct MTDataStdDeviationInternalType
{	float CycleTime;
	double Mean;
	double Mean2;
	unsigned long NumberOfValues;
	plcbit EnableOld;
	plcbit ResetOld;
	plcbit Hold;
} MTDataStdDeviationInternalType;

typedef struct MTDataVarianceInternalType
{	float CycleTime;
	double Mean;
	double Mean2;
	unsigned long NumberOfValues;
	plcbit EnableOld;
	plcbit ResetOld;
	plcbit Hold;
} MTDataVarianceInternalType;

typedef struct MTDataRMSInternalType
{	float CycleTime;
	double Mean2;
	unsigned long NumberOfValues;
	plcbit EnableOld;
	plcbit ResetOld;
	plcbit Hold;
} MTDataRMSInternalType;

typedef struct MTDataMeanInternalType
{	float CycleTime;
	double Mean;
	unsigned long NumberOfValues;
	plcbit EnableOld;
	plcbit ResetOld;
	plcbit Hold;
} MTDataMeanInternalType;

typedef struct MTDataMinMaxInternalType
{	float CycleTime;
	unsigned long NumberOfValues;
	plcbit EnableOld;
	plcbit ResetOld;
	plcbit Hold;
} MTDataMinMaxInternalType;

typedef struct MTDataStatisticsInternalType
{	float CycleTime;
	unsigned long Buffer;
	unsigned long BufferOld;
	unsigned long BufferMax;
	unsigned long BufferCntMax;
	float* pBuffer;
	float InOld;
	unsigned long NumberOfValues;
	unsigned long Number0;
	unsigned long NumberMax;
	unsigned long IndexMinValue;
	unsigned long IndexMaxValue;
	float MinValue;
	float MaxValue;
	double Mean;
	double Mean2;
	plcbit Change;
	plcbit ResetOld;
	plcbit EnableOld;
	plcbit UpdateOld;
	plcbit ParametersValid;
	plcbit FirstTime;
} MTDataStatisticsInternalType;

typedef struct MTDataCapability
{
	/* VAR_INPUT (analog) */
	float LowerLimit;
	float UpperLimit;
	float In;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	float Cp;
	float Cpk;
	/* VAR (analog) */
	struct MTDataCapabilityInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Reset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MTDataCapability_typ;

typedef struct MTDataMean
{
	/* VAR_INPUT (analog) */
	float In;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	float Out;
	/* VAR (analog) */
	struct MTDataMeanInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Reset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MTDataMean_typ;

typedef struct MTDataMinMax
{
	/* VAR_INPUT (analog) */
	float In;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	float MinValue;
	unsigned long IndexMinValue;
	float MaxValue;
	unsigned long IndexMaxValue;
	/* VAR (analog) */
	struct MTDataMinMaxInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Reset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MTDataMinMax_typ;

typedef struct MTDataRMS
{
	/* VAR_INPUT (analog) */
	float In;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	float Out;
	/* VAR (analog) */
	struct MTDataRMSInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Reset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MTDataRMS_typ;

typedef struct MTDataStatistics
{
	/* VAR_INPUT (analog) */
	unsigned long MovingWindowLength;
	float In;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	float MinValue;
	unsigned long IndexMinValue;
	float MaxValue;
	unsigned long IndexMaxValue;
	float Mean;
	float RMS;
	float Variance;
	float StdDeviation;
	/* VAR (analog) */
	struct MTDataStatisticsInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Update;
	plcbit Reset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit UpdateDone;
} MTDataStatistics_typ;

typedef struct MTDataStdDeviation
{
	/* VAR_INPUT (analog) */
	float In;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	float Out;
	/* VAR (analog) */
	struct MTDataStdDeviationInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Reset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MTDataStdDeviation_typ;

typedef struct MTDataVariance
{
	/* VAR_INPUT (analog) */
	float In;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	float Out;
	/* VAR (analog) */
	struct MTDataVarianceInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Reset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MTDataVariance_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void MTDataCapability(struct MTDataCapability* inst);
_BUR_PUBLIC void MTDataMean(struct MTDataMean* inst);
_BUR_PUBLIC void MTDataMinMax(struct MTDataMinMax* inst);
_BUR_PUBLIC void MTDataRMS(struct MTDataRMS* inst);
_BUR_PUBLIC void MTDataStatistics(struct MTDataStatistics* inst);
_BUR_PUBLIC void MTDataStdDeviation(struct MTDataStdDeviation* inst);
_BUR_PUBLIC void MTDataVariance(struct MTDataVariance* inst);


#ifdef __cplusplus
};
#endif
#endif /* _MTDATA_ */

