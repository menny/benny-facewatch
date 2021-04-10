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
	ColorsSchemeType_Black_Blues_Blues = 1,
	ColorsSchemeType_DkGray_Blues_Whites,
}

/*pattern: background _ main-color _ accent*/
const BLACK_BLUES_BLUES = new ColorsSchemeData(
	0x000011,
	0x00AAFF, 0x0000FF, 0x000066,
	0xAAAAFF, 0x8888FF, 0x7777CC);

const DKGRAY_BLUES_WHITES = new ColorsSchemeData(
	0x333333,
	0xAAAAFF, 0x8888DD, 0x333366,
	0xAAAAFF, 0x8888FF, 0x7777CC);
		
function getColorsScheme() {
	var type = Application.getApp().getProperty("ColorsSchemeType");
	switch(type) {
		case ColorsSchemeType_Black_Blues_Blues:
			return BLACK_BLUES_BLUES;
		case ColorsSchemeType_DkGray_Blues_Whites:
			return DKGRAY_BLUES_WHITES;
		default:
			throw new Lang.InvalidValueException("Unknown color-scheme-type " + type);
	}
}