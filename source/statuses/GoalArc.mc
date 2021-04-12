using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;

class GoalArcBase extends StatusViewBase {
	
	function initialize() {
        StatusViewBase.initialize();
    }

}

class StepsGoalArc extends GoalArcBase {

	function initialize() {
        GoalArcBase.initialize();
    }

	protected function checkIfUpdateRequired(now) {
		return false;
	}

	protected function getStatusViewId() {
    	return "StepsGoalArc";
    }

	protected function getVisiblePrefId() {
    	return "ShowStepsGoalArc";
    }
}


class FloorsGoalArc extends GoalArcBase {

	function initialize() {
        GoalArcBase.initialize();
    }

	protected function checkIfUpdateRequired(now) {
		return false;
	}

	protected function getStatusViewId() {
    	return "FloorsGoalArc";
    }

	protected function getVisiblePrefId() {
    	return "ShowFloorsGoalArc";
    }
}
