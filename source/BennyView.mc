using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time;

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
    var _allViews = [];
    
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        _watchHandsView = View.findDrawableById("WatchHands");
        _allViews.add(_watchHandsView);
        _heartRateView = View.findDrawableById("HeartRate");
        _allViews.add(_heartRateView);
        _heartRateHistoryView = View.findDrawableById("HeartRateHistory");
        _allViews.add(_heartRateHistoryView);
        _stepsGoalView = View.findDrawableById("StepsGoalArc");
        _allViews.add(_stepsGoalView);
        _floorsGoalView = View.findDrawableById("FloorsGoalArc");
        _allViews.add(_floorsGoalView);
        _distanceView = View.findDrawableById("Distance");
        _allViews.add(_distanceView);
        _phoneStatusView = View.findDrawableById("PhoneStatus");
        _allViews.add(_phoneStatusView);
        _watchStatusView = View.findDrawableById("WatchStatus");
        _allViews.add(_watchStatusView);
        _weatherView = View.findDrawableById("Weather");
        _allViews.add(_weatherView);
        _dateView = View.findDrawableById("Date");
        _allViews.add(_dateView);
        _alarmView = View.findDrawableById("Alarm");
        _allViews.add(_alarmView);
        _doNotDisturbDigitalWatch = View.findDrawableById("DoNotDisturbDigitalWatch");
        _allViews.add(_doNotDisturbDigitalWatch);
        for( var i = 0; i < _allViews.size(); i += 1 ) {
			if (_allViews[i] == null) {
				throw new Lang.OperationNotAllowedException("view is null at index " + i);
			}
		}
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	onSettingsChanged();
    	return true;
    }
    
    function setVisibilityOnView(app, view, viewSettingsName) {
        var propValue = app.getProperty(viewSettingsName);
        if (propValue == null) {
				throw new Lang.OperationNotAllowedException("prop-value for " + viewSettingsName + " is null");
        }
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
    	//forcing update
    	for( var i = 0; i < _allViews.size(); i += 1 ) {
    		_allViews[i].requestUpdate();
		}
    }

    // Update the view
    function onUpdate(dc) {
        View.onUpdate(dc);
        var now = Time.now().value(); 
        //checking for update need
    	for( var i = 0; i < _allViews.size(); i += 1 ) {
    		_allViews[i].onUpdateCalledOnRootView(now);
		}
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
