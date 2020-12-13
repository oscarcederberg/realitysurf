package;

import flixel.FlxState;

class PlayState extends FlxState
{
	public var level:LevelMap;

	override public function create()
	{
		this.bgColor = Global.RGB_BLACK;

		this.level = new LevelMap("level_dev.json");
		add(level.tiles);
		add(level.player);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
