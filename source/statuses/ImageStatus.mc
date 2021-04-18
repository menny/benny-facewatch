using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;

class ImageStatusBase extends StatusViewBase {

	private var _visible = true;
	
	function initialize() {
        StatusViewBase.initialize();
    }
    
    protected function getStatuesImages(dc) {
    	throw new Lang.OperationNotAllowedException("status images not set");
    }
    
    protected function onDrawNow(dc) {
    	var statusImages = getStatuesImages(dc);
    	if (statusImages != null && statusImages.size() > 0) {
	    	var x = 0;
			var y = 0;
			for (var imageIndex = 0; imageIndex < statusImages.size(); imageIndex++) {
				dc.drawBitmap(x, y, statusImages[imageIndex]);
				x = x - RadialPositions.RADIAL_ICON_SIZE - 3;
			}
    	}
    }
}

/* will show phone related statuses: connection, notification, maybe phone-battery*/
class PhoneStatusView extends ImageStatusBase {

	private var cachedDisconnectIcon = null;
	private var cachedNotificationIcon = null;
	private var _currentlyDisconnected = false;
	private var _currentlyHaveNotifications = false;

	function initialize() {
        ImageStatusBase.initialize();
    }

	protected function getVisiblePrefId() {
    	return "ShowPhoneStatus";
    }

	protected function checkIfUpdateRequired(now, force) {
		var deviceSettings = _state.getDeviceSettings(now, 5);
		var newDisconnected = !deviceSettings.phoneConnected;
		var newNotifications = deviceSettings.notificationCount > 0;
		if (force || _currentlyDisconnected != newDisconnected || _currentlyHaveNotifications != newNotifications) {
			_currentlyDisconnected = newDisconnected;
			_currentlyHaveNotifications = newNotifications;
			return true;
		}
		return false;
	}
    
    protected function getStatuesImages(dc) {
    	if (_currentlyDisconnected) {
			if (cachedDisconnectIcon == null) {
				cachedDisconnectIcon = [WatchUi.loadResource(Rez.Drawables.PhoneStatusDisconnectedIcon)];
				cachedNotificationIcon = null;
			}
			return cachedDisconnectIcon;
    	} else if (_currentlyHaveNotifications) {
			if (cachedNotificationIcon == null) {
				cachedNotificationIcon = [WatchUi.loadResource(Rez.Drawables.PhoneStatusNotificationIcon)];
				cachedDisconnectIcon = null;
			}
			return cachedNotificationIcon;
    	} else {
			cachedDisconnectIcon = null;
			cachedNotificationIcon = null;
    		return null;
		}
    }
	
	protected function getViewBox() {
		var radius = _state.screenWidth/2 - RadialPositions.RADIAL_ICON_SIZE;
    	var x = calcRadialX(_state.centerX, radius, RadialPositions.RADIAL_POSITION_PHONE_CONNECTION);
    	var y = calcRadialY(_state.centerY, radius, RadialPositions.RADIAL_POSITION_PHONE_CONNECTION);
		
		return new ViewBox(x, y,
			RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_ICON_SIZE);
    }
}


/* will show watch related statuses: battery, DnD*/
class WatchStatus extends ImageStatusBase {

	private var cachedLowBatteryIcon = null;
	private var cachedChargingBatteryIcon = null;
	private var _currentlyLowBattery = false;
	private var _currentlyCharging = false;
	
	function initialize() {
        ImageStatusBase.initialize();
    }
    
	protected function getVisiblePrefId() {
    	return "ShowWatchStatus";
    }

	protected function checkIfUpdateRequired(now, force) {
		var stats = _state.getSystemStats(now, 5);
		var newLowBattery = stats.battery < 15;
		var newCharging = stats.charging;
		if (force || _currentlyLowBattery != newLowBattery || _currentlyCharging != newCharging) {
			_currentlyLowBattery = newLowBattery;
			_currentlyCharging = newCharging;
			return true;
		}
		return false;
	}

	protected function getStatuesImages(dc) {
    	if (_currentlyLowBattery) {
			if (cachedLowBatteryIcon == null) {
				cachedLowBatteryIcon = [WatchUi.loadResource(Rez.Drawables.WatchStatusLowBattery)];
				cachedChargingBatteryIcon = null;
			}
			return cachedLowBatteryIcon;
    	} else if (_currentlyCharging) {
			if (cachedChargingBatteryIcon == null) {
				cachedChargingBatteryIcon = [WatchUi.loadResource(Rez.Drawables.WatchStatusChargingBattery)];
				cachedLowBatteryIcon = null;
			}
			return cachedChargingBatteryIcon;
    	} else {
			cachedLowBatteryIcon = null;
			cachedChargingBatteryIcon = null;
    		return null;
		}
    }
	
	protected function getViewBox() {
		var radius = _state.screenWidth/2 - RadialPositions.RADIAL_ICON_SIZE;
    	var x = calcRadialX(_state.centerX, radius, RadialPositions.RADIAL_POSITION_WATCH_BATTERY);
    	var y = calcRadialY(_state.centerY, radius, RadialPositions.RADIAL_POSITION_WATCH_BATTERY);
		
		return new ViewBox(x, y,
			RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_ICON_SIZE);
    }
}

/* shows if there is an alarm set. Hopefully, we'll get to tell when*/
class Alarm extends ImageStatusBase {
	private var cachedAlarmIcon = null;
	private var _currentAlarmActive = false;
	
	function initialize() {
        ImageStatusBase.initialize();
    }
    
	protected function getVisiblePrefId() {
    	return "ShowAlarmStatus";
    }
	
	protected function checkIfUpdateRequired(now, force) {
    	var deviceSettings = _state.getDeviceSettings(now, 10);
		var newAlarm = deviceSettings.alarmCount > 0;
		if (force || newAlarm != _currentAlarmActive) {
			_currentAlarmActive = newAlarm;
			return true;
		}
		return false;
	}
    
    protected function getStatuesImages(dc) {
    	if (_currentAlarmActive) {
			if (cachedAlarmIcon == null) {
				cachedAlarmIcon = [WatchUi.loadResource(Rez.Drawables.AlarmStatusIcon)];
			}
	    	return cachedAlarmIcon;
    	} else {
			cachedAlarmIcon = null;
    		return null;
		}
    }
	
	protected function getViewBox() {
		var radius = _state.screenWidth/2 - RadialPositions.RADIAL_ICON_SIZE;
    	var x = calcRadialX(_state.centerX, radius, RadialPositions.RADIAL_POSITION_ALARM);
    	var y = calcRadialY(_state.centerY, radius, RadialPositions.RADIAL_POSITION_ALARM);
		
		return new ViewBox(x, y,
			RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_ICON_SIZE);
    }
}

class Weather extends ImageStatusBase {

	function initialize() {
        ImageStatusBase.initialize();
    }
    
	protected function checkIfUpdateRequired(now, force) {
    	//never
		return false;
	}

	protected function getVisiblePrefId() {
    	return "ShowWeather";
    }
	
	protected function getStatuesImages(dc) {
		return null;
	}
	
	protected function getViewBox() {
		var radius = _state.screenWidth/2 - RadialPositions.RADIAL_ICON_SIZE;
    	var x = calcRadialX(_state.centerX, radius, RadialPositions.RADIAL_POSITION_WEATHER);
    	var y = calcRadialY(_state.centerY, radius, RadialPositions.RADIAL_POSITION_WEATHER);
		
		return new ViewBox(x, y,
			RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_ICON_SIZE);
    }
}
