using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;

class Background extends ChildViewBase {

    function initialize() {
        ChildViewBase.initialize();
    }

	protected function getStatusViewId() {
		return "Background";
	}

	function onSettingsChanged(app) {
		//nothing here
	}

	function onUpdateCalledOnRootView(now) {
		//never
	}

    function draw(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, getColorsScheme().backgroundColor);
        dc.clear();
    }

}

class WatchTicks extends ChildViewBase {
	var deviceSettings = System.getDeviceSettings();

	function initialize() {
        ChildViewBase.initialize();
    }

	protected function getStatusViewId() {
		return "WatchTicks";
	}

	function onSettingsChanged(app) {
		//nothing here
	}

	function onUpdateCalledOnRootView(now) {
		//never
	}

    function draw(dc) {
    	var colorsScheme = getColorsScheme();
    	var cx = deviceSettings.screenWidth/2;
    	var cy = deviceSettings.screenHeight/2;
    	var tickWidth = 2;
    	var tickWidther = 3;
    	var tickWidthest = 4;
    	var tickEnd = deviceSettings.screenWidth/2;
    	var tickStartSmall = tickEnd - deviceSettings.screenWidth/50;
    	var tickStart = tickEnd - deviceSettings.screenWidth/30;
    	var tickStartLarger = tickEnd - deviceSettings.screenWidth/20;
    	var tickStartLargest = tickEnd - deviceSettings.screenWidth/17;
    	for( var tickAngle = 0; tickAngle < 360; tickAngle = tickAngle + (360/60)) {
    		if (tickAngle == 0) {
    			dc.setColor(colorsScheme.majorWatchTickColor, Graphics.COLOR_TRANSPARENT);
    			drawRadialRect(dc, Math.toRadians(tickAngle), tickWidthest, tickStartLargest, tickEnd, cx, cy);
    		} else if (tickAngle % 90 == 0) {
    			dc.setColor(colorsScheme.majorWatchTickColor, Graphics.COLOR_TRANSPARENT);
    			drawRadialRect(dc, Math.toRadians(tickAngle), tickWidther, tickStartLarger, tickEnd, cx, cy);
    		} else if (tickAngle % 30 == 0) {
    			dc.setColor(colorsScheme.minorWatchTickColor, Graphics.COLOR_TRANSPARENT);
    			drawRadialRect(dc, Math.toRadians(tickAngle), tickWidth, tickStart, tickEnd, cx, cy);
    		} else {
    			dc.setColor(colorsScheme.microWatchTickColor, Graphics.COLOR_TRANSPARENT);
    			drawRadialRect(dc, Math.toRadians(tickAngle), tickWidth, tickStartSmall, tickEnd, cx, cy);
    		}
		}
    }
}

class WatchHands extends ChildViewBase {
	var deviceSettings = System.getDeviceSettings();
	var showSeconds = true;
	var lastUpdateSeconds = 0;

    function initialize() {
        ChildViewBase.initialize();
    }
    
	protected function getStatusViewId() {
		return "WatchHands";
	}
	
	function onSettingsChanged(app) {
		//nothing here
	}

    function onUpdateCalledOnRootView(now) {
		if (now != lastUpdateSeconds) {
			if (showSeconds) {
				requestUpdate();
				lastUpdateSeconds = now;
			} else if ((now % 60 == 0) || (now - lastUpdateSeconds >= 60)) {
				requestUpdate();
				lastUpdateSeconds = now;
			}
		}
	}

    function onExitSleep() {
    	showSeconds = true;
    	requestUpdate();
    }
    
    function onEnterSleep() {
    	showSeconds = false;
    	requestUpdate();
    }
    
    private function drawHand(dc, angle, width, start, end, cx, cy, color) {
    	//circle at the center
    	dc.setColor(color, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(cx, cy, width + 1);
		
    	//hand
		drawRadialRect(dc, angle, width.toFloat()/2.0, start, end, cx, cy);
    }
    
    private function drawHandWithShadow(dc, angle, width, start, end, cx, cy, foregroundColor, shadowColor) {
		var radianAngle = Math.toRadians(angle);
		
	    //always a black line below (shadow)
	    if (shadowColor != Graphics.COLOR_TRANSPARENT) {
	    	drawHand(dc, radianAngle, width, start, end, cx + 1, cy + 1, shadowColor);
		}
		
		drawHand(dc, radianAngle, width, start, end, cx, cy, foregroundColor);
	}

    function draw(dc) {
    	var colorsScheme = getColorsScheme();
    	var clockTime = System.getClockTime();
    	var timeZoneOffsetMinutes = clockTime.timeZoneOffset + clockTime.dst;
        var hours = ((clockTime.hour + (timeZoneOffsetMinutes/60)) % 12).toFloat();
        var minutes = (clockTime.min + (timeZoneOffsetMinutes % 60)).toFloat();
        var seconds = clockTime.sec;
    	var cx = deviceSettings.screenWidth/2;
    	var cy = deviceSettings.screenHeight/2;
    	var tickEnd = deviceSettings.screenWidth/2;
    	var tickChunck = deviceSettings.screenWidth/17;
    	
    	//tweaking the positions
    	hours = hours + (minutes/60.0);
    	minutes = minutes + (seconds/60.0);
    	
    	//hours
		drawHandWithShadow(dc, hours*30, 6, 0, tickEnd - tickChunck*4, cx, cy, colorsScheme.hoursHandColor, Graphics.COLOR_BLACK);
		
		//minutes
		drawHandWithShadow(dc, minutes*6, 4, 0, tickEnd - tickChunck*2, cx, cy, colorsScheme.minutesHandColor, Graphics.COLOR_BLACK);
		
		if (showSeconds) {
			drawHandWithShadow(dc, seconds*6, 1, -tickChunck, tickEnd - tickChunck, cx, cy, colorsScheme.secondsHandColor, Graphics.COLOR_BLACK);
		}
		
		//dot at the center of the hands (the axis)
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(cx, cy, 1);
    }

}
