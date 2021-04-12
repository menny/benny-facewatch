using Toybox.WatchUi;
using Toybox.Lang;

class ChildViewBase extends WatchUi.Drawable {

	function initialize() {
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

    function onUpdateCalledOnRootView(now) {
    	throw new Lang.OperationNotAllowedException("onUpdateCalledOnRootView not set");
	}
}
