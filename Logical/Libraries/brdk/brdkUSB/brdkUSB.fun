
FUNCTION_BLOCK brdkUSBConnect (*This function block outputs a list of all connected USB flash devices with a connected device name that can be used in e.g. FileIO library. B&R technology guards are filtered away from the node list.*)
	VAR_INPUT
		updateMemInfo : BOOL; (*Updates the memory info of the nodes*)
		simulateMount : BOOL; (*Simulates a USB mount. Creates a file device for C:\USB\*)
	END_VAR
	VAR_OUTPUT
		node : ARRAY[0..BRDK_USB_MAX_DEVICES] OF brdk_usb_connect_node_output_typ; (*List of avaible USB nodes*)
		status : brdk_usb_status_typ; (*Status of the function block*)
	END_VAR
	VAR
		internal : brdk_usb_connect_internal_typ; (*internal variables*)
	END_VAR
END_FUNCTION_BLOCK
