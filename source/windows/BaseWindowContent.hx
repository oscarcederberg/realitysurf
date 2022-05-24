package windows;

import utils.AttachableSprite;

abstract class BaseWindowContent extends AttachableSprite
{
	public function new(parent:BaseWindow, relativeX:Int, relativeY:Int)
	{
		attach(parent, relativeX, relativeY);
		super(parent.x + relativeX, parent.y + relativeY);
	}

	override public function update(elapsed:Float):Void
	{
		updateAttachment();
	}
}
