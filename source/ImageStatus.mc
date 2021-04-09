using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;

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

class PhoneStatus extends ImageStatusBase {

	function initialize() {
        ImageStatusBase.initialize();
    }
    
	protected function getStatusId() {
    	return "PhoneStatus";
    }
}

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
