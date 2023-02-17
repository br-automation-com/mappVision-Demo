
#include <bur/plctypes.h>
#ifdef __cplusplus
	extern "C"
	{
#endif
#include "brdkViBase.h"
#ifdef __cplusplus
	};
#endif
/* TODO: Add your comment here */
unsigned long  brdkViBase_LEDIntensity(unsigned char LEDLenseType, unsigned short distance, unsigned long exposureTime, unsigned char fromColor, unsigned char toColor)
{
	
	double fromIntensity=1, toIntensity=1,fromEffekt=1,toEffekt=1;
	
	switch(LEDLenseType){
		case 1:
			switch(fromColor){
				case BRDKVIBASE_CAM_LED_RED:
					fromIntensity = 6000;
					fromEffekt = 38;
				break;
				case BRDKVIBASE_CAM_LED_GREEN:
					
					fromIntensity = 11300;
					fromEffekt = 25;
					break;
				case BRDKVIBASE_CAM_LED_BLUE:
					fromIntensity = 3500;
					fromEffekt = 37;
				break;
				case BRDKVIBASE_CAM_LED_LIME:
					fromIntensity = 12100;
					fromEffekt = 26;
				break;
				case BRDKVIBASE_CAM_LED_WHITE:
					fromIntensity = 16900;
					fromEffekt = 52;
				break;
				case BRDKVIBASE_CAM_LED_IR:
					fromIntensity = 42;
					fromEffekt = 42;
				break;
				
				case BRDKVIBASE_CAM_LED_UV:
					fromIntensity = 1;
					fromEffekt = 1;
				break;
			}
	
			switch(toColor){
				case BRDKVIBASE_CAM_LED_RED:
					toIntensity = 6000;
					toEffekt = 38;
				break;
				case BRDKVIBASE_CAM_LED_GREEN:
					toIntensity = 11300;
					toEffekt = 25;
				break;
				case BRDKVIBASE_CAM_LED_BLUE:
					toIntensity = 3500;
					toEffekt = 37;
				break;
				case BRDKVIBASE_CAM_LED_LIME:
					toIntensity = 12100;
					toEffekt = 26;
				break;
				case BRDKVIBASE_CAM_LED_WHITE:
					toIntensity = 16900;
					toEffekt = 52;
				break;
				case BRDKVIBASE_CAM_LED_IR:
					toIntensity = 42;
					toEffekt = 42;
				break;
				case BRDKVIBASE_CAM_LED_UV:
					toIntensity = 1;
					toEffekt = 1;
				break;
			}
			
		break;
		case 2:

			switch(fromColor){
				case BRDKVIBASE_CAM_LED_RED:
					fromIntensity = 23700;
					fromEffekt = 180;//145;
				break;
				case BRDKVIBASE_CAM_LED_GREEN:			
					fromIntensity = 49500;
					fromEffekt = 101;
				break;
				case BRDKVIBASE_CAM_LED_BLUE:
					fromIntensity = 16000;
					fromEffekt = 179;
				break;
				case BRDKVIBASE_CAM_LED_LIME:
					fromIntensity = 55500;
					fromEffekt = 119;
				break;
				case BRDKVIBASE_CAM_LED_WHITE:
					fromIntensity = 67300;
					fromEffekt = 203;
				break;
				case BRDKVIBASE_CAM_LED_IR:
					fromIntensity = 156;
					fromEffekt = 156;
				break;
				case BRDKVIBASE_CAM_LED_UV:
					fromIntensity = 1;
					fromEffekt = 1;
				break;
			}

			switch(toColor){
				case BRDKVIBASE_CAM_LED_RED:
					toIntensity = 23700;
					toEffekt = 180;//145;
				break;
				case BRDKVIBASE_CAM_LED_GREEN:	
					toIntensity = 49500;
					toEffekt = 101;
					break;
				case BRDKVIBASE_CAM_LED_BLUE:
					toIntensity = 16000;
					toEffekt = 179;
				break;
				case BRDKVIBASE_CAM_LED_LIME:
					toIntensity = 55500;
					toEffekt = 119;
				break;
				case BRDKVIBASE_CAM_LED_WHITE:
					toIntensity = 67300;
					toEffekt = 203;
				break;
				case BRDKVIBASE_CAM_LED_IR:
					toIntensity = 156;
					toEffekt = 156;
				break;
				
				case BRDKVIBASE_CAM_LED_UV:
					toIntensity = 1;
					toEffekt = 1;
				break;
			}
		

		break;
		case 3:

			switch(fromColor){
				case BRDKVIBASE_CAM_LED_RED:
					fromIntensity = 60800;
					fromEffekt = 395;
				break;
				case BRDKVIBASE_CAM_LED_GREEN:		
					fromIntensity = 130700;
					fromEffekt = 273;
					break;
				case BRDKVIBASE_CAM_LED_BLUE:
					fromIntensity = 52300;
					fromEffekt = 570;
				break;
				case BRDKVIBASE_CAM_LED_LIME:
					fromIntensity = 142800;
					fromEffekt = 305;
				break;
				case BRDKVIBASE_CAM_LED_WHITE:
					fromIntensity = 198700;
					fromEffekt = 605;
				break;
				case BRDKVIBASE_CAM_LED_IR:
					fromIntensity = 1;
					fromEffekt = 1;
				break;
				
				case BRDKVIBASE_CAM_LED_UV:
					fromIntensity = 1;
					fromEffekt = 1;
				break;
			}
			switch(toColor){
				case BRDKVIBASE_CAM_LED_RED:
					toIntensity = 60800;
					toEffekt = 395;
				break;
				case BRDKVIBASE_CAM_LED_GREEN:			
					toIntensity = 130700;
					toEffekt = 273;
					break;
				case BRDKVIBASE_CAM_LED_BLUE:
					toIntensity = 52300;
					toEffekt = 570;
				break;
				case BRDKVIBASE_CAM_LED_LIME:
					toIntensity = 142800;
					toEffekt = 305;
				break;
				case BRDKVIBASE_CAM_LED_WHITE:
					toIntensity = 198700;
					toEffekt = 605;
				break;
				case BRDKVIBASE_CAM_LED_IR:
					toIntensity = 1;
					toEffekt = 1;
				break;
				
				case BRDKVIBASE_CAM_LED_UV:
					toIntensity = 1;
					toEffekt = 1;
				break;
	
			}

		break;
	}
	
	return (fromEffekt/toEffekt)*exposureTime;
	//return (toIntensity/fromIntensity)*exposureTime;
	
}
