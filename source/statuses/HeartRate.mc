using Toybox.Graphics;
using Toybox.WatchUi;

class HeartRate extends StatusViewBase {
	
	function initialize() {
        StatusViewBase.initialize();
    }

	function getStatusViewId() {
		return "HeartRate";
	}

	function getVisiblePrefId() {
		return "ShowHeartRate";
	}

	protected function checkIfUpdateRequired(now) {
		//never
		return false;
	}

	protected function onDrawNow(dc) {
	}
}

class HeartRateHistory extends StatusViewBase {

	function initialize() {
        StatusViewBase.initialize();
    }

	function getStatusViewId() {
		return "HeartRateHistory";
	}

	function getVisiblePrefId() {
		return "ShowHeartRateHistory";
	}

	protected function checkIfUpdateRequired(now) {
		//never
		return false;
	}

	protected function onDrawNow(dc) {
	}
}
