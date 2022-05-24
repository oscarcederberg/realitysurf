package;

import utils.AttachableObject;
import flixel.FlxObject;

class Hitbox extends AttachableObject
{
	public function new(parent:FlxObject, relativeX:Int, relativeY:Int, width:Int, height:Int)
	{
		attach(parent, relativeX, relativeY);
		super(parent.x + relativeX, parent.y + relativeY, width, height);
	}

	override public function update(elapsed:Float):Void
	{
		updateAttachment();
	}
}
