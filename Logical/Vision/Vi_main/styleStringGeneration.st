
ACTION styleStringGeneration:
		
	brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(this.strElemId));					// string for element id attribute (value)
		brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR('" style="'));						// string for beginning of the style paramateres (text)
		brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strFillColor));		// string for fill color attribute (text + value)
		brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strStrokeColor));	// string for stroke color attribute (text + value)
		brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(';stroke-width:')); 				// string for stroke width attribute (text)
		brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strStrokeWidth));	// string for stroke width attribute (value)
		brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(';fill-opacity:')); 				// string for fill opacity attribute (text)
		brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strFillOpac)); 		// string for fill opacity attribute (value)
		brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(';stroke-opacity:')); 				// string for stroke opacity attribute (text)
		brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strStrokeOpac)); 	// string for stroke opacity attribute (value)		
		brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR('"'));
END_ACTION
