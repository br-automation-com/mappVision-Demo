/*global define*/
define(["brease/core/designer/BaseWidget/ClassInfo"], function (superClassInfo, classExtension) {
	"use strict";
	var classInfo = {
		meta: {
			className: "widgets.brdk.VisionImage", 
			parents: ["*"],
			children: [],
			inheritance: ["widgets.brdk.VisionImage","brease.core.BaseWidget"],
			actions: {"Focus":{"method":"focus"},"PanDown":{"method":"panDown"},"PanLeft":{"method":"panLeft"},"PanReset":{"method":"panReset"},"PanRight":{"method":"panRight"},"PanUp":{"method":"panUp"},"setColorList":{"method":"setColorList","parameter":{"colorList":{"name":"colorList","index":0,"type":"ColorList"}}},"setEditable":{"method":"setEditable","parameter":{"editable":{"name":"editable","index":0,"type":"Boolean"},"metaData":{"name":"metaData","index":1,"type":"Object"}}},"SetEnable":{"method":"setEnable","parameter":{"value":{"name":"value","index":0,"type":"Boolean"}}},"SetFlipHorisontal":{"method":"setFlipHorisontal","parameter":{"flip":{"name":"flip","index":0,"type":"Boolean"}}},"SetFlipVertical":{"method":"setFlipVertical","parameter":{"flip":{"name":"flip","index":0,"type":"Boolean"}}},"setMaxZoomLevel":{"method":"setMaxZoomLevel","parameter":{"maxZoomLevel":{"name":"maxZoomLevel","index":0,"type":"UNumber"}}},"setMinZoomLevel":{"method":"setMinZoomLevel","parameter":{"minZoomLevel":{"name":"minZoomLevel","index":0,"type":"UNumber"}}},"setParentCoWiId":{"method":"setParentCoWiId","parameter":{"value":{"name":"value","index":0,"type":"String"}}},"SetStyle":{"method":"setStyle","parameter":{"value":{"name":"value","index":0,"type":"StyleReference"}}},"setSvgImage":{"method":"setSvgImage","parameter":{"svgImage":{"name":"svgImage","index":0,"type":"String"}}},"setSvgOverlay":{"method":"setSvgOverlay","parameter":{"svgOverlay":{"name":"svgOverlay","index":0,"type":"String"}}},"setTabIndex":{"method":"setTabIndex","parameter":{"value":{"name":"value","index":0,"type":"Number"}}},"setTransitionTime":{"method":"setTransitionTime","parameter":{"transitionTime":{"name":"transitionTime","index":0,"type":"UInteger"}}},"SetViewRotateAngle":{"method":"setViewRotateAngle","parameter":{"viewRotateAngle":{"name":"viewRotateAngle","index":0,"type":"Number"}}},"SetVisible":{"method":"setVisible","parameter":{"value":{"name":"value","index":0,"type":"Boolean"}}},"SetVisibleOverlay":{"method":"setVisibleOverlay","parameter":{"visibility":{"name":"visibility","index":0,"type":"Boolean"}}},"setWsPort":{"method":"setWsPort","parameter":{"PLC":{"name":"PLC","index":0,"type":"Number"}}},"ShowTooltip":{"method":"showTooltip"},"ViewReset":{"method":"viewReset"},"ZoomIn":{"method":"zoomIn"},"ZoomOut":{"method":"zoomOut"},"ZoomReset":{"method":"zoomReset"},"SetPLCWebsocketPort":{"method":"setPLCWebsocketPort","parameter":{"value":{"name":"value","index":0,"type":"UNumber"}}}}
		}
	};
	if (superClassInfo.classExtension) {
		classInfo.classExtension = superClassInfo.classExtension;
	}
	if (classExtension) {
		classInfo.classExtension = classExtension;
	}
	return classInfo;
});