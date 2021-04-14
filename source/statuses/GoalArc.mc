using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.ActivityMonitor;
using Toybox.System;

class GoalArcBase extends StatusViewBase {
	//note about arc:
	//0 degrees: 3 o'clock position.
	//90 degrees: 12 o'clock position.
	//180 degrees: 9 o'clock position.
	//270 degrees: 6 o'clock position.
	private const ARC_START = RadialPositions.RADIAL_GOAL_START_ARC;
	private const ARC_LENGTH = RadialPositions.RADIAL_GOAL_START_LENGTH;
	private var goalAcheivedIcon;
	private var goalIcon;
	private var arcRadius;
	protected var _deviceSettings = System.getDeviceSettings();

	function initialize() {
        StatusViewBase.initialize();
		goalAcheivedIcon = WatchUi.loadResource(Rez.Drawables.GoalAchievedIcon);
		goalIcon = getGoalIcon();
		arcRadius = getGoalIndex() * _deviceSettings.screenWidth/8;
    }

	protected function onDrawNow(dc) {
    	var colorsScheme = getColorsScheme();
		dc.setPenWidth(6);
		
		//data
		var goalCurrent = getGoalCurrentValue();
		var goalRatio = goalCurrent.toFloat() / getGoalTarget().toFloat();
		var timesCompleted = goalRatio.toNumber();
		var fillRatio = goalRatio - timesCompleted;
			
		var cx = _deviceSettings.screenWidth/2;
		var cy = _deviceSettings.screenHeight/2;
		//empty
		if (timesCompleted % 2 == 0) {
			dc.setColor(colorsScheme.goalBackgroundColor, Graphics.COLOR_TRANSPARENT);
		} else {
			dc.setColor(colorsScheme.goalFillColor, Graphics.COLOR_TRANSPARENT);
		}
		dc.drawArc(cx, cy, arcRadius, dc.ARC_CLOCKWISE, ARC_START, ARC_START - ARC_LENGTH);
		//full
		if (goalCurrent > 0) {
			if (timesCompleted % 2 == 0) {
				dc.setColor(colorsScheme.goalFillColor, Graphics.COLOR_TRANSPARENT);
			} else {
				dc.setColor(colorsScheme.goalExtraFillColor, Graphics.COLOR_TRANSPARENT);
			}
			if (timesCompleted > 0) {
				dc.setPenWidth(3);
			}
			dc.drawArc(cx, cy, arcRadius, dc.ARC_CLOCKWISE, ARC_START, ARC_START - fillRatio * ARC_LENGTH);
			//check mark
			if (timesCompleted >= 1) {
				var iconX = calcRadialX(cx, arcRadius + 14, RadialPositions.RADIAL_GOAL_ACHEIVD_ICON);
				var iconY = calcRadialY(cy, arcRadius + 14, RadialPositions.RADIAL_GOAL_ACHEIVD_ICON);
				dc.drawBitmap(iconX, iconY, goalAcheivedIcon);
				//todo: add times completed text
			}
		}
		//goal icon
		var iconX = calcRadialX(cx, arcRadius, RadialPositions.RADIAL_GOAL_ICON);
		var iconY = calcRadialY(cy, arcRadius, RadialPositions.RADIAL_GOAL_ICON);
		dc.drawBitmap(iconX, iconY, goalIcon);
		//count
		var textX = calcRadialX(cx, arcRadius + 6, RadialPositions.RADIAL_GOAL_TEXT);
		var textY = calcRadialY(cy, arcRadius + 6, RadialPositions.RADIAL_GOAL_TEXT);
        dc.setColor(colorsScheme.goalTextColor, Graphics.COLOR_TRANSPARENT);
		dc.drawText(textX, textY, Graphics.FONT_XTINY, formatGoal(goalCurrent), Graphics.TEXT_JUSTIFY_LEFT);
	}
	
	protected function formatGoal(goalCount) {
		if (goalCount > 100000) {
			return "100k+";
		} else if (goalCount > 12000) {
			var fraction = goalCount.toFloat()/1000;
			return fraction.format("%.1f") + "k";
		} else if (goalCount > 1200) {
			var fraction = goalCount.toFloat()/1000;
			return fraction.format("%.2f") + "k";
		} else {
			return goalCount.format("%d");
		}
	}

	protected function getGoalIcon() {
    	throw new Lang.OperationNotAllowedException("goal icon not set for " + getStatusViewId());
	}

	protected function getGoalIndex() {
    	throw new Lang.OperationNotAllowedException("goal index not set for " + getStatusViewId());
	}

	protected function getGoalTarget() {
    	throw new Lang.OperationNotAllowedException("goal target count not set for " + getStatusViewId());
	}

	protected function getGoalCurrentValue() {
    	throw new Lang.OperationNotAllowedException("goal current value not set for " + getStatusViewId());
	}

}

class StepsGoalArc extends GoalArcBase {

	private var _lastCheck = 0;
	private var _activityInfo = ActivityMonitor.getInfo();
	function initialize() {
        GoalArcBase.initialize();
    }

	protected function checkIfUpdateRequired(now) {
		if (now - _lastCheck >= 5) {
			_lastCheck = now;
			_activityInfo = ActivityMonitor.getInfo();
			return true;
		} else {
			return false;
		}
	}

	protected function getStatusViewId() {
    	return "StepsGoalArc";
    }

	protected function getVisiblePrefId() {
    	return "ShowStepsGoalArc";
    }

	protected function getGoalIcon() {
		return WatchUi.loadResource(Rez.Drawables.GoalStepsIcon);
	}

	protected function getGoalCurrentValue() {
		return _activityInfo.steps;
	}

	protected function getGoalTarget() {
		return _activityInfo.stepGoal;
	}

	protected function getGoalIndex() {
		return 3;
	}
}


class FloorsGoalArc extends GoalArcBase {

	private var _lastCheck = 0;
	private var _activityInfo = ActivityMonitor.getInfo();
	function initialize() {
        GoalArcBase.initialize();
    }

	protected function checkIfUpdateRequired(now) {
		if (now - _lastCheck >= 5) {
			_lastCheck = now;
			_activityInfo = ActivityMonitor.getInfo();
			return true;
		} else {
			return false;
		}
	}

	protected function getStatusViewId() {
    	return "FloorsGoalArc";
    }

	protected function getVisiblePrefId() {
    	return "ShowFloorsGoalArc";
    }
    
    protected function getGoalIcon() {
		return WatchUi.loadResource(Rez.Drawables.GoalFloorsIcon);
	}

	protected function getGoalCurrentValue() {
		return _activityInfo.floorsClimbed;
	}

	protected function getGoalTarget() {
		return _activityInfo.floorsClimbedGoal;
	}

	protected function getGoalIndex() {
		return 2;
	}
}
