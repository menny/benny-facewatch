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
    var _currentColorScheme;
    
    function initialize() {
        WatchFace.initialize();
        _currentColorScheme = null;
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
        _distanceView = View.findDrawableById("DistanceView");
        _allViews.add(_distanceView);
        _phoneStatusView = View.findDrawableById("PhoneStatusView");
        _allViews.add(_phoneStatusView);
        _watchStatusView = View.findDrawableById("WatchStatus");
        _allViews.add(_watchStatusView);
        _weatherView = View.findDrawableById("Weather");
        _allViews.add(_weatherView);
        _dateView = View.findDrawableById("DateView");
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
    
    function onSettingsChanged() {
    	var app = Application.getApp();
    	for( var i = 0; i < _allViews.size(); i += 1 ) {
    		_allViews[i].onSettingsChanged(app);
		}
        //if color-scheme was changed, we need to refresh everything
        if (_currentColorScheme != getColorsScheme()) {
            _currentColorScheme = getColorsScheme();
            for( var i = 0; i < _allViews.size(); i += 1 ) {
                _allViews[i].requestUpdate();
            }    
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
