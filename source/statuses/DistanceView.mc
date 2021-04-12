
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

	protected function getStatusViewId() {
    	return "DistanceView";
    }
}
