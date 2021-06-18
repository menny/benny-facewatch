class DistanceView extends StatusViewBase {

    function initialize() {
        StatusViewBase.initialize(5);
    }

    protected function checkIfUpdateRequired(now, force, peekOnly) {
        //never
        return false;
    }

    protected function getViewBox() {
        return new ViewBox(_state.centerX, _state.centerY,
            0, 0);
    }

    protected function getVisiblePrefId() {
        return "ShowDistance";
    }

    protected function getVisibleForDndState(inDndState) {
        return false;
    }
}
