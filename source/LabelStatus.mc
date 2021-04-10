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

    function onUpdateCalledOnRootView(now) {
		if (_visible && checkIfUpdateRequired(now)) {
			requestUpdate();
		}
	}

	protected function checkIfUpdateRequired(now) {
    	throw new Lang.OperationNotAllowedException("checkIfUpdateRequired not set");
	}
}

class Date extends LabelStatus {
    const DAY = 24 * 60 * 60;
	var lastUpdateInDays = 0;

	function initialize() {
        LabelStatus.initialize();
    }
    
    protected function checkIfUpdateRequired(now) {
        now = now / DAY;
        if (now != lastUpdateInDays) {
			requestUpdate();
            lastUpdateInDays = now;
            return true;
		} else {
			return false;
		}
    }

	function getLabelId() {
    	return "Date";
    }
}


class Distance extends LabelStatus {

	function initialize() {
        LabelStatus.initialize();
    }
    
    protected function checkIfUpdateRequired(now) {
        //never
        return false;
    }

	function getLabelId() {
    	return "Distance";
    }
}

class DoNotDisturbDigitalWatch extends LabelStatus {
    const MINUTE = 60;
	var lastUpdateInMinutes = 0;

	function initialize() {
        LabelStatus.initialize();
    }
    
    protected function checkIfUpdateRequired(now) {
        now = now / MINUTE;
        if (now != lastUpdateInMinutes) {
			requestUpdate();
            lastUpdateInMinutes = now;
            return true;
		} else {
			return false;
		}
    }
    
	function getLabelId() {
    	return "DoNotDisturbDigitalWatch";
    }
}
