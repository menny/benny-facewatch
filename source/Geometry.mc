using Toybox.Math;
using Toybox.Graphics;

/**
 Draws thick rotated line

 dc - device context
 angle - rotation angle in degrees
 width - half of line width
 start, end - radial R coordinates of line
 cx, cy - rotation center coords
 */
function drawRadialRect(dc, angle, width, start, end, cx, cy, foregroundColor, shadowColor) {
    var sina = Math.sin(Math.toRadians(angle));
    var cosa = Math.cos(Math.toRadians(angle));

    var sx = start * sina;
    var sy = - start * cosa;
    var ex = end * sina;
    var ey = - end * cosa;
    
    var bottomStartX = cx + sx;
    var bottomStartY = cy + sy;
    var bottomEndX = cx + ex;
    var bottomEndY = cy + ey;
    
	dc.setPenWidth(width);

    //always a black line below (shadow)
    if (shadowColor != Graphics.COLOR_TRANSPARENT) {
		dc.setColor(shadowColor, Graphics.COLOR_TRANSPARENT);
		var shadowOffset = 1;
		dc.drawLine(bottomStartX + shadowOffset, bottomStartY + shadowOffset, bottomEndX + shadowOffset, bottomEndY + shadowOffset);
	}
	
	dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
	dc.drawLine(bottomStartX, bottomStartY, bottomEndX, bottomEndY);
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