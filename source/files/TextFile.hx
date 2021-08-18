package files;

class TextFile extends BaseFile
{
	public function new(x:Float, y:Float, values:Null<Dynamic>)
	{
		super(x, y, values);

		// GRAPHICS
		loadGraphic("assets/images/file.png", false, Global.CELL_SIZE, Global.CELL_SIZE);
	}
}
