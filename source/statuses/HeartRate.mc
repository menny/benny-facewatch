using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.Application;

class HeartRate extends StatusViewBase {
	
	private var _lastCheck = 0;
	private var _heartIcon;
	private var _radius;
	private var _currentHeartBeat = ActivityMonitor.INVALID_HR_SAMPLE;

	function initialize() {
		_heartIcon = WatchUi.loadResource(Rez.Drawables.HeartRateIcon);
        StatusViewBase.initialize();
		_radius = _state.staticDeviceSettings.screenHeight/5;
    }
	function getVisiblePrefId() {
		return "ShowHeartRate";
	}

	protected function checkIfUpdateRequired(now, force) {
		if (force || ((now - _lastCheck) >= 3)) {
			_lastCheck = now;
			_currentHeartBeat = _state.getHeartBeat(now, 3);
			return true;
		} else {
			return false;
		}
	}
	
	protected function getStatusWidth() {
		return 2 * _heartIcon.getWidth();
	}
	
	protected function getStatusHeight() {
		var fontHeight = Graphics.getFontHeight(Graphics.FONT_XTINY);
		return _heartIcon.getHeight() + 2 * fontHeight;
	}
	
	protected function getStatusX() {
		var cx = _state.centerX;
    	return calcRadialX(cx, _radius, RadialPositions.RADIAL_HEART_RATE_ICON);
	}
	
	protected function getStatusY() {
    	var cy = _state.centerY;
    	return calcRadialY(cy, _radius, RadialPositions.RADIAL_HEART_RATE_ICON);
	}

	protected function onDrawNow(dc) {
    	var colorsScheme = getColorsScheme();
		
		var hrText = "--";
		if (_currentHeartBeat != ActivityMonitor.INVALID_HR_SAMPLE) {
			hrText = _currentHeartBeat.format("%d");
		}

		dc.drawBitmap(0, 0, _heartIcon);
		//text is just below
		var textX = dc.getWidth()/2 - dc.getTextWidthInPixels(hrText, Graphics.FONT_XTINY)/2;
		var textY = RadialPositions.RADIAL_ICON_SIZE + 2;
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
		var state = Application.getApp().getBennyState();
		_radius = state.staticDeviceSettings.screenHeight/5;
		graphHeight = _radius.toFloat();
		graphWidth = state.staticDeviceSettings.screenWidth.toFloat()/4.0;
        StatusViewBase.initialize();
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

	function getVisiblePrefId() {
		return "ShowHeartRateHistory";
	}

	protected function checkIfUpdateRequired(now, force) {
		if (force || ((now - _lastCheck) >= 30)) {
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
	
	protected function getStatusWidth() {
		return _state.staticDeviceSettings.screenWidth/2;
	}
	
	protected function getStatusHeight() {
		var fontHeight = Graphics.getFontHeight(Graphics.FONT_XTINY);
		return graphHeight + fontHeight;
	}
	
	protected function getStatusX() {
		var cx = _state.centerX;
		return calcRadialX(cx, _radius, RadialPositions.RADIAL_HEART_RATE_ICON) + RadialPositions.RADIAL_ICON_SIZE + 4;
		
	}
	
	protected function getStatusY() {
		var cy = _state.centerY;
		return calcRadialY(cy, _radius, RadialPositions.RADIAL_HEART_RATE_ICON);
		
	}

	protected function onDrawNow(dc) {
		var fontHeight = Graphics.getFontHeight(Graphics.FONT_XTINY);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(1);
		var xStep = graphWidth/lastHourData.size();
		var yFactor = graphHeight/MAX_HR_VALUE;
		var graphBottomY = fontHeight + graphHeight - _radius/2;
		var previousX = 0;
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
			var endX = maxValueX + 4;
			var endY = fontHeight*0.75;
	    	var colorsScheme = getColorsScheme();
			dc.setColor(colorsScheme.goalTextColor, Graphics.COLOR_TRANSPARENT);
			dc.fillCircle(maxValueX, maxValueY, 2);
			dc.drawLine(maxValueX, maxValueY, endX, endY);
			dc.drawText(endX, endY, Graphics.FONT_XTINY, maxValue.format("%d"), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
		}		
	}
}
