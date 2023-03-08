
ACTION processResultsAction: 

		//Conversion of individual USINT values into strings for OCR
	brsmemset(ADR(hmi.out.VF.ocrData),0,SIZEOF(hmi.out.VF.ocrData));
	IF  hw.VF.ocr.in.common.numResults > 0 THEN
		FOR j:=0 TO hw.VF.ocr.in.common.numResults-1 DO
			brsmemcpy(ADR(hmi.out.VF.ocrData[j]),ADR(hw.VF.ocr.in.results[j].data),SIZEOF(hw.VF.ocr.in.results[j].data));
		END_FOR;
	END_IF
	
	//Conversion of individual USINT values into strings for Code Reader
	brsmemset(ADR(hmi.out.VF.crData),0,SIZEOF(hmi.out.VF.crData));
	IF  hw.VF.codeReader.in.common.numResults > 0 THEN
		FOR j:=0 TO hw.VF.codeReader.in.common.numResults-1 DO
			brsmemcpy(ADR(hmi.out.VF.crData[j]),ADR(hw.VF.codeReader.in.results[j].data),SIZEOF(hw.VF.codeReader.in.results[j].data));
		END_FOR;
	END_IF
		
	
	
	// conversion of variables to suitable data types
	hmi.in.cmd.draw.strStrokeWidth := INT_TO_STRING(hmi.in.cmd.draw.intStrokeWidth);
	hmi.in.cmd.draw.strFillOpac := REAL_TO_STRING(hmi.in.cmd.draw.realFillOpac);
	hmi.in.cmd.draw.strStrokeOpac := REAL_TO_STRING(hmi.in.cmd.draw.realStrokeOpac);
	
	// DRAW CIRCLES ON RESULTS

	//check results and their position
		
	IF hw.VF.blob.in.common.numResults > 0 THEN
			
		hmi.out.svgOverlay := '';
		
			FOR i:= 0 TO hw.VF.blob.in.common.numResults-1 BY 1 DO
				this.tmp2D.x := DINT_TO_REAL(hw.VF.blob.in.results[i].positionX) / 100.0;
				this.tmp2D.y := DINT_TO_REAL(hw.VF.blob.in.results[i].positionY) / 100.0;
				
				// STYLE STRING GENERATION			
				// merging of individual strings into desired result string (e.g.:'style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"')	
				this.strElemId := UINT_TO_STRING(i);
				
				hmi.in.cmd.draw.strStyle := 'id="1'; 
								
				brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(this.strElemId));
				brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR('" style="'));
				brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strFillColor));		// string for fill color attribute (text + value)
				brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strStrokeColor));	// string for stroke color attribute (text + value)
				brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(';stroke-width:')); 				// string for stroke width attribute (text)
				brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strStrokeWidth));	// string for stroke width attribute (value)
				brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(';fill-opacity:')); 				// string for fill opacity attribute (text)
				brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strFillOpac)); 		// string for fill opacity attribute (value)
				brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(';stroke-opacity:')); 				// string for stroke opacity attribute (text)
				brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strStrokeOpac)); 	// string for stroke opacity attribute (value)		
				brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR('"'));
				
				
				
				// DRAW SELECTED SHAPE WITH SPECIFIED PARAMETERS ON THE OVERLAY
				CASE hmi.in.cmd.draw.intShape OF
					0: // Rectangle
						brdkViGeom_drawSvgRectFromCP(this.tmp2D,hmi.in.cmd.draw.length,hmi.in.cmd.draw.width,hmi.in.cmd.draw.rotation,ADR(hmi.out.svgOverlay),ADR(hmi.in.cmd.draw.strStyle));
					1: // Circle
						brdkViGeom_drawSvgCircle(this.tmp2D,hmi.in.cmd.draw.radius,ADR(hmi.out.svgOverlay),ADR(hmi.in.cmd.draw.strStyle));
					2: // Triangle
						brdkViGeom_drawSvgTriFromCP(this.tmp2D,hmi.in.cmd.draw.length,hmi.in.cmd.draw.width,hmi.in.cmd.draw.rotation,ADR(hmi.out.svgOverlay),ADR(hmi.in.cmd.draw.strStyle));	  
	
				END_CASE;
			
			END_FOR;
		END_IF;

	
//	// ERASE ALL
//	IF hmi.in.cmd.draw.reset THEN
//		hmi.out.svgOverlay := '';
//	END_IF;
	


	//
	
END_ACTION
