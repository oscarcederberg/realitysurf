package windows;

import flixel.util.FlxColor;
import utils.TextHandler;
import flixel.text.FlxText;
import lime.utils.Assets;

class TextWindowContent extends BaseWindowContent {
	public static inline final OFFSET_SIDE = 2;
	public static inline final OFFSET_TOP = 3;
	public static inline final OFFSET_BOTTOM = 4;

	public var lines:Array<String>;
	public var charsPerLine:Int;

	public function new(parent:BaseWindow, relativeX:Int, relativeY:Int, assetPath:String) {
		super(parent, relativeX - OFFSET_SIDE, relativeY - OFFSET_TOP);

		this.charsPerLine = parent.widthInTiles * 2;
		this.elementsPerScreen = parent.heightInTiles * 2 - 1;

		var _textFormatter = new TextHandler(Assets.getText(assetPath));
		this.lines = _textFormatter.format(this.charsPerLine);
		this.elements = this.lines.length;

		makeGraphic(parent.widthInTiles * Global.CELL_SIZE
			+ 2 * OFFSET_SIDE, parent.heightInTiles * Global.CELL_SIZE
			+ OFFSET_TOP
			+ OFFSET_BOTTOM,
			FlxColor.TRANSPARENT);
		makeText();
	}

	function makeText():Void {
		for (i in 0...elementsPerScreen) {
			var text:FlxText = new FlxText(0, 0, 0, lines[i], 8);
			text.height = 8;
			text.color = Global.RGB_GREEN;
			text.setBorderStyle(FlxTextBorderStyle.OUTLINE, Global.RGB_BLACK);
			stamp(text, -3 + OFFSET_SIDE, i * 8 + OFFSET_TOP);

			text.kill();
		}
	}
}
