
ACTION processResultsAction: 
	
// DRAW CIRCLES ON RESULTS	
	
	//check results and their position
	IF hw.VF.blob.in.common.numResults > 0 THEN
		FOR i:= 0 TO hw.VF.blob.in.common.numResults-1 BY 1 DO
	  		this.tmp2D.x := DINT_TO_REAL(hw.VF.blob.in.results[i].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.blob.in.results[i].positionY) / 100.0;
			
			// draw circle on overlay
			brdkViGeom_drawSvgCircle(this.tmp2D,50.0,ADR(hmi.out.svgOverlay),ADR('style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'));
		
		END_FOR;
	END_IF;
	
// STYLE STRING GENERATION
	
	// conversion of variables to suitable data types
	hmi.in.cmd.draw.intShape := STRING_TO_INT(hmi.in.cmd.draw.strShape);
	hmi.in.cmd.draw.strStrokeWidth := INT_TO_STRING(hmi.in.cmd.draw.intStrokeWidth);
	hmi.in.cmd.draw.strFillOpac := REAL_TO_STRING(hmi.in.cmd.draw.realFillOpac);
	hmi.in.cmd.draw.strStrokeOpac := REAL_TO_STRING(hmi.in.cmd.draw.realStrokeOpac);
	
	// merging of individual strings into desired result string (e.g.:'style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"')	
	hmi.in.cmd.draw.strStyle := 'style="';
		
	brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strFillColor));		// string for fill color attribute (text + value)
	brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strStrokeColor));	// string for stroke color attribute (text + value)
	brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(';stroke-width:')); 				// string for stroke width attribute (text)
	brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strStrokeWidth));	// string for stroke width attribute (value)
	brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(';fill-opacity:')); 				// string for fill opacity attribute (text)
	brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strFillOpac)); 		// string for fill opacity attribute (value)
	brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(';stroke-opacity:')); 				// string for stroke opacity attribute (text)
	brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR(hmi.in.cmd.draw.strStrokeOpac)); 	// string for stroke opacity attribute (value)		
	brsstrcat(ADR(hmi.in.cmd.draw.strStyle),ADR('"'));
	

	
	IF hmi.in.cmd.draw.reset THEN
		hmi.out.svgOverlay := '';
	END_IF;
	
// DRAW SELECTED SHAPE ON CLICK POSITION
	
	IF hmi.in.cmd.click THEN
		hmi.in.cmd.click := FALSE;
		
		this.tmp2D.x := hmi.in.cmd.x; //Click X coordinate
		this.tmp2D.y := hmi.in.cmd.y; // Click Y coordinate
		
		//hmi.out.svgOverlay := '';	// when new shape is drawn, the previous is deleted
		
		// Draw selected shape with specified parameters on the overlay
		CASE hmi.in.cmd.draw.intShape OF
			1: // Rectangle
				brdkViGeom_drawSvgRectFromCP(this.tmp2D,hmi.in.cmd.draw.length,hmi.in.cmd.draw.width,hmi.in.cmd.draw.rotation,ADR(hmi.out.svgOverlay),ADR(hmi.in.cmd.draw.strStyle));
			2: // Circle
				brdkViGeom_drawSvgCircle(this.tmp2D,hmi.in.cmd.draw.radius,ADR(hmi.out.svgOverlay),ADR(hmi.in.cmd.draw.strStyle));
			3: // Triangle
				brdkViGeom_drawSvgTriFromCP(this.tmp2D,hmi.in.cmd.draw.length,hmi.in.cmd.draw.width,hmi.in.cmd.draw.rotation,ADR(hmi.out.svgOverlay),ADR(hmi.in.cmd.draw.strStyle));	  
	
		END_CASE;
		
	END_IF
		
	
END_ACTION
