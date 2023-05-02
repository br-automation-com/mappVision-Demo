define([
    'brease/core/BaseWidget',
    'brease/events/BreaseEvent',
    'widgets/brdk/VisionImage/libs/Renderer',
	// 'widgets/brdk/VisionImage/libs/opencv.js',	
    'brease/core/Utils',
    'widgets/brease/common/libs/redux/utils/UtilsSvg',
    'brease/decorators/DragAndDropCapability',
    'widgets/brease/common/libs/BreaseResizeObserver',
    'brease/decorators/ContentActivatedDependency',
    'widgets/brease/common/DragDropProperties/libs/DroppablePropertiesEvents'
], function (SuperClass, BreaseEvent, Renderer, Utils, UtilsSvg, dragAndDropCapability, BreaseResizeObserver, contentActivatedDependency) {

    'use strict';

    /**
    * @class widgets.brdk.VisionImage
    * #Description
    * This widget allows the displaying and modification of svg contents at runtime.
    * @extends brease.core.BaseWidget
    *
    * @mixins widgets.brease.common.DragDropProperties.libs.DroppablePropertiesEvents
    *
    * @iatMeta studio:license
    * licensed
    * @iatMeta category:Category
    * Drawing
    * @iatMeta description:short
    * Display vision image and svg overlay
    * @iatMeta description:de
    * Aktivieren Sie die Visualisierung eines Vision-Bildes und einer darüber liegenden SVG-Überlagerung. Kann den Inhalt zoomen, schwenken, drehen und spiegeln.
    * @iatMeta description:en
    * Enable visualisation of an Vision image and an svg overlay ontop of it. Can zoom, pan, rotate and flip the contnet.
    */

    /**
    * @cfg {ColorList} colorList='#FFCC66,#FF8800,#FFCC99,#993333'
    * @iatStudioExposed
    * @iatCategory Appearance
    * List of possible colors to apply to svg elements.
    */

    /**
    * @cfg {UInteger} transitionTime=500
    * @iatStudioExposed
    * @bindable
    * @iatCategory Behavior
    * Default execution time of any svg transformation.
    */

    /**
    * @cfg {String} svgImage=''
    * @iatStudioExposed
    * @bindable
    * @iatCategory Data
    * Additional svg string content to display on the widget.
    */
	
	    /**
    * @cfg {UNumber} PLCWebsocketPort=0
    * @iatStudioExposed
    * @bindable
    * @iatCategory Data
    * Additional PLC websocket port to connect to (0=Not used).
    */
	
	/**
    * @cfg {String} svgOverlay=''
    * @iatStudioExposed
    * @bindable
    * @iatCategory Data
    * Additional svg string content to display on the widget.
    */

    /**
    * @cfg {UNumber} minZoomLevel=20
    * @iatStudioExposed
    * @iatCategory Behavior
    * Defines in percentage the lower limit of the zoom in the Paper area (100 means no zoom level applied)
    */

    /**
    * @cfg {UNumber} maxZoomLevel=1000
    * @iatStudioExposed
    * @iatCategory Behavior
    * Defines in percentage the upper limit of the zoom in the Paper area (100 means no zoom level applied)
    */
	
	
    /**
    * @cfg {Number} viewRotateAngle=0
    * @iatStudioExposed
	* @bindable
    * @iatCategory Behavior
    * Defines in degrees the view rotation
    */

        /**
     * @cfg {Boolean} flipVertical=false
     * @iatStudioExposed
     * @bindable
     * @iatCategory Behavior
     * Flip image vertical
     */

    /**
     * @cfg {Boolean} flipHorisontal=false
     * @iatStudioExposed
     * @bindable
     * @iatCategory Behavior
     * Flip image horizontal
     */
      /**
     * @cfg {Boolean} visibleOverlay=true
     * @iatStudioExposed
     * @bindable
     * @iatCategory Behavior
     * Overlay is visible if the value is true. Otherwise, invisible.
     */




    var defaultSettings = {
            svgImage: '',
            svgOverlay: '',
			imageWidth: 0,
			imageHeight: 0,
            colorList: '#FFCC66,#FF8800,#FFCC99,#993333',
            transitionTime: 500,
            minZoomLevel: 20,
            maxZoomLevel: 1000,
			PLCWebsocketPort: 0,
			viewRotateAngle: 0,
			flipX: 1,
			flipY: 1,
			flipVertical: false,
			flipHorisontal: false,
            visibleOverlay: true,
			viewBox: { 
			    x: 0,
			    y: 0,
			    width: 1280,
			    height: 1024
			},
        },

        WidgetClass = SuperClass.extend(function VisionImage() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {
        this.el.addClass('brdkVisionImage');
        this.timeTransform = new Date();
        this.timeSvgContent = new Date();
        this.elem.addEventListener(BreaseEvent.WIDGET_READY, this._bind('_widgetReadyHandler'));
        this.settings.colorList = this._parseColorList(this.settings.colorList);
        this.$svgContainer = this.el.children('svg.brdkVisionImageSVGContainer');
        this.renderer = new Renderer(this, this.settings);       
		this.socket = null;
		this.wsConnectRetry = false;
        if (brease.config.editMode) {
            _addPlaceholderImage(this);
        } else {
            this.setSvgImage(this.settings.svgImage);
			this.setSvgOverlay(this.settings.svgOverlay);
			this.renderer.executeActionUpdateTransform();
            if (brease.config.preLoadingState === true) {
                this.widgetPreLoaded = true;
            } 
			if(this.settings.PLCWebsocketPort != 0){
				this._wsConnect();
			}
		
			// else {
                // this.setSvgFilePath(this.settings.svgFilePath);
            // }
        }
        this.observer = new BreaseResizeObserver(this.elem, this._bind(_redrawDimension));
        SuperClass.prototype.init.apply(this, arguments);
        document.body.addEventListener(BreaseEvent.THEME_CHANGED, this._bind(_onThemeChanged));
    };

    /**
    * @method setColorList
    * Sets the list of possible colors to be used for svg element modification.
    * @param {ColorList} colorList
    */
    p.setColorList = function (colorList) {
        this.settings.colorList = this._parseColorList(colorList);
        this.renderer.updateColorList(this.settings.colorList);
    };

    /**
    * @method getColorList
    * Gets the list of possible colors.
    * @return {ColorList} 
    */
    p.getColorList = function () {
        return this.settings.colorList;
    };

    /**
    * @method setTransitionTime
    * Sets the execution time for a svg element transition.
    * @param {UInteger} transitionTime
    */
    p.setTransitionTime = function (transitionTime) {
        this.settings.transitionTime = transitionTime;
        this.renderer.updateTransitionTime(this.settings.transitionTime);
    };

    /**
    * @method getTransitionTime
    * Gets the execution time for a svg element transition
    * @return {UInteger} 
    */
    p.getTransitionTime = function () {
        return this.settings.transitionTime;
    };





    /**
    * @method setSvgImage
    * Set additional svg content to be displayed.
    * @param {String} svgImage
    */
    p.setSvgImage = function (svgImage) {
      
		//console.log('image update');
        this.settings.svgImage = svgImage;
        return this._updateView();
        



    };
	
	
	
    p._updateView = function ( ) {



        var deferred = new $.Deferred();



        if (!brease.config.editMode) {
            this.renderer.updateSVG('content', this.settings.svgImage + (this.settings.visibleOverlay ? this.settings.svgOverlay : '')).then(function () {
                deferred.resolve();
                }, function () {
                    deferred.resolve();
            });
            // _updateTransform.call(this);
        }



        return deferred;
    };
	
    /**
    * @method getSvgImage
    * Get the additionally added svg content.
    * @return {String}
    */
    p.getSvgImage = function () {
        return this.settings.svgImage;
    };


	/**
    * @method setWsPort
    * set th Websocket port number that is used on the PLC.
    * @param {Number} PLC websocket port
    */
    p.setPLCWebsocketPort = function (port) {
        this.settings.PLCWebsocketPort = port;
		console.log('port update '+port);
		if(this.socket != null){
			if (this.socket.readyState === WebSocket.OPEN) {
				this.socket.onclose = function(event){
					console.log("WS Closed");
					this.socket = null;
				};
			  console.log("WS closing");
			  this.socket.close(1000,"Deliberate close");
			}
		}
			
		if(port != 0){
			this._wsConnect();
		}
		
    };


/**
    * @method getWsPort
    * Get the Websocket port number that is used on the PLC.
    * @param {Number} PLC websocket port
    */
    p.getWsPort = function () {
        return this.settings.PLCWebsocketPort;
    };

	
	p._wsConnect = function(){
	console.log("VisionImage: Trying to connect to "+this.settings.PLCWebsocketPort+"...");
	this.wsConnectRetry = false;
	this.socket = new WebSocket('ws://'+window.location.hostname+':'+this.settings.PLCWebsocketPort);
	this.socket.binaryType = "arraybuffer";
	this.socket.onopen = function(event){console.log("VisionImage: Connection established");};
	this.socket.onmessage = this._onWsMessage.bind(this);
	this.socket.onerror = this._onWsError.bind(this);
	this.socket.onclose = function(event) {
	  if (event.wasClean) {
		//console.log("[close] Connection closed cleanly, code="+event.code+" reason="+event.reason);
	  } else {
		//console.log("[close] Connection died");
		if(!this.wsConnectRetry){
			this.wsConnectRetry = true;
			setTimeout(this.wsConnect, 2000);
		}

	  }
	};
	};
	
	
	p._onWsError = function(error){
		//console.log("WS error");
		this.socket.close();
		if(!this.wsConnectRetry){
			this.wsConnectRetry = true;
			setTimeout(this.wsConnect, 2000);
		}
	};
 
	p._onWsMessage =  function (event) {
	  var base64string ="";
	  
	  if(event.data instanceof ArrayBuffer){
		// base64string = btoa(String.fromCharCode.apply(null, new Uint8Array(event.data)));
		// currentElement.src = "data:image/jpeg;base64,"+base64string;
	  }else{
		  if(event.data.startsWith("<foreignObject x=") && event.data.endsWith("</foreignObject>")){
			this.setSvgImage(event.data);
		  }else{
			  console.warn("WS data was not correct SVG for Vision Image widget");
		  }
		  
		// switch(event.data){
			// case "RED":
			// last = false;
			// currentElement = imgRedElement;
			// console.log("Red");
			// break;
			// case "BLUE":
			// currentElement = imgBlueElement;
			// console.log("BLUE");
			// break;
			// case "Green":
			// currentElement = imgGreenElement;
			// console.log("Green");
			// break;
			// case "Done":
			// //	createColorImage();
				// console.log("Done");
			// break;
			
		// }
	  }
	  //console.log("[message] Data received from server:");
	};
	
	

    /**
    * @method setSvgOverlay
    * Set additional svg content to be displayed.
    * @param {String} svgOverlay
    */
    p.setSvgOverlay = function (svgOverlay) {
       
        this.settings.svgOverlay = svgOverlay;
        return this._updateView();
    };

    /**
    * @method getSvgOverlay
    * Get the additionally added svg content.
    * @return {String}
    */
    p.getSvgOverlay = function () {
        return this.settings.svgOverlay;
    };
	
	  /**
    * @method setViewRotateAngle
    * @iatStudioExposed
    * Sets viewRotateAngle
    * @param {Number} viewRotateAngle
    */
    p.setViewRotateAngle = function (viewRotateAngle) {
        this.settings.viewRotateAngle = viewRotateAngle;
		this._calcViewbox();

        this._setViewBox(this.settings.viewBox);
        this.renderer.executeActionRotate();

    };

    /**
    * @method getViewRotateAngle 
    * Returns viewRotateAngle.
    * @return {Number}
    */
    p.getViewRotateAngle= function () {
        return this.settings.viewRotateAngle;
    };

    /**
    * @method setMinZoomLevel
    * Sets minZoomLevel
    * @param {UNumber} minZoomLevel
    */
    p.setMinZoomLevel = function (minZoomLevel) {
        this.settings.minZoomLevel = minZoomLevel;
    };

    /**
    * @method getMinZoomLevel 
    * Returns minZoomLevel.
    * @return {UNumber}
    */
    p.getMinZoomLevel = function () {
        return this.settings.minZoomLevel;
    };

    /**
    * @method setMaxZoomLevel
    * Sets maxZoomLevel
    * @param {UNumber} maxZoomLevel
    */
    p.setMaxZoomLevel = function (maxZoomLevel) {
        this.settings.maxZoomLevel = maxZoomLevel;
    };

    /**
    * @method getMaxZoomLevel 
    * Returns maxZoomLevel
    * @return {UNumber}
    */
    p.getMaxZoomLevel = function () {
        return this.settings.maxZoomLevel;
    };




     /**
    * @method setVisibleOverlay
    * @iatStudioExposed
    * Sets visibility of overlay, visible if the value is true. Otherwise, invisible.
    * @param {Boolean} visibility
    */
      p.setVisibleOverlay = function (visibility) {
        this.settings.visibleOverlay = visibility;



		



        return this._updateView();



    };

    /**
    * @method getVisibleOverlay 
    * Returns visibleOverlay.
    */
    p.getVisibleOverlay= function () {
        return this.settings.visibleOverlay;
    };




    /**
    * @method viewReset
    * @iatStudioExposed
    * Reset the view level to 100% zoom and pan x,y to 0
    */
    p.viewReset = function () {
        this.renderer.executeActionZoom(0);
		this.renderer.executeActionPan(0,0);
    };
	
    /**
    * @method zoomIn
    * @iatStudioExposed
    * Zoom into the Paper
    */
    p.zoomIn = function () {
        this.renderer.executeActionZoom(1);
    };

    /**
    * @method zoomOut
    * @iatStudioExposed
    * Zoom out of the Paper
    */
    p.zoomOut = function () {
        this.renderer.executeActionZoom(-1);
    };




	
	/**
    * @method zoomReset
    * @iatStudioExposed
    * Reset the view level to 100% zoom
    */
    p.zoomReset = function () {
        this.renderer.executeActionZoom(0);
    };
	
   
	/**
    * @method panLeft
    * @iatStudioExposed
    * Pan the view left
    */
    p.panLeft = function () {
        this.renderer.executeActionPan(1,0);
    };	
	
	/**
    * @method panRight
    * @iatStudioExposed
    * Pan the view right
    */
    p.panRight = function () {
        this.renderer.executeActionPan(-1,0);
    };	
	
	/**
    * @method panUp
    * @iatStudioExposed
    * Pan the view up
    */
    p.panUp = function () {
        this.renderer.executeActionPan(0,1);
    };

/**
    * @method panDown
    * @iatStudioExposed
    * Pan the view down
    */
    p.panDown = function () {
        this.renderer.executeActionPan(0,-1);
    };	
	
	 /**
    * @method panReset
    * @iatStudioExposed
    * Reset the view pan x,y to 0
    */
    p.panReset = function () {
        this.renderer.executeActionPan(0,0);
    };	


    /**
     * @method setFlipHorisontal



    



     * @iatStudioExposed
     * Sets flipHorisontal
     * @param {Boolean} flip
     */
    p.setFlipHorisontal = function(flip){
        this.settings.flipHorisontal = flip;
        if(flip){
            this.settings.flipY = -1;
        }else{
			this.settings.flipY = 1;
		}



        this.renderer.executeActionFlip();
    };

    /** 
     * @method getFlipHorisontal
     * Returns flipHorisontal
    */
    p.getFlipHorisontal = function(){
        return this.settings.flipHorisontal;
    };

    /**
     * @method setFlipVertical
     * @iatStudioExposed
     * Sets flipVertical
     * @param {Boolean} flip
     */
    p.setFlipVertical = function(flip){
        this.settings.flipVertical = flip;
        if(flip){
            this.settings.flipX = -1;
        }else{
			this.settings.flipX = 1;
		}



        this.renderer.executeActionFlip();
    };

    /** 
     * @method getFlipVertical
     * Returns flipVertical
    */
    p.getFlipVertical = function(){
        return this.settings.flipVertical;
    };
	




    p._calcViewbox = function () {
    	 var x=[];
        var y=[];

        x[0] = (Math.cos(Math.PI/180*this.settings.viewRotateAngle)*-(this.settings.imageWidth/2)-Math.sin(Math.PI/180*this.settings.viewRotateAngle)*(this.settings.imageHeight/2))+this.settings.imageWidth/2;
        y[0] = (Math.sin(Math.PI/180*this.settings.viewRotateAngle)*-(this.settings.imageWidth/2)+Math.cos(Math.PI/180*this.settings.viewRotateAngle)*(this.settings.imageHeight/2))+this.settings.imageHeight/2;

        x[1] = (Math.cos(Math.PI/180*this.settings.viewRotateAngle)*-(this.settings.imageWidth/2)-Math.sin(Math.PI/180*this.settings.viewRotateAngle)*-(this.settings.imageHeight/2))+this.settings.imageWidth/2;
        y[1] = (Math.sin(Math.PI/180*this.settings.viewRotateAngle)*-(this.settings.imageWidth/2)+Math.cos(Math.PI/180*this.settings.viewRotateAngle)*-(this.settings.imageHeight/2))+this.settings.imageHeight/2;

        x[2] = (Math.cos(Math.PI/180*this.settings.viewRotateAngle)*(this.settings.imageWidth/2)-Math.sin(Math.PI/180*this.settings.viewRotateAngle)*-(this.settings.imageHeight/2))+this.settings.imageWidth/2;
        y[2] = (Math.sin(Math.PI/180*this.settings.viewRotateAngle)*(this.settings.imageWidth/2)+Math.cos(Math.PI/180*this.settings.viewRotateAngle)*-(this.settings.imageHeight/2))+this.settings.imageHeight/2;

        x[3] = (Math.cos(Math.PI/180*this.settings.viewRotateAngle)*(this.settings.imageWidth/2)-Math.sin(Math.PI/180*this.settings.viewRotateAngle)*(this.settings.imageHeight/2))+this.settings.imageWidth/2;
        y[3] = (Math.sin(Math.PI/180*this.settings.viewRotateAngle)*(this.settings.imageWidth/2)+Math.cos(Math.PI/180*this.settings.viewRotateAngle)*(this.settings.imageHeight/2))+this.settings.imageHeight/2;

        this.settings.viewBox.x = Math.min(x[0],x[1],x[2],x[3]);
        var maxx = Math.max(x[0],x[1],x[2],x[3]);
        this.settings.viewBox.y = Math.min(y[0],y[1],y[2],y[3]);
        var maxy = Math.max(y[0],y[1],y[2],y[3]);

       this.settings.viewBox.width = maxx-this.settings.viewBox.x ;
       this.settings.viewBox.height = maxy-this.settings.viewBox.y ;

    };

    p._widgetReadyHandler = function () {
        return false;
    };

    p._parseColorList = function (colorList) {
        // eslint-disable-next-line no-useless-escape
        return colorList.match(/(((rgba\((((25[0-5])|(2[01234][0-9])|([01][0-9][0-9])|([0-9]{1,2})),(\s)?){3}((0\.[0-9]{1,2})|1(.0)?|0)\)))|([\#]([a-fA-F\d]{6}|[a-fA-F\d]{3})))/g);
    };
    p._customImageClickHandler = function (e) {



        // _customClickHandler will trigger the click event as regular clicks are not detected on moving elements anymore.

        var pt = this.$svgContainer[0].createSVGPoint();
        pt.x = e.clientX;
        pt.y = e.clientY;

        var tmp = $(e.target).parents('g[name="flip"]')[0];
        
        var invPt = pt.matrixTransform(tmp.getScreenCTM().inverse());
        //console.log(invPt);



        var eventArgs = {

            x: Math.round(invPt.x),

            y: Math.round(invPt.y),

            origin: brease.uiController.parentWidgetId(e.target),

            elementId: 'noElementClicked'

        };

        var clickedElement;

        if (e.type === 'vmousedown') {

            clickedElement = document.elementFromPoint(e.clientX, e.clientY);
        }

        if (clickedElement && clickedElement.ownerSVGElement && clickedElement.hasAttribute('id')) {

            eventArgs.elementId = '#' + clickedElement.getAttribute('id');

        }

        /**

       * @event ImageClick

       * @iatStudioExposed

       * Fired when image in widget is clicked

       * @param {Integer} x

       * @param {Integer} y

       * @param {String} origin id of widget that triggered this event

       * @param {String} elementId id of a clicked svg element

       */

        var clickEv = this.createMouseEvent('ImageClick', eventArgs, e);

        clickEv.dispatch();

    };



       
    p._customClickHandler = function (e) {
        // _customClickHandler will trigger the click event as regular clicks are not detected on moving elements anymore.
        if (this.isDisabled) {
            /**
            * @event DisabledClick
            * Fired when disabled element is clicked on.
            * @iatStudioExposed
            * @param {String} horizontalPos horizontal position of click in pixel i.e '10px'
            * @param {String} verticalPos vertical position of click in pixel i.e '10px'
            * @param {String} origin id of widget that triggered this event
            * @param {Boolean} hasPermission defines if the state is caused due to missing roles of the current user 
            * @eventComment
            */
            var origin = brease.uiController.parentWidgetId(e.target),
                hasPermission = (this.settings.editable && this.settings.permissions.operate);
            var disabledClickEv = this.createMouseEvent('DisabledClick', { hasPermission: hasPermission, origin: origin }, e);
            disabledClickEv.dispatch(false);
            document.body.dispatchEvent(new CustomEvent(BreaseEvent.DISABLED_CLICK, {
                detail: {
                    contentId: this.settings.parentContentId,
                    hasPermission: hasPermission,
                    origin: origin,
                    widgetId: this.elem.id,
                    horizontalPos: disabledClickEv.data.eventArgs.horizontalPos,
                    verticalPos: disabledClickEv.data.eventArgs.verticalPos
                },
                bubbles: true
            }));
            SuperClass.prototype._handleEvent.call(this, e);
            return;
        }

        var svgClickPoint = this._createSVGPointFromClick(this, e);

        var eventArgs = {
            x: Math.round(svgClickPoint.x),
            y: Math.round(svgClickPoint.y),
            origin: brease.uiController.parentWidgetId(e.target),
            elementId: 'noElementClicked'
        };

        var clickedElement;

        if (e.type === 'vmousedown') {
            clickedElement = document.elementFromPoint(e.clientX, e.clientY);
        }

        if (clickedElement && clickedElement.ownerSVGElement && clickedElement.hasAttribute('id')) {
            eventArgs.elementId = '#' + clickedElement.getAttribute('id');
        }

        /**
       * @event Click
       * @iatStudioExposed
       * Fired when widget is clicked
       * @param {Integer} x
       * @param {Integer} y
       * @param {String} horizontalPos horizontal position of click in pixel i.e '10px'
       * @param {String} verticalPos vertical position of click in pixel i.e '10px'
       * @param {String} origin id of widget that triggered this event
       * @param {String} elementId id of a clicked svg element
       */
        var clickEv = this.createMouseEvent('Click', eventArgs, e);
        clickEv.dispatch();
        //clickEv.target = this.elem;
        //SuperClass.prototype._clickHandler.call(this, clickEv);
    };

    // overwrite base click handler to prevent it from firing the click event. _mouseUpHandler will do this.
    p._clickHandler = function (e) {
    };

    p._triggerTransformDoneEvent = function (originalSelect) {

        /**
       * @event TransformDone
       * @iatStudioExposed
       * Fired when a transform command has finished execution.
       * @param {String} select
       */

        var ev;

        if (this.elem) {
            ev = this.createEvent('TransformDone', { select: originalSelect });
            ev.dispatch();
        }

    };
    p.contentActivatedHandler = function () {
        if (this.observer.initialized) {
            this.observer.wake();
        } else {
            this.observer.init();
        }
    };
    
    p._visibleHandler = function () {
        SuperClass.prototype._visibleHandler.apply(this, arguments);
        _redrawDimension.call(this);
    };

    p.suspend = function () {
        document.body.removeEventListener(BreaseEvent.THEME_CHANGED, this._bind(_onThemeChanged));
        this.observer.suspend();
        SuperClass.prototype.suspend.apply(this, arguments);
    };
    p.wake = function () {
        document.body.addEventListener(BreaseEvent.THEME_CHANGED, this._bind(_onThemeChanged));
        SuperClass.prototype.wake.apply(this, arguments);
        if (this.widgetPreLoaded) {
            this.widgetPreLoaded = false;
            // A&P 666500. Widget doesn't load svg when precaching is used and svgFile is binded 
            // as we prevent setting svgFilePath in preloadingState, there is no need to ask if file-container is empty
            if (this.settings.svgFilePath !== '') {
                this.setSvgFilePath(this.settings.svgFilePath);
            }
        }
		if(this.settings.PLCWebsocketPort != 0){
			this._wsConnect();
		}
    };

	p.suspend = function () {
		if(this.socket != null){
			if (this.socket.readyState === WebSocket.OPEN) {
				this.socket.onclose = function(event){
					console.log("WS Closed");
					this.socket = null;
				};
			  console.log("WS closing");
			  this.socket.close(1000,"Deliberate close");
			}
		}
        SuperClass.prototype.suspend.apply(this, arguments);
    
	};
    
	p.dispose = function () {
        this.elem.removeEventListener(BreaseEvent.WIDGET_READY, this._bind('_widgetReadyHandler'));
        document.body.removeEventListener(BreaseEvent.THEME_CHANGED, this._bind(_onThemeChanged));
        this.observer.dispose();
        this.observer = undefined;
		if(this.socket != null){
			if (this.socket.readyState === WebSocket.OPEN) {
				this.socket.onclose = function(event){
					console.log("WS Closed");
					this.socket = null;
				};
			  console.log("WS closing");
			  this.socket.close(1000,"Deliberate close");
			}
		}
        clearTimeout(this.renderer.timeout);
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    p._createSVGPointFromClick = function (widget, e) {
        // convert point from d3.createSVGPoint
        var point = this.$svgContainer.get(0).createSVGPoint(),
            leftBorder = parseInt(widget.el.css('border-left-width'), 10),
            rightBorder = parseInt(widget.el.css('border-right-width'), 10),
            topBorder = parseInt(widget.el.css('border-top-width'), 10),
            bottomBorder = parseInt(widget.el.css('border-bottom-width'), 10),
            scaleFactor = Utils.getScaleFactor(widget.elem);

        if (e.type === 'vmousedown') {
            point.x = (e.pageX - widget.el.offset().left) / scaleFactor;
            point.y = (e.pageY - widget.el.offset().top) / scaleFactor;
        }

        if (point.x > (widget.elem.clientWidth + leftBorder + rightBorder)) {
            point.x = widget.elem.clientWidth + leftBorder + rightBorder;
        } else if (point.x < 0) {
            point.x = 0;
        }

        if (point.y > (widget.elem.clientHeight + topBorder + bottomBorder)) {
            point.y = widget.elem.clientHeight + topBorder + bottomBorder;
        } else if (point.y < 0) {
            point.y = 0;
        }

        return point;
    };

	p._setViewBox = function (viewBox) {
        var viewBoxStr = '0 0 '+ viewBox.width + ' ' + viewBox.height;
        UtilsSvg.setViewBox(this.$svgContainer.get(0), viewBoxStr);
    };
	

    p._setViewBoxDimensions = function (elemWidth, elemHeight) {



        var viewBox = '0 0 '+ elemWidth + ' ' + elemHeight;
        UtilsSvg.setViewBox(this.$svgContainer.get(0), viewBox);
    };

    function _addPlaceholderImage(widget) {
        widget.el.css({
            'background-image': 'url("widgets/brdk/VisionImage/assets/VisionImagePlaceholder.svg")',
            'background-repeat': 'no-repeat',
            'background-position': 'center center'
        });
    }

    function _updateTransform() {
        if (this.settings.transform !== '') {
            this.timeSvgContent = new Date();
            this.data = JSON.parse(this.settings.transform.replace(/'/g, '"'));
            this.renderer.evalTransform(this.data, this.timeTransform - this.timeSvgContent);
        }
    }

    function _redrawDimension() {
        if (this.isVisible() && this.renderer && !brease.config.editMode) {
			console.log("Redraw Dimensions");
            //this.renderer.setDimension();
        }
        
    }
    function _onThemeChanged() {
        _redrawDimension.call(this);
       
    }
    return contentActivatedDependency.decorate(dragAndDropCapability.decorate(WidgetClass, false), true);
});
