using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Graphics;

class ViewBox {
    var x;
    var y;
    var width;
    var height;
    function initialize(x, y, width, height) {
        self.x = x.toNumber();
        self.y = y.toNumber();
        self.width = width.toNumber();
        self.height = height.toNumber();
    }
}

class StatusViewBase extends ChildViewBase {

    protected var _viewBox;
    protected var _visible = false;

    function initialize(minTimeBetweenDraws) {
        ChildViewBase.initialize(minTimeBetweenDraws);
        _viewBox = getViewBox();
    }

    function onSettingsChanged(app, sleeping, inDndMode) {
        var newVisible = app.getProperty(getVisiblePrefId()) && getVisibleForDndState(inDndMode);
        if (newVisible != _visible) {
            onVisibilityChanged(newVisible);
        }
    }

    protected function onVisibilityChanged(visible) {
        _visible = visible;
    }

    protected function getViewBox() {
        throw new Lang.OperationNotAllowedException("getViewBox not set");
    }

    protected function getVisiblePrefId() {
        throw new Lang.OperationNotAllowedException("visible pref id not set");
    }

    protected function getVisibleForDndState(inDndMode) {
        throw new Lang.OperationNotAllowedException("getVisibleForDndState not set");
    }

    function draw(dc, now, force) {
        ChildViewBase.draw(dc, now, force);
    }

    protected function checkIfUpdateRequired(now, force) {
        throw new Lang.OperationNotAllowedException("checkIfUpdateRequired not set");
    }
}

class StatusDcViewBase extends StatusViewBase {

    private var _bitmap;

    function initialize(minTimeBetweenDraws) {
        StatusViewBase.initialize(minTimeBetweenDraws);
    }

    protected function onVisibilityChanged(visible) {
        StatusViewBase.onVisibilityChanged(visible);
        if (visible) {
            //allocating the draw-on bitmap
            _bitmap = new Graphics.BufferedBitmap({
                :width => _viewBox.width,
                :height => _viewBox.height
            });
        } else {
            //releasing memory
            _bitmap = null;
        }
    }

    protected function onDrawNow(dc) {
        throw new Lang.OperationNotAllowedException("onDrawNow id not set");
    }

    function draw(dc, now, force) {
        StatusViewBase.draw(dc, now, force);
        if (_visible) {
            var actualDc = _bitmap.getDc();
            if (checkIfUpdateRequired(now, force)) {
                actualDc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
                actualDc.clear();
                onDrawNow(actualDc);
            }
            dc.drawBitmap(_viewBox.x, _viewBox.y, _bitmap);
        }
    }
}
