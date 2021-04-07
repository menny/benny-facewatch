using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;

class ImageStatusBase extends WatchUi.Drawable {

	var _visible = true;
	
	function initialize() {
        var dictionary = {
            :identifier => getStatusId()
        };

        Drawable.initialize(dictionary);
    }

    function setVisible(visible) {
		_visible = visible;
	}
	
    function draw(dc) {
    	if (_visible) {
    	} else {
	        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    		dc.clear();
    	}
    }
    
    function getStatusId() {
    	throw new Lang.OperationNotAllowedException("status id not set");
    }
}

class PhoneStatus extends ImageStatusBase {

	function initialize() {
        ImageStatusBase.initialize();
    }
    
	function getStatusId() {
    	return "PhoneStatus";
    }
}

class Alarm extends ImageStatusBase {

	function initialize() {
        ImageStatusBase.initialize();
    }
    
	function getStatusId() {
    	return "Alarm";
    }
}

class Weather extends ImageStatusBase {

	function initialize() {
        ImageStatusBase.initialize();
    }
    
	function getStatusId() {
    	return "Weather";
    }
}
