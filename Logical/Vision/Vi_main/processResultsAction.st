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
	hmi.out.svgOverlay := '';
	//BLOB
	IF hw.VF.blob.in.common.numResults > 0 THEN
		
		FOR i:= 0 TO hw.VF.blob.in.common.numResults-1 BY 1 DO
			this.tmp2D.x := DINT_TO_REAL(hw.VF.blob.in.results[i].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.blob.in.results[i].positionY) / 100.0;
				
			// Style string generation			
			// e.g.:'id="13" style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'	
				
			this.strElemId := UINT_TO_STRING(i);
			
			hmi.in.cmd.draw.strStyle := 'id="1'; 
								
			styleStringGeneration;
										
			// Draw selested shape with specified parameters on the overlay
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

	//CODE READER
	
	IF hw.VF.codeReader.in.common.numResults > 0 THEN
			
		hmi.out.svgOverlay := '';
		
		FOR i:= 0 TO hw.VF.codeReader.in.common.numResults-1 BY 1 DO
			this.tmp2D.x := DINT_TO_REAL(hw.VF.codeReader.in.results[i].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.codeReader.in.results[i].positionY) / 100.0;
				
			// Style string generation			
			// e.g.:'id="13" style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'	
			
			this.strElemId := UINT_TO_STRING(i);
				
			hmi.in.cmd.draw.strStyle := 'id="2'; 
								
			styleStringGeneration;
						
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
	
	//MATCHING
	
	IF hw.VF.matching.in.common.numResults > 0 THEN
			
		hmi.out.svgOverlay := '';
		
		FOR i:= 0 TO hw.VF.matching.in.common.numResults-1 BY 1 DO
			this.tmp2D.x := DINT_TO_REAL(hw.VF.matching.in.results[i].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.matching.in.results[i].positionY) / 100.0;
				
			// Style string generation			
			// e.g.:'id="13" style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'	
			
			this.strElemId := UINT_TO_STRING(i);
				
			hmi.in.cmd.draw.strStyle := 'id="3'; 
								
			styleStringGeneration;
						
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

(*	//MEASUREMENT
	
	IF hwInstance[4].VF.measurement.in.common.numResults > 0 THEN
			
		hmi.out.svgOverlay := '';
		
		FOR i:= 0 TO hw.VF.measurement.in.common.numResults-1 BY 1 DO
			this.tmp2D.x := DINT_TO_REAL(hw.VF.measurement.in.results[i].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.measurement.in.results[i].positionY) / 100.0;
				
			// Style string generation			
			// e.g.:'id="13" style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'	
			
			this.strElemId := UINT_TO_STRING(i);
				
			hmi.in.cmd.draw.strStyle := 'id="4'; 
								
			styleStringGeneration;
						
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
	*)

	//OCR
	
	IF hwInstance[5].VF.ocr.in.common.numResults > 0 THEN
			
		hmi.out.svgOverlay := '';
		
		FOR i:= 0 TO hw.VF.ocr.in.common.numResults-1 BY 1 DO
			this.tmp2D.x := DINT_TO_REAL(hw.VF.ocr.in.results[i].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.ocr.in.results[i].positionY) / 100.0;
				
			// Style string generation			
			// e.g.:'id="13" style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'	
			
			this.strElemId := UINT_TO_STRING(i);
				
			hmi.in.cmd.draw.strStyle := 'id="5'; 
								
			styleStringGeneration;
						
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
	
	//PIXEL COUNT
	
	IF hwInstance[6].VF.pixelCnt.in.common.numResults > 0 THEN
			
		hmi.out.svgOverlay := '';
		
		FOR i:= 0 TO hw.VF.pixelCnt.in.common.numResults-1 BY 1 DO
			this.tmp2D.x := DINT_TO_REAL(hw.VF.pixelCnt.in.results[i].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.pixelCnt.in.results[i].positionY) / 100.0;
				
			// Style string generation			
			// e.g.:'id="13" style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'	
			
			this.strElemId := UINT_TO_STRING(i);
				
			hmi.in.cmd.draw.strStyle := 'id="6'; 
								
			styleStringGeneration;
						
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
	
END_ACTION