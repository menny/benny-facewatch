using Toybox.Graphics;
using Toybox.WatchUi;

class HeartRate extends StatusViewBase {
	
	private var _lastCheck = 0;
	private var _heartIcon;
	private var _deviceSettings = System.getDeviceSettings();
	private var _radius;

	function initialize() {
        StatusViewBase.initialize();
		_heartIcon = WatchUi.loadResource(Rez.Drawables.HeartRateIcon);
		_radius = _deviceSettings.screenHeight/6;
    }

	function getStatusViewId() {
		return "HeartRate";
	}

	function getVisiblePrefId() {
		return "ShowHeartRate";
	}

	protected function checkIfUpdateRequired(now) {
		if (now - _lastCheck >= 2) {
			_lastCheck = now;
			return true;
		} else {
			return false;
		}
	}

	protected function onDrawNow(dc) {
    	var colorsScheme = getColorsScheme();
		var hrDataIterator = ActivityMonitor.getHeartRateHistory(1, true);

		var cx = _deviceSettings.screenWidth/2;
		var cy = _deviceSettings.screenHeight/2;
		var iconX = calcRadialX(cx, _radius, RadialPositions.RADIAL_HEART_RATE_ICON);
		var iconY = calcRadialY(cy, _radius, RadialPositions.RADIAL_HEART_RATE_ICON);
		dc.drawBitmap(iconX, iconY, _heartIcon);
		//text is just below
		var hrText = Math.mean([hrDataIterator.getMin(), hrDataIterator.getMax()]).format("%d");
		var textX = iconX + dc.getTextWidthInPixels(hrText, Graphics.FONT_XTINY)/2;
		var textY = iconY + RadialPositions.RADIAL_ICON_SIZE;
        dc.setColor(colorsScheme.goalTextColor, Graphics.COLOR_TRANSPARENT);
		dc.drawText(textX, textY, Graphics.FONT_XTINY, hrText, Graphics.TEXT_JUSTIFY_CENTER);
	}
}

class HeartRateHistory extends StatusViewBase {

	function initialize() {
        StatusViewBase.initialize();
    }

	function getStatusViewId() {
		return "HeartRateHistory";
	}

	function getVisiblePrefId() {
		return "ShowHeartRateHistory";
	}

	protected function checkIfUpdateRequired(now) {
		//never
		return false;
	}

	protected function onDrawNow(dc) {
	}
}
