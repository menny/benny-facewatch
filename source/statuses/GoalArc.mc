using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.ActivityMonitor;
using Toybox.System;
using Toybox.Application;

class GoalArcBase extends StatusViewBase {

    private const ARC_START = RadialPositions.RADIAL_GOAL_START_ARC;
    private const ARC_LENGTH = RadialPositions.RADIAL_GOAL_START_LENGTH;
    private const ARC_PEN_WIDTH = 8;

    private const FONT_HEIGHT = Graphics.getFontHeight(Graphics.FONT_XTINY);
    private const BOTTOM_ICON_OFFSET_X = 0;
    private const BOTTOM_ICON_OFFSET_Y = 0;
    private const ACHIEVED_ICON_OFFSET_X = -1.5 *ARC_PEN_WIDTH;
    private const ACHIEVED_ICON_OFFSET_Y = ARC_PEN_WIDTH;
    private const TOP_TEXT_OFFSET_X = ARC_PEN_WIDTH;
    private const TOP_TEXT_OFFSET_Y = ARC_PEN_WIDTH - FONT_HEIGHT;

    private var arcRadius;

    function initialize() {
        arcRadius = getGoalIndex() * Application.getApp().getBennyState().screenWidth/8;
        StatusViewBase.initialize();
    }

    protected function onDrawNow(dc) {
        var colorsScheme = getColorsScheme();
        dc.setPenWidth(1);

        //data
        var goalCurrent = getGoalCurrentValue();
        var goalTarget = getGoalTarget();
        if (goalCurrent == null || goalTarget == null) {
            goalCurrent = 0;
            goalTarget = 1;
        }
        var goalRatio = goalCurrent.toFloat() / goalTarget.toFloat();
        var timesCompleted = goalRatio.toNumber();
        var fillRatio = goalRatio - timesCompleted;

        var cx = _state.centerX - _viewBox.x;
        var cy = _state.centerY - _viewBox.y;
        //empty
        if (timesCompleted == 0) {
            dc.setColor(colorsScheme.goalBackgroundColor, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(colorsScheme.goalFillColor, Graphics.COLOR_TRANSPARENT);
        }
        drawArcWithCircles(dc, cx, cy, arcRadius, ARC_PEN_WIDTH, ARC_START, ARC_START + ARC_LENGTH);

        var arcBottomX = calcRadialX(cx, arcRadius, ARC_START);
        var arcBottomY = calcRadialY(cy, arcRadius, ARC_START);
        var arcTopX = calcRadialX(cx, arcRadius, ARC_START + ARC_LENGTH);
        var arcTopY = calcRadialY(cy, arcRadius, ARC_START + ARC_LENGTH);
        //full
        if (goalCurrent > 0) {
            if (timesCompleted == 0) {
                dc.setColor(colorsScheme.goalFillColor, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(colorsScheme.goalExtraFillColor, Graphics.COLOR_TRANSPARENT);
            }
            drawArcWithCircles(dc, cx, cy, arcRadius, ARC_PEN_WIDTH-2, ARC_START, ARC_START + fillRatio * ARC_LENGTH);
            //check mark
            if (timesCompleted >= 1) {
                var goalAchievedIcon = WatchUi.loadResource(Rez.Drawables.GoalAchievedIcon);
                var iconX = arcTopX + ACHIEVED_ICON_OFFSET_X;
                var iconY = arcTopY + ACHIEVED_ICON_OFFSET_Y - goalAchievedIcon.getHeight();
                dc.drawBitmap(iconX, iconY, goalAchievedIcon);
                //todo: add times completed text
            }
        }
        //goal icon
        var iconX = arcBottomX + BOTTOM_ICON_OFFSET_X;
        var iconY = arcBottomY + BOTTOM_ICON_OFFSET_Y;
        dc.drawBitmap(iconX, iconY, getGoalIcon());
        //count
        var textX = arcTopX + TOP_TEXT_OFFSET_X;
        var textY = arcTopY + TOP_TEXT_OFFSET_Y;
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

    protected function getViewBox() {
        //left is the arc edge to the left (270 degrees)
        var leftArc = calcRadialX(_state.centerX, arcRadius, 270) - ARC_PEN_WIDTH;
        //right the end of the count text
        var rightArc = calcRadialX(_state.centerX, arcRadius, ARC_START + ARC_LENGTH) + TOP_TEXT_OFFSET_X + 2.5*FONT_HEIGHT;

        //top is the text
        var topArc = calcRadialY(_state.centerY, arcRadius, ARC_START + ARC_LENGTH) + TOP_TEXT_OFFSET_Y - FONT_HEIGHT;
        //bottom is the icon
        var bottomArc = calcRadialY(_state.centerY, arcRadius, ARC_START) + ACHIEVED_ICON_OFFSET_Y + getGoalIcon().getHeight();

        return new ViewBox(leftArc, topArc,
            rightArc - leftArc, bottomArc - topArc);
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

    protected function checkIfUpdateRequired(now, force) {
        var activityInfo = _state.getActivityMonitorInfo(now, 5);
        var newSteps = activityInfo.steps;
        var newStepsGoal = activityInfo.stepGoal;
        if (force || newSteps != _steps || newStepsGoal != _stepsGoal) {
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

    protected function checkIfUpdateRequired(now, force) {
        var activityInfo = _state.getActivityMonitorInfo(now, 5);
        var newValue = activityInfo.floorsClimbed;
        var newGoal = activityInfo.floorsClimbedGoal;
        if (force || newValue != _floors || newGoal != _floorsGoal) {
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
        return 1;
    }
}

class WeeklyActiveGoalArc extends GoalArcBase {

    private var _activeMinutes = 0;
    private var _activeMinutesGoal = 150;
    function initialize() {
        GoalArcBase.initialize();
    }

    protected function checkIfUpdateRequired(now, force) {
        var activityInfo = _state.getActivityMonitorInfo(now, 60);
        var newValue = activityInfo.activeMinutesWeek;
        if (newValue == null) {
            newValue = 0;
        } else {
            //this is Toybox.ActivityMonitor.ActiveMinutes
            newValue = newValue.total;
        }
        var newGoal = activityInfo.activeMinutesWeekGoal;
        if (force || newValue != _activeMinutes || newGoal != _activeMinutesGoal) {
            _activeMinutes = newValue;
            _activeMinutesGoal = newGoal;
            return true;
        }

        return false;
    }

    protected function getVisiblePrefId() {
        return "ShowActiveMinutesGoalArc";
    }

    protected function getGoalIcon() {
        return WatchUi.loadResource(Rez.Drawables.GoalActiveMinutesIcon);
    }

    protected function getGoalCurrentValue() {
        return _activeMinutes;
    }

    protected function getGoalTarget() {
        return _activeMinutesGoal;
    }

    protected function getGoalIndex() {
        return 2;
    }
}
