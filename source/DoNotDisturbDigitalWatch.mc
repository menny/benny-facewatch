using Toybox.Time;
using Toybox.Time.Gregorian;

class DoNotDisturbDigitalWatch extends ChildViewBase {
    const MINUTE = 60;
    private var _inDndMode = false;

    function initialize() {
        ChildViewBase.initialize();
    }

    function onSettingsChanged(app, sleeping, inDndMode) {
        _inDndMode = inDndMode;
    }

    function draw(dc, now, force) {
        if (_inDndMode) {
            var colorsScheme = getColorsScheme();

            var calendar = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            var hours = calendar.hour;
            var hoursFormat = "%02d";
            var postFix = "";
            if (!_state.getDeviceSettings(now, MINUTE).is24Hour) {
                hoursFormat = "%d";
                postFix = " am";
                if (hours == 0) {
                    hours = 12;
                } else if (hours > 12) {
                    hours = hours - 12;
                    postFix = " pm";
                }
            }
            var timeString = Lang.format("$1$:$2$", [hours.format(hoursFormat), calendar.min.format("%02d")]);
            dc.setColor(colorsScheme.minutesHandColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(_state.centerX, _state.centerY, Graphics.FONT_NUMBER_HOT, timeString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            if (postFix.length() > 0) {
                dc.setColor(colorsScheme.secondsHandColor, Graphics.COLOR_TRANSPARENT);
                var timeOffset = dc.getTextWidthInPixels(timeString, Graphics.FONT_NUMBER_HOT);
                dc.drawText(_state.centerX+timeOffset/2, _state.centerY, Graphics.FONT_MEDIUM, postFix, Graphics.TEXT_JUSTIFY_LEFT);
            }
        }
    }
}

class DoNotDisturbDateView extends DateView {

    function initialize() {
        DateView.initialize();
    }

    protected function getViewBox() {
        var fontHeight = Graphics.getFontHeight(Graphics.FONT_TINY);
        var width = 3*fontHeight;
        return new ViewBox(_state.centerX - width/2, _state.centerY + 2*fontHeight,
            width, fontHeight);
    }

    protected function getVisibleForDndState(inDndState) {
        return inDndState;
    }

    protected function onDrawNow(dc) {
        dc.setPenWidth(1);
        var colorsScheme = getColorsScheme();
        dc.setColor(colorsScheme.dateTextColor, Graphics.COLOR_TRANSPARENT);

        var calendar = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        var dateText = Lang.format("$1$  $2$", [calendar.day_of_week, calendar.day]);
        dc.drawText(dc.getWidth()/2, 0, Graphics.FONT_TINY, dateText, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
