package windows;

class TextWindow extends BaseWindow
{
	public function new(x:Float, y:Float, width:Int, height:Int, handler:WindowHandler, assetPath:String)
	{
		super(x, y, width, height, handler);
		
		this.content = new TextWindowContent(this, BaseWindow.OFFSET_CONTENT_X, BaseWindow.OFFSET_CONTENT_Y, assetPath);
		this.content.scrollFactor.set(0, 0);

		if(content.elements > content.elementsPerScreen)
		{
			var _x:Int = Std.int(Global.CELL_SIZE / 2) * (widthInTiles + 1) - BaseWindow.OFFSET_SIDE;
			var _y:Int = Std.int(Global.CELL_SIZE / 2) * (heightInTiles + 1) - BaseWindow.OFFSET_TOP;

			this.scrollbar = new Scrollbar(this, _x, _y, content.elementsPerScreen, content.elements);
		}
	}
}
