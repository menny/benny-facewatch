using Toybox.WatchUi;
using Toybox.Lang;

class ChildViewBase {

    protected var _state;
    protected var _sleeping = false;

	function initialize() {
        _state = Application.getApp().getBennyState();
    }

    function onSettingsChanged(app) {
		throw new Lang.OperationNotAllowedException("onSettingsChanged not set");
	}

    function isUpdateRequired(now) {
    	throw new Lang.OperationNotAllowedException("isUpdateRequired not set");
	}
	
	function setSleepState(isSleeping) {
		_sleeping = isSleeping;
	}
	
	function draw(dc) {
    	throw new Lang.OperationNotAllowedException("draw not set for " + toString());
	}
}
