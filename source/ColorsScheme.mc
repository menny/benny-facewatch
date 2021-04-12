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
	
	var dateBackgroundColor;
	var dateTextColor;
	var dateBorderColor;
	
	function initialize(colorsArray/*there is a limit on the number of arguments in a method*/) {
		var colorIndex = 0; 
		self.backgroundColor = colorsArray[colorIndex];
		colorIndex++;
		self.majorWatchTickColor = colorsArray[colorIndex];
		colorIndex++;
		self.minorWatchTickColor = colorsArray[colorIndex];
		colorIndex++;
		self.microWatchTickColor = colorsArray[colorIndex];
		colorIndex++;
		self.hoursHandColor = colorsArray[colorIndex];
		colorIndex++;
		self.minutesHandColor = colorsArray[colorIndex];
		colorIndex++;
		self.secondsHandColor = colorsArray[colorIndex];
		colorIndex++;
		self.dateBackgroundColor = colorsArray[colorIndex];
		colorIndex++;
		self.dateTextColor = colorsArray[colorIndex];
		colorIndex++;
		self.dateBorderColor = colorsArray[colorIndex];
	}
}

enum {
	ColorsSchemeType_Black_Blues_Blues = 1,
	ColorsSchemeType_DkGray_Blues_Whites,
}

/*pattern: background _ main-color _ accent*/
const BLACK_BLUES_BLUES = new ColorsSchemeData(
	[0x000011,
	0x00AAFF, 0x0000FF, 0x000066,
	0xAAAAFF, 0x8888FF, 0x7777CC,
	0x1818148, 0x4444DD, 0x4444DD]);

const DKGRAY_BLUES_WHITES = new ColorsSchemeData(
	[0x333333,
	0xAAAAFF, 0x8888DD, 0x333366,
	0xAAAAFF, 0x8888FF, 0x7777CC,
	0x222258, 0x4444DD, 0xCCCCCC]);
		
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