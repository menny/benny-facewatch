using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Activity;
using Toybox.ActivityMonitor;

class HeartRate extends StatusViewBase {
	
	private var _lastCheck = 0;
	private var _heartIcon;
	private var _radius;
	private var _currentHeartBeat = ActivityMonitor.INVALID_HR_SAMPLE;

	function initialize() {
        StatusViewBase.initialize();
		_heartIcon = WatchUi.loadResource(Rez.Drawables.HeartRateIcon);
		_radius = _state.staticDeviceSettings.screenHeight/5;
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
			_currentHeartBeat = _state.getHeartBeat(now, 3);
			return true;
		} else {
			return false;
		}
	}

	protected function onDrawNow(dc) {
    	var colorsScheme = getColorsScheme();
		
		var hrText = "--";
		if (_currentHeartBeat != ActivityMonitor.INVALID_HR_SAMPLE) {
			hrText = _currentHeartBeat.format("%d");
		}

		var cx = _state.centerX;
		var cy = _state.centerY;
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

class HeartRateHistory extends StatusViewBase {

	private var _lastCheck = 0;
	private var _radius;
	private var graphHeight;
	private var graphWidth;
	private var hrDataIndex = 0;
	private var lastHourData = new [120];
	private var _currentHeartBeat = ActivityMonitor.INVALID_HR_SAMPLE;
	private const MAX_HR_VALUE = ActivityMonitor.INVALID_HR_SAMPLE;//it's 255
		
	function initialize() {
        StatusViewBase.initialize();
		_radius = _state.staticDeviceSettings.screenHeight/5;
		graphHeight = _radius.toFloat();
		graphWidth = _state.staticDeviceSettings.screenWidth.toFloat()/4.0;
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
			var sample = _state.getHeartBeat(now, 3);
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
		var cx = _state.centerX;
		var cy = _state.centerY;
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
