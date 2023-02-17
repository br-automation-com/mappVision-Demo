#include <brdkFile_func.h>

unsigned long buildParameterString(char* pDrive,char* pPath, char* pDeviceParam) {
	brdkStrCpy((unsigned long)pDeviceParam,(unsigned long)"/DEVICE=\"");
	brdkStrCat((unsigned long)pDeviceParam,(unsigned long)pDrive);
	brdkStrCat((unsigned long)pDeviceParam,(unsigned long)"\\");
	if(pPath[0] != 0) {
		brdkStrReplace((unsigned long)pPath,(unsigned long)"/",(unsigned long)"\\");	/* replace any front slah with backslash */
		brdkStrCat((unsigned long)pDeviceParam,(unsigned long)pPath);
	}
	brdkStrCat((unsigned long)pDeviceParam,(unsigned long)"\"");
	return (unsigned long)pDeviceParam;
}

char* getDrive(brdk_file_drive_typ drive, char* pDrive) {
	switch(drive) {
		case C_DRIVE: brdkStrCpy((unsigned long)pDrive,(unsigned long)"C:\\"); break;
		case D_DRIVE: brdkStrCpy((unsigned long)pDrive,(unsigned long)"D:\\"); break;
		case E_DRIVE: brdkStrCpy((unsigned long)pDrive,(unsigned long)"E:\\"); break;
		case F_DRIVE: brdkStrCpy((unsigned long)pDrive,(unsigned long)"F:\\"); break;
		case G_DRIVE: brdkStrCpy((unsigned long)pDrive,(unsigned long)"G:\\"); break;		
	}
	return pDrive;
}

signed long splitFolderPath(char* pDestination, char* pSource) {
	int idx = 0;
	signed long pos = -1;
	if(pSource[idx] != 0) {
		pos = brdkStrIndexOf((unsigned long)&pSource[idx],(unsigned long)"\\",BRDK_STR_LEFT_SEARCH);
		if(pos > -1) {
			brdkStrMemCpy((unsigned long)pDestination,(unsigned long)&pSource[idx],(unsigned long)++pos);
			pDestination[pos] = 0;
		}
	}
	return pos;
}


