using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;

class Background extends ChildViewBase {

    function initialize() {
        ChildViewBase.initialize(24*60*60);
    }

    function onSettingsChanged(app, sleeping, inDndMode) {
    }

    function draw(dc, now, force) {
        ChildViewBase.draw(dc, now, force);
        dc.setColor(Graphics.COLOR_TRANSPARENT, getColorsScheme().backgroundColor);
        dc.clear();
    }
}

class WatchTicks extends ChildViewBase {

    private var _notInDndMode = true;

    function initialize() {
        ChildViewBase.initialize(24*60*60);
    }

    function onSettingsChanged(app, sleeping, inDndMode) {
        _notInDndMode = !inDndMode;
    }

    function isDirty(now) {
        return _notInDndMode && ChildViewBase.isDirty(now);
    }

    function draw(dc, now, force) {
        ChildViewBase.draw(dc, now, force);
        if (_notInDndMode) {
            var deviceSettings = _state.staticDeviceSettings;
            var colorsScheme = getColorsScheme();
            var cx = _state.centerX;
            var cy = _state.centerY;
            var tickMicroWidth = 1;
            var tickWidth = 2;
            var tickWidther = 3;
            var tickWidthest = 5;
            var tickEnd = deviceSettings.screenWidth/2;
            var tickStartSmall = tickEnd - deviceSettings.screenWidth/50;
            var tickStart = tickEnd - deviceSettings.screenWidth/30;
            var tickStartLarger = tickEnd - deviceSettings.screenWidth/24;
            var tickStartLargest = tickEnd - deviceSettings.screenWidth/17;
            for( var tickAngle = 0; tickAngle < 360; tickAngle = tickAngle + (360/60)) {
                if (tickAngle == 0) {
                    dc.setColor(colorsScheme.majorWatchTickColor, Graphics.COLOR_TRANSPARENT);
                    drawRadialTriangle(dc, cx, cy, tickAngle, tickWidthest, tickStartLargest, tickEnd);
                } else if (tickAngle % 90 == 0) {
                    dc.setColor(colorsScheme.majorWatchTickColor, Graphics.COLOR_TRANSPARENT);
                    drawRadialTriangle(dc, cx, cy, tickAngle, tickWidther, tickStartLarger, tickEnd);
                } else if (tickAngle % 30 == 0) {
                    dc.setColor(colorsScheme.minorWatchTickColor, Graphics.COLOR_TRANSPARENT);
                    drawRadialRect(dc, Math.toRadians(tickAngle), tickWidth, tickStart, tickEnd, cx, cy);
                } else {
                    dc.setColor(colorsScheme.microWatchTickColor, Graphics.COLOR_TRANSPARENT);
                    drawRadialRect(dc, Math.toRadians(tickAngle), tickMicroWidth, tickStartSmall, tickEnd, cx, cy);
                }
            }
        }
    }
}

class WatchHands extends ChildViewBase {

    private var _notInDndMode = true;
    private var _notInSleepingMode = true;

    function initialize() {
        ChildViewBase.initialize(1);
    }

    function onSettingsChanged(app, sleeping, inDndMode) {
        _notInDndMode = !inDndMode;
        _notInSleepingMode = !sleeping;

        if (_notInSleepingMode) {
            _minTimeBetweenUpdates = 1;
        } else {
            _minTimeBetweenUpdates = 60;
        }
    }

    function isDirty(now) {
        return _notInDndMode && ChildViewBase.isDirty(now);
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

    function draw(dc, now, force) {
        ChildViewBase.draw(dc, now, force);
        if (_notInDndMode) {
            var colorsScheme = getColorsScheme();
            var clockTime = System.getClockTime();
            var timeZoneOffsetMinutes = clockTime.timeZoneOffset + clockTime.dst;
            var hours = ((clockTime.hour + (timeZoneOffsetMinutes/60)) % 12).toFloat();
            var minutes = (clockTime.min + (timeZoneOffsetMinutes % 60)).toFloat();
            var seconds = clockTime.sec;
            var cx = _state.centerX;
            var cy = _state.centerY;
            var tickEnd = _state.staticDeviceSettings.screenWidth/2;
            var tickChunck = _state.staticDeviceSettings.screenWidth/17;

            //tweaking the positions
            hours = hours + (minutes/60.0);
            minutes = minutes + (seconds/60.0);

            //hours
            drawHandWithShadow(dc, hours*30, 6, 0, tickEnd - tickChunck*4, cx, cy, colorsScheme.hoursHandColor, Graphics.COLOR_BLACK);

            //minutes
            drawHandWithShadow(dc, minutes*6, 4, 0, tickEnd - tickChunck*2, cx, cy, colorsScheme.minutesHandColor, Graphics.COLOR_BLACK);

            if (_notInSleepingMode) {
                drawHandWithShadow(dc, seconds*6, 1, -tickChunck, tickEnd - tickChunck, cx, cy, colorsScheme.secondsHandColor, Graphics.COLOR_BLACK);
            }

            //dot at the center of the hands (the axis)
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(cx, cy, 1);

            if (_notInSleepingMode) {
                _lastDrawTime = now;
            } else {
                //only every minute
                _lastDrawTime = (now/60).toNumber()*60;
            }
        }
    }
}
