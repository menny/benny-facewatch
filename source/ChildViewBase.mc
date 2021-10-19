using Toybox.WatchUi;
using Toybox.Lang;

class ChildViewBase {

    protected var _state;
    protected var _lastDrawTime = 0;
    protected var _minTimeBetweenUpdates;

    function initialize(minTimeBetweenDraws) {
        _minTimeBetweenUpdates = minTimeBetweenDraws;
        _state = Application.getApp().getBennyState();
    }

    function onSettingsChanged(app, sleeping, inDndMode) {
        throw new Lang.OperationNotAllowedException("onSettingsChanged not set");
    }

    function draw(dc, now, force) {
        _lastDrawTime = now;
    }
}
