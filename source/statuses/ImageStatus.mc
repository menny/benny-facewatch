using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;

class ImageStatusBase extends StatusViewBase {

	private var _visible = true;
	protected var _deviceSettings = System.getDeviceSettings();
	
	function initialize() {
        StatusViewBase.initialize();
    }
    
    protected function getStatuesImages(dc) {
    	throw new Lang.OperationNotAllowedException("status images not set");
    }
    
    protected function getStatusImageStartCoords(dc) {
    	throw new Lang.OperationNotAllowedException("status image coords not set");
    }
    
    protected function onDrawNow(dc) {
    	var statusImages = getStatuesImages(dc);
    	if (statusImages != null && statusImages.size() > 0) {
	    	var coords = getStatusImageStartCoords(dc);
			var x = coords[0];
			var y = coords[1];
			for (var imageIndex = 0; imageIndex < statusImages.size(); imageIndex++) {
				dc.drawBitmap(x, y, statusImages[imageIndex]);
				x = x - RadialPositions.RADIAL_ICON_SIZE - 3;
			}
    	}
    }
}

/* will show phone related statuses: connection, notification, maybe phone-battery*/
class PhoneStatusView extends ImageStatusBase {

	private var lastUpdateSeconds = 0;
	private var cachedDisconnectIcon = null;
	private var cachedNotificationIcon = null;

	function initialize() {
        ImageStatusBase.initialize();
    }
    
	protected function getStatusViewId() {
    	return "PhoneStatusView";
    }

	protected function getVisiblePrefId() {
    	return "ShowPhoneStatus";
    }

	protected function checkIfUpdateRequired(now) {
    	if (now - lastUpdateSeconds > 5) {
			lastUpdateSeconds = now;
			return true;
		} else {
			return false;
		}
	}
    
    protected function getStatuesImages(dc) {
    	if (!_deviceSettings.phoneConnected) {
			if (cachedDisconnectIcon == null) {
				cachedDisconnectIcon = [WatchUi.loadResource(Rez.Drawables.PhoneStatusDisconnectedIcon)];
				cachedNotificationIcon = null;
			}
			return cachedDisconnectIcon;
    	} else if (_deviceSettings.notificationCount > 0) {
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
    
    protected function getStatusImageStartCoords(dc) {
    	var cx = _deviceSettings.screenWidth/2;
    	var cy = _deviceSettings.screenHeight/2;
    	var x = calcRadialX(cx, cx - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_PHONE_CONNECTION);
    	var y = calcRadialY(cy, cy - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_PHONE_CONNECTION);
    	
    	return [x, y];
    }
}


/* will show watch related statuses: battery, DnD*/
class WatchStatus extends ImageStatusBase {

	private var lastUpdateSeconds = 0;
	private var cachedLowBatteryIcon = null;
	private var cachedChargingBatteryIcon = null;
	
	function initialize() {
        ImageStatusBase.initialize();
    }
    
	protected function getVisiblePrefId() {
    	return "ShowWatchStatus";
    }
	
	protected function getStatusViewId() {
    	return "WatchStatus";
    }

	protected function checkIfUpdateRequired(now) {
    	if (now - lastUpdateSeconds > 5) {
			lastUpdateSeconds = now;
			return true;
		} else {
			return false;
		}
	}

	protected function getStatuesImages(dc) {
    	var stats = System.getSystemStats();
    	if (stats.battery < 15) {
			if (cachedLowBatteryIcon == null) {
				cachedLowBatteryIcon = [WatchUi.loadResource(Rez.Drawables.WatchStatusLowBattery)];
				cachedChargingBatteryIcon = null;
			}
			return cachedLowBatteryIcon;
    	} else if (stats.charging) {
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
    
    protected function getStatusImageStartCoords(dc) {
    	var cx = _deviceSettings.screenWidth/2;
    	var cy = _deviceSettings.screenHeight/2;
    	var x = calcRadialX(cx, cx - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_WATCH_BATTERY);
    	var y = calcRadialY(cy, cy - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_WATCH_BATTERY);
    	
    	return [x, y];
    }
}

/* shows if there is an alarm set. Hopefully, we'll get to tell when*/
class Alarm extends ImageStatusBase {
	private var lastUpdateSeconds = 0;
	private var cachedAlarmIcon = null;
	
	function initialize() {
        ImageStatusBase.initialize();
    }
    
	protected function getStatusViewId() {
    	return "Alarm";
    }

	protected function getVisiblePrefId() {
    	return "ShowAlarmStatus";
    }
	
	protected function checkIfUpdateRequired(now) {
    	if (now - lastUpdateSeconds > 10) {
			lastUpdateSeconds = now;
			return true;
		} else {
			return false;
		}
	}
    
    protected function getStatuesImages(dc) {
    	if (_deviceSettings.alarmCount > 0) {
			if (cachedAlarmIcon == null) {
				cachedAlarmIcon = [WatchUi.loadResource(Rez.Drawables.AlarmStatusIcon)];
			}
	    	return cachedAlarmIcon;
    	} else {
			cachedAlarmIcon = null;
    		return null;
		}
    }
    
    protected function getStatusImageStartCoords(dc) {
    	var cx = _deviceSettings.screenWidth/2;
    	var cy = _deviceSettings.screenHeight/2;
    	var x = calcRadialX(cx, cx - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_ALARM);
    	var y = calcRadialY(cy, cy - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_ALARM);
    	
    	return [x, y];
    }
}

class Weather extends ImageStatusBase {

	function initialize() {
        ImageStatusBase.initialize();
    }
    
	protected function checkIfUpdateRequired(now) {
    	//never
		return false;
	}

	protected function getVisiblePrefId() {
    	return "ShowWeather";
    }
	
	protected function getStatusViewId() {
    	return "Weather";
    }

	protected function getStatuesImages(dc) {
		return null;
	}

	protected function getStatusImageStartCoords(dc) {
    	var cx = _deviceSettings.screenWidth/2;
    	var cy = _deviceSettings.screenHeight/2;
    	var x = calcRadialX(cx, cx - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_WEATHER);
    	var y = calcRadialY(cy, cy - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_WEATHER);
    	
    	return [x, y];
    }
}
