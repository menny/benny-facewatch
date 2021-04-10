using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;

class ImageStatusBase extends WatchUi.Drawable {

	private var _visible = true;
	protected var _deviceSettings = System.getDeviceSettings();
	
	function initialize() {
        var dictionary = {
            :identifier => getStatusId()
        };

        Drawable.initialize(dictionary);
    }

    function setVisible(visible) {
		_visible = visible;
	}
	
    function draw(dc) {
    	if (_visible) {
    		_deviceSettings = System.getDeviceSettings();
    		onDrawStatue(dc);
    	} else {
	        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    		dc.clear();
    	}
    }
    
    protected function getStatusId() {
    	throw new Lang.OperationNotAllowedException("status id not set");
    }
    
    protected function getStatuesImage(dc) {
    	throw new Lang.OperationNotAllowedException("status image not set");
    }
    
    protected function getStatusImageCoords(dc) {
    	throw new Lang.OperationNotAllowedException("status image coords not set");
    }
    
    protected function onDrawStatue(dc) {
    	var statusImage = getStatuesImage(dc);
    	if (statusImage != null) {
	    	var coords = getStatusImageCoords(dc);
	    	dc.drawBitmap(coords[0], coords[1], statusImage);
    	}
    }
}

/* will show phone related statuses: connection, notification, maybe phone-battery*/
class PhoneStatus extends ImageStatusBase {

	function initialize() {
        ImageStatusBase.initialize();
    }
    
	protected function getStatusId() {
    	return "PhoneStatus";
    }
    
    protected function getStatuesImage(dc) {
    	if (!_deviceSettings.phoneConnected) {
	    	return WatchUi.loadResource(Rez.Drawables.PhoneStatusDisconnectedIcon);
    	} else if (_deviceSettings.notificationCount > 0) {
	    	return WatchUi.loadResource(Rez.Drawables.PhoneStatusNotificationIcon);
    	} else {
    		return null;
		}
    }
    
    function getStatusImageCoords(dc) {
    	var cx = _deviceSettings.screenWidth/2;
    	var cy = _deviceSettings.screenHeight/2;
    	var x = calcRadialX(cx, cx - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_PHONE_CONNECTION);
    	var y = calcRadialY(cy, cy - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_PHONE_CONNECTION);
    	
    	return [x, y];
    }
}


/* will show watch related statuses: battery, DnD*/
class WatchStatus extends ImageStatusBase {

	function initialize() {
        ImageStatusBase.initialize();
    }
    
	protected function getStatusId() {
    	return "WatchStatus";
    }
    
    protected function getStatuesImage(dc) {
    	var stats = System.getSystemStats();
    	if (stats.charging) {
	    	return WatchUi.loadResource(Rez.Drawables.WatchStatusChargingBattery);
    	} else if (stats.battery < 15) {
	    	return WatchUi.loadResource(Rez.Drawables.WatchStatusLowBattery);
    	} else {
    		return null;
		}
    }
    
    function getStatusImageCoords(dc) {
    	var cx = _deviceSettings.screenWidth/2;
    	var cy = _deviceSettings.screenHeight/2;
    	var x = calcRadialX(cx, cx - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_WATCH_BATTERY);
    	var y = calcRadialY(cy, cy - RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_POSITION_WATCH_BATTERY);
    	
    	return [x, y];
    }
}

/* shows if there is an alarm set. Hopefully, we'll get to tell when*/
class Alarm extends ImageStatusBase {

	function initialize() {
        ImageStatusBase.initialize();
    }
    
	protected function getStatusId() {
    	return "Alarm";
    }
    
    protected function getStatuesImage(dc) {
    	if (_deviceSettings.alarmCount > 0) {
	    	return WatchUi.loadResource(Rez.Drawables.AlarmStatusIcon);
    	} else {
    		return null;
		}
    }
    
    function getStatusImageCoords(dc) {
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
    
	protected function getStatusId() {
    	return "Weather";
    }
}
