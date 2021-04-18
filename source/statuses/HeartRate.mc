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
        var state = Application.getApp().getBennyState();
		_heartIcon = WatchUi.loadResource(Rez.Drawables.HeartRateIcon);
		_radius = state.screenHeight/3.5;
        StatusViewBase.initialize();
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
    
    protected function getViewBox() {
		var fontHeight = Graphics.getFontHeight(Graphics.FONT_XTINY);
		var x = calcRadialX(_state.centerX, _radius, RadialPositions.RADIAL_HEART_RATE_ICON);
		var y = calcRadialY(_state.centerY, _radius, RadialPositions.RADIAL_HEART_RATE_ICON);
		return new ViewBox(x, y,
    		2 * _heartIcon.getWidth(), _heartIcon.getHeight() + fontHeight);
    }

	protected function onDrawNow(dc) {
    	var colorsScheme = getColorsScheme();
		
		var hrText = "--";
		if (_currentHeartBeat != ActivityMonitor.INVALID_HR_SAMPLE) {
			hrText = _currentHeartBeat.format("%d");
		}

		dc.drawBitmap(_heartIcon.getWidth()/2, 0, _heartIcon);
		//text is just below
		var textX = dc.getWidth()/2 - dc.getTextWidthInPixels(hrText, Graphics.FONT_XTINY)/2;
		var textY = _heartIcon.getHeight();
        dc.setColor(colorsScheme.goalTextColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
		dc.drawText(textX, textY, Graphics.FONT_XTINY, hrText, Graphics.TEXT_JUSTIFY_LEFT);
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
    
    protected function getViewBox() {
		var fontHeight = Graphics.getFontHeight(Graphics.FONT_XTINY);
		
		//only using 75% of the height, since we are not using the bottom graph (bpm will not be too low)
		var height = graphHeight * 0.75 + fontHeight;
		return new ViewBox(
			calcRadialX(_state.centerX, _radius, RadialPositions.RADIAL_HEART_RATE_ICON) + 2 * RadialPositions.RADIAL_ICON_SIZE + 4,
			calcRadialY(_state.centerY, _radius, RadialPositions.RADIAL_HEART_RATE_ICON),
    		graphWidth + 2*fontHeight, height);
    }

	protected function onDrawNow(dc) {
		var fontHeight = Graphics.getFontHeight(Graphics.FONT_XTINY);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(1);
		var xStep = graphWidth/lastHourData.size();
		var yFactor = graphHeight/MAX_HR_VALUE;
		var graphBottomY = fontHeight + graphHeight - _radius/2;
		var maxValue = -1;
		var maxValueY = -1;
		var maxValueX = -1;
		for (var hrIndex=lastHourData.size(); hrIndex>=0; hrIndex--) {
			var x = (lastHourData.size()-hrIndex) * xStep;
			var sample = lastHourData[(hrIndex+hrDataIndex) % lastHourData.size()];
			var y = graphBottomY - sample * yFactor;
			if (sample > maxValue) {
				maxValue = sample;
				maxValueY = y;
				maxValueX = x;
			}
			dc.drawPoint(x, y);
		}
		//drawing max-value
		if (maxValue != -1) {
			// var endX = maxValueX + fontHeight*0.3;
			var endY = maxValueY - fontHeight*0.5;
			var justify;
			var endX;
			if (maxValueX > (graphWidth - fontHeight)) {
				//end of graph
				justify = Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER;
	    		endX = maxValueX - fontHeight*0.3;
			} else if (maxValueX > fontHeight) {
				//center of graph
				justify = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
	    		endX = maxValueX + fontHeight*0.3;
			} else {
				//beginning of graph
	    		endX = maxValueX + fontHeight*0.5;
				justify = Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER;
			}
			var colorsScheme = getColorsScheme();
			dc.setColor(colorsScheme.goalTextColor, Graphics.COLOR_TRANSPARENT);
			dc.fillCircle(maxValueX, maxValueY, 2);
			dc.drawLine(maxValueX, maxValueY, endX, endY);
			dc.setPenWidth(1);
			dc.drawText(endX, endY, Graphics.FONT_XTINY, maxValue.format("%d"), justify);
		}		
	}
}
