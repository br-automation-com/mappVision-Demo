#ifndef BRDK_FILE_FUNCS
#define BRDK_FILE_FUNCS 1

#include <brdkFile.h>
#include <bur/plctypes.h>

#ifdef __cplusplus
	extern "C"
	{
#endif

#ifdef __cplusplus
	};
#endif

#define false 0
#define true 1
#define NULL 0

unsigned long buildParameterString(char* pDrive,char* pPath, char* pDeviceParam);
char* getDrive(brdk_file_drive_typ drive, char* pDrive);
signed long splitFolderPath(char* pDestination, char* pSource);

#endif /* !BRDK_FILE_FUNCS */
