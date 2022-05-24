package windows;

import utils.TextHandler;
import flixel.text.FlxText;
import lime.utils.Assets;

class TextWindowContent extends BaseWindowContent
{
	var lines:Array<String>;
	var charsPerLine:Int;
	var linesPerScreen:Int;
	
	public function new(parent:BaseWindow, relativeX:Int, relativeY:Int, assetPath:String)
	{
		super(parent, relativeX, relativeY);
		
		this.charsPerLine = parent.widthInTiles * 2;
		this.linesPerScreen = parent.heightInTiles * 2;

		var _textFormatter = new TextHandler(Assets.getText(assetPath));
		this.lines = _textFormatter.format(this.charsPerLine);
		
		makeGraphic(parent.widthInTiles * Global.CELL_SIZE, parent.heightInTiles * Global.CELL_SIZE, Global.RGB_GREEN);
		makeText();
	}

	function makeText():Void
	{
		for (i in 0...linesPerScreen) 
		{
			var text:FlxText = new FlxText(0, 0, 0, lines[i], 8);
			text.height = 8;
			text.color = Global.RGB_GREEN;
			text.setBorderStyle(FlxTextBorderStyle.OUTLINE, Global.RGB_BLACK);
			stamp(text, -3, i * 8);

			text.kill();
		}
	}
}