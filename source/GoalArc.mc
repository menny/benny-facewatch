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

	function setVisible(visible) {
		_visible = visible;
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
    
    function getGoalId() {
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
    
	function getGoalId() {
    	return "StepsGoalArc";
    }
}


class FloorsGoalArc extends GoalArcBase {

	function initialize() {
        GoalArcBase.initialize();
    }

	function onUpdateCalledOnRootView(now) {
		//never
	}
    
	function getGoalId() {
    	return "FloorsGoalArc";
    }
}
