using Toybox.Math;
/**
 Draws thick rotated line

 dc - device context
 angle - rotation angle in degrees
 width - half of line width
 start, end - radial R coordinates of line
 cx, cy - rotation center coords
 */
function drawRadialRect(dc, angle, width, start, end, cx, cy) {
    var sina = Math.sin(Math.toRadians(angle));
    var cosa = Math.cos(Math.toRadians(angle));
    var dx = width * cosa;
    var dy = width * sina;

    var sx = start * sina;
    var sy = - start * cosa;
    var ex = end * sina;
    var ey = - end * cosa;
    dc.fillPolygon([
       [cx + sx + dx, cy + sy + dy],
       [cx + sx - dx, cy + sy - dy],
       [cx + ex - dx, cy + ey - dy],
       [cx + ex + dx, cy + ey + dy]
    ]);
}

/*
Get X coordinate from radius and angle.
*/
function calcRadialX(cx, r, a) {
    return cx + r * Math.sin(Math.toRadians(a));
}
/*
Get Y coordinate from radius and angle.
*/
function calcRadialY(cy, r, a) {
    return cy - r * Math.cos(Math.toRadians(a));
}