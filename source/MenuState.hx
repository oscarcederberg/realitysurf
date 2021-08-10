package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	var playButton:FlxButton;

	override public function create()
	{
		playButton = new FlxButton(0, 8 * 192 / 16, "REALITYSURF", clickPlay);
		playButton.screenCenter(X);
		add(playButton);

		super.create();
	}

	function clickPlay()
	{
		FlxG.switchState(new PlayState());
	}
}
