package windows;

import flixel.text.FlxText;
import lime.utils.Assets;

class TextWindowContent extends BaseWindowContent
{
	var textString:String;
	
	public function new(parent:BaseWindow, relativeX:Int, relativeY:Int, assetPath:String)
	{
		super(parent, relativeX, relativeY);

		this.textString = Assets.getText(assetPath);
		
		makeGraphic(parent.widthInTiles * Global.CELL_SIZE, parent.heightInTiles * Global.CELL_SIZE, Global.RGB_GREEN);
		makeText();
	}

	function makeText():Void
	{
		var text:FlxText = new FlxText(0, 0, 0, textString, 8);
		text.color = Global.RGB_GREEN;
		text.setBorderStyle(FlxTextBorderStyle.OUTLINE, Global.RGB_BLACK);
		stamp(text, 0, 0);

		text.kill();
	}
}