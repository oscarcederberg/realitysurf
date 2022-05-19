package;

import flixel.system.FlxAssets;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		FlxAssets.FONT_DEFAULT = "assets/fonts/c64_mono.ttf";
		addChild(new FlxGame(512, 384, MenuState));
	}
}
