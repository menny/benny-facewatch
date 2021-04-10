using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

class ColorsSchemeData {
	var backgroundColor;
	var majorWatchTickColor;
	var minorWatchTickColor;
	var microWatchTickColor;
	var hoursHandColor;
	var minutesHandColor;
	var secondsHandColor;
	
	function initialize(backgroundColor,
		majorWatchTickColor, minorWatchTickColor, microWatchTickColor,
		hoursHandColor, minutesHandColor, secondsHandColor) {
		self.backgroundColor = backgroundColor;
		self.majorWatchTickColor = majorWatchTickColor;
		self.minorWatchTickColor = minorWatchTickColor;
		self.microWatchTickColor = microWatchTickColor;
		self.hoursHandColor = hoursHandColor;
		self.minutesHandColor = minutesHandColor;
		self.secondsHandColor = secondsHandColor;
	}
}

enum {
	ColorsSchemeType_Blues = 1,
	ColorsSchemeType_Reds,
	ColorsSchemeType_Greens,
	ColorsSchemeType_Whites,
}

const BLUES = new ColorsSchemeData(
	0x000011,
	0x00AAFF, 0x0000FF, 0x000066,
	0xAAAAFF, 0x8888FF, 0x7777CC);
	
function getColorsScheme() {
	var type = Application.getApp().getProperty("ColorsSchemeType");
	switch(type) {
		case ColorsSchemeType_Blues:
			return BLUES;
		default:
			throw new Lang.InvalidValueException("Unknown color-scheme-type " + type);
	}
}