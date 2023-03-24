
ACTION tableResultsAction: 
	IF hw.VF.blob.in.common.numResults > 0 THEN
	  	FOR p:=0 TO hw.VF.ocr.in.common.numResults-1 DO
			hmi.out.VF.blob.ModelNumber[p+1] := hw.VF.blob.in.results[p].modelNumber;
			hmi.out.VF.blob.Clipped[p+1] := hw.VF.blob.in.results[p].clipped;
			hmi.out.VF.blob.Area[p+1] := hw.VF.blob.in.results[p].area;
			hmi.out.VF.blob.PositionX[p+1] := hw.VF.blob.in.results[p].positionX;
			hmi.out.VF.blob.PositionY[p+1] := hw.VF.blob.in.results[p].positionY;
			hmi.out.VF.blob.Orientation[p+1] := hw.VF.blob.in.results[p].orientation;
			hmi.out.VF.blob.MeanGrayValue[p+1] := hw.VF.blob.in.results[p].meanGreyValue;
			hmi.out.VF.blob.Length[p+1] := hw.VF.blob.in.results[p].length;
			hmi.out.VF.blob.Width[p+1] := hw.VF.blob.in.results[p].width;
		END_FOR;
	END_IF;

	IF hw.VF.codeReader.in.common.numResults > 0 THEN	
		FOR p:=0 TO hw.VF.codeReader.in.common.numResults-1 DO
			hmi.out.VF.codeReader.CodeType[p+1] := hw.VF.codeReader.in.results[p].symbolType;
			hmi.out.VF.codeReader.Grading[p+1] := hw.VF.codeReader.in.results[p].gradingValue;
			hmi.out.VF.codeReader.PositionX[p+1] := hw.VF.codeReader.in.results[p].positionX;
			hmi.out.VF.codeReader.PositionY[p+1] := hw.VF.codeReader.in.results[p].positionY;
			hmi.out.VF.codeReader.Orientation[p+1] := hw.VF.codeReader.in.results[p].orientation;
		END_FOR;
	END_IF;
	
	IF hw.VF.matching.in.common.numResults > 0 THEN
		FOR p:=0 TO hw.VF.matching.in.common.numResults-1 DO
			hmi.out.VF.match.ModelNumber[p+1] := hw.VF.matching.in.results[p].modelNumber;
			hmi.out.VF.match.Score[p+1] := hw.VF.matching.in.results[p].score;
			hmi.out.VF.match.PositionX[p+1] := hw.VF.matching.in.results[p].positionX;
			hmi.out.VF.match.PositionY[p+1] := hw.VF.matching.in.results[p].positionY;
			hmi.out.VF.match.Orientation[p+1] := hw.VF.matching.in.results[p].orientation;
			hmi.out.VF.match.Scale[p+1] := hw.VF.matching.in.results[p].scale;
		END_FOR;
	END_IF;

	IF hw.VF.measurement.in.common.numResults > 0 THEN	
		FOR p:=0 TO hw.VF.measurement.in.common.numResults-1 DO
			hmi.out.VF.measurement.Result[p+1] := hw.VF.measurement.in.results[p].result;
		END_FOR;
	END_IF;
	
	IF hw.VF.ocr.in.common.numResults > 0 THEN	
		FOR p:=0 TO hw.VF.ocr.in.common.numResults-1 DO
			hmi.out.VF.ocr.Grading[p+1] := hw.VF.ocr.in.results[p].gradingValue;
			hmi.out.VF.ocr.PositionX[p+1] := hw.VF.ocr.in.results[p].positionX;
			hmi.out.VF.ocr.PositionY[p+1] := hw.VF.ocr.in.results[p].positionY;
			hmi.out.VF.ocr.Orientation[p+1] := hw.VF.ocr.in.results[p].orientation;
		END_FOR;
	END_IF;
	
	IF hw.VF.pixelCnt.in.common.numResults > 0 THEN	
		FOR p:=0 TO hw.VF.pixelCnt.in.common.numResults-1 DO
			hmi.out.VF.pixelCnt.ModelNumber[p+1] := hw.VF.pixelCnt.in.results[p].modelNumber;
			hmi.out.VF.pixelCnt.ModelArea[p+1] := hw.VF.pixelCnt.in.results[p].modelArea;
			hmi.out.VF.pixelCnt.NumPixels[p+1] := hw.VF.pixelCnt.in.results[p].numPixels;
			hmi.out.VF.pixelCnt.MinGray[p+1] := hw.VF.pixelCnt.in.results[p].minGray;
			hmi.out.VF.pixelCnt.MaxGray[p+1] := hw.VF.pixelCnt.in.results[p].maxGray;
			hmi.out.VF.pixelCnt.DeviationGray[p+1] := hw.VF.pixelCnt.in.results[p].deviationGray;
			hmi.out.VF.pixelCnt.NumConnectedComponents[p+1] := hw.VF.pixelCnt.in.results[p].numConnectedComponents;
			hmi.out.VF.pixelCnt.PositionX[p+1] := hw.VF.pixelCnt.in.results[p].positionX;
			hmi.out.VF.pixelCnt.PositionY[p+1] := hw.VF.pixelCnt.in.results[p].positionY;
		END_FOR;
	END_IF;

	
END_ACTION
