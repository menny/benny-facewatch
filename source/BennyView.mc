using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

class BennyView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    	var heartRate = View.findDrawableById("HeartRate");
    	heartRate.setVisible(Application.getApp().getProperty("ShowHeartRate"));
        var heartRateHistory = View.findDrawableById("HeartRateHistory");
    	heartRateHistory.setVisible(Application.getApp().getProperty("ShowHeartRateHistory"));
        var stepsGoalArc = View.findDrawableById("StepsGoalArc");
    	stepsGoalArc.setVisible(Application.getApp().getProperty("ShowStepsGoalArc"));
        var floorsGoalArc = View.findDrawableById("FloorsGoalArc");
    	floorsGoalArc.setVisible(Application.getApp().getProperty("ShowFloorsGoalArc"));
        var distance = View.findDrawableById("Distance");
    	distance.setVisible(Application.getApp().getProperty("ShowDistance"));
        var phoneStatus = View.findDrawableById("PhoneStatus");
    	phoneStatus.setVisible(Application.getApp().getProperty("ShowPhoneStatus"));
        var weather = View.findDrawableById("Weather");
    	weather.setVisible(Application.getApp().getProperty("ShowWeather"));
        var date = View.findDrawableById("Date");
    	date.setVisible(Application.getApp().getProperty("ShowDate"));
        var alarm = View.findDrawableById("Alarm");
    	alarm.setVisible(Application.getApp().getProperty("ShowAlarmStatus"));
        // Get the current time and format it correctly
//        var timeFormat = "$1$:$2$";
//        var clockTime = System.getClockTime();
//        var hours = clockTime.hour;
//        if (!System.getDeviceSettings().is24Hour) {
//            if (hours > 12) {
//                hours = hours - 12;
//            }
//        } else {
//            if (Application.getApp().getProperty("UseMilitaryFormat")) {
//                timeFormat = "$1$$2$";
//                hours = hours.format("%02d");
//            }
//        }
//        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
//
//        // Update the view
//        var view = View.findDrawableById("TimeLabel");
//        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
