
#include <bur/plctypes.h>
#ifdef __cplusplus
	extern "C"
	{
#endif
	#include "brdkViBase.h"
#ifdef __cplusplus
	};
#endif

#include<iostream>
#include <string.h>

unsigned long bur_heap_size=0xFFFFF;
/* TODO: Add your comment here */
plcbit brdkViBase_CamStatusToString(unsigned long status, unsigned long pString)
{
	int i;

	if(status == 0){ // Display only a single 0
		strcpy((char*)pString,"Ready");
	}else if( status == 0x00000001 ){
		strcpy((char*)pString,"Image acquisition");
	}else if( status == 0x00000002 ){
		strcpy((char*)pString,"Waiting trigger");
	}else if( status == 0x00000010 ){
		strcpy((char*)pString,"Searching settings");
	}else if( status == 0x00000080 ){
		strcpy((char*)pString,"Setting focus");
	}else if( status == 0x00000090 ){
		strcpy((char*)pString,"Searching settings");
	}else if( status == 0x00000800 ){
		strcpy((char*)pString,"Cam CPU not ready");
	}else if( status == 0x00001000 ){
		strcpy((char*)pString,"Cam sensor not ready");
	}else if( status == 0x01000000 || status == 0x02000000 || status == 0x03000000 ){
		strcpy((char*)pString,"OS check/update");
	}else if( status == 0x80000000 ){
		strcpy((char*)pString,"Vision cockpit active");
	}else{
		// Display the status in hex format 0x02000800
		strcpy((char*)pString,"0x");
		sprintf((char*)pString+2, "%x", status);
	}
}
