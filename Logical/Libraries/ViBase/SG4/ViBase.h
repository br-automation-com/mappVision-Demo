/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _VIBASE_
#define _VIBASE_
#ifdef __cplusplus
extern "C" {
#endif

#include <bur/plctypes.h>


#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Datatypes and datatypes of function blocks */
typedef enum ViBaseErrorEnum
{
	viBASE_NO_ERROR = 0,
	viBASE_ERR_FILE_WRITE = -1046282219,
	viBASE_ERR_INVALID_FILE_DEVICE = -1046282218,
	viBASE_ERR_FILE_SYSTEM = -1046282217,
	viBASE_ERR_NO_MEDIATOR = -1046282197,
	viBASE_ERR_COMPONENT_CHANGED = -1046282196,
	viBASE_ERR_INVALID_COMPONENT = -1046282195,
	viBASE_ERR_INVALID_COMPONENT_IF = -1046282194,
	viBASE_ERR_INVALID_PARAMETER = -1046282193,
	viBASE_ERR_COMPONENT_NOT_READY = -1046282185,
	viBASE_ERR_NO_INSTANCE = -1046282141,
	viBASE_ERR_APP_NOT_COMPATIBLE = -1046282120,
	viBASE_WRN_APP_NOT_LOADED = -2120023941,
	viBASE_ERR_APP_NOT_LOADED = -1046282117,
	viBASE_ERR_APP_NOT_EXIST = -1046282080
} ViBaseErrorEnum;

typedef struct ViBaseFubProcessingType
{
	signed long Mediator[2];
} ViBaseFubProcessingType;

typedef struct ViBaseControlIfType
{
	plcdword VTable;
} ViBaseControlIfType;

typedef struct ViBaseInternalType
{
	unsigned long ID;
	unsigned long Check;
	unsigned long ParamHash;
	plcword State;
	unsigned short Error;
	struct ViBaseFubProcessingType* Treating;
	unsigned long Reserve[2];
	unsigned char Flags;
	struct ViBaseControlIfType* ControlIf;
	signed long SeqNo;
} ViBaseInternalType;

typedef struct ViComponentInternalMappLinkType
{
	unsigned long Internal[2];
} ViComponentInternalMappLinkType;

typedef struct ViComponentInternalCameraIfType
{
	plcdword Vtable;
} ViComponentInternalCameraIfType;

typedef struct ViComponentType
{
	struct ViComponentInternalCameraIfType* CameraType;
	struct ViComponentInternalMappLinkType MappLinkInternal;
} ViComponentType;

typedef struct ViBaseSaveDiagData
{
	/* VAR_INPUT (analog) */
	struct ViComponentType* MpLink;
	plcstring (*DeviceName);
	plcstring (*FileName);
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	/* VAR (analog) */
	struct ViBaseInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} ViBaseSaveDiagData_typ;

typedef struct ViBaseLoadApplication
{
	/* VAR_INPUT (analog) */
	struct ViComponentType* MpLink;
	plcstring (*Name);
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	/* VAR (analog) */
	struct ViBaseInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} ViBaseLoadApplication_typ;

/* Prototyping of functions and function blocks */
_BUR_PUBLIC void ViBaseSaveDiagData(struct ViBaseSaveDiagData* inst);
_BUR_PUBLIC void ViBaseLoadApplication(struct ViBaseLoadApplication* inst);

#ifdef __cplusplus
} // End of C-Linkage
#endif
#endif /* _VIBASE_ */

