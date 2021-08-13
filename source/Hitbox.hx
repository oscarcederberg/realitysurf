import flixel.FlxObject;
import flixel.FlxSprite;

class Hitbox extends FlxObject
{
	var parent:FlxSprite;
	var relativeX:Int;
	var relativeY:Int;

	public function new(parent:FlxSprite, relativeX:Int, relativeY:Int, width:Int, height:Int)
	{
		this.parent = parent;
		this.relativeX = relativeX;
		this.relativeY = relativeY;
		super(parent.x + relativeX, parent.y + relativeY, width, height);
	}

	override public function update(elapsed:Float):Void
	{
		setPosition(parent.x + relativeX, parent.y + relativeY);
	}
}
