using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Activity;
using Toybox.ActivityMonitor;

class HeartRate extends StatusViewBase {
	
	private var _lastCheck = 0;
	private var _heartIcon;
	private const _deviceSettings = System.getDeviceSettings();
	private var _radius;

	function initialize() {
        StatusViewBase.initialize();
		_heartIcon = WatchUi.loadResource(Rez.Drawables.HeartRateIcon);
		_radius = _deviceSettings.screenHeight/5;
    }

	function getStatusViewId() {
		return "HeartRate";
	}

	function getVisiblePrefId() {
		return "ShowHeartRate";
	}

	protected function checkIfUpdateRequired(now) {
		if (now - _lastCheck >= 3) {
			_lastCheck = now;
			return true;
		} else {
			return false;
		}
	}

	protected function onDrawNow(dc) {
    	var colorsScheme = getColorsScheme();
		
		var hrText = "--";
		var sample = getCurrentHeartRateAsDouble();
		if (sample != ActivityMonitor.INVALID_HR_SAMPLE) {
			hrText = sample.format("%d");
		}

		var cx = _deviceSettings.screenWidth/2;
		var cy = _deviceSettings.screenHeight/2;
		var iconX = calcRadialX(cx, _radius, RadialPositions.RADIAL_HEART_RATE_ICON);
		var iconY = calcRadialY(cy, _radius, RadialPositions.RADIAL_HEART_RATE_ICON);
		dc.drawBitmap(iconX, iconY, _heartIcon);
		//text is just below
		var textX = iconX + dc.getTextWidthInPixels(hrText, Graphics.FONT_XTINY)/2;
		var textY = iconY + RadialPositions.RADIAL_ICON_SIZE;
        dc.setColor(colorsScheme.goalTextColor, Graphics.COLOR_TRANSPARENT);
		dc.drawText(textX, textY, Graphics.FONT_XTINY, hrText, Graphics.TEXT_JUSTIFY_CENTER);
	}
}

private function getCurrentHeartRateAsDouble() {
	//greedily, trying to grab the HR from current activity (this is the most precise)
	var activityInfo = Activity.getActivityInfo();
	var sample = activityInfo.currentHeartRate;
	if (sample != null) {
		return sample;
	} else {
		var sample = ActivityMonitor.getHeartRateHistory(1, /* newestFirst */ true).next();
		if (sample != null && sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
			return sample.heartRate;
		}
	}

	return ActivityMonitor.INVALID_HR_SAMPLE;
}

class HeartRateHistory extends StatusViewBase {

	private var _lastCheck = 0;
	private const _deviceSettings = System.getDeviceSettings();
	private var _radius;
	private var graphHeight;
	private var graphWidth;
	private var hrDataIndex = 0;
	private var lastHourData = new [120];
	private const MAX_HR_VALUE = ActivityMonitor.INVALID_HR_SAMPLE;//it's 255
		
	function initialize() {
        StatusViewBase.initialize();
		_radius = _deviceSettings.screenHeight/5;
		graphHeight = _radius.toFloat();
		graphWidth = _deviceSettings.screenWidth.toFloat()/4.0;
		var history = ActivityMonitor.getHeartRateHistory(
			1000,
			false);
		var sample = history.next();
		var lastSampleTime = 0;
		var sampleIndex = 0;
		while (sample != null && sampleIndex < lastHourData.size()) {
			if (sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE && (lastSampleTime == 0 || (lastSampleTime - sample.when.value()).abs() >= 30)) {
				lastSampleTime = sample.when.value();
				lastHourData[sampleIndex] = sample.heartRate;
				sampleIndex++;
			}

			sample = history.next();
		}
		//filling the rest with 60bpm
		for (;sampleIndex < lastHourData.size(); sampleIndex++) {
			lastHourData[sampleIndex] = 60;
		}
    }

	function getStatusViewId() {
		return "HeartRateHistory";
	}

	function getVisiblePrefId() {
		return "ShowHeartRateHistory";
	}

	protected function checkIfUpdateRequired(now) {
		if (now - _lastCheck >= 30) {
			var sample = getCurrentHeartRateAsDouble();
			if (sample != ActivityMonitor.INVALID_HR_SAMPLE) {
				hrDataIndex++;
				if (hrDataIndex >= lastHourData.size()) {
					hrDataIndex = 0;
				}
				lastHourData[hrDataIndex] = sample;
				_lastCheck = now;
				return true;
			}
		}
		return false;
	}

	protected function onDrawNow(dc) {
		var cx = _deviceSettings.screenWidth/2;
		var cy = _deviceSettings.screenHeight/2;
		var startX = calcRadialX(cx, _radius, RadialPositions.RADIAL_HEART_RATE_ICON) + RadialPositions.RADIAL_ICON_SIZE + 4;
		var startY = calcRadialY(cy, _radius, RadialPositions.RADIAL_HEART_RATE_ICON);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(1);
		var xStep = graphWidth/lastHourData.size();
		var yFactor = graphHeight/MAX_HR_VALUE;
		var graphBottomY = startY - _radius/2 + graphHeight;
		var previousX = startX;
		var previousY = graphBottomY - lastHourData[hrDataIndex]*yFactor;
		var maxValue = -1;
		var maxValueY = -1;
		var maxValueX = -1;
		for (var hrIndex=lastHourData.size(); hrIndex>=0; hrIndex--) {
			var nextX = previousX + xStep;
			var sample = lastHourData[(hrIndex+hrDataIndex) % lastHourData.size()];
			var nextY = graphBottomY - sample * yFactor;
			if (sample > maxValue) {
				maxValue = sample;
				maxValueY = nextY;
				maxValueX = nextX;
			}
			dc.drawLine(previousX, previousY, nextX, nextY);
			previousX = nextX;
			previousY = nextY;
		}
		//drawing max-value
		if (maxValue != -1) {
	    	var colorsScheme = getColorsScheme();
			dc.setColor(colorsScheme.goalTextColor, Graphics.COLOR_TRANSPARENT);
			dc.drawLine(maxValueX, maxValueY, startX+graphWidth + 4, maxValueY);
			dc.drawText(startX+graphWidth + 6, maxValueY, Graphics.FONT_XTINY, maxValue.format("%d"), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
		}		
	}
}
