using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time;

class BennyView extends WatchUi.WatchFace {
	
	var _watchHandsView;
    var _currentViewForUpdateCheck = 0;
    var _allViews = [];
    var _currentColorScheme;
    var _lastUpdateCall = 0;
    
    function initialize() {
        WatchFace.initialize();
        _currentColorScheme = null;
    }

    // Load your resources here
    function onLayout(dc) {
        addLayerWithView(new Background());
        addLayerWithView(new WatchTicks());
        addLayerWithView(new HeartRate());
        addLayerWithView(new HeartRateHistory());
        addLayerWithView(new StepsGoalArc());
        addLayerWithView(new FloorsGoalArc());
        addLayerWithView(new DistanceView());
        addLayerWithView(new PhoneStatusView());
        addLayerWithView(new WatchStatus());
        addLayerWithView(new Weather());
        addLayerWithView(new DateView());
        addLayerWithView(new Alarm());
        _watchHandsView = new WatchHands();
        addLayerWithView(_watchHandsView);
        addLayerWithView(new DoNotDisturbDigitalWatch());
    }

    private function addLayerWithView(view) {
        _allViews.add(view);
        //addLayer(view.getLayer());
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	//forcing init
        onSettingsChanged();
    	return true;
    }
    
    function onSettingsChanged() {
        System.println("onSettingsChanged on BennyView");
    	var app = Application.getApp();
    	for( var i = 0; i < _allViews.size(); i += 1 ) {
    		_allViews[i].onSettingsChanged(app);
		}
		requestUpdate();
    }

    // Update the view
    function onUpdate(dc) {
        var now = getCurrentEpocSeconds();
        //checking for update need
        _lastUpdateCall = now;
    	var scheme = getColorsScheme();
        if (_currentColorScheme != scheme) {
	    	//if color-scheme was changed, we need to refresh everything
            _currentColorScheme = scheme;
            drawAllViews(dc);
        } else {
	        var maxChecks = _allViews.size();
            var redrawNeeded = false;
	    	while(maxChecks > 0) {
	            maxChecks--;
	            var childView = _allViews[_currentViewForUpdateCheck];
	            _currentViewForUpdateCheck++;
	            if (_currentViewForUpdateCheck >= _allViews.size()) {
	                _currentViewForUpdateCheck = 0;
	            }
	            if (childView.isUpdateRequired(now)) {
	            	redrawNeeded = true;
	                break;
	            }
			}

            if (redrawNeeded) {
                drawAllViews(dc);
            }
        }
        //handled
        return true;
    }

    private function drawAllViews(dc) {
        for( var i = 0; i < _allViews.size(); i += 1 ) {
            _allViews[i].draw(dc);
        } 
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
    	requestUpdate();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	for( var i = 0; i < _allViews.size(); i += 1 ) {
            _allViews[i].setSleepState(true);
        }
    	requestUpdate();
    }

}
