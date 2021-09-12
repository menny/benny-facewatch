using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.ActivityMonitor;
using Toybox.System;
using Toybox.Application;

class GoalArcBase extends StatusDcViewBase {

    protected const ARC_START = RadialPositions.RADIAL_GOAL_START_ARC;
    protected const ARC_LENGTH = RadialPositions.RADIAL_GOAL_START_LENGTH;
    protected const ARC_PEN_WIDTH = 8;
    protected const ARC_PEN_FILL_WIDTH = ARC_PEN_WIDTH-4;

    private const FONT_HEIGHT = Graphics.getFontHeight(Graphics.FONT_XTINY);
    private const BOTTOM_ICON_OFFSET_X = 0;
    private const BOTTOM_ICON_OFFSET_Y = 0;
    private const ACHIEVED_ICON_OFFSET_X = -1.5 *ARC_PEN_WIDTH;
    private const ACHIEVED_ICON_OFFSET_Y = ARC_PEN_WIDTH;
    private const TOP_TEXT_OFFSET_X = ARC_PEN_WIDTH;
    private const TOP_TEXT_OFFSET_Y = ARC_PEN_WIDTH - FONT_HEIGHT;

    protected var arcRadius;

    function initialize(minSecondsBetweenUpdates) {
        arcRadius = getGoalIndex() * Application.getApp().getBennyState().screenWidth/8;
        StatusDcViewBase.initialize(minSecondsBetweenUpdates);
    }

    protected function getVirtualCenterX() {
        return _state.centerX - _viewBox.x;
    }

    protected function getVirtualCenterY() {
        return _state.centerY - _viewBox.y;
    }

    protected function getVisibleForDndState(inDndState) {
        return !inDndState;
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
        if (goalRatio > 1.0) {
            goalRatio = 1.0;
        }

        var cx = getVirtualCenterX();
        var cy = getVirtualCenterY();
        //empty
        dc.setColor(colorsScheme.goalBackgroundColor, Graphics.COLOR_TRANSPARENT);
        drawArcWithOs(dc, cx, cy, arcRadius, ARC_PEN_WIDTH, ARC_START, ARC_START + ARC_LENGTH);

        var arcBottomX = calcRadialX(cx, arcRadius, ARC_START);
        var arcBottomY = calcRadialY(cy, arcRadius, ARC_START);
        var arcTopX = calcRadialX(cx, arcRadius, ARC_START + ARC_LENGTH);
        var arcTopY = calcRadialY(cy, arcRadius, ARC_START + ARC_LENGTH);
        //fill with progress
        if (goalCurrent > 0) {
            dc.setColor(colorsScheme.goalFillColor, Graphics.COLOR_TRANSPARENT);
            drawArcWithOs(dc, cx, cy, arcRadius, ARC_PEN_FILL_WIDTH, ARC_START, ARC_START + goalRatio * ARC_LENGTH);
            //check mark
            if (goalRatio >= 1.0) {
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
    private var _moveBarLevel = -1;
    function initialize() {
        GoalArcBase.initialize(5);
    }

    protected function checkIfUpdateRequired(now, force) {
        var activityInfo = _state.getActivityMonitorInfo(now, 5);
        var newSteps = activityInfo.steps;
        var newStepsGoal = activityInfo.stepGoal;
        var moveBarLevel = activityInfo.moveBarLevel;
        if (moveBarLevel == null) {
            moveBarLevel = -1;
        }
        if (force || newSteps != _steps || newStepsGoal != _stepsGoal || moveBarLevel != _moveBarLevel) {
            _steps = newSteps;
            _stepsGoal = newStepsGoal;
            _moveBarLevel = moveBarLevel;
            return true;
        }

        return false;
    }

    protected function onDrawNow(dc) {
        GoalArcBase.onDrawNow(dc);
        if (_moveBarLevel >= 0) {
            var cx = getVirtualCenterX();
            var cy = getVirtualCenterY();
            var radius = arcRadius-ARC_PEN_WIDTH;
            //drawing the move-bar next to the arc
            var colorsScheme = getColorsScheme();
            dc.setColor(colorsScheme.goalExtraFillColor, Graphics.COLOR_TRANSPARENT);
            if (_moveBarLevel == ActivityMonitor.MOVE_BAR_LEVEL_MAX) {
                //you better get moving!
                var arcBottomX = calcRadialX(cx, radius, ARC_START);
                var arcBottomY = calcRadialY(cy, radius, ARC_START) - ARC_PEN_WIDTH;
                dc.drawText(arcBottomX, arcBottomY, Graphics.FONT_TINY, "!", Graphics.TEXT_JUSTIFY_VCENTER);
            } else {
                //Full is good, empty is bad. "Keep it full".
                var ratio = 1 - _moveBarLevel.toFloat()/ActivityMonitor.MOVE_BAR_LEVEL_MAX.toFloat();
                drawArcWithOs(dc, cx, cy, radius, 1, ARC_START, ARC_START + ratio * ARC_LENGTH);
            }
        }
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
        GoalArcBase.initialize(5);
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
    private var _activeVigorousMinutes = 0;
    function initialize() {
        GoalArcBase.initialize(60);
    }

    protected function checkIfUpdateRequired(now, force) {
        var activityInfo = _state.getActivityMonitorInfo(now, 60);
        var newValue = activityInfo.activeMinutesWeek;
        var newVigorousValue;
        if (newValue == null) {
            newValue = 0;
            newVigorousValue = 0;
        } else {
            //this is Toybox.ActivityMonitor.ActiveMinutes
            newVigorousValue = newValue.vigorous;
            newValue = newValue.total;
        }
        var newGoal = activityInfo.activeMinutesWeekGoal;
        if (force || newValue != _activeMinutes || newGoal != _activeMinutesGoal || newVigorousValue != _activeVigorousMinutes) {
            _activeMinutes = newValue;
            _activeMinutesGoal = newGoal;
            _activeVigorousMinutes = newVigorousValue;
            return true;
        }

        return false;
    }

    protected function onDrawNow(dc) {
        GoalArcBase.onDrawNow(dc);
        if (_activeMinutesGoal > 0 && _activeVigorousMinutes > 0) {
            //drawing the vigorous minutes ontop the arc
            var colorsScheme = getColorsScheme();
            dc.setPenWidth(1);
            dc.setColor(colorsScheme.goalExtraFillColor, Graphics.COLOR_TRANSPARENT);
            var vigorousRatio = _activeVigorousMinutes.toFloat()/_activeMinutesGoal.toFloat();
            drawArcWithOs(dc, getVirtualCenterX(), getVirtualCenterY(), arcRadius, ARC_PEN_FILL_WIDTH, ARC_START, ARC_START + vigorousRatio * ARC_LENGTH);
        }
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
