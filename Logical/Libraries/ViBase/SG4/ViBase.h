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
#define viBASE_ERR_APP_NOT_EXIST (-1045167968)
#define viBASE_ERR_FEATURE_NOT_SUPPORTED (-1045167977)
#define viBASE_ERR_IMG_TOO_BIG (-1045167979)
#define viBASE_ERR_NO_IMG_AVAILABLE (-1045167980)
#define viBASE_ERR_GET_IMG_FAILED (-1045167981)
#define viBASE_INF_APP_LIST_NOT_COMPLETE 1102315666
#define viBASE_ERR_CMD_INV_HMI_OPEN (-1045167984)
#define viBASE_ERR_CMD_INV_LOAD_FAILED (-1045168000)
#define viBASE_ERR_APP_NOT_SAVED (-1045168004)
#define viBASE_WRN_APP_NOT_LOADED (-2118909829)
#define viBASE_ERR_APP_NOT_LOADED (-1045168005)
#define viBASE_ERR_APP_NOT_COMPATIBLE (-1045168008)
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
_GLOBAL_CONST signed long viBASE_ERR_APP_NOT_EXIST;
_GLOBAL_CONST signed long viBASE_ERR_FEATURE_NOT_SUPPORTED;
_GLOBAL_CONST signed long viBASE_ERR_IMG_TOO_BIG;
_GLOBAL_CONST signed long viBASE_ERR_NO_IMG_AVAILABLE;
_GLOBAL_CONST signed long viBASE_ERR_GET_IMG_FAILED;
_GLOBAL_CONST signed long viBASE_INF_APP_LIST_NOT_COMPLETE;
_GLOBAL_CONST signed long viBASE_ERR_CMD_INV_HMI_OPEN;
_GLOBAL_CONST signed long viBASE_ERR_CMD_INV_LOAD_FAILED;
_GLOBAL_CONST signed long viBASE_ERR_APP_NOT_SAVED;
_GLOBAL_CONST signed long viBASE_WRN_APP_NOT_LOADED;
_GLOBAL_CONST signed long viBASE_ERR_APP_NOT_LOADED;
_GLOBAL_CONST signed long viBASE_ERR_APP_NOT_COMPATIBLE;
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

typedef plcstring ViBaseFormatItemCollectionType[131];

typedef plcstring ViBaseFormatPlainTextType[51];

/* Prototyping of functions and function blocks */
_BUR_PUBLIC void ViBaseSaveDiagData(struct ViBaseSaveDiagData* inst);
_BUR_PUBLIC void ViBaseLoadApplication(struct ViBaseLoadApplication* inst);
_BUR_PUBLIC void ViBaseSaveApplication(struct ViBaseSaveApplication* inst);
_BUR_PUBLIC void ViBaseListApplication(struct ViBaseListApplication* inst);
_BUR_PUBLIC void ViBaseGetImage(struct ViBaseGetImage* inst);

#ifdef __cplusplus
} // End of C-Linkage
#endif
#endif /* _VIBASE_ */

