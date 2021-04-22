using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class DateView extends StatusViewBase {
    const DAY = 24 * 60 * 60;
    const border = 1;
    const paddingY = 1;
    const paddingX = 3;

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

    protected function getViewBox() {
        var fontHeight = Graphics.getFontHeight(Graphics.FONT_XTINY);
        var height = fontHeight + 2*border + paddingY*2;
        var screenWidthFactor = 3;
        var width = _state.screenWidth/screenWidthFactor;
        return new ViewBox(_state.centerX + width/screenWidthFactor, _state.centerY - height/2.0,
            width, height);
    }

    protected function onDrawNow(dc) {
        dc.setPenWidth(1);
        var colorsScheme = getColorsScheme();
        var calendar = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateText = Lang.format("$1$  $2$", [calendar.day_of_week, calendar.day]);
        var textDimens = dc.getTextDimensions(dateText, Graphics.FONT_XTINY);

        //var x = dc.getWidth() - textDimens[0] - _state.staticDeviceSettings.screenWidth/10 - paddingX;
        var maxWidth = textDimens[0] + border*2 + paddingX*2;
        //border
        dc.setColor(colorsScheme.dateBorderColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(0, 0, maxWidth, dc.getHeight(), 4);
        maxWidth -= border*2;
        //background
        dc.setColor(colorsScheme.dateBackgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(border, border, maxWidth, dc.getHeight() - 2*border, 3);
        //text
        dc.setColor(colorsScheme.dateTextColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(paddingX + border, border + paddingY, Graphics.FONT_XTINY, dateText, Graphics.TEXT_JUSTIFY_LEFT);
    }

    protected function getVisiblePrefId() {
        return "ShowDate";
    }
}
