package;

import flixel.FlxG;
import flixel.FlxSprite;

enum FileType
{
	Text;
}

class File extends FlxSprite
{
	var parent:PlayState;

	public var fileName:String;
	public var fileType:FileType;
	public var fileData:String;
	public var windowWidth:Int;
	public var windowHeight:Int;

	public function new(x:Float, y:Float, values:Null<Dynamic>)
	{
		super(x, y);

		this.parent = cast(FlxG.state);

		this.fileName = values.name;
		this.fileData = values.data;
		this.windowWidth = Std.parseInt(values.width);
		this.windowHeight = Std.parseInt(values.height);
		try
		{
			this.fileType = FileType.createByName(values.type);
		}
		catch (e)
		{
			this.fileType = FileType.Text;
		}

		loadGraphic("assets/images/file.png", false, Global.CELL_SIZE, Global.CELL_SIZE);
	}

	public function interact()
	{
		parent.createWindow(this);
	}
}
