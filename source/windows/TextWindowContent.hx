package windows;

class TextWindowContent extends BaseWindowContent
{
	public function new(parent:BaseWindow, relativeX:Int, relativeY:Int, asset:String)
	{
		super(parent, relativeX, relativeY);
		
		makeGraphic(parent.widthInTiles * Global.CELL_SIZE, parent.heightInTiles * Global.CELL_SIZE, Global.RGB_GREEN);
	}
}
