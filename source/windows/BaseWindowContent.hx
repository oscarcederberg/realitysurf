package windows;

import flixel.FlxSprite;

abstract class BaseWindowContent extends FlxSprite
{
	var parent:BaseWindow;
	var relativeX:Int;
	var relativeY:Int;

	public function new(parent:BaseWindow, relativeX:Int, relativeY:Int)
	{
		this.parent = parent;
		this.relativeX = relativeX;
		this.relativeY = relativeY;

		super(parent.x + relativeX, parent.y + relativeY);
	}

	override public function update(elapsed:Float):Void
	{
		setPosition(parent.x + relativeX, parent.y + relativeY);
	}
}
