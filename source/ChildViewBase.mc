using Toybox.WatchUi;
using Toybox.Lang;

class ChildViewBase {

    protected var _state;

    function initialize() {
        _state = Application.getApp().getBennyState();
    }

    function onSettingsChanged(app, sleeping, inDndMode) {
        throw new Lang.OperationNotAllowedException("onSettingsChanged not set");
    }

    function draw(dc, now, force) {
        throw new Lang.OperationNotAllowedException("draw not set for " + toString());
    }
}
