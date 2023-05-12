
ACTION setupPointersAction:
	
	hmi ACCESS ADR(hmiInstance[idx]);
	hw ACCESS ADR(hwInstance[idx]);
	this ACCESS ADR(localInstance[idx]);

END_ACTION
