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

	public function new(x:Float, y:Float, name:String = "", type:FileType = FileType.Text, data:String = "", width:Int = 1, height:Int = 1)
	{
		super(x, y);

		this.fileName = name;
		this.fileType = type;
		this.fileData = data;
		this.windowHeight = height;
		this.windowWidth = width;
	}
}
