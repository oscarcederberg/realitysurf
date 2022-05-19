package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	var playButton:FlxButton;

	override public function create()
	{
		playButton = new FlxButton(0, 0, "PLAY", clickPlay);
		playButton.screenCenter(XY);
		add(playButton);

		super.create();
	}

	function clickPlay()
	{
		FlxG.switchState(new PlayState());
	}
}
