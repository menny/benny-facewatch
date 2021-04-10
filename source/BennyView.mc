using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

class BennyView extends WatchUi.WatchFace {
	
	var _watchHandsView;
    var _heartRateView;
    var _heartRateHistoryView;
    var _stepsGoalView;
    var _floorsGoalView;
    var _distanceView;
    var _phoneStatusView;
    var _watchStatusView;
    var _weatherView;
    var _dateView;
    var _alarmView;
    var _doNotDisturbDigitalWatch;
    
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        _watchHandsView = View.findDrawableById("WatchHands");
        _heartRateView = View.findDrawableById("HeartRate");
        _heartRateHistoryView = View.findDrawableById("HeartRateHistory");
        _stepsGoalView = View.findDrawableById("StepsGoalArc");
        _floorsGoalView = View.findDrawableById("FloorsGoalArc");
        _distanceView = View.findDrawableById("Distance");
        _phoneStatusView = View.findDrawableById("PhoneStatus");
        _watchStatusView = View.findDrawableById("WatchStatus");
        _weatherView = View.findDrawableById("Weather");
        _dateView = View.findDrawableById("Date");
        _alarmView = View.findDrawableById("Alarm");
        _doNotDisturbDigitalWatch = View.findDrawableById("DoNotDisturbDigitalWatch");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	onSettingsChanged();
    	return true;
    }
    
    function setVisibilityOnView(app, view, viewSettingsName) {
    	view.setVisible(app.getProperty(viewSettingsName));
    }
    
    function onSettingsChanged() {
    	var app = Application.getApp();
    	setVisibilityOnView(app, _heartRateView, "ShowHeartRate");
    	setVisibilityOnView(app, _heartRateHistoryView, "ShowHeartRateHistory");
    	setVisibilityOnView(app, _stepsGoalView, "ShowStepsGoalArc");
    	setVisibilityOnView(app, _floorsGoalView, "ShowFloorsGoalArc");
    	setVisibilityOnView(app, _distanceView, "ShowDistance");
    	setVisibilityOnView(app, _phoneStatusView, "ShowPhoneStatus");
    	setVisibilityOnView(app, _watchStatusView, "ShowWatchStatus");
    	setVisibilityOnView(app, _weatherView, "ShowWeather");
    	setVisibilityOnView(app, _dateView, "ShowDate");
    	setVisibilityOnView(app, _alarmView, "ShowAlarmStatus");
    	
    	WatchUi.requestUpdate();
    }

    // Update the view
    function onUpdate(dc) {
        View.onUpdate(dc);
        _phoneStatusView.requestUpdate();
        _watchStatusView.requestUpdate();
        _alarmView.requestUpdate();
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
    	_watchHandsView.onExitSleep();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
	    _watchHandsView.onEnterSleep();
    }

}
