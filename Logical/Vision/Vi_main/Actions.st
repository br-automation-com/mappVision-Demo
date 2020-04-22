ACTION ACTION_InitCodeTypes:
	CodeTypes[0]	:= 'Auto Identify (0)';;
	CodeTypes[1]	:= '2/5 Industrial (1)';
	CodeTypes[2]	:= '2/5 Interleaved (2)';
	CodeTypes[3]	:= 'Codebar (3)';
	CodeTypes[4]	:= 'Code 32 (4)';
	CodeTypes[5]	:= 'Code 39 (5)';
	CodeTypes[6]	:= 'Code 93 (6)';
	CodeTypes[7]	:= 'Code 128 (7)';
	CodeTypes[8]	:= 'MSI (8)';
	CodeTypes[9]	:= 'PharmaCode (9)';
	CodeTypes[10]	:= 'EAN-8 (10)';
	CodeTypes[11]	:= 'EAN-8 Add-On 2 (11)';
	CodeTypes[12]	:= 'EAN-8 Add-On 5 (12)';
	CodeTypes[13]	:= 'EAN-13 (13)';
	CodeTypes[14]	:= 'EAN-13 Add-On 2 (14)';
	CodeTypes[15]	:= 'EAN-13 Add-On 5 (15)';
	CodeTypes[20]	:= 'UPC-A (20)';
	CodeTypes[21]	:= 'UPC-A Add-On 2 (21)';
	CodeTypes[22]	:= 'UPC-A Add-On 5 (22)';
	CodeTypes[23]	:= 'UPC-E (23)';
	CodeTypes[24]	:= 'UPC-E Add-On 2 (24)';
	CodeTypes[25]	:= 'UPC-E Add-On 5 (25)';
	CodeTypes[30]	:= 'GS1-128 (30)';
	CodeTypes[31]	:= 'GS1 DataBar Omnidirectional (31)';
	CodeTypes[32]	:= 'GS1 DataBar Truncated (32)';
	CodeTypes[33]	:= 'GS1 DataBar Stacked (33)';
	CodeTypes[34]	:= 'GS1 DataBar Stacked Omnidirectional (34)';
	CodeTypes[35]	:= 'GS1 DataBar Limited (35)';
	CodeTypes[36]	:= 'GS1 DataBar Expanded (36)';
	CodeTypes[37]	:= 'GS1 DataBar ExpandedStacked (37)';
	CodeTypes[50]	:= 'Data Matrix ECC200 (50)';
	CodeTypes[51]	:= 'QR Code Model 1 (51)';
	CodeTypes[52]	:= 'QR Code Model 2 (52)';
	CodeTypes[53]	:= 'Micro QRCode (53)';
	CodeTypes[54]	:= 'PDF417 (54)';
	CodeTypes[55]	:= 'Aztec Code (55)';
	CodeTypes[60]	:= 'GS1 Data Matrix (60)';
	CodeTypes[61]	:= 'GS1 QR Code Model 1 (61)';
	CodeTypes[62]	:= 'GS1 QR Code Model 2 (62)';
	CodeTypes[63]	:= 'GS1 Aztec Code (63)';
	FOR i := 0 TO MAX_NUM_CODETYPES DO
		IF CodeTypes[i] <> '' THEN
			brsstrcat(ADR(visCodeTypePresentDropDownValues[i]), ADR('{"value":"'));
			brsitoa(i, ADR(tmpStr1));
			brsstrcat(ADR(visCodeTypePresentDropDownValues[i]), ADR(tmpStr1));
			brsstrcat(ADR(visCodeTypePresentDropDownValues[i]), ADR('","text":"'));
			brsstrcat(ADR(visCodeTypePresentDropDownValues[i]), ADR(CodeTypes[i]));
			brsstrcat(ADR(visCodeTypePresentDropDownValues[i]), ADR('"}'));
		END_IF
	END_FOR
END_ACTION
