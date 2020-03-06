/*
	powerlnk.h

	(C) B&R Industrie Elektronik
*/

#ifndef POWERLNK_H_
#define POWERLNK_H_ 0x1105 /* Version V1.10.5 */
#ifdef __cplusplus
extern "C" {
#endif

#include <bur/plctypes.h>

/* Constants */

/* Error Numbers */
#define ERR_PLMGR_VERS_CONFLICT             20900   /* Version conflict in system structures */
#define ERR_PLMGR_NOMEM                     20901   /* Failed to allocate memory */
#define ERR_PLMGR_WRONG_DEVICE              20903   /* wrong device description */
#define ERR_PLMGR_CONFIG_NOT_FOUND          20904   /* configuration not found */
#define ERR_PLMGR_ALREADY_CONFIGURATED      20905   /* configuration already done */
#define ERR_PLMGR_NOT_IMPLEMENTED           20906   /* function is not implemented */
#define ERR_PLMGR_ILLEGAL_PARAMETER         20908   /* Illegal parameters in function call */
#define ERR_PLMGR_WRONG_IDENT               20911   /* Wrong ident */
#define ERR_PLMGR_ERROR_ALLOC_STATION       20913   /* Error at allocating station */
#define ERR_PLMGR_ERROR_ALLOC_CHANNEL       20914   /* Error at allocating channel */
#define ERR_PLMGR_ERROR_ALLOC_BUFFER        20915   /* Error at allocating buffer */
#define ERR_PLMGR_CHANNEL_ALREADY_OPEN      20916   /* Channel was opened by someone else */
#define ERR_PLMGR_NO_FRAME_RECEIVED         20917   /* No frame received by now */
#define ERR_PLMGR_FRAME_TOO_LONG            20918   /* Received frame does not fit into buffer */
#define ERR_PLMGR_WRITE_ACTIVE              20919   /* Write is already active for this channel */
#define ERR_PLMGR_OFFSET_TO_HIGH            20920   /* Offset for ident is too high */
#define ERR_PLMGR_NIL_POINTER               20921   /* parameter pointed to address 0 */
#define ERR_PLMGR_OVERFLOW                  20922   /* overflow of buffer */
#define ERR_PLMGR_UNAVAILABLE_DATAPOINT     20923   /* datapoint not available */
#define ERR_PLMGR_WRONG_TASKCLASS           20924   /* taskklass does not exist */
#define ERR_PLMGR_STATION_NOT_ACTIVE        20925   /* station not active */
#define ERR_PLMGR_TOO_MANY_INTERFACES       20926   /* To many PowerLink-Interfaces configured */
#define ERR_PLMGR_BUS_CONFIGURED_TWICE      20927   /* Same bus number declared twice */
#define ERR_PLMGR_SYNC_BY_SYSTEM            20928   /* Syncronisation has to be configured by System */
#define ERR_PLMGR_SYNC_FAILED               20929   /* Synchronizing System failed */
#define ERR_PLMGR_CONFIG_CONFLICT           20930   /* Conflict with IOTIMER-Device-Configuration */
#define ERR_PLMGR_NOT_IN_PRES               20931   /* data point not in poll response of station */
#define ERR_PLMGR_UNKNOWN_TYPE              20932   /* datatype of data point not valid */
#define ERR_PLMGR_NO_PDO_MAPPING_DEFINED    20933   /* no PDO mapping defined */

#define ERR_PLMGR_PARSE_ERROR               20950   /* Error at parsing datapoint description */
#define ERR_PLMGR_PARSE_END_EXPECTED        20951   /* expected end of string earlier */
#define ERR_PLMGR_PARSE_NO_PERCENT          20952   /* no percent % singn at start of datapoint description */
#define ERR_PLMGR_PARSE_NOT_IN_OR_OUT       20953   /* Direction neither I nor Q */
#define ERR_PLMGR_PARSE_INTERFACE           20954   /* incorrect interface number */
#define ERR_PLMGR_PARSE_STATION             20955   /* incorrect station number */
#define ERR_PLMGR_PARSE_MODUL               20956   /* incorrect modul number */
#define ERR_PLMGR_PARSE_SUBMODUL            20957   /* incorrect sub modul number */
#define ERR_PLMGR_PARSE_CHANNEL             20958   /* incorrect channel number */
#define ERR_PLMGR_PARSE_BIT                 20959   /* incorrect bit number */
#define ERR_PLMGR_PARSE_TO_MANY_NUMBERS     20960   /* too many numbers in datapoint description */
#define ERR_PLMGR_PARSE_NETTIME             20961   /* wrong datatype or length for nettime */
#define ERR_PLMGR_PARSE_SLOT                20962   /* incorrect slot number SL */
#define ERR_PLMGR_PARSE_SUBSLOT             20963   /* incorrect subslot number SS */
#define ERR_PLMGR_PARSE_TRAILINGCHARS       20964   /* trailing characters after valid channel or device name*/

#define ERR_PLMGR_WARNING_FW_UPDATE         20980   /* Updated firmware for station, (in error log book) */
#define ERR_PLMGR_HW_BOOTUP_FAILED          20981   /* Error at starting PowerLink hardware (in error log book) */
#define ERR_PLMGR_RECOMMEND_FW_UPDATE       20982   /* Firmware update for IF686 is recommended, download plfif686.br */
#define ERR_PLMGR_INTERNAL                  20997   /* Internal error in Library, this should never happen (in error log book) */
#define ERR_PLMGR_EXCEPTION                 20998   /* unexpected exception from PowerLink hardware (in error log book) */
#define ERR_PLMGR_NO_POWERLNK_LIBRARY       20999   /* PowerLink-Library not on plc */

/* Taskclasses for plCECreate function */
#define plCE_CYCLIC_1  1
#define plCE_CYCLIC_2  2
#define plCE_CYCLIC_3  3
#define plCE_CYCLIC_4  4
/* plCE_CYCLIC_5 .. 8 only valid for i386-Targets */
#define plCE_CYCLIC_5  5
#define plCE_CYCLIC_6  6
#define plCE_CYCLIC_7  7
#define plCE_CYCLIC_8  8

/* plCE_TIMER_x only valid for m68k-Targets */
#define plCE_TIMER_1  -1
#define plCE_TIMER_2  -2

/* Flags for plAcycOpen function */
#define plOPEN_MODE_READ  0  /* open channel for read*/
#define plOPEN_MODE_WRITE 1  /* open channel for write */
#define plOPEN_MODE_RW    2  /* open channel for read and write */

#define plOPEN_MODE_EPLV1    0x10  /* Force to V1 format */
#define plOPEN_MODE_EPLV2    0x20  /* Force to V2 format */
#define plOPEN_MODE_LENGTH   0x40  /* Use length in frame even in V2 */

#define plOPEN_PRIORITY_ENABLE      0x8000    /* enable using priority (used in V2 only) */
/* priority for asynchrounous send, applied in EPL V2 only */
#define plOPEN_PRIORITY_LOWEST      0x0000    /* lowest priority  */
#define plOPEN_PRIORITY_LOWER       0x0100	
#define plOPEN_PRIORITY_LOW         0x0200	
#define plOPEN_PRIORITY_GENERIC     0x0300    /* normal priority (default) */
#define plOPEN_PRIORITY_HIGH        0x0400    
#define plOPEN_PRIORITY_HIGHER      0x0500	
#define plOPEN_PRIORITY_HIGHEST     0x0600	  /* highest priority */
#define plOPEN_PRIORITY_NMT         0x0700    /* reserved for NMT requests */

/* States from plState Function */
/* Error States from plState */
#define plSTATE_WRONG_IDENT         0xffff
/* States of Stations */
#define plSTATE_STATION_NONEXISTANT 0x0000    /* No Access to this station has occured yet */
#define plSTATE_STATION_WAITING     0x0001    /* The software tried to access this station, but it is not on the BUS   */
#define plSTATE_STATION_OSDL        0x0002    /* The firmware had the wrong version so a Firmwareupdate is in progress */
#define plSTATE_STATION_CONFIG      0x0003    /* The configuration of the Station is in progress */
#define plSTATE_STATION_ACTIVATEING 0x0004    /* The activation of the copy entries is in progress */
#define plSTATE_STATION_ACTIVE      0x0005    /* The station is online and the copy entries are handle cyclically */
#define plSTATE_STATION_INACTIVE    0x0006    /* The station is offline but was active before */
#define plSTATE_STATION_CHANGED     0x0007    /* The IO configuration of the station has changed, a reboot is necessary to
                                                 allow the changed station to get active. */
#define plSTATE_STATION_CFGFAILED   0x0008    /* The configuration of the station failed, and the option EPL_NoResetOnConfigFail is on. */
#define plSTATE_STATION_FAILED      0x000f    /* Configuration of Station failed (out of memory or other serious problem) */

/* States of Copy Entries */
#define plSTATE_CE_WAITING    1 /* Station for Copy-Entry was not active since Copy-Entry was created */
#define plSTATE_CE_ACTIVE     2 /* Station is online and Copy-Entry is active */
#define plSTATE_CE_INACTIVE   3 /* Copy-Entry is active, but Station is not online */
#define plSTATE_CE_ERROR      4 /* Copy-Entry is not available on its Station */

/* States of Write Channels */
#define plSTATE_CHANNEL_WRITE_MASK    0x0f00  /* Mask state of Read/Write-Channels with this mask to get the Write-State */
#define plSTATE_CHANNEL_WRITE_CLOSED  0x0000  /* This Channel is not opend for Write access */
#define plSTATE_CHANNEL_WRITE_OPEN    0x0100  /* Channel is open, no Frames are waiting to be sent */
#define plSTATE_CHANNEL_WRITE_ACTIVE  0x0200  /* Write-Buffer is waiting to be sent */
#define plSTATE_CHANNEL_WRITE_WRONG   0x0f00  /* Result of plSTATE_WRONG_IDENT & plSTATE_CHANNEL_WRITE_MASK */
/* States of Read Channels */
#define plSTATE_CHANNEL_READ_MASK     0x00f0  /* Mask state of Read/Write-Channels with this mask to get the Read-State */
#define plSTATE_CHANNEL_READ_CLOSED   0x0000  /* This channel is not opend for Read access */
#define plSTATE_CHANNEL_READ_EMPTY    0x0010  /* This channel is open but does not have any frames */
#define plSTATE_CHANNEL_READ_READY    0x0020  /* This channel is open and has a ready frame to be read */
#define plSTATE_CHANNEL_READ_WRONG    0x00f0  /* Result of plSTATE_WRONG_IDEND & plSTATE_CHANNEL_READ_MASK */

/* actionIDs for plAction function */
#define plACTION_GET_NET_QUALITY           1  /* read statistical info of netquality*/
#define plACTION_GET_IDENT                 2  /* get ident of a PowerLink station */
#define plACTION_START_SYNC_STATISTICS     3  /* start collection of statistic information of synchronous task class only on SG3 */
#define plACTION_STOP_SYNC_STATISTICS      4  /* stop collection of statistic information of synchronous task class only on SG3*/
#define plACTION_GET_SYNC_STATISTICS       5  /* read statistic information of synchrounous task class to
                                                 a PLACTION_SYNC_STATISTICS_typ structure only on SG3 */
#define plACTION_GET_FIRMWARE_VERSION      6  /* read version of firmware to UDINT variable */
#define plACTION_DEVICE_TO_BUS_NR          7  /* Convert device string to bus number */
#define plACTION_GET_STATION_NUMBER        8  /* read node number of local station to UDINT variable */
#define plACTION_GET_IF_PARAMETERS         9  /* get the interface parameters for a powerlink bus */
#define plACTION_GET_LOST_INA_SOURCE      10  /* internal only! get last source station of lost ina request to a DINT (-1) if no lost */


#define plACTION_GET_STATIONFLAG          12  /* get station flag e.g. plSYSCONF_STATIONFLAG_SLOW to UDINT variable */
#define plACTION_GET_STATION_HWVARIANT    13  /* get hardware ident of station to UDINT variable */
#define plACTION_GET_STATION_SHIFT        14  /* get cyclic cycle shift of multiplexed station to UDINT variable */

#define plACTION_GET_IF_CYCLE_TIME        15  /* get powerlink cycle time to UDINT variable */
#define plACTION_GET_IF_PRESCALE          16  /* get powerlink prescale to UDINT variable */
#define plACTION_GET_IF_MUXPRESCALE       17  /* get multiplex prescale to UDINT variable */

#define plACTION_GET_IF_RSQUEUELAPCNT     18  /* get rs queue lap count to UDINT variable */

#define plACTION_GET_CROSSLINK_INFO       19  /* get crosslink infomation of input datapoint (only SG4 >= AR V2.85) */

#define plACTION_GET_PROTOCOL_VERSION     20  /* get set protocol version to UDINT variable */
#define plACTION_GET_DP_INFO              21  /* query the PDO information of an I/O data point (only SG4 >= AR B2.96) */
#define plACTION_GET_PDO_INFO             22  /* query the PDO information of by Index/Subindex (only SG4 >= AR B2.96) */
/* action 23, 24 and 25 used by ncman */

#define	plDIRECTION_IN                     1  /* Direction "input" to PLC returned from plACTION_GET_PDO_INFO */
#define	plDIRECTION_OUT                    2  /* Direction "output" from PLC returned from plACTION_GET_PDO_INFO */
#define	plDIRECTION_XOUT                   3  /* Direction "crosslinked output" returned from plACTION_GET_PDO_INFO */

#define plMESSAGE_TYPE_PREQ                3  /* MessageType "poll request" returned from plACTION_GET_PDO_INFO */
#define plMESSAGE_TYPE_PRES                4  /* MessageType "poll response" returned from plACTION_GET_PDO_INFO */

/* Flags for stations in config */
#define plSYSCONF_STATIONFLAG_SLOW              0x20  /* Station is a slow one */

/* Data types for system configuration */

/* Konfiguration for remote stations */
typedef struct PLSYSCONF_RS_typ
{
	USINT size_x16;     /* Size of configuration entry in blocks of 16 bytes (by now always 1) */
	                    /* Set size_x16 to 0 to mark the last remote station configuration entry */
	USINT bus;          /* Bus number: Valid Numbers 1 .. 255 */
	USINT station;      /* Station number */
	USINT flags;        /* flags as OR of constants plSYSCONF_STATIONFLAG_... */
	UDINT hwVariant;    /* Hardware variant: 0=any */
	INT insize;         /* Size for input buffer (0xffff for automatic)*/
	INT outsize;        /* Size for output buffer (0xffff for automatic)*/
	INT RespTimeout;	/* response timeout in µs <= 0 -> default = 25µs */
	USINT MuxNetworkSlot; /* ignored for normal stations, for multiplexed stations 1 to MuxPrescaler */
	USINT reserve2;     /* reserved set to 0 */
}PLSYSCONF_RS_typ;

/* Konfiguration of interfaces */
typedef struct PLSYSCONF_IF_typ/* Configuration structure for PowerLink Interface Modules */
{
    USINT station;      /* Station number 0 for Master, 1..253 for intelligent slave */
    USINT slot;         /* Module Slot 0..directly on CPU, slotnumber on Backplane */
    USINT subslot;      /* Slot in CP260 1 or 2, in other cases allways 1 */
    USINT interface;    /* allways 1*/
    UDINT pl_cycle;     /* cycle time of PowerLink cycle in us */
	UDINT pl_prescale;  /* prescaler for synchron PowerLink timer-taskclass */
    UDINT uptimeout;    /* timeout for configurated remote stations at power up in us */
    USINT bus;          /* Bus number of PowerLink interface. Corresponds to
                           "bus" element in the PLSYSCONF_RS_typ. Valid Number 1...255.
                           If bus is set to 0, the Library countes the busses by itself. */
    USINT MuxStationsPerCycle;  /* ignored since FW-Version V0.06.0: until FW-Version V0.05.9 number of handled multiplexed stations in each powerlink cycle */
    USINT MuxPrescaler; /* number of powerlink cycles for one mux cycle 1 .. 253 */
    USINT reservedbyte2; /* reserved set to 0 */
    UDINT reservedlong; /* reserved set to 0 */
}PLSYSCONF_IF_typ;

typedef struct PLSYSCONF_typ /* global PowerLink configuration */
{
    USINT noIF;         /* Number of interface Cards (allways 1)*/
    USINT takt_master;  /* Which interface is taktmaster (allways 1), 0 for no taktmaster */
    UINT  reserve1;     /* reserved set to 0 */
    UDINT pRemoteCfg;   /* Pointer to array of remote station configuration */
                        /* end array with an entry with .size_x16=0 */
    PLSYSCONF_IF_typ interfaces[15]; /* Interface configurations */
}PLSYSCONF_typ;

/* Object structures for plAction function */
typedef struct PLACTION_NET_QUALITY_typ{
	UDINT nLineQualFreezeCnt; /* out: count of started io cycles within last time */
	UDINT nLineQualFailCnt;   /* out: count of failed cycles within last time */
}PLACTION_NET_QUALITY_typ;

typedef struct PLACTION_GET_IDENT_typ{
	char *pName;    /* in:  name  */
	UDINT ident;    /* out: ident */
}PLACTION_GET_IDENT_typ;

typedef struct PLACTION_DEVICE_TO_BUS_NR_typ{
	char *pDeviceString;  /* in:  device string   */
	USINT busNumber;      /* out: bus number      */
}PLACTION_DEVICE_TO_BUS_NR_typ;

/* PLACTION_SYNC_STATISTICS_typ Supported only on SG3 */
typedef struct PLACTION_SYNC_STATISTICS_typ{
	UINT act_usec;             /* out: duration of last synchrounous taskclass */
	UINT min_usec;             /* out: minimal duration of synchrounous taskclass */
	UINT max_usec;             /* out: maximal duration of synchrounous taskclass */
	UINT act_cycle;            /* out: exact cycletime of last synchronous taskclass */
	UINT min_cycle;            /* out: minimal cycletime of synchronous taskclass */
	UINT max_cycle;            /* out: maximal cycletime of synchronous taskclass */
}PLACTION_SYNC_STATISTICS_typ;

typedef struct PLACTION_GET_CROSSLINK_INFO_typ{
	const char *DeviceName;    /* in: name of io device e.g. "SS1.IF2.ST3.SL7" */
	const char *ChannelName;   /* in: name of datapoint e.g. "AnalogInput01" */
	UINT NodeId;               /* out: Node number of powerlink station */
	UINT Offset;               /* out: Offset in data counted in Bits */
	UINT Length;               /* out: Length of data point counted in Bits */
	UINT TypeId;               /* out: Type ident of datapoint EPL V2 (matches CANopen Specification) */
}PLACTION_GET_CROSSLINK_INFO_typ;

typedef struct PLACTION_GET_DP_INFO_typ{
	const char *DeviceName;    /* in: name of io device e.g. "SS1.IF2.ST3.SL7" */
	const char *ChannelName;   /* in: name of datapoint e.g. "AnalogInput01" */
	USINT DestNode;            /* out: Node number of destination in network frame */
	USINT SrcNode;             /* out: Node number of source in network frame */
	USINT MessageType;         /* out: Message Type on Powerlink (plMESSAGE_TYPE_PREQ(=3) PReq, plMESSAGE_TYPE_PRES(=4) PRes) */
	USINT MuxSlot;             /* out: multiplex slot (0 continous station) */
	UINT OffsetAbs;            /* out: Offset in net data of EPL frame counted in bits */
	UINT OffsetRel;            /* out: Offset relative to station net data in bits */
	UINT Length;               /* out: Length of data point counted in bits */
	UINT TypeId;               /* out: Type ident of datapoint EPL V2 (matches CANopen Specification) */
	UINT NodeInSize;           /* out: input net size of station (PRes) */
	UINT NodeOutSize;          /* out: output net size of station (size of PReq, or part of PResMN ) */
	USINT Direction;           /* out: plDIRECTION_IN(=1) Input,plDIRECTION_OUT(=2) Output relative to local node */
	USINT Node;                /* out: node of datapoint */
	UINT reserved;             /* res: reserved word for alignment */
	UDINT ImageIndex;          /* out: image index for inputs 0 for outputs */
	UDINT ImageOffset;         /* out: offset of datapoint in local image buffer (bytes) */
}PLACTION_GET_DP_INFO_typ;

typedef struct PLACTION_GET_PDO_INFO_typ{
	const char *DeviceName;    /* in: name of io device e.g. "SS1.IF2.ST3.SL7" */
	UINT ODIndex;              /* in: Index of object in Powerlink object dictionary */
	USINT ODSubindex;          /* in: query the PDO information of by Index/Subindex */
	USINT align;               /* res: reseved for alignment */
	USINT DestNode;            /* out: Node number of destination in network frame */
	USINT SrcNode;             /* out: Node number of source in network frame */
	USINT MessageType;         /* out: Message Type on Powerlink (plMESSAGE_TYPE_PREQ(=3) PReq, plMESSAGE_TYPE_PRES(=4) PRes) */
	USINT MuxSlot;             /* out: multiplex slot (0 continous station) */
	UINT OffsetAbs;            /* out: Offset in net data of EPL frame counted in bits */
	UINT OffsetRel;            /* out: Offset relative to station net data in bits */
	UINT Length;               /* out: Length of data point counted in bits */
	UINT TypeId;               /* out: Type ident of datapoint EPL V2 (matches CANopen Specification) */
	UINT NodeInSize;           /* out: input net size of station (PRes) */
	UINT NodeOutSize;          /* out: output net size of station (size of PReq, or part of PResMN ) */
	USINT Direction;           /* out: plDIRECTION_IN(=1) Input,plDIRECTION_OUT(=2) Output relative to local node */
	USINT Node;                /* out: node of datapoint */
	UINT reserved;             /* res: reserved word for alignment */
	UDINT ImageIndex;          /* out: image index for inputs 0 for outputs */
	UDINT ImageOffset;         /* out: offset of datapoint in local image buffer (bytes) */
}PLACTION_GET_PDO_INFO_typ;

/* Prototyping of functions and function blocks */
UINT plConfig(PLSYSCONF_typ *pConfigStruct);
UINT plCECreate(const char* pDatapoint, void* address, SINT taskclass, UDINT *pIdent);
UINT plCEDelete(UDINT ident);
UINT plState(UDINT ident);
UINT plAction(UDINT ident, UDINT actionID, void* pObject, UDINT objectSize);
UINT plAcycOpen(const char* pName, UDINT flags, UDINT *pIdent);
UINT plAcycClose(UDINT ident);
UINT plAcycRead(UDINT ident, void* bufferAdr, UDINT bufferLen, UDINT *pReadLen);
UINT plAcycInvite(UDINT ident);
UINT plAcycWrite(UDINT ident, void* bufferAdr, UDINT bufferLen, UDINT *pWrittenLen);

#ifdef __cplusplus
};
#endif
#endif /* POWERLNK_H_ */

