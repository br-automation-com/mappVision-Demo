(********************************************************************
 * COPYRIGHT (C) BERNECKER + RAINER, AUSTRIA, A-5142 EGGELSBERG
 ********************************************************************
 * Library: ViBase
 * File:	ViBase.fun
 ********************************************************************
 * Declaration of IEC-FBs of library ViBase
 ********************************************************************)

FUNCTION_BLOCK ViBaseSaveDiagData (*A set of diagnostic data for the image processing on a camera can be saved to the PLC with function block ViBaseSaveDiagData.*)
	VAR_INPUT
		MpLink : REFERENCE TO ViComponentType; (*Pointer to the vision component from which diagnostic data should be stored.*)
		Execute : BOOL; (*Execution of the function block begins on a rising edge of this input.*)
		DeviceName : REFERENCE TO STRING[50]; (*Pointer to the device name. Points to the name of an existing file device (e.g. "HD0") that was created in AS or with function block DevLink.*)
		FileName : REFERENCE TO STRING[255]; (*Pointer to the filename. The filename consists of the path and filename (e.g. "dir1\package1.tar.gz"). The path specification refers to the specified file device. If no name is specified, <Nettime>.tar.gz is used.*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Execution successful. Function block is finished.*)
		Busy : BOOL; (*The function block is active and must continue to be called.*)
		Error : BOOL; (*Error during execution.*)
		StatusID : DINT; (*Status information*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViBaseLoadApplication (*Function block ViBaseLoadApplication can be used to load a vision application from the controller to a camera module.*)
	VAR_INPUT
		MpLink : REFERENCE TO ViComponentType; (*Pointer to the vision component to which the vision application is loaded.*)
		Execute : BOOL; (*Execution of the function block begins on a rising edge of this input.*)
		Name : REFERENCE TO STRING[50]; (*Pointer to the name of the vision application to be loaded.*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Execution successful. Function block is finished.*)
		Busy : BOOL; (*The function block is active and must continue to be called.*)
		Error : BOOL; (*Error during execution.*)
		StatusID : DINT; (*Status information*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViBaseDeleteApplication (*Function block ViBaseDeleteApplication can be used to delete a vision application from the controller.*)
	VAR_INPUT
		MpLink : REFERENCE TO ViComponentType; (*Pointer to the vision component .*)
		Execute : BOOL; (*Execution of the function block begins on a rising edge of this input.*)
		Name : REFERENCE TO STRING[50]; (*Pointer to the name of the vision application to be loaded.*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Execution successful. Function block is finished.*)
		Busy : BOOL; (*The function block is active and must continue to be called.*)
		Error : BOOL; (*Error during execution.*)
		StatusID : DINT; (*Status information*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViBaseSaveApplication (*Function block ViBaseSaveApplication can be used to save a vision application from a camera module to the controller.*)
	VAR_INPUT
		MpLink : REFERENCE TO ViComponentType; (*Pointer to the vision component from which the vision application is saved.*)
		Execute : BOOL; (*Execution of the function block begins on a rising edge of this input.*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Execution successful. Function block is finished.*)
		Busy : BOOL; (*The function block is active and must continue to be called.*)
		Error : BOOL; (*Error during execution.*)
		StatusID : DINT; (*Status information*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViBaseSaveApplicationAs (*Function block ViBaseSaveApplicationAs can be used to save a vision application under a different name*)
	VAR_INPUT
		MpLink : REFERENCE TO ViComponentType; (*Pointer to the vision component from which the vision application is saved.*)
		Execute : BOOL; (*Execution of the function block begins on a rising edge of this input.*)
		Name : REFERENCE TO STRING[50]; (*Pointer to the name under which the vision application will be saved.*)
		Overwrite : BOOL; (*Check for a already existing VA, overwrite it if existing and compatible.*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Execution successful. Function block is finished.*)
		Busy : BOOL; (*The function block is active and must continue to be called.*)
		Error : BOOL; (*Error during execution.*)
		StatusID : DINT; (*Status information*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViBaseListApplication (*Function block ViBaseListApplication can be used to get the list of loadable vision applications.*)
	VAR_INPUT
		MpLink : REFERENCE TO ViComponentType; (*Pointer to the vision component to which the vision application is loaded.*)
		Execute : BOOL; (*Execution of the function block begins on a rising edge of this input.*)
		Format : ViBaseFormatEnum; (*Determines the text format in which applications are listed.*)
		List : UDINT; (*Pointer to a memory area to which the information is copied.
													The data type depends on the selected format:
													- Pointer to ViBaseFormatPlainTextType[MaxEntries]
													- Pointer to ViBaseFormatItemCollectionType[MaxEntries]*)
		ListLen : UDINT; (*Length of the provided data area (a multiple of the size of the structure selected via the format).
Size of the whole list, e.g. sizeof(List).*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Execution successful. Function block is finished.*)
		Busy : BOOL; (*The function block is active and must continue to be called.*)
		Error : BOOL; (*Error during execution.*)
		StatusID : DINT; (*Status information*)
		NrEntries : UINT; (*Number of vision application found.*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViBaseGetImage (*Function block ViBaseGetImage can be used to get the last acquired image.*)
	VAR_INPUT
		MpLink : REFERENCE TO ViComponentType; (*Pointer to the vision component.*)
		Execute : BOOL; (*Execution of the function block begins on a rising edge of this input.*)
		Type : ViBaseImageTypeEnum; (*Determines the image format in which the image data is provided.*)
		QualityLevel: USINT; (*JPG compression quality level. Ignored for type viBASE_IMAGE_TYPE_BMP.*)
		Timeout : TIME; (*Max. time to execute the function block. When the timeout expires, the function block is terminated with error. 0 = timeout disabled. *)
		Buffer : UDINT; (*Pointer to a memory area to which the image data is copied.*)
		BufferSize : UDINT; (*Length of the provided data area in bytes.*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Execution successful. Function block is finished.*)
		Busy : BOOL; (*The function block is active and must continue to be called.*)
		Active : BOOL; (*It is possible to acquire the next image on the camera without disturbing the Function block*)
		Error : BOOL; (*Error during execution.*)
		StatusID : DINT; (*Status information*)
		BufferLen : UDINT; (*Number of bytes actually copied.*)
		Nettime : DINT; (*Nettime image was taken*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ViBaseAxisBasedAcquisition (*Function block ViBaseAxisBasedAcquisition can be used to acquisition a picture by axis position.*)
	VAR_INPUT
		MpLink : REFERENCE TO ViComponentType; (*Pointer to the vision component.*)
		Enable : BOOL; (*Function block is active as long as Enable is set.*)
		AcquisitionParameters : ViBaseAxBsdAcqAcqParType; (*Parameters which define when the capturing is triggered based on the axis position.*)
		AdvancedParameters: ViBaseAxBsdAcqAdvParType; (*Structure for using advanced functions.*)
		Update : BOOL; (*Updates the trigger parameters. *)
		PauseAcquisition : BOOL; (*If set to TRUE, the internal calculations are still active, but no image will be acquired.*)
		ForceAcquisition : BOOL; (*On a rising edge of this input an image acquisition is forced.*)
	END_VAR
	VAR_OUTPUT
		InOperation : BOOL; (*Calculations are active and time stamps are forwarded to the vision component.*)
		Busy : BOOL; (*The function block is active and must continue to be called.*)
		Error : BOOL; (*Error during execution.*)
		StatusID : DINT; (*Status information*)
		UpdateDone : BOOL; (*Indicates that new trigger data has been initialized.*)
		AdditionalInfo : ViBaseAxBsdAcqAddInfoType; (*Additional useful data, e.g. for system monitoring or error analysis.*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} ViBaseInternalType;
	END_VAR
END_FUNCTION_BLOCK
