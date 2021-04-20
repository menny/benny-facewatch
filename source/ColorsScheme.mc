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
	
	var goalBackgroundColor;
	var goalFillColor;
	var goalExtraFillColor;
	var goalTextColor;
	
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
		self.dateBorderColor = colorsArray[colorIndex];
		colorIndex++;
		self.dateTextColor = colorsArray[colorIndex];
		colorIndex++;
		self.goalBackgroundColor = colorsArray[colorIndex];
		colorIndex++;
		self.goalFillColor = colorsArray[colorIndex];
		colorIndex++;
		self.goalExtraFillColor = colorsArray[colorIndex];
		colorIndex++;
		self.goalTextColor = colorsArray[colorIndex];		
	}
}

enum {
	ColorsSchemeType_Black_Blues_Blues = 1,
	ColorsSchemeType_DkGray_Blues_Whites,
}

//RGB222:
//00,55,AA,FF
/*pattern: background _ main-color _ accent*/
const BLACK_BLUES_BLUES = new ColorsSchemeData(
	[0x000000,//bk
	0x00AAFF, 0x0000FF, 0x0000AA,//ticks
	0xAAAAFF, 0x55AAFF, 0x5555AA,//hands
	0x000055, 0x5555AA, 0x5555FF,//date
	0x0000AA, 0x5555AA, 0x5555FF, 0x5555FF]);//goal

const DKGRAY_BLUES_WHITES = new ColorsSchemeData(
	[0x333333,
	0xAAAAFF, 0x8888DD, 0x333366,
	0xAAAAFF, 0x8888FF, 0x7777CC,
	0x222258, 0x4444DD, 0xCCCCCC,
	0x000088, 0x4444FF, 0xAAAAFF, 0xFFFFFF]);
		
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