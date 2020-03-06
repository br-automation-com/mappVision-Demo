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
typedef struct ViBaseExecInternalType
{
	unsigned short i_serno;
	unsigned short i_state;
	signed long Result;
} ViBaseExecInternalType;

typedef struct ViBaseInternalType
{
	struct ViBaseExecInternalType i_base;
	unsigned long m_ctx;
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

