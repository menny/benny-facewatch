
class DoNotDisturbDigitalWatch extends ChildViewBase {
    const MINUTE = 60;
	var lastUpdateInMinutes = 0;

	function initialize() {
        ChildViewBase.initialize();
    }
    
    function onSettingsChanged(app) {
		//don't do anything
	}

    function onUpdateCalledOnRootView(now) {
    	//don't do anything right now
	}

	protected function getStatusViewId() {
    	return "DoNotDisturbDigitalWatch";
    }
}
