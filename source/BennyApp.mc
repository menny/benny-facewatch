using Toybox.Application;
using Toybox.WatchUi;

class BennyApp extends Application.AppBase {
	private var _rootView;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	_rootView = new BennyView();
        return [ _rootView ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        if (_rootView != null) {
        	_rootView.onSettingsChanged();
    	}
    }

}