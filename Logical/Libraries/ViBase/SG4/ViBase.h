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
/* Constants */
#ifdef _REPLACE_CONST
#define viBASE_ERR_CAM_NO_VA_LOADED (-1045167871)
#define viBASE_ERR_CMD_INV_ACCESS_BASIS (-1045167872)
#define viBASE_ERR_ACQ_W_HMI_ACTIVE (-1045167928)
#define viBASE_ERR_FRCD_ACQ_W_HMI_ACTIVE (-1045167929)
#define viBASE_ERR_NEG_DFLT_POS_COMPENS (-1045167930)
#define viBASE_ERR_ACQ_CAM_NOTREADY (-1045167931)
#define viBASE_ERR_FRCD_ACQ_CAM_NOTREADY (-1045167932)
#define viBASE_ERR_ACQ_TOO_EARLY (-1045167933)
#define viBASE_ERR_FRCD_ACQ_TOO_EARLY (-1045167934)
#define viBASE_ERR_ACQ_W_CMD_ACTIVE (-1045167935)
#define viBASE_ERR_FRCD_ACQ_W_CMD_ACTIVE (-1045167936)
#define viBASE_ERR_AXIS_NOT_INITIALZED (-1045167937)
#define viBASE_ERR_AXIS_NOT_HOMED (-1045167938)
#define viBASE_ERR_CHANGE_DISBLD_NEG_DIR (-1045167939)
#define viBASE_ERR_CHANGE_START_POS (-1045167940)
#define viBASE_ERR_READ_PRD_RESOLUTION (-1045167941)
#define viBASE_ERR_READ_AXIS_VELOCITY (-1045167942)
#define viBASE_ERR_READ_AXIS_POSITION (-1045167943)
#define viBASE_ERR_NO_DFLT_POS_COMPENS (-1045167945)
#define viBASE_ERR_MAPP_AXIS_REF_INVAL (-1045167946)
#define viBASE_ERR_MAPP_AXIS_REF_INCORR (-1045167947)
#define viBASE_ERR_COMP_SAVE_AS_FAILED (-1045167963)
#define viBASE_ERR_COMP_ALREADY_EXISTS (-1045167964)
#define viBASE_ERR_APP_ALREADY_EXISTS_W (-1045167965)
#define viBASE_ERR_APP_NAME_INVALID (-1045167966)
#define viBASE_ERR_APP_ALREADY_EXISTS (-1045167967)
#define viBASE_ERR_APP_NOT_EXIST (-1045167968)
#define viBASE_ERR_FEATURE_NOT_SUPPORTED (-1045167977)
#define viBASE_ERR_IMG_TOO_BIG (-1045167979)
#define viBASE_ERR_NO_IMG_AVAILABLE (-1045167980)
#define viBASE_ERR_GET_IMG_FAILED (-1045167981)
#define viBASE_INF_APP_LIST_NOT_COMPLETE 1102315666
#define viBASE_ERR_CMD_INV_HMI_OPEN (-1045167984)
#define viBASE_ERR_DELETE_FAILURE (-1045167986)
#define viBASE_ERR_DELETE_VA_IN_USE (-1045167987)
#define viBASE_ERR_CMD_INV_LOAD_FAILED (-1045168000)
#define viBASE_ERR_APP_NOT_SAVED (-1045168004)
#define viBASE_ERR_APP_NOT_LOADED (-1045168005)
#define viBASE_WRN_APP_NOT_LOADED (-2118909829)
#define viBASE_ERR_APP_NOT_COMPATIBLE (-1045168008)
#define viBASE_ERR_FB_ALREADY_ACTIVE (-1045168023)
#define viBASE_ERR_EXECUTION_TIMEOUT (-1045168028)
#define viBASE_ERR_NO_INSTANCE (-1045168029)
#define viBASE_ERR_COMPONENT_NOT_READY (-1045168073)
#define viBASE_ERR_INVALID_PARAMETER (-1045168081)
#define viBASE_ERR_INVALID_COMPONENT_IF (-1045168082)
#define viBASE_ERR_INVALID_COMPONENT (-1045168083)
#define viBASE_ERR_COMPONENT_CHANGED (-1045168084)
#define viBASE_ERR_NO_MEDIATOR (-1045168085)
#define viBASE_ERR_FILE_SYSTEM (-1045168105)
#define viBASE_ERR_INVALID_FILE_DEVICE (-1045168106)
#define viBASE_ERR_FILE_WRITE (-1045168107)
#else
_GLOBAL_CONST signed long viBASE_ERR_CAM_NO_VA_LOADED;
_GLOBAL_CONST signed long viBASE_ERR_CMD_INV_ACCESS_BASIS;
_GLOBAL_CONST signed long viBASE_ERR_ACQ_W_HMI_ACTIVE;
_GLOBAL_CONST signed long viBASE_ERR_FRCD_ACQ_W_HMI_ACTIVE;
_GLOBAL_CONST signed long viBASE_ERR_NEG_DFLT_POS_COMPENS;
_GLOBAL_CONST signed long viBASE_ERR_ACQ_CAM_NOTREADY;
_GLOBAL_CONST signed long viBASE_ERR_FRCD_ACQ_CAM_NOTREADY;
_GLOBAL_CONST signed long viBASE_ERR_ACQ_TOO_EARLY;
_GLOBAL_CONST signed long viBASE_ERR_FRCD_ACQ_TOO_EARLY;
_GLOBAL_CONST signed long viBASE_ERR_ACQ_W_CMD_ACTIVE;
_GLOBAL_CONST signed long viBASE_ERR_FRCD_ACQ_W_CMD_ACTIVE;
_GLOBAL_CONST signed long viBASE_ERR_AXIS_NOT_INITIALZED;
_GLOBAL_CONST signed long viBASE_ERR_AXIS_NOT_HOMED;
_GLOBAL_CONST signed long viBASE_ERR_CHANGE_DISBLD_NEG_DIR;
_GLOBAL_CONST signed long viBASE_ERR_CHANGE_START_POS;
_GLOBAL_CONST signed long viBASE_ERR_READ_PRD_RESOLUTION;
_GLOBAL_CONST signed long viBASE_ERR_READ_AXIS_VELOCITY;
_GLOBAL_CONST signed long viBASE_ERR_READ_AXIS_POSITION;
_GLOBAL_CONST signed long viBASE_ERR_NO_DFLT_POS_COMPENS;
_GLOBAL_CONST signed long viBASE_ERR_MAPP_AXIS_REF_INVAL;
_GLOBAL_CONST signed long viBASE_ERR_MAPP_AXIS_REF_INCORR;
_GLOBAL_CONST signed long viBASE_ERR_COMP_SAVE_AS_FAILED;
_GLOBAL_CONST signed long viBASE_ERR_COMP_ALREADY_EXISTS;
_GLOBAL_CONST signed long viBASE_ERR_APP_ALREADY_EXISTS_W;
_GLOBAL_CONST signed long viBASE_ERR_APP_NAME_INVALID;
_GLOBAL_CONST signed long viBASE_ERR_APP_ALREADY_EXISTS;
_GLOBAL_CONST signed long viBASE_ERR_APP_NOT_EXIST;
_GLOBAL_CONST signed long viBASE_ERR_FEATURE_NOT_SUPPORTED;
_GLOBAL_CONST signed long viBASE_ERR_IMG_TOO_BIG;
_GLOBAL_CONST signed long viBASE_ERR_NO_IMG_AVAILABLE;
_GLOBAL_CONST signed long viBASE_ERR_GET_IMG_FAILED;
_GLOBAL_CONST signed long viBASE_INF_APP_LIST_NOT_COMPLETE;
_GLOBAL_CONST signed long viBASE_ERR_CMD_INV_HMI_OPEN;
_GLOBAL_CONST signed long viBASE_ERR_DELETE_FAILURE;
_GLOBAL_CONST signed long viBASE_ERR_DELETE_VA_IN_USE;
_GLOBAL_CONST signed long viBASE_ERR_CMD_INV_LOAD_FAILED;
_GLOBAL_CONST signed long viBASE_ERR_APP_NOT_SAVED;
_GLOBAL_CONST signed long viBASE_ERR_APP_NOT_LOADED;
_GLOBAL_CONST signed long viBASE_WRN_APP_NOT_LOADED;
_GLOBAL_CONST signed long viBASE_ERR_APP_NOT_COMPATIBLE;
_GLOBAL_CONST signed long viBASE_ERR_FB_ALREADY_ACTIVE;
_GLOBAL_CONST signed long viBASE_ERR_EXECUTION_TIMEOUT;
_GLOBAL_CONST signed long viBASE_ERR_NO_INSTANCE;
_GLOBAL_CONST signed long viBASE_ERR_COMPONENT_NOT_READY;
_GLOBAL_CONST signed long viBASE_ERR_INVALID_PARAMETER;
_GLOBAL_CONST signed long viBASE_ERR_INVALID_COMPONENT_IF;
_GLOBAL_CONST signed long viBASE_ERR_INVALID_COMPONENT;
_GLOBAL_CONST signed long viBASE_ERR_COMPONENT_CHANGED;
_GLOBAL_CONST signed long viBASE_ERR_NO_MEDIATOR;
_GLOBAL_CONST signed long viBASE_ERR_FILE_SYSTEM;
_GLOBAL_CONST signed long viBASE_ERR_INVALID_FILE_DEVICE;
_GLOBAL_CONST signed long viBASE_ERR_FILE_WRITE;
#endif

