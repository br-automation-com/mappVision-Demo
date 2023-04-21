
TYPE
	brdk_file_dev_handler_int_typ : 	STRUCT  (*Internal variables.*)
		fileState : UINT; (*State of the file device handler.*)
		driveState : UINT; (*State of the drive handler.*)
		DevLink_0 : DevLink; (*Device link.*)
		DevUnlink_0 : DevUnlink; (*Device unlink.*)
		DirInfo_0 : DirInfo; (*Directory create.*)
		drive : STRING[30]; (*Drive.*)
		deviceParam : STRING[BRDK_FILE_MAX_PATH_LEN]; (*Device parameter string.*)
		fileIdx : DINT; (*File index.*)
		activeHandles : ARRAY[0..BRDK_FILE_MAX_FILES_DEVICES]OF UDINT; (*Active handles.*)
		driveReady : BOOL; (*Drive ready to use.*)
		oldUseUSB : BOOL; (*Holds the old command.*)
		usbOK : BOOL; (*USB drive present and ready to use.*)
		brdkFileCreateSubFolders_0 : brdkFileCreateSubFolders; (*Create sub folders.*)
		UsbNodeListGet_0 : UsbNodeListGet; (*Get list of USB nodes.*)
		UsbNodeGet_0 : UsbNodeGet; (*Get USB node.*)
		nodeId : ARRAY[0..BRDK_FILE_MAX_USB_NODES]OF UDINT; (*Node id buffer list.*)
		nodeIdx : USINT; (*Node id index.*)
		usbNode : usbNode_typ; (*Node info.*)
		oldUSBok : BOOL; (*Holds the old status.*)
		oldNodeId : UDINT; (*Holds the old node id.*)
	END_STRUCT;
	brdk_file_dev_handler_sim_typ : 	STRUCT  (*Simulation options.*)
		pcRootFolder : STRING[BRDK_FILE_MAX_PATH_LEN] := 'plcRoot'; (*Path on the PC that will simulate the root of the controller. Default plcRoot -> C:\plcRoot\*)
		pcUSBDrive : brdk_file_drive_typ := D_DRIVE; (*Drive letter of the PC's USB. Default D:\.*)
		pcHDDrive : brdk_file_drive_typ := C_DRIVE; (*Drive letter of the PC's HD. Default C:\.*)
	END_STRUCT;
	brdk_file_dev_handler_setup_typ : 	STRUCT  (*Setup options.*)
		plcDrive : brdk_file_drive_typ := C_DRIVE; (*Drive letter of the controller flash. Default C:\.*)
		usbOverrule : BOOL := FALSE; (*Inserted USB stick will overrule internal flash if the USB stick is present.*)
		fileDevices : ARRAY[0..BRDK_FILE_MAX_FILES_DEVICES]OF brdk_file_file_devices_typ := [(name:='CONFIG',path:='config'),(name:='RECIPES',path:='recipes'),8((0))]; (*File devices. Default CONFIG and RECEIPES with config and recipes folder.*)
		rootFileDeviceName : STRING[10] := 'ROOT';
	END_STRUCT;
	brdk_file_drive_typ : 
		( (*Drive selection. Default C:\.*)
		C_DRIVE := 0, (*C:\*)
		D_DRIVE := 1, (*D:\*)
		E_DRIVE := 2, (*E:\*)
		F_DRIVE := 3, (*F:\*)
		G_DRIVE := 4 (*G:\*)
		) := C_DRIVE;
	brdk_file_file_devices_typ : 	STRUCT  (*File devices setup.*)
		name : STRING[BRFK_FILE_MAX_FILE_DEVICE_LEN]; (*Name of the file device to be used as input for file functions.*)
		path : STRING[BRDK_FILE_MAX_PATH_LEN]; (*Folder path for the file device. Only the folders must be entered the drive is setup in the setup options. E.g. config.*)
	END_STRUCT;
	brdk_file_create_subfold_int_typ : 	STRUCT  (*Internal variables.*)
		state : DINT; (*State of the function block.*)
		DirCreate_0 : DirCreate; (*Directory create.*)
		tmpPath : STRING[BRDK_FILE_MAX_PATH_LEN]; (*Temp path string.*)
		pathPos : DINT; (*Path position.*)
		tmpPathPos : DINT; (*Tmp path position.*)
		tmpLen : DINT; (*Temp length.*)
	END_STRUCT;
	brdk_file_read_internal_typ : 	STRUCT  (*Internal variables.*)
		state : DINT; (*State of the function block.*)
		FileOpen_0 : FileOpen; (*File open.*)
		FileClose_0 : FileClose; (*File close.*)
		FileReadEx_0 : FileReadEx; (*File read.*)
		offset : UDINT; (*Read offset.*)
	END_STRUCT;
	brdk_file_write_internal_typ : 	STRUCT  (*Internal variables.*)
		state : DINT; (*State of the function block.*)
		FileOpen_0 : FileOpen; (*File open.*)
		FileCreate_0 : FileCreate; (*File create.*)
		FileClose_0 : FileClose; (*File close.*)
		FileDelete_0 : FileDelete; (*File delete.*)
		FileWrite_0 : FileWrite; (*File write.*)
	END_STRUCT;
END_TYPE