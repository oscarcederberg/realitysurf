package windows;

import flixel.math.FlxPoint;
import utils.AttachableSprite;

abstract class BaseWindowContent extends AttachableSprite {
	public var elements:Int;
	public var elementsPerScreen:Int;

	public function new(parent:BaseWindow, relativeX:Int, relativeY:Int) {
		super(parent.x + relativeX, parent.y + relativeY);

		attach(parent, relativeX, relativeY);
	}

	public function handleInput(point:FlxPoint, click:Bool, scroll:Int):Void {}
}
