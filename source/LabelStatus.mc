using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class LabelStatus extends WatchUi.Drawable {

	private var _visible = true;
	protected var _deviceSettings = System.getDeviceSettings();
	
	function initialize() {
        var dictionary = {
            :identifier => getLabelId()
        };

        Drawable.initialize(dictionary);
    }

    function onSettingsChanged(app) {
		var newVisible = app.getProperty(getVisiblePrefId());
		if (newVisible != _visible) {
			_visible = newVisible;
			requestUpdate();
		}
	}

	protected function getVisiblePrefId() {
    	throw new Lang.OperationNotAllowedException("visible pref id not set");
    }
	
    function draw(dc) {
    	if (_visible) {
            onDrawLabel(dc);
    	} else {
	        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    		dc.clear();
    	}
    }
    
    protected function onDrawLabel(dc) {
        throw new Lang.OperationNotAllowedException("onDrawLabel id not set");
    }
    
    protected function getLabelId() {
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
            lastUpdateInDays = now;
            return true;
		} else {
			return false;
		}
    }

    protected function onDrawLabel(dc) {
    	var colorsScheme = getColorsScheme();
        var calendar = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateText = Lang.format("$1$  $2$", [calendar.day_of_week, calendar.day]);
        var textDimens = dc.getTextDimensions(dateText, Graphics.FONT_XTINY);
        
        var paddingX = 3;
        var paddingY = 1;
    	var y = _deviceSettings.screenHeight/2  - textDimens[1]/2 - paddingY;
        var x = _deviceSettings.screenWidth - textDimens[0] - _deviceSettings.screenWidth/10 - paddingX;
        //border
        dc.setColor(colorsScheme.dateBorderColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(x - paddingX - 1, y - paddingY - 1, textDimens[0] + paddingX*2 + 2, textDimens[1] + paddingY*2 + 2, 4);
        //background
        dc.setColor(colorsScheme.dateBackgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(x - paddingX, y - paddingY, textDimens[0] + paddingX*2, textDimens[1] + paddingY*2, 3);
        //text
        dc.setColor(colorsScheme.dateTextColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_XTINY, dateText, Graphics.TEXT_JUSTIFY_LEFT);
    }

    protected function getVisiblePrefId() {
    	return "ShowDate";
    }

	protected function getLabelId() {
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

    protected function getVisiblePrefId() {
    	return "ShowDistance";
    }

	protected function getLabelId() {
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
        return false;
    }

    protected function getVisiblePrefId() {
    	return "ShowDoNotDisturbView";
    }
    
	protected function getLabelId() {
    	return "DoNotDisturbDigitalWatch";
    }
}
