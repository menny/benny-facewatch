using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;

class ImageStatusBase extends StatusViewBase {

    var _images = null;

    function initialize(minTimeBetweenDraws) {
        StatusViewBase.initialize(minTimeBetweenDraws);
    }

    protected function getStatuesImages(dc) {
        throw new Lang.OperationNotAllowedException("status images not set");
    }

    protected function onVisibilityChanged(visible) {
        StatusViewBase.onVisibilityChanged(visible);
        if (!visible) {
            _images = null;
        }
    }

    function draw(dc, now, force) {
        StatusViewBase.draw(dc, now, force);
        if (_visible) {
            if (checkIfUpdateRequired(now, force)) {
                _images = getStatuesImages(dc);
            }
            if (_images != null && _images.size() > 0) {
                dc.setClip(_viewBox.x, _viewBox.y, _viewBox.width, _viewBox.height);
                var x = _viewBox.x;
                var y = _viewBox.y;
                for (var imageIndex = 0; imageIndex < _images.size(); imageIndex++) {
                    dc.drawBitmap(x, y, _images[imageIndex]);
                    x = x - RadialPositions.RADIAL_ICON_SIZE - 3;
                }
                dc.clearClip();
            }
        }
    }
}

/* will show phone related statuses: connection, notification, maybe phone-battery*/
class PhoneStatusView extends ImageStatusBase {

    private var _currentlyDisconnected = false;
    private var _currentlyHaveNotifications = false;
    private var _notInDndMode = true;//in DnD we do not show notifications, but show connection

    function initialize() {
        ImageStatusBase.initialize(5);
    }

    protected function getVisiblePrefId() {
        return "ShowPhoneStatus";
    }

    function onSettingsChanged(app, sleeping, inDndMode) {
        ImageStatusBase.onSettingsChanged(app, sleeping, inDndMode);
        _notInDndMode = !inDndMode;
    }

    protected function getVisibleForDndState(inDndState) {
        return true;//but only showing disconnect
    }

    protected function checkIfUpdateRequired(now, force) {
        var deviceSettings = _state.getDeviceSettings(now, 5);
        var newDisconnected = !deviceSettings.phoneConnected;
        //hiding notifications in DND mode
        var newNotifications = _notInDndMode && deviceSettings.notificationCount > 0;
        if (force || _currentlyDisconnected != newDisconnected || _currentlyHaveNotifications != newNotifications) {
            _currentlyDisconnected = newDisconnected;
            _currentlyHaveNotifications = newNotifications;
            return true;
        }
        return false;
    }

    protected function getStatuesImages(dc) {
        if (_currentlyDisconnected) {
            return [WatchUi.loadResource(Rez.Drawables.PhoneStatusDisconnectedIcon)];
        } else if (_currentlyHaveNotifications) {
            return [WatchUi.loadResource(Rez.Drawables.PhoneStatusNotificationIcon)];
        } else {
            return null;
        }
    }

    protected function getViewBox() {
        var radius = _state.screenWidth/2 - RadialPositions.RADIAL_ICON_SIZE;
        var x = calcRadialX(_state.centerX, radius, RadialPositions.RADIAL_POSITION_PHONE_CONNECTION);
        var y = calcRadialY(_state.centerY, radius, RadialPositions.RADIAL_POSITION_PHONE_CONNECTION);

        return new ViewBox(x, y,
            RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_ICON_SIZE);
    }
}


/* will show watch related statuses: battery, DnD*/
class WatchStatus extends ImageStatusBase {

    private var _currentlyLowBattery = false;
    private var _currentlyCharging = false;

    function initialize() {
        ImageStatusBase.initialize(5);
    }

    protected function getVisiblePrefId() {
        return "ShowWatchStatus";
    }

    protected function getVisibleForDndState(inDndState) {
        return true;
    }

    protected function checkIfUpdateRequired(now, force) {
        var stats = _state.getSystemStats(now, 5);
        var newLowBattery = stats.battery < 15;
        var newCharging = stats.charging;
        if (force || _currentlyLowBattery != newLowBattery || _currentlyCharging != newCharging) {
            _currentlyLowBattery = newLowBattery;
            _currentlyCharging = newCharging;
            return true;
        }
        return false;
    }

    protected function getStatuesImages(dc) {
        if (_currentlyCharging) {
            return [WatchUi.loadResource(Rez.Drawables.WatchStatusChargingBattery)];
        } else if (_currentlyLowBattery) {
            return [WatchUi.loadResource(Rez.Drawables.WatchStatusLowBattery)];
        } else {
            return null;
        }
    }

    protected function getViewBox() {
        var radius = _state.screenWidth/2 - RadialPositions.RADIAL_ICON_SIZE;
        var x = calcRadialX(_state.centerX, radius, RadialPositions.RADIAL_POSITION_WATCH_BATTERY);
        var y = calcRadialY(_state.centerY, radius, RadialPositions.RADIAL_POSITION_WATCH_BATTERY);

        return new ViewBox(x, y,
            RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_ICON_SIZE);
    }
}

/* shows if there is an alarm set. Hopefully, we'll get to tell when*/
class Alarm extends ImageStatusBase {
    private var _currentAlarmActive = false;

    function initialize() {
        ImageStatusBase.initialize(10);
    }

    protected function getVisiblePrefId() {
        return "ShowAlarmStatus";
    }

    protected function getVisibleForDndState(inDndState) {
        return true;
    }

    protected function checkIfUpdateRequired(now, force) {
        var deviceSettings = _state.getDeviceSettings(now, 10);
        var newAlarm = deviceSettings.alarmCount > 0;
        if (force || newAlarm != _currentAlarmActive) {
            _currentAlarmActive = newAlarm;
            return true;
        }
        return false;
    }

    protected function getStatuesImages(dc) {
        if (_currentAlarmActive) {
            return [WatchUi.loadResource(Rez.Drawables.AlarmStatusIcon)];
        } else {
            return null;
        }
    }

    protected function getViewBox() {
        var radius = _state.screenWidth/2 - RadialPositions.RADIAL_ICON_SIZE;
        var x = calcRadialX(_state.centerX, radius, RadialPositions.RADIAL_POSITION_ALARM);
        var y = calcRadialY(_state.centerY, radius, RadialPositions.RADIAL_POSITION_ALARM);

        return new ViewBox(x, y,
            RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_ICON_SIZE);
    }
}

class Weather extends ImageStatusBase {

    function initialize() {
        ImageStatusBase.initialize(60*15);
    }

    protected function checkIfUpdateRequired(now, force) {
        //never
        return false;
    }

    protected function getVisibleForDndState(inDndState) {
        return true;
    }

    protected function getVisiblePrefId() {
        return "ShowWeather";
    }

    protected function getStatuesImages(dc) {
        return null;
    }

    protected function getViewBox() {
        var radius = _state.screenWidth/2 - RadialPositions.RADIAL_ICON_SIZE;
        var x = calcRadialX(_state.centerX, radius, RadialPositions.RADIAL_POSITION_WEATHER);
        var y = calcRadialY(_state.centerY, radius, RadialPositions.RADIAL_POSITION_WEATHER);

        return new ViewBox(x, y,
            RadialPositions.RADIAL_ICON_SIZE, RadialPositions.RADIAL_ICON_SIZE);
    }
}