/* Datatypes and datatypes of function blocks */
typedef enum ViBaseFormatEnum
{
	viBASE_FORMAT_PLAIN_TEXT = 0,
	viBASE_FORMAT_ITEMCOLLECTION = 1
} ViBaseFormatEnum;

typedef enum ViBaseImageTypeEnum
{
	viBASE_IMAGE_TYPE_BMP = 0,
	viBASE_IMAGE_TYPE_JPG = 1
} ViBaseImageTypeEnum;

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

typedef struct ViBaseAxBsdAcqAcqParType
{
	double AcquisitionPositions[8];
	double Period;
	double StartPosition;
} ViBaseAxBsdAcqAcqParType;

typedef struct ViBaseAxBsdAcqAdvParType
{
	plcbit DisableNegativeDirection;
	float AddPositionCompensation;
	float AddOutputCompensation;
} ViBaseAxBsdAcqAdvParType;

typedef struct ViBaseAxBsdAcqAddInfoType
{
	float DefaultPositionCompensation;
	float DefaultOutputCompensation;
	signed char TimestampCount;
	signed long CalculatedTimestamp;
} ViBaseAxBsdAcqAddInfoType;

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

typedef struct ViBaseDeleteApplication
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
} ViBaseDeleteApplication_typ;

typedef struct ViBaseSaveApplication
{
	/* VAR_INPUT (analog) */
	struct ViComponentType* MpLink;
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
} ViBaseSaveApplication_typ;

