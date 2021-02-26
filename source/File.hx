package;

import flixel.FlxSprite;

enum FileType
{
	Text;
}

class File extends FlxSprite
{
	public var fileName:String;
	public var fileType:FileType;
	public var fileData:String;
	public var windowWidth:Int;
	public var windowHeight:Int;

	public function new(x:Float, y:Float, values:Xml)
	{
		super(x, y);

		this.fileName = values.get("name");
		this.fileType = FileType.createByName(values.get("type"));
		this.fileData = values.get("data");
		this.windowWidth = Std.parseInt(values.get("width"));
		this.windowHeight = Std.parseInt(values.get("height"));

		loadGraphic("assets/images/file.png", false, Global.CELL_SIZE, Global.CELL_SIZE);
	}
}
