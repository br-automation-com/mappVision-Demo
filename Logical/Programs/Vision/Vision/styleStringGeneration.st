

ACTION styleStringGeneration:
	
	IF hmi.in.recipe.draw.intShape > 0 THEN
		this.strElemId := UINT_TO_STRING(i);
		brsstrcat(ADR(this.strStyle),ADR(this.strElemId));					// string for element id attribute (value)
		brsstrcat(ADR(this.strStyle),ADR('" style="'));						// string for beginning of the style paramateres (text)
		brsstrcat(ADR(this.strStyle),ADR(hmi.in.recipe.draw.fillColor));		// string for fill color attribute (text + value)
	
		IF i = hmi.in.cmd.intElemId THEN
			brsstrcat(ADR(this.strStyle),ADR(hmi.in.recipe.draw.activeStrokeColor));	
		ELSE
			brsstrcat(ADR(this.strStyle),ADR(hmi.in.recipe.draw.strokeColor));	// string for stroke color attribute (text + value)
		END_IF;
	
	
		brsstrcat(ADR(this.strStyle),ADR('stroke-width: ')); 				// string for stroke width attribute (text)
		tmpStr := INT_TO_STRING(hmi.in.recipe.draw.strokeWidth);
		brsstrcat(ADR(this.strStyle),ADR(tmpStr));	// string for stroke width attribute (value)
		brsstrcat(ADR(this.strStyle),ADR('; fill-opacity: ')); 				// string for fill opacity attribute (text)
		tmpStr := REAL_TO_STRING(hmi.in.recipe.draw.fillOpac);
		brsstrcat(ADR(this.strStyle),ADR(tmpStr)); 		// string for fill opacity attribute (value)
		brsstrcat(ADR(this.strStyle),ADR('; stroke-opacity: ')); 				// string for stroke opacity attribute (text)
		tmpStr := REAL_TO_STRING(hmi.in.recipe.draw.strokeOpac);
		brsstrcat(ADR(this.strStyle),ADR(tmpStr)); 	// string for stroke opacity attribute (value)
		brsstrcat(ADR(this.strStyle),ADR('"'));
	END_IF
	
	CASE hmi.in.recipe.draw.intShape OF
		0: // None
			
		1: // Rectangle
			brdkViGeom_drawSvgRectFromCP(this.tmp2D,hmi.in.recipe.draw.length,hmi.in.recipe.draw.width,this.tmpAngle,ADR(hmi.out.svgOverlay),ADR(this.strStyle));
		2: // Circle
			brdkViGeom_drawSvgCircle(this.tmp2D,hmi.in.recipe.draw.radius,ADR(hmi.out.svgOverlay),ADR(this.strStyle));
		3: // Triangle
			brdkViGeom_drawSvgTriFromCP(this.tmp2D,hmi.in.recipe.draw.length,hmi.in.recipe.draw.width,this.tmpAngle,ADR(hmi.out.svgOverlay),ADR(this.strStyle));	  
	END_CASE;
	
END_ACTION
