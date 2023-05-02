ACTION processResultsAction: 


	this.tmpAngle:= -(hmi.in.recipe.draw.rotation);
	
	// DRAW CIRCLES ON RESULTS
	hmi.out.svgOverlay := '';
	brsmemset(ADR(hmi.out.tableVF),0,SIZEOF(hmi.out.tableVF));

	//BLOB
	IF hw.VF.blob.in.common.numResults > 0 THEN
		FOR i:= 1 TO hw.VF.blob.in.common.numResults BY 1 DO
			
			//----------------------------------
			//          table results 
			hmi.out.tableVF.blob.ModelNumber[i] := hw.VF.blob.in.results[i-1].modelNumber;
			hmi.out.tableVF.blob.Clipped[i] := hw.VF.blob.in.results[i-1].clipped;
			hmi.out.tableVF.blob.Area[i] := hw.VF.blob.in.results[i-1].area;
			hmi.out.tableVF.blob.PositionX[i] := DINT_TO_REAL(hw.VF.blob.in.results[i-1].positionX) /100.0;
			hmi.out.tableVF.blob.PositionY[i] :=  DINT_TO_REAL(hw.VF.blob.in.results[i-1].positionY) /100.0;
			hmi.out.tableVF.blob.Orientation[i] :=  DINT_TO_REAL(hw.VF.blob.in.results[i-1].orientation) /100.0;
			hmi.out.tableVF.blob.MeanGrayValue[i] := hw.VF.blob.in.results[i-1].meanGreyValue;
			hmi.out.tableVF.blob.Length[i] := hw.VF.blob.in.results[i-1].length;
			hmi.out.tableVF.blob.Width[i] := hw.VF.blob.in.results[i-1].width;
			
			//------------------------------------
			//			Overlay darwing 
			this.tmp2D.x := DINT_TO_REAL(hw.VF.blob.in.results[i-1].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.blob.in.results[i-1].positionY) / 100.0;
			this.tmpAngle:= -(hmi.out.tableVF.blob.PositionY[i]);
			// Style string generation			
			// e.g.:'id="13" style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'	
			this.strStyle := 'id="1'; 
			
			// Draw selested shape with specified parameters on the overlay
			styleStringGeneration;
		END_FOR;
	END_IF
	
	

	//CODE READER
	
	IF hw.VF.codeReader.in.common.numResults > 0 THEN
		FOR i:= 1 TO hw.VF.codeReader.in.common.numResults BY 1 DO
			
			//----------------------------------
			//          table results 
			//Conversion of individual USINT values into strings for Code Reader
			brsmemcpy(ADR(hmi.out.tableVF.codeReader.BarcodeText[i]),ADR(hw.VF.codeReader.in.results[i-1].data),SIZEOF(hw.VF.codeReader.in.results[i-1].data));
			hmi.out.tableVF.codeReader.BarcodeType[i] 		:= hw.VF.codeReader.in.results[i-1].symbolType;
			hmi.out.tableVF.codeReader.Grading[i] 		:= hw.VF.codeReader.in.results[i-1].gradingValue;
			hmi.out.tableVF.codeReader.PositionX[i] 	:=  DINT_TO_REAL(hw.VF.codeReader.in.results[i-1].positionX) /100.0;
			hmi.out.tableVF.codeReader.PositionY[i] 	:=  DINT_TO_REAL(hw.VF.codeReader.in.results[i-1].positionY) /100.0;
			hmi.out.tableVF.codeReader.Orientation[i] 	:=  DINT_TO_REAL(hw.VF.codeReader.in.results[i-1].orientation) /100.0;
			
			//------------------------------------
			//			Overlay darwing 
			
			this.tmp2D.x := DINT_TO_REAL(hw.VF.codeReader.in.results[i-1].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.codeReader.in.results[i-1].positionY) / 100.0;
			this.tmpAngle:= -REAL_TO_LREAL(hmi.out.tableVF.codeReader.Orientation[i]);
			
			// Style string generation			
			// e.g.:'id="13" style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'	
			this.strStyle := 'id="2'; 
							
			styleStringGeneration;
		END_FOR;
	END_IF;
	
	//MATCHING
	
	IF hw.VF.matching.in.common.numResults > 0 THEN
		FOR i:= 1 TO hw.VF.matching.in.common.numResults BY 1 DO
			
			//----------------------------------
			//          table results 
			hmi.out.tableVF.match.ModelNumber[i] := hw.VF.matching.in.results[i-1].modelNumber;
			hmi.out.tableVF.match.Score[i] :=  DINT_TO_REAL(hw.VF.matching.in.results[i-1].score) /100.0;
			hmi.out.tableVF.match.PositionX[i] :=  DINT_TO_REAL(hw.VF.matching.in.results[i-1].positionX) /100.0;
			hmi.out.tableVF.match.PositionY[i] :=  DINT_TO_REAL(hw.VF.matching.in.results[i-1].positionY) /100.0;
			hmi.out.tableVF.match.Orientation[i] :=  DINT_TO_REAL(hw.VF.matching.in.results[i-1].orientation) /100.0;
			hmi.out.tableVF.match.Scale[i] :=  DINT_TO_REAL(hw.VF.matching.in.results[i-1].scale) /100.0;
			
			//------------------------------------
			//			Overlay darwing 
			
			this.tmp2D.x := DINT_TO_REAL(hw.VF.matching.in.results[i-1].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.matching.in.results[i-1].positionY) / 100.0;
			this.tmpAngle:= -REAL_TO_LREAL(hmi.out.tableVF.blob.PositionY[i]);
			// Style string generation			
			// e.g.:'id="13" style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'	
			this.strStyle := 'id="3'; 
							
			// DRAW SELECTED SHAPE WITH SPECIFIED PARAMETERS ON THE OVERLAY
			styleStringGeneration;
						
		END_FOR;
	END_IF;

	//MEASUREMENT 
	
	IF hw.VF.measurement.in.common.numResults > 0 THEN	
		FOR i:=1 TO hw.VF.measurement.in.common.numResults DO
			hmi.out.tableVF.measurement.Result[i] := hw.VF.measurement.in.results[i-1].result;
		END_FOR;
	END_IF;
	

	//OCR
	
	IF hwInstance[5].VF.ocr.in.common.numResults > 0 THEN
		FOR i:= 1 TO hw.VF.ocr.in.common.numResults BY 1 DO
			//----------------------------------
			//          table results 
			hmi.out.tableVF.ocr.Grading[i] := hw.VF.ocr.in.results[i-1].gradingValue;
			hmi.out.tableVF.ocr.PositionX[i] :=  DINT_TO_REAL(hw.VF.ocr.in.results[i-1].positionX) /100.0;
			hmi.out.tableVF.ocr.PositionY[i] :=  DINT_TO_REAL(hw.VF.ocr.in.results[i-1].positionY) /100.0;
			hmi.out.tableVF.ocr.Orientation[i] :=  DINT_TO_REAL(hw.VF.ocr.in.results[i-1].orientation) /100.0;
			//Conversion of individual USINT values into strings for OCR
			brsmemcpy(ADR(hmi.out.tableVF.ocr.Text[i]),ADR(hw.VF.ocr.in.results[i-1].data),SIZEOF(hw.VF.ocr.in.results[i-1].data));
		
			//------------------------------------
			//			Overlay darwing 
			
			this.tmp2D.x := DINT_TO_REAL(hw.VF.ocr.in.results[i-1].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.ocr.in.results[i-1].positionY) / 100.0;
			this.tmpAngle:= -REAL_TO_LREAL(hmi.out.tableVF.blob.PositionY[i]);
			// Style string generation			
			// e.g.:'id="13" style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'	
				
			this.strStyle := 'id="5'; 
		
			// DRAW SELECTED SHAPE WITH SPECIFIED PARAMETERS ON THE OVERLAY
			styleStringGeneration;
				
		END_FOR;
	END_IF;
	
	//PIXEL COUNT
	
	IF hwInstance[6].VF.pixelCnt.in.common.numResults > 0 THEN
		FOR i:= 1 TO hw.VF.pixelCnt.in.common.numResults BY 1 DO
			//----------------------------------
			//          table results 
			hmi.out.tableVF.pixelCnt.ModelNumber[i] := hw.VF.pixelCnt.in.results[i-1].modelNumber;
			hmi.out.tableVF.pixelCnt.ModelArea[i] := hw.VF.pixelCnt.in.results[i-1].modelArea;
			hmi.out.tableVF.pixelCnt.NumPixels[i] := hw.VF.pixelCnt.in.results[i-1].numPixels;
			hmi.out.tableVF.pixelCnt.MinGray[i] := hw.VF.pixelCnt.in.results[i-1].minGray;
			hmi.out.tableVF.pixelCnt.MaxGray[i] := hw.VF.pixelCnt.in.results[i-1].maxGray;
			hmi.out.tableVF.pixelCnt.DeviationGray[i] :=  DINT_TO_REAL(hw.VF.pixelCnt.in.results[i-1].deviationGray) /100.0;
			hmi.out.tableVF.pixelCnt.MeanGray[i] :=  DINT_TO_REAL(hw.VF.pixelCnt.in.results[i-1].meanGray) /100.0;
			hmi.out.tableVF.pixelCnt.NumConnectedComponents[i] := hw.VF.pixelCnt.in.results[i-1].numConnectedComponents;
			hmi.out.tableVF.pixelCnt.PositionX[i] := DINT_TO_REAL(hw.VF.pixelCnt.in.results[i-1].positionX) /100.0;
			hmi.out.tableVF.pixelCnt.PositionY[i] := DINT_TO_REAL(hw.VF.pixelCnt.in.results[i-1].positionY) /100.0;
			
			
			//------------------------------------
			//			Overlay darwing 
			
			this.tmp2D.x := DINT_TO_REAL(hw.VF.pixelCnt.in.results[i-1].positionX) / 100.0;
			this.tmp2D.y := DINT_TO_REAL(hw.VF.pixelCnt.in.results[i-1].positionY) / 100.0;
			this.tmpAngle := -REAL_TO_LREAL(hmi.in.recipe.draw.rotation);
			
			// Style string generation			
			// e.g.:'id="13" style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'	
			
			this.strStyle := 'id="6'; 
								
			styleStringGeneration;
			
		END_FOR;
	END_IF;
	
		END_ACTION