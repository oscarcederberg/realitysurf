package;

import flixel.FlxState;

class PlayState extends FlxState
{
	public var level:LevelMap;
	public var hud:HUD;

	override public function create()
	{
		this.bgColor = Global.RGB_BLACK;

		this.level = new LevelMap("level_dev.json");
		this.hud = new HUD();
		add(level.tiles);
		add(level.player);
		add(hud);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
