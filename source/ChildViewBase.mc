using Toybox.WatchUi;
using Toybox.Lang;

class ChildViewBase extends WatchUi.Drawable {

    protected var _state;

	function initialize() {
        _state = Application.getApp().getBennyState();
        var dictionary = {
            :identifier => getStatusViewId()
        };

        Drawable.initialize(dictionary);
    }

    function onSettingsChanged(app) {
		throw new Lang.OperationNotAllowedException("onSettingsChanged not set");
	}
    
    protected function getStatusViewId() {
    	throw new Lang.OperationNotAllowedException("status view id not set");
    }

    function isUpdateRequired(now) {
    	throw new Lang.OperationNotAllowedException("isUpdateRequired not set");
	}
}
