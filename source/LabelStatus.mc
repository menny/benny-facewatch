using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;

class LabelStatus extends WatchUi.Drawable {

	var _visible = true;
	
	function initialize() {
        var dictionary = {
            :identifier => getLabelId()
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
    
    function getLabelId() {
    	throw new Lang.OperationNotAllowedException("label id not set");
    }
}

class Date extends LabelStatus {

	function initialize() {
        LabelStatus.initialize();
    }
    
	function getLabelId() {
    	return "Date";
    }
}


class Distance extends LabelStatus {

	function initialize() {
        LabelStatus.initialize();
    }
    
	function getLabelId() {
    	return "Distance";
    }
}

class DoNotDisturbDigitalWatch extends LabelStatus {

	function initialize() {
        LabelStatus.initialize();
    }
    
	function getLabelId() {
    	return "DoNotDisturbDigitalWatch";
    }
}
