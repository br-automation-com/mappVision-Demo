
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
plcbit brdkViBase_LEDColorToOptions(enum BRDKVIBASE_LED_COLOR_ENM LEDColor, plcstring* (*pOptions)[5])
{
	
	char (*pArray)[51] = (char (*)[51]) pOptions;


    
		brsstrcpy((char*) pArray[0], "{\"value\":\"0\",\"text\":\"None\"}");
		brsstrcpy((char*) pArray[1], "");
		brsstrcpy((char*) pArray[2], "");
		brsstrcpy((char*) pArray[3], "");
		brsstrcpy((char*) pArray[4], "");

    switch(LEDColor){
        case BRDKVIBASE_LED_COLOR_3_BLUE:
             brsstrcpy((char*) pArray[1], "{\"value\":\"3\",\"text\":\"Blue\"}");
         	 
            break; 

        case BRDKVIBASE_LED_COLOR_8_RED:
             brsstrcpy((char*) pArray[1], "{\"value\":\"1\",\"text\":\"Red\"}");
            break; 

        case BRDKVIBASE_LED_COLOR_A_UV:
             brsstrcpy((char*) pArray[1], "{\"value\":\"210\",\"text\":\"Ultraviolet\"}");
            break; 

        case BRDKVIBASE_LED_COLOR_D_IR:
             brsstrcpy((char*) pArray[1], "{\"value\":\"100\",\"text\":\"Infrared\"}");
            break; 

        case BRDKVIBASE_LED_COLOR_F_W:
             brsstrcpy((char*) pArray[1], "{\"value\":\"99\",\"text\":\"White\"}");
            break; 

        case BRDKVIBASE_LED_COLOR_Q_RGBL:
             brsstrcpy((char*) pArray[1], "{\"value\":\"1\",\"text\":\"Red\"}");
             brsstrcpy((char*) pArray[2], "{\"value\":\"2\",\"text\":\"Green\"}");
             brsstrcpy((char*) pArray[3], "{\"value\":\"3\",\"text\":\"Blue\"}");
             brsstrcpy((char*) pArray[4], "{\"value\":\"4\",\"text\":\"Lime\"}");
            break; 

        case BRDKVIBASE_LED_COLOR_R_RBIRW:
             brsstrcpy((char*) pArray[1], "{\"value\":\"1\",\"text\":\"Red\"}");
             brsstrcpy((char*) pArray[2], "{\"value\":\"3\",\"text\":\"Blue\"}");
             brsstrcpy((char*) pArray[3], "{\"value\":\"99\",\"text\":\"White\"}");
             brsstrcpy((char*) pArray[4], "{\"value\":\"100\",\"text\":\"Infrared\"}");
            break; 

        case BRDKVIBASE_LED_COLOR_H_IRW:
             brsstrcpy((char*) pArray[1], "{\"value\":\"99\",\"text\":\"White\"}");
             brsstrcpy((char*) pArray[2], "{\"value\":\"100\",\"text\":\"Infrared\"}");
            break; 
    }
}
	