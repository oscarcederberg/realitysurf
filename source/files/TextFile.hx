package files;

import files.FileFactory.FileType;

class TextFile extends BaseFile
{
	var fileType:FileType;

	public function new(x:Float, y:Float, values:Null<Dynamic>)
	{
		super(x, y, values);

		this.fileType = FileType.Text;

		// GRAPHICS
		loadGraphic("assets/images/file.png", false, Global.CELL_SIZE, Global.CELL_SIZE);
	}
}
