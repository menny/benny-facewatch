using Toybox.System;
using Toybox.Time;
using Toybox.Activity;
using Toybox.ActivityMonitor;

function getCurrentEpocSeconds() {
    return Time.now().value();
}

class State {
	const staticDeviceSettings = System.getDeviceSettings();
    const screenWidth = staticDeviceSettings.screenWidth;
    const screenHeight = staticDeviceSettings.screenHeight;
    const centerX = screenWidth/2;
    const centerY = screenHeight/2;

    private var _cachedDeviceSettingsTime = 0;
    private var _cachedDeviceSettings;

    private var _cachedSystemStatsTime = 0;
    private var _cachedSystemStats;

    private var _cachedHeartBeatTime = 0;
    private var _cachedHeartBeat;

    private var _cachedActivityInfoTime = 0;
    private var _cachedActivityInfo;

    private var _cachedActivityMonitorInfoTime = 0;
    private var _cachedActivityMonitorInfo;

	function initialize() {
        var now = getCurrentEpocSeconds();
        _cachedDeviceSettingsTime = now;
        _cachedDeviceSettings = staticDeviceSettings;
    }

    function getDeviceSettings(now, ttl) {
        if ((_cachedDeviceSettingsTime + ttl) >= now) {
            return _cachedDeviceSettings;
        }

        _cachedDeviceSettingsTime = now;
        _cachedDeviceSettings = System.getDeviceSettings();
        return _cachedDeviceSettings;
    }

    function getSystemStats(now, ttl) {
        if ((_cachedSystemStatsTime + ttl) >= now) {
            return _cachedSystemStats;
        }

        _cachedSystemStatsTime = now;
        _cachedSystemStats = System.getSystemStats();
        return _cachedSystemStats;
    }

    function getHeartBeat(now, ttl) {
        if ((_cachedHeartBeatTime + ttl) >= now) {
            return _cachedHeartBeat;
        }

        _cachedHeartBeatTime = now;
        _cachedHeartBeat = getCurrentHeartRateAsDouble(now, ttl);
        return _cachedHeartBeat;
    }

    function getActivityInfo(now, ttl) {
        if ((_cachedActivityInfoTime + ttl) >= now) {
            return _cachedActivityInfo;
        }

        _cachedActivityInfoTime = now;
        _cachedActivityInfo = Activity.getActivityInfo();
        return _cachedActivityInfo;
    }

    function getActivityMonitorInfo(now, ttl) {
        if ((_cachedActivityMonitorInfoTime + ttl) >= now) {
            return _cachedActivityMonitorInfo;
        }

        _cachedActivityMonitorInfoTime = now;
        _cachedActivityMonitorInfo = ActivityMonitor.getInfo();
        return _cachedActivityMonitorInfo;
    }

    private function getCurrentHeartRateAsDouble(now, ttl) {
        //greedily, trying to grab the HR from current activity (this is the most precise)
        var activityInfo = getActivityInfo(now, ttl);
        var sample = activityInfo.currentHeartRate;
        if (sample != null) {
            return sample;
        } else {
            var sample = ActivityMonitor.getHeartRateHistory(1, /* newestFirst */ true).next();
            if (sample != null && sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                return sample.heartRate;
            }
        }

        return ActivityMonitor.INVALID_HR_SAMPLE;
    }
    
}
