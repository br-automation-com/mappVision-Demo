/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _VICORE_
#define _VICORE_
#ifdef __cplusplus
extern "C" {
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Datatypes and datatypes of function blocks */
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

#ifdef __cplusplus
} // End of C-Linkage
#endif
#endif /* _VICORE_ */

