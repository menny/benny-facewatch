using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.ActivityMonitor;
using Toybox.System;
using Toybox.Application;

class GoalArcBase extends StatusViewBase {
	//note about arc:
	//0 degrees: 3 o'clock position.
	//90 degrees: 12 o'clock position.
	//180 degrees: 9 o'clock position.
	//270 degrees: 6 o'clock position.
	private const ARC_START = RadialPositions.RADIAL_GOAL_START_ARC;
	private const ARC_LENGTH = RadialPositions.RADIAL_GOAL_START_LENGTH;
	private const ARC_PEN_WIDTH = 6;
	private var goalAcheivedIcon;
	private var goalIcon;
	private var arcRadius;

	function initialize() {
		goalAcheivedIcon = WatchUi.loadResource(Rez.Drawables.GoalAchievedIcon);
		goalIcon = getGoalIcon();
		arcRadius = getGoalIndex() * Application.getApp().getBennyState().staticDeviceSettings.screenWidth/8;
        StatusViewBase.initialize();
    }

	protected function onDrawNow(dc) {
    	var colorsScheme = getColorsScheme();
		dc.setPenWidth(ARC_PEN_WIDTH);
		
		//data
		var goalCurrent = getGoalCurrentValue();
		var goalRatio = goalCurrent.toFloat() / getGoalTarget().toFloat();
		var timesCompleted = goalRatio.toNumber();
		var fillRatio = goalRatio - timesCompleted;
			
		var cx = arcRadius + ARC_PEN_WIDTH;
		var cy = dc.getHeight()/2;
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
				dc.setPenWidth(ARC_PEN_WIDTH/2);
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
		var textX = calcRadialX(cx, arcRadius + ARC_PEN_WIDTH, RadialPositions.RADIAL_GOAL_TEXT);
		var textY = calcRadialY(cy, arcRadius + ARC_PEN_WIDTH, RadialPositions.RADIAL_GOAL_TEXT);
        dc.setColor(colorsScheme.goalTextColor, Graphics.COLOR_TRANSPARENT);
		dc.drawText(textX, textY, Graphics.FONT_XTINY, formatGoal(goalCurrent), Graphics.TEXT_JUSTIFY_LEFT);
	}
	
	protected function formatGoal(goalCount) {
		if (goalCount > 100000) {
			return (goalCount/1000).format("%d") + "k";
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
	
	protected function getStatusWidth() {
		var fontHeight = Graphics.getFontHeight(Graphics.FONT_XTINY);
		var leftArc = calcRadialX(_state.centerX, arcRadius, 270);
		var rightArc = calcRadialX(_state.centerX, arcRadius, ARC_START);
		return rightArc - leftArc + 3*fontHeight + ARC_PEN_WIDTH;
	}
	
	protected function getStatusHeight() {
		var fontHeight = Graphics.getFontHeight(Graphics.FONT_XTINY);
		var topArc = calcRadialY(_state.centerY, arcRadius, ARC_START + ARC_LENGTH);
		var bottomArc = calcRadialY(_state.centerY, arcRadius, ARC_START);
		return bottomArc - topArc + fontHeight + goalIcon.getHeight();
	}
	
	protected function getStatusX() {
		return calcRadialX(_state.centerX, arcRadius, 270) - ARC_PEN_WIDTH/2;
	}
	
	protected function getStatusY() {
		var fontHeight = Graphics.getFontHeight(Graphics.FONT_XTINY);
		var topArc = calcRadialY(_state.centerY, arcRadius, ARC_START + ARC_LENGTH);
		return topArc - fontHeight;
	}

	protected function getGoalIcon() {
    	throw new Lang.OperationNotAllowedException("goal icon not set for " + toString());
	}

	protected function getGoalIndex() {
    	throw new Lang.OperationNotAllowedException("goal index not set for " + toString());
	}

	protected function getGoalTarget() {
    	throw new Lang.OperationNotAllowedException("goal target count not set for " + toString());
	}

	protected function getGoalCurrentValue() {
    	throw new Lang.OperationNotAllowedException("goal current value not set for " + toString());
	}

}

class StepsGoalArc extends GoalArcBase {
	private var _steps = 0;
	private var _stepsGoal = 10000;
	function initialize() {
        GoalArcBase.initialize();
    }

	protected function checkIfUpdateRequired(now) {
		var activityInfo = _state.getActivityMonitorInfo(now, 5);
		var newSteps = activityInfo.steps;
		var newStepsGoal = activityInfo.stepGoal;
		if (newSteps != _steps || newStepsGoal != _stepsGoal) {
			_steps = newSteps;
			_stepsGoal = newStepsGoal;
			return true;
		}
		
		return false;
	}
	protected function getVisiblePrefId() {
    	return "ShowStepsGoalArc";
    }

	protected function getGoalIcon() {
		return WatchUi.loadResource(Rez.Drawables.GoalStepsIcon);
	}

	protected function getGoalCurrentValue() {
		return _steps;
	}

	protected function getGoalTarget() {
		return _stepsGoal;
	}

	protected function getGoalIndex() {
		return 3;
	}
}


class FloorsGoalArc extends GoalArcBase {

	private var _floors = 0;
	private var _floorsGoal = 10;
	function initialize() {
        GoalArcBase.initialize();
    }

	protected function checkIfUpdateRequired(now) {
		var activityInfo = _state.getActivityMonitorInfo(now, 5);
		var newValue = activityInfo.floorsClimbed;
		var newGoal = activityInfo.floorsClimbedGoal;
		if (newValue != _floors || newGoal != _floorsGoal) {
			_floors = newValue;
			_floorsGoal = newGoal;
			return true;
		}

		return false;
	}

	protected function getVisiblePrefId() {
    	return "ShowFloorsGoalArc";
    }
    
    protected function getGoalIcon() {
		return WatchUi.loadResource(Rez.Drawables.GoalFloorsIcon);
	}

	protected function getGoalCurrentValue() {
		return _floors;
	}

	protected function getGoalTarget() {
		return _floorsGoal;
	}

	protected function getGoalIndex() {
		return 2;
	}
}
