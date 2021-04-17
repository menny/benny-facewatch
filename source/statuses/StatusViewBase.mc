using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Graphics;

class StatusViewBase extends ChildViewBase {

	private var _bitmap;
	private var _visible = true;

	function initialize() {
        ChildViewBase.initialize();
        _bitmap = new Graphics.BufferedBitmap({
        	:width => getStatusWidth(),
        	:height => getStatusHeight()
        });
    }

    function onSettingsChanged(app) {
		var newVisible = app.getProperty(getVisiblePrefId());
		if (newVisible != _visible) {
			_visible = newVisible;
		}
	}
	
	protected function getStatusWidth() {
    	throw new Lang.OperationNotAllowedException("getStatusWidth not set");
	}
	
	protected function getStatusHeight() {
    	throw new Lang.OperationNotAllowedException("getStatusHeight not set");
	}
	
	protected function getStatusX() {
    	throw new Lang.OperationNotAllowedException("getStatusX not set");
	}
	
	protected function getStatusY() {
    	throw new Lang.OperationNotAllowedException("getStatusY not set");
	}

	protected function getVisiblePrefId() {
    	throw new Lang.OperationNotAllowedException("visible pref id not set");
    }

	function draw(dc, now, force) {
    	if (_visible) {
	    	var actualDc = _bitmap.getDc();
			if (checkIfUpdateRequired(now, force)) {
				actualDc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
				actualDc.clear();
				onDrawNow(actualDc);
			}
	    	dc.drawBitmap(getStatusX(), getStatusY(), _bitmap);
	    }
    }
    
    protected function onDrawNow(dc) {
        throw new Lang.OperationNotAllowedException("onDrawNow id not set");
    }

	protected function checkIfUpdateRequired(now, force) {
    	throw new Lang.OperationNotAllowedException("checkIfUpdateRequired not set");
	}
}
