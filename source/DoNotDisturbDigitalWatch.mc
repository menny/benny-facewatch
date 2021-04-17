
class DoNotDisturbDigitalWatch extends ChildViewBase {
    const MINUTE = 60;
	var lastUpdateInMinutes = 0;

	function initialize() {
        ChildViewBase.initialize();
    }
    
    function onSettingsChanged(app) {
		//don't do anything
	}

    function isUpdateRequired(now) {
    	//don't do anything right now
		return false;
	}
	
	function draw(dc, now, force) {
		//nothing for now
	}
}
