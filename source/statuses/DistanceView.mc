
class DistanceView extends StatusViewBase {

	function initialize() {
        StatusViewBase.initialize();
    }
    
    protected function checkIfUpdateRequired(now) {
        //never
        return false;
    }

    protected function getVisiblePrefId() {
    	return "ShowDistance";
    }
    
    protected function getStatusWidth() {
		return 0;
	}
	
	protected function getStatusHeight() {
		return 0;
	}
	
	protected function getStatusX() {
    	return _state.centerX;
	}
	
	protected function getStatusY() {
    	return _state.centerY;
	}
}
