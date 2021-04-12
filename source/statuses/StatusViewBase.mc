using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class StatusViewBase extends ChildViewBase {

	private var _visible = true;
	
	function initialize() {
        ChildViewBase.initialize();
    }

    function onSettingsChanged(app) {
		var newVisible = app.getProperty(getVisiblePrefId());
		if (newVisible != _visible) {
			_visible = newVisible;
			requestUpdate();
		}
	}

	protected function getVisiblePrefId() {
    	throw new Lang.OperationNotAllowedException("visible pref id not set");
    }
	
    function draw(dc) {
    	if (_visible) {
            onDrawNow(dc);
    	} else {
	        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    		dc.clear();
    	}
    }
    
    protected function onDrawNow(dc) {
        throw new Lang.OperationNotAllowedException("onDrawNow id not set");
    }

    function onUpdateCalledOnRootView(now) {
		if (_visible && checkIfUpdateRequired(now)) {
			requestUpdate();
		}
	}

	protected function checkIfUpdateRequired(now) {
    	throw new Lang.OperationNotAllowedException("checkIfUpdateRequired not set");
	}
}