typedef struct ViBaseSaveApplicationAs
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
	plcbit Overwrite;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} ViBaseSaveApplicationAs_typ;

typedef struct ViBaseListApplication
{
	/* VAR_INPUT (analog) */
	struct ViComponentType* MpLink;
	enum ViBaseFormatEnum Format;
	unsigned long List;
	unsigned long ListLen;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	unsigned short NrEntries;
	/* VAR (analog) */
	struct ViBaseInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} ViBaseListApplication_typ;

typedef struct ViBaseGetImage
{
	/* VAR_INPUT (analog) */
	struct ViComponentType* MpLink;
	enum ViBaseImageTypeEnum Type;
	unsigned char QualityLevel;
	plctime Timeout;
	unsigned long Buffer;
	unsigned long BufferSize;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	unsigned long BufferLen;
	signed long Nettime;
	/* VAR (analog) */
	struct ViBaseInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Active;
	plcbit Error;
} ViBaseGetImage_typ;

typedef struct ViBaseAxisBasedAcquisition
{
	/* VAR_INPUT (analog) */
	struct ViComponentType* MpLink;
	struct ViBaseAxBsdAcqAcqParType AcquisitionParameters;
	struct ViBaseAxBsdAcqAdvParType AdvancedParameters;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct ViBaseAxBsdAcqAddInfoType AdditionalInfo;
	/* VAR (analog) */
	struct ViBaseInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Update;
	plcbit PauseAcquisition;
	plcbit ForceAcquisition;
	/* VAR_OUTPUT (digital) */
	plcbit InOperation;
	plcbit Busy;
	plcbit Error;
	plcbit UpdateDone;
} ViBaseAxisBasedAcquisition_typ;

typedef plcstring ViBaseFormatItemCollectionType[131];

typedef plcstring ViBaseFormatPlainTextType[51];

/* Prototyping of functions and function blocks */
_BUR_PUBLIC void ViBaseSaveDiagData(struct ViBaseSaveDiagData* inst);
_BUR_PUBLIC void ViBaseLoadApplication(struct ViBaseLoadApplication* inst);
_BUR_PUBLIC void ViBaseDeleteApplication(struct ViBaseDeleteApplication* inst);
_BUR_PUBLIC void ViBaseSaveApplication(struct ViBaseSaveApplication* inst);
_BUR_PUBLIC void ViBaseSaveApplicationAs(struct ViBaseSaveApplicationAs* inst);
_BUR_PUBLIC void ViBaseListApplication(struct ViBaseListApplication* inst);
_BUR_PUBLIC void ViBaseGetImage(struct ViBaseGetImage* inst);
_BUR_PUBLIC void ViBaseAxisBasedAcquisition(struct ViBaseAxisBasedAcquisition* inst);

#ifdef __cplusplus
} // End of C-Linkage
#endif
#endif /* _VIBASE_ */

