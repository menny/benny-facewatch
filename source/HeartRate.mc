using Toybox.Graphics;
using Toybox.WatchUi;

class HeartRate extends WatchUi.Drawable {

	var _visible = true;
	
	function initialize() {
        var dictionary = {
            :identifier => "HeartRate"
        };

        Drawable.initialize(dictionary);
    }

	function onUpdateCalledOnRootView(now) {
		//never
	}

    function onSettingsChanged(app) {
		var newVisible = app.getProperty("ShowHeartRate");
		if (newVisible != _visible) {
			_visible = newVisible;
			requestUpdate();
		}
	}
	
    function draw(dc) {
    	if (_visible) {
    	} else {
	        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    		dc.clear();
    	}
    }
}

class HeartRateHistory extends WatchUi.Drawable {

	var _visible = true;
	
	function initialize() {
        var dictionary = {
            :identifier => "HeartRateHistory"
        };

        Drawable.initialize(dictionary);
    }

	function onUpdateCalledOnRootView(now) {
		//never
	}

    function onSettingsChanged(app) {
		var newVisible = app.getProperty("ShowHeartRateHistory");
		if (newVisible != _visible) {
			_visible = newVisible;
			requestUpdate();
		}
	}
	
    function draw(dc) {
    	if (_visible) {
    	} else {
	        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    		dc.clear();
    	}
    }
}
