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
    	var tickWidth = 2;
    	var tickWidther = tickWidth*2;
    	var tickEnd = deviceSettings.screenWidth/2;
    	var tickStartSmall = tickEnd - deviceSettings.screenWidth/50;
    	var tickStart = tickEnd - deviceSettings.screenWidth/30;
    	var tickStartLarger = tickEnd - deviceSettings.screenWidth/20;
    	for( var tickAngle = 0; tickAngle < 360; tickAngle = tickAngle + (360/60)) {
    		if (tickAngle % 90 == 0) {
    			drawRadialRect(dc, tickAngle, tickWidther, tickStartLarger, tickEnd, cx, cy, colorsScheme.majorWatchTickColor, Graphics.COLOR_TRANSPARENT);
    		} else if (tickAngle % 30 == 0) {
    			drawRadialRect(dc, tickAngle, tickWidth, tickStart, tickEnd, cx, cy, colorsScheme.minorWatchTickColor, Graphics.COLOR_TRANSPARENT);
    		} else {
    			drawRadialRect(dc, tickAngle, tickWidth, tickStartSmall, tickEnd, cx, cy, colorsScheme.microWatchTickColor, Graphics.COLOR_TRANSPARENT);
    		}
		}
    }
}

class WatchHands extends WatchUi.Drawable {
	var deviceSettings = System.getDeviceSettings();
	var showSeconds = true;
	var lastUpdateSeconds = 0;

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
    }
    
    function onEnterSleep() {
    	showSeconds = false;
    	requestUpdate();
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
    	var tickEndHours = tickEnd - tickChunck*3;
		dc.setColor(colorsScheme.hoursHandColor, Graphics.COLOR_TRANSPARENT);
		//circle at the beginning
		dc.fillCircle(calcRadialX(cx, tickStartHours - 3, hoursAngle), calcRadialY(cy, tickStartHours - 3, hoursAngle), 5);
    	drawRadialRect(dc, hoursAngle, 5, -3, tickEndHours, cx, cy, colorsScheme.hoursHandColor, Graphics.COLOR_BLACK);
		
		//minutes
		var centerCircleColor = colorsScheme.minutesHandColor;
		dc.setColor(centerCircleColor, Graphics.COLOR_TRANSPARENT);
		var minutesAngle = minutes*6;
		var tickStartMinutes = -4;
		var tickEndMinutes = tickEnd - tickChunck*1.25;
		dc.fillCircle(calcRadialX(cx, tickStartMinutes - 3, minutesAngle), calcRadialY(cy, tickStartMinutes - 3, minutesAngle), 2.5);
		drawRadialRect(dc, minutesAngle, 3, tickStartMinutes, tickEndMinutes, cx, cy, centerCircleColor, Graphics.COLOR_BLACK);
		
		if (showSeconds) {
			//actually, the top hand is seconds, so change the color of the center circle
			centerCircleColor = colorsScheme.secondsHandColor;
			dc.setColor(centerCircleColor, Graphics.COLOR_TRANSPARENT);
			var secondsAngle = seconds*6;
			//no shadow for the seconds. It's just too thin and it looks weird.
			drawRadialRect(dc, seconds*6, 1, -8, tickEnd - tickChunck/2, cx, cy, centerCircleColor, Graphics.COLOR_TRANSPARENT);
			dc.fillCircle(calcRadialX(cx, -10, secondsAngle), calcRadialY(cy, -10, secondsAngle), 1.5);
		}
		
		//circle at the center.
		dc.setColor(centerCircleColor, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(cx, cy, 4);
		//dot at the center of the hands (the axis)
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(cx, cy, 1);
    }

}
