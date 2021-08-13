package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	public var level:LevelMap;

	public var windowHandler:FileWindowHandler;
	public var hud:HUD;

	override public function create()
	{
		this.bgColor = Global.RGB_BLACK;
		this.level = new LevelMap("level_dev.json");
		this.hud = new HUD();
		this.windowHandler = new FileWindowHandler();

		FlxG.camera.follow(level.player, LOCKON, 0.1);
		FlxG.camera.snapToTarget();

		add(level.tiles);
		add(level.files);
		add(level.player);
		add(windowHandler.windows);
		add(hud);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		windowHandler.update(elapsed);

		super.update(elapsed);
	}

	public function createWindow(file:File)
	{
		windowHandler.createWindow(file);
	}
}
