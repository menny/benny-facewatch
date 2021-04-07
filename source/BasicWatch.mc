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

    function draw(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Application.getApp().getProperty("BackgroundColor"));
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

    function draw(dc) {
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
		    	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
    			drawRadialRect(dc, tickAngle, tickWidther, tickStartLarger, tickEnd, cx, cy);
    		} else if (tickAngle % 30 == 0) {
		    	dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
    			drawRadialRect(dc, tickAngle, tickWidth, tickStart, tickEnd, cx, cy);
    		} else {
		    	dc.setColor(0x000066, Graphics.COLOR_TRANSPARENT);
    			drawRadialRect(dc, tickAngle, tickWidth, tickStartSmall, tickEnd, cx, cy);
    		}
		}
    }
}

class WatchHands extends WatchUi.Drawable {
	var deviceSettings = System.getDeviceSettings();
	var showSeconds = true;

    function initialize() {
        var dictionary = {
            :identifier => "WatchHands"
        };

        Drawable.initialize(dictionary);
    }
    
    function onExitSleep() {
    	showSeconds = true;
    	Drawable.onExitSleep();
    	self.requestUpdate();
    }
    
    function onEnterSleep() {
    	showSeconds = false;
    	Drawable.onEnterSleep();
    	self.requestUpdate();
    }

    function draw(dc) {
        var clockTime = System.getClockTime();
        var hours = (clockTime.hour % 12).toFloat();
        var minutes = clockTime.min.toFloat();
        var seconds = clockTime.sec;
    	var cx = deviceSettings.screenWidth/2;
    	var cy = deviceSettings.screenHeight/2;
    	var tickEnd = deviceSettings.screenWidth/2;
    	var tickChunck = deviceSettings.screenWidth/17;
    	
    	//tweaking the positions
    	hours = hours + (minutes/60.0);
    	minutes = minutes + (seconds/60.0);
    	
    	//hours
    	dc.setColor(0xAAAAFF, Graphics.COLOR_TRANSPARENT);
    	var hoursAngle = hours*30;
    	var tickStartHours = -3;
    	var tickEndHours = tickEnd - tickChunck*2;
		drawRadialRect(dc, hoursAngle, 2, -3, tickEndHours, cx, cy);
		//circle at the beginning
		dc.fillCircle(calcRadialX(cx, tickStartHours - 1, hoursAngle), calcRadialY(cy, tickStartHours - 1, hoursAngle), 4);
		//circle at the tip
		dc.fillCircle(calcRadialX(cx, tickEndHours, hoursAngle), calcRadialY(cy, tickEndHours, hoursAngle), 2);
		
		//minutes
		dc.setColor(0xAAAAFF, Graphics.COLOR_TRANSPARENT);
		var minutesAngle = minutes*6;
		var tickStartMinutes = -4;
		var tickEndMinutes = tickEnd - tickChunck;
		drawRadialRect(dc, minutesAngle, 1, tickStartMinutes, tickEndMinutes, cx, cy);
		dc.fillCircle(calcRadialX(cx, tickStartMinutes - 2, minutesAngle), calcRadialY(cy, tickStartMinutes - 2, minutesAngle), 2);
		dc.fillCircle(calcRadialX(cx, tickEndMinutes, minutesAngle), calcRadialY(cy, tickEndMinutes, minutesAngle), 1);
		
		if (showSeconds) {
			dc.setColor(0x7777CC, Graphics.COLOR_TRANSPARENT);
			var secondsAngle = seconds*6;
			drawRadialRect(dc, seconds*6, 0.5, -8, tickEnd - tickChunck/2, cx, cy);
			dc.fillCircle(calcRadialX(cx, -10, secondsAngle), calcRadialY(cy, -10, secondsAngle), 2);
			dc.fillCircle(cx, cy, 4);
			dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
			dc.fillCircle(cx, cy, 1);
		}
    }

}
