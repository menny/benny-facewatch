using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Graphics;

class ViewBox {
	var x;
	var y;
	var width;
	var height;
	function initialize(x, y, width, height) {
		self.x = x;
		self.y = y;
		self.width = width;
		self.height = height;
	}
}

class StatusViewBase extends ChildViewBase {

	private var _bitmap;
	protected var _viewBox;
	private var _visible = true;

	function initialize() {
        ChildViewBase.initialize();
        _viewBox = getViewBox();
        _bitmap = new Graphics.BufferedBitmap({
        	:width => _viewBox.width,
        	:height => _viewBox.height
        });
    }

    function onSettingsChanged(app) {
		var newVisible = app.getProperty(getVisiblePrefId());
		if (newVisible != _visible) {
			_visible = newVisible;
		}
	}
	
	protected function getViewBox() {
    	throw new Lang.OperationNotAllowedException("getViewBox not set");
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
	    	dc.drawBitmap(_viewBox.x, _viewBox.y, _bitmap);
	    }
    }
    
    protected function onDrawNow(dc) {
        throw new Lang.OperationNotAllowedException("onDrawNow id not set");
    }

	protected function checkIfUpdateRequired(now, force) {
    	throw new Lang.OperationNotAllowedException("checkIfUpdateRequired not set");
	}
}
