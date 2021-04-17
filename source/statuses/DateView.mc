using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class DateView extends StatusViewBase {
    const DAY = 24 * 60 * 60;
	var lastUpdateInDays = 0;

	function initialize() {
        StatusViewBase.initialize();
    }
    
    protected function checkIfUpdateRequired(now, force) {
        now = now / DAY;
        if (force || now != lastUpdateInDays) {
            lastUpdateInDays = now;
            return true;
		} else {
			return false;
		}
    }

	protected function getStatusWidth() {
		//we'll take the entire half
		return _state.staticDeviceSettings.screenWidth/2;
	}
	
	protected function getStatusHeight() {
		var fontHeight = Graphics.getFontHeight(Graphics.FONT_XTINY);
		return 1.5 * fontHeight;
	}
	
	protected function getStatusX() {
    	return _state.centerX;
	}
	
	protected function getStatusY() {
    	return _state.centerY - getStatusHeight()/2;
	}
    
    protected function onDrawNow(dc) {
    	var colorsScheme = getColorsScheme();
        var calendar = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateText = Lang.format("$1$  $2$", [calendar.day_of_week, calendar.day]);
        var textDimens = dc.getTextDimensions(dateText, Graphics.FONT_XTINY);
        
        var paddingX = 3;
        var paddingY = 1;
    	var y = dc.getHeight()/2 - textDimens[1]/2 - paddingY * 2;
        var x = dc.getWidth() - textDimens[0] - _state.staticDeviceSettings.screenWidth/10 - paddingX;
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
}
