
TYPE
	brdk_usb_status_typ : 
		( (*Status of the function block*)
		BRDK_USB_STATUS_NO_USB_DEV_FOUND, (*No USB device found*)
		BRDK_USB_STATUS_FB_READY (*Ready to connect*)
		);
	brdk_usb_connect_node_output_typ : 	STRUCT  (*Node device info*)
		device : STRING[5]; (*Node device name*)
		freeMemory : DINT; (*[Mb] -1 means memory info could not be read*)
		totalMemory : DINT; (*[Mb] -1 means memory info could not be read*)
	END_STRUCT;
	brdk_usb_connect_internal_typ : 	STRUCT  (*internal variables*)
		UsbNodeListGet_0 : UsbNodeListGet; (*get node list*)
		nodeIdBuffer : ARRAY[0..BRDK_USB_MAX_DEVICES]OF UDINT; (*node id buffer*)
		oldCnt : UDINT; (*old count*)
		node : ARRAY[0..BRDK_USB_MAX_DEVICES]OF brdk_usb_connect_int_node_typ; (*node list*)
		simulationMountActivated : BOOL; (*is the mount being simulated*)
	END_STRUCT;
	brdk_usb_connect_int_node_typ : 	STRUCT  (*internal node variables*)
		state : UINT; (*node state*)
		infoBuffer : usbNode_typ; (*node info*)
		UsbNodeGet_0 : UsbNodeGet; (*usb get node*)
		DevLink_0 : DevLink; (*creates a deveice link*)
		DevUnlink_0 : DevUnlink; (*unlinks a device link*)
		DevMemInfo_0 : DevMemInfo; (*reads the memory info about the device*)
		device : STRING[8]; (*device name*)
		param : STRING[20]; (*device parameters*)
		devLinkFailCnt : UDINT; (*faild dev link count*)
	END_STRUCT;
END_TYPE
