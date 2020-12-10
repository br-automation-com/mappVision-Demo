ACTION ACTION_InitTexts: 
SvgTexts.ContentStart := 
'<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="1280px" height="1024px" shape-rendering="geometricPrecision" text-rendering="geometricPrecision" image-rendering="optimizeQuality" fill-rule="nonzero" clip-rule="evenodd" viewBox="0 0 1280 1024" xmlns:xlink="http://www.w3.org/1999/xlink">
	<title>';
SvgTexts.ContentAfterTitle :=
'</title>
	<image
		xlink:href="data:image/';
SvgTexts.ContentBase64 :=
';base64,';
SvgTexts.ContentBeginJS :=
'"
		width="1280" height="1024"
		id="LoadedPicture"
		x="0" y="0" 
	/>
	<defs>
		<style>
		  text {
		   pointer-events: none;
		   user-select: none;
		   -webkit-user-select: none;
		   -moz-user-select: none;
		  }
		</style>
		
		<symbol id="FadenkreuzBlau" fill="blue" stroke="blue" style="stroke-width:5">
			<use xlink:href="#Crosshair"/>
		</symbol>
		
		<symbol id="FadenkreuzRot" fill="red" stroke="red" style="stroke-width:5">
			<use xlink:href="#Crosshair"/>
		</symbol>
		
		<symbol id="Crosshair" >
			<path d="M 40,1 V 30 Z" id="up" />
			<path d="M 40,50 V 80 Z" id="down" />
			<path d="M 30,40 H 0 Z" id="left" />
			<path d="M 80,40 H 50 Z" id="right" />
			<circle style="fill:#000000; fill-opacity:0" cx="40" cy="40" r="25" />
		</symbol>
		
		<!-- Script -->
		<script type="text/javascript">
			<![CDATA[
			var blueCrosshairs, redCrosshair, indices, infoTxt;
			var amountElements;
			var actIndex = 1;
			var textInfo = ["Model ID: ", "Pos X: ", "Pos Y: ", "Orientation: ", "Clipped: ", "Gray: ", "Length: ", "Width: ", "Area: ", "Score: ", "Scale: ", "Grading: ", "Code Type: ", "Text: ", "Result: "];
			var visTextInfo = [';
SvgTexts.ContentBetween1 :=
'];
			var data = [
				[';
SvgTexts.ContentBetween2 :=
'],
				[';
SvgTexts.ContentEndJS :=
']
			];
			window.onload = function () {;
				blueCrosshairs 	= document.getElementsByName("crosshairBlue");
				redCrosshair	= document.getElementById("crosshairRed");
				indices			= document.getElementsByName("indice");
				infoTxt 		= document.getElementsByName("info");
				amountElements	= blueCrosshairs.length;
				let i;
				//fill and position indices
				for(i = 0; i < amountElements; i++) {
					indices[i].textContent = i + 1;
					let transformValues = blueCrosshairs[i].getAttribute("transform").match(/-?[\d.]+/g);
					indices[i].setAttribute("x", parseInt(transformValues[0]) + 85);
					indices[i].setAttribute("y", parseInt(transformValues[1]) + 35 );
				}
				//set visibility of information text
				for (i = 0; i< visTextInfo.length; i++ ){
					if (!visTextInfo[i]) {
						infoTxt[i].style.display = "none"
					}
				}
				//fill information text with first element and position red crosshair
				updateData(1);
				document.getElementById("crosshairRed").style.display = "inline";
				document.getElementById("infogroup").style.display = "inline";
			}
			
			function updateData(index) {
				index--; // Internal indices start at 0
				let i;
				for (i = 0; i< visTextInfo.length; i++ ){
					if (visTextInfo[i]) {
						infoTxt[i].textContent = textInfo[i] + data[index][i];
					}
				}
				document.getElementById("txtActElement").textContent = index + 1;
				//manipulate position of red crosshair
				let transform = blueCrosshairs[index].getAttribute("transform");
				redCrosshair.setAttribute("transform",transform);
				//set color of index number
				for(i = 0; i < amountElements; i++) {
					indices[i].setAttribute("fill","blue");
				}
				indices[index].setAttribute("fill","red");
			}
			function decreaseIndex(){
				actIndex--;
				if(actIndex < 1) actIndex = amountElements ;
				updateData(actIndex);
			}
			function increaseIndex(){
				actIndex++;
				if(actIndex > amountElements) actIndex = 1;
				updateData(actIndex);
			}
			]]>
		</script>
	</defs>
	
	<!-- blue crosshairs -->
';
SvgTexts.ContentCrossHairBegin :=
'	<use name="crosshairBlue" xlink:href="#FadenkreuzBlau" onclick="updateData(';
SvgTexts.ContentCrossHairMiddle :=
')" transform="translate(';
SvgTexts.ContentCrossHairEnd :=
')"/>
';
SvgTexts.ContentCrossHairRed :=
'
	<!-- red crosshair -->
	<use id="crosshairRed" xlink:href="#FadenkreuzRot" style="display: none"/>
	
	<!-- indices -->
';
SvgTexts.ContentCrossHairIndex :=
'	<text class="cText" font-size="22" font-family="Helvetica, Arial, sans-serif" > <tspan class="text" name="indice" fill="blue"></tspan></text>
';
SvgTexts.ContentEnd :=
'
	<g id="infogroup" transform="translate(20,30)" style="display: none">
		<!-- buttons -->
		<path d="M0,30, L60,60, L60,0, Z" stroke="black" fill="red" onclick="decreaseIndex()" style="stroke-width:5"/>
		<text id="txtActElement" fill="red" font-size="75" font-family="Helvetica, Arial, sans-serif" text-anchor="middle" x="102" y="55"></text>
		<path d="M150,60, L210,30, L150,0, Z" stroke="black" fill="red" onclick="increaseIndex()" style="stroke-width:5"/>
		
		<!-- informations -->
		<text class="cText" fill="red" font-size="35" font-family="Helvetica, Arial, sans-serif" x="0" y="80">
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
			<tspan class="text" name="info" x="0" dy="32"></tspan>
		</text>
	</g>
</svg>';
END_ACTION
ACTION ACTION_CreateHtmlFile:
HtmlFileContent1 :=
'<!DOCTYPE html>
<html lang="de">
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>Camera Picture</title>
		<style>
			html, body{
				height: 100%;
				width: 100%;
				background: #C0C0C0;
				margin: 0;
				padding: 0;
			}
			img {
				width: 100%;
				height: auto;
				margin-left: auto;
				margin-right: auto;
			}
			div {
				height: 100%;
				width: 100%;
			}
		</style>
	</head>
	<body style="overflow: hidden">
		<div>
			<img id="imgError" src="VisionEye.png" />
			<img id="imgCamera" src="" />
			<script>
				function getParameterByName(param) {
					var url = window.location.href;
					var regex = new RegExp("[?&]" + param + "(=([^&#]*)|&|#|$$)"),
					results = regex.exec(url);
					if (!results) return null;
					if (!results[2]) return "";
					return decodeURIComponent(results[2].replace(/\+/g, " "));
				}
				var ImagePath 			= "http://';
HtmlFileContent2 :=
'" + getParameterByName("node") + ":8080/jpg";
				var ErrorImagePath 		= "VisionEye.png";
				var UpdateInterval_ms 	= 200;
				var MissingImgCtr		= 0;
				function updateImage() {
					document.getElementById("imgCamera").setAttribute("src", ImagePath + "?q=" + getParameterByName("q") + "&" + Math.random());
					var img = document.getElementById("imgCamera");
					var rot = getParameterByName("rot");
					var scale = getParameterByName("scale");
					if (scale == 0){
						scale = 1;
					}
					switch (rot) {
						case "0":
							move_x = 0;
							move_y = 0;
							break;
						case "90":
							move_x = img.height;
							move_y = 0;
							break;
						case "180":
							move_x = img.width;
							move_y = img.height;
							break;
						case "270":
							move_x = 0;
							move_y = img.width;
							break;
						default: //same as 0
							move_x = 0;
							move_y = 0;
					}
					document.getElementById("imgCamera").setAttribute("style", "transform-origin: 0% 0%; transform: scale(" + scale + ") translate(" + move_x + "px," + move_y + "px) rotate(" + rot + "deg);");
					if(img.naturalHeight !== 0 ) {
						MissingImgCtr = 0;
						showCameraImage() ;
					} else {
						MissingImgCtr++;
					}
					if(MissingImgCtr > 2){
						showErrorImage();
					}
					setTimeout(updateImage, UpdateInterval_ms);
				}
				showErrorImage();
				setTimeout(updateImage, UpdateInterval_ms);
				function showErrorImage() {
					var img = document.getElementById("imgError");
					img.style.display = "inline";
					var img = document.getElementById("imgCamera");
					img.style.display = "none";
				}
				function showCameraImage() {
					var img = document.getElementById("imgError");
					img.style.display = "none";
					var img = document.getElementById("imgCamera");
					img.style.display = "inline";
				}
			</script>
		</div>
	</body>
</html>';
END_ACTION
ACTION CreateVC4HTML:
VC4HTML[0] := '<!DOCTYPE html>
<html lang="de">
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>Camera Picture</title>		
	</head>
	<body >
		<img id="imgError" width="';
VC4HTML[1] := 'px" height="';
VC4HTML[2] := 'px" src="';
VC4HTML[3] := '" />
	</body>
</html>';
END_ACTION