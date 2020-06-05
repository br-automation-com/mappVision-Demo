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