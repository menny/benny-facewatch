using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;

class GoalArcBase extends WatchUi.Drawable {

	var _visible = true;
	var _lastUpdateSeconds = 0;
	
	function initialize() {
        var dictionary = {
            :identifier => getGoalId()
        };

        Drawable.initialize(dictionary);
    }

	function onSettingsChanged(app) {
		var newVisible = app.getProperty(getVisiblePrefId());
		if (newVisible != _visible) {
			_visible = newVisible;
			requestUpdate();
		}
	}

	protected function getVisiblePrefId() {
    	throw new Lang.OperationNotAllowedException("visible pref id not set");
    }

	function onUpdateCalledOnRootView(now) {
		throw new Lang.OperationNotAllowedException("onUpdateCalledOnRootView not set");
	}
	
    function draw(dc) {
    	if (_visible) {
    	} else {
	        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    		dc.clear();
    	}
    }
    
    protected function getGoalId() {
    	throw new Lang.OperationNotAllowedException("goal id not set");
    }
}

class StepsGoalArc extends GoalArcBase {

	function initialize() {
        GoalArcBase.initialize();
    }

	function onUpdateCalledOnRootView(now) {
		//never
	}
    
	protected function getGoalId() {
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

	function onUpdateCalledOnRootView(now) {
		//never
	}
    
	protected function getGoalId() {
    	return "FloorsGoalArc";
    }

	protected function getVisiblePrefId() {
    	return "ShowFloorsGoalArc";
    }
}
