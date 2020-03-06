(********************************************************************
 * COPYRIGHT (C) BERNECKER + RAINER, AUSTRIA, A-5142 EGGELSBERG
 ********************************************************************
 * Library: ViBase
 * File:	ViBase.typ
 ********************************************************************
 * Declaration of data-types of library ViBase
 ********************************************************************)




TYPE
	ViBaseExecInternalType : STRUCT (*Internal structure-types for FB-processing*)
		i_serno : UINT;
		i_state : UINT;
		Result	: DINT;
	END_STRUCT;

	ViBaseInternalType : STRUCT (*Internal structure-types for FB-processing*)
		i_base	: ViBaseExecInternalType;
		m_ctx	: UDINT; (*internal reference; e.g. memory-pointer*)
	END_STRUCT;

END_TYPE