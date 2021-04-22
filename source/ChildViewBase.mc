using Toybox.WatchUi;
using Toybox.Lang;

class ChildViewBase {

    protected var _state;
    protected var _sleeping = false;

    function initialize() {
        _state = Application.getApp().getBennyState();
    }

    function onSettingsChanged(app) {
        throw new Lang.OperationNotAllowedException("onSettingsChanged not set");
    }

    function setSleepState(isSleeping) {
        _sleeping = isSleeping;
    }

    function draw(dc, now, force) {
        throw new Lang.OperationNotAllowedException("draw not set for " + toString());
    }
}
