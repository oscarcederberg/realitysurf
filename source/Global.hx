package;

import flixel.util.FlxColor;

// NOTE: Is there a cleaner way to handle this?
class Global {
	public static inline final CELL_SIZE:Int = 16;

	public static final RGB_GREEN:FlxColor = FlxColor.fromRGB(99, 196, 70, 255);
	public static final RGB_BLACK:FlxColor = FlxColor.fromRGB(32, 32, 32, 255);

	public static var stepsTaken:Int = 0;
	public static var levelAssetsPath:String = "blah";
}
