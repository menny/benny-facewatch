using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;

class Background extends WatchUi.Drawable {

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

	function onUpdateCalledOnRootView(now) {
		//never
	}

    function draw(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, getColorsScheme().backgroundColor);
        dc.clear();
    }

}

class WatchTicks extends WatchUi.Drawable {
	var deviceSettings = System.getDeviceSettings();

	function initialize() {
        var dictionary = {
            :identifier => "WatchTicks"
        };

        Drawable.initialize(dictionary);
    }

	function onUpdateCalledOnRootView(now) {
		//never
	}

    function draw(dc) {
    	var colorsScheme = getColorsScheme();
    	var cx = deviceSettings.screenWidth/2;
    	var cy = deviceSettings.screenHeight/2;
    	var tickWidth = 1;
    	var tickWidther = tickWidth*2;
    	var tickEnd = deviceSettings.screenWidth/2;
    	var tickStartSmall = tickEnd - deviceSettings.screenWidth/50;
    	var tickStart = tickEnd - deviceSettings.screenWidth/30;
    	var tickStartLarger = tickEnd - deviceSettings.screenWidth/20;
    	for( var tickAngle = 0; tickAngle < 360; tickAngle = tickAngle + (360/60)) {
    		if (tickAngle % 90 == 0) {
		    	dc.setColor(colorsScheme.majorWatchTickColor, Graphics.COLOR_TRANSPARENT);
    			drawRadialRect(dc, tickAngle, tickWidther, tickStartLarger, tickEnd, cx, cy);
    		} else if (tickAngle % 30 == 0) {
		    	dc.setColor(colorsScheme.minorWatchTickColor, Graphics.COLOR_TRANSPARENT);
    			drawRadialRect(dc, tickAngle, tickWidth, tickStart, tickEnd, cx, cy);
    		} else {
		    	dc.setColor(colorsScheme.microWatchTickColor, Graphics.COLOR_TRANSPARENT);
    			drawRadialRect(dc, tickAngle, tickWidth, tickStartSmall, tickEnd, cx, cy);
    		}
		}
    }
}

class WatchHands extends WatchUi.Drawable {
	var deviceSettings = System.getDeviceSettings();
	var showSeconds = true;
	var lastUpdateSeconds;

    function initialize() {
        var dictionary = {
            :identifier => "WatchHands"
        };

        Drawable.initialize(dictionary);
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
    	Drawable.onExitSleep();
    }
    
    function onEnterSleep() {
    	showSeconds = false;
    	requestUpdate();
    	Drawable.onEnterSleep();
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
    	var hoursAngle = hours*30;
    	var tickStartHours = -3;
    	var tickEndHours = tickEnd - tickChunck*2;
		dc.setColor(colorsScheme.hoursHandColor, Graphics.COLOR_TRANSPARENT);
    	drawRadialRect(dc, hoursAngle, 2, -3, tickEndHours, cx, cy);
		//circle at the beginning
		dc.fillCircle(calcRadialX(cx, tickStartHours - 1, hoursAngle), calcRadialY(cy, tickStartHours - 1, hoursAngle), 4);
		//circle at the tip
		dc.fillCircle(calcRadialX(cx, tickEndHours, hoursAngle), calcRadialY(cy, tickEndHours, hoursAngle), 2);
		
		//minutes
		dc.setColor(colorsScheme.minutesHandColor, Graphics.COLOR_TRANSPARENT);
		var minutesAngle = minutes*6;
		var tickStartMinutes = -4;
		var tickEndMinutes = tickEnd - tickChunck;
		drawRadialRect(dc, minutesAngle, 1, tickStartMinutes, tickEndMinutes, cx, cy);
		dc.fillCircle(calcRadialX(cx, tickStartMinutes - 2, minutesAngle), calcRadialY(cy, tickStartMinutes - 2, minutesAngle), 2);
		dc.fillCircle(calcRadialX(cx, tickEndMinutes, minutesAngle), calcRadialY(cy, tickEndMinutes, minutesAngle), 1);
		
		if (showSeconds) {
			dc.setColor(colorsScheme.secondsHandColor, Graphics.COLOR_TRANSPARENT);
			var secondsAngle = seconds*6;
			drawRadialRect(dc, seconds*6, 0.5, -8, tickEnd - tickChunck/2, cx, cy);
			dc.fillCircle(calcRadialX(cx, -10, secondsAngle), calcRadialY(cy, -10, secondsAngle), 2);
			dc.fillCircle(cx, cy, 4);
			dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
			dc.fillCircle(cx, cy, 1);
		}
    }

}
