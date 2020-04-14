/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _VIBASE_
#define _VIBASE_
#ifdef __cplusplus
extern "C" {
#endif

#include <bur/plctypes.h>

#include "ViCore.h"


#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Datatypes and datatypes of function blocks */
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

typedef struct ViBaseSaveDiagInfo
{
	/* VAR_INPUT (analog) */
	struct ViComponentType* MpLink;
	signed long ImageNettime;
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
} ViBaseSaveDiagInfo_typ;

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
_BUR_PUBLIC void ViBaseSaveDiagInfo(struct ViBaseSaveDiagInfo* inst);
_BUR_PUBLIC void ViBaseLoadApplication(struct ViBaseLoadApplication* inst);

#ifdef __cplusplus
} // End of C-Linkage
#endif
#endif /* _VIBASE_ */

