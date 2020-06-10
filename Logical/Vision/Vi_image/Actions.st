ACTION ACTION_InitTexts: 
SvgTexts.Header1 := 
'<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="1280px" height="1024px" shape-rendering="geometricPrecision" text-rendering="geometricPrecision" image-rendering="optimizeQuality" fill-rule="nonzero" clip-rule="evenodd" viewBox="0 0 1280 1024" xmlns:xlink="http://www.w3.org/1999/xlink">
	<title>';
SvgTexts.Header2 :=
'</title>
	<image
	xlink:href="data:image/';
SvgTexts.Header3 :=
';base64,';
SvgTexts.Header4 :=
'"
	width="1280"
	height="1024"
	id="LoadedPicture"
	x="0"
	y="0" />';
SvgTexts.CrosshairDefinition :=
'
	<defs>
		<symbol id="Fadenkreuz">
			<desc>Ein einfaches Fadenkreuz</desc>
			<g id="Crosshair">
			<path style="stroke:#ff0000;stroke-width:5" d="M 40,1 V 30 Z" id="up" />
			<path style="stroke:#ff0000;stroke-width:5" d="M 40,50 V 80 Z" id="down" />
			<path style="stroke:#ff0000;stroke-width:5" d="M 30,40 H 0 Z" id="left" />
			<path style="stroke:#ff0000;stroke-width:5" d="M 80,40 H 50 Z" id="right" />
			<circle style="fill:none;stroke:#ff0000;stroke-width:5" cx="40" cy="40" r="25" id="circle6" />
			</g>
		</symbol>
	</defs>';
SvgTexts.Crosshair1 :=
'
	<use xlink:href="#Fadenkreuz" transform="translate(';
SvgTexts.SvgClose :=
'
</svg>';
END_ACTION
ACTION ACTION_CreateHtmlFile:
HtmlFileContent :=
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
                font: 14px Arial;
                color: white;
                background: #444;
                margin: 0;
                padding: 0;
            }
            img {
                width: 100%;
                display: block;
                margin-left: auto;
                margin-right: auto;
                content-fit: contain;
                content-position: 50% 50%;
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
            <img id="imgCamera" src=""   />
            
            <script>
				var ImagePath 			= "http://192.168.200.1:8080/jpg";
				var ErrorImagePath 		= "VisionEye.png";
				var UpdateInterval_ms 	= 200;
	
				function getParameterByName() {
                    var url = window.location.href;
                    var regex = new RegExp("[?&]q(=([^&#]*)|&|#|$$)"),
                    results = regex.exec(url);
                    if (!results) return null;
                    if (!results[2]) return "";
                    return decodeURIComponent(results[2].replace(/\+/g, " "));
                }
				
				function updateImage() {
					document.getElementById("imgCamera").setAttribute("src", ImagePath + "?q=" + getParameterByName() + "&" + Math.random());
					
					var img = document.getElementById("imgCamera");
					
					if(img.naturalHeight !== 0 ) {
						showCameraImage() ;
					} else {
						showErrorImage();
					}
					
					setTimeout(updateImage, UpdateInterval_ms);
				}
				
				showCameraImage();
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