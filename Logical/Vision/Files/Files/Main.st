
PROGRAM _INIT
	(* Insert code here *)
	this.brdkFileDev.enable := TRUE;
	this.brdkFileDev.setup.plcDrive := F_DRIVE;
	this.brdkFileDev.setup.usbOverrule := FALSE;
	this.brdkFileDev.simulation.pcRootFolder := 'plcSim\MappVisionDemo';
	this.brdkFileDev.simulation.pcHDDrive := C_DRIVE;
	this.brdkFileDev.setup.rootFileDeviceName := 'ROOT_PLC';
	
	this.brdkFileDev.setup.fileDevices[0].name := 'SIM_BLOB';
	this.brdkFileDev.setup.fileDevices[0].path := 'sim/BLOB';
	this.brdkFileDev.setup.fileDevices[1].name := 'SIM_CR';
	this.brdkFileDev.setup.fileDevices[1].path := 'sim/CR';
	this.brdkFileDev.setup.fileDevices[2].name := 'SIM_MATCH';
	this.brdkFileDev.setup.fileDevices[2].path := 'sim/Match';
	this.brdkFileDev.setup.fileDevices[3].name := 'SIM_MEAS';
	this.brdkFileDev.setup.fileDevices[3].path := 'sim/Measurement';
	this.brdkFileDev.setup.fileDevices[4].name := 'SIM_OCR';
	this.brdkFileDev.setup.fileDevices[4].path := 'sim/OCR';
	this.brdkFileDev.setup.fileDevices[5].name := 'SIM_PXCNT';
	this.brdkFileDev.setup.fileDevices[5].path := 'sim/PxCnt';
		
	
	
	this.brdkFileDevUsb.setup.plcDrive := F_DRIVE;
	this.brdkFileDevUsb.setup.usbOverrule := TRUE;
	this.brdkFileDevUsb.simulation.pcRootFolder := 'plcSim\MappVisionDemo';
	this.brdkFileDevUsb.simulation.pcHDDrive := C_DRIVE;
	this.brdkFileDevUsb.simulation.pcUSBDrive := D_DRIVE;
	this.brdkFileDevUsb.setup.rootFileDeviceName := 'ROOT_USB';
	
	this.brdkFileDevUsb.setup.fileDevices[0].name := 'IMG';
	this.brdkFileDevUsb.setup.fileDevices[0].path := 'images';
	this.brdkFileDevUsb.setup.fileDevices[1].name := 'RECIPE';
	this.brdkFileDevUsb.setup.fileDevices[1].path := 'Recipe';
	this.brdkFileDevUsb.setup.fileDevices[2].name := 'VI_DIAG';
	this.brdkFileDevUsb.setup.fileDevices[2].path := 'visionDiag';
	
END_PROGRAM


PROGRAM _CYCLIC
	(* Insert code here *)
	 

	this.brdkFileDev();
	
	IF EDGEPOS(this.brdkFileDev.ready) THEN
		this.brdkFileDevUsb.enable := TRUE;
	END_IF
	
	this.brdkFileDevUsb();
	
	gFiles.output.fileDevice := 'ROOT';
	gFiles.output.ready := this.brdkFileDevUsb.ready;
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
	END_PROGRAM

