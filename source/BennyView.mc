using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time;

class BennyView extends WatchUi.WatchFace {

    var _allViews = [];
    var _forceReDraw = false;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        _allViews.add(new Background());
        _allViews.add(new WatchTicks());
        _allViews.add(new HeartRate());
        _allViews.add(new HeartRateHistory());
        _allViews.add(new StepsGoalArc());
        _allViews.add(new WeeklyActiveGoalArc());
        _allViews.add(new FloorsGoalArc());
        _allViews.add(new DistanceView());
        _allViews.add(new PhoneStatusView());
        _allViews.add(new WatchStatus());
        _allViews.add(new Weather());
        _allViews.add(new DateView());
        _allViews.add(new Alarm());
        _allViews.add(new WatchHands());
        _allViews.add(new DoNotDisturbDigitalWatch());
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        //forcing init
        onSettingsChanged();
        _forceReDraw = true;
        return true;
    }

    function onSettingsChanged() {
        var app = Application.getApp();
        for( var i = 0; i < _allViews.size(); i += 1 ) {
            _allViews[i].onSettingsChanged(app);
        }
        _forceReDraw = true;
        requestUpdate();
    }

    // Update the view
    function onUpdate(dc) {
        var now = getCurrentEpocSeconds();

        for( var i = 0; i < _allViews.size(); i += 1 ) {
            _allViews[i].draw(dc, now, _forceReDraw);
        }
        _forceReDraw = false;
        //handled
        return true;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        return true;
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
        for( var i = 0; i < _allViews.size(); i += 1 ) {
            _allViews[i].setSleepState(false);
        }
        _forceReDraw = true;
        requestUpdate();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        for( var i = 0; i < _allViews.size(); i += 1 ) {
            _allViews[i].setSleepState(true);
        }
        _forceReDraw = true;
        requestUpdate();
    }

}
