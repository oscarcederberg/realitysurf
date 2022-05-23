package windows;

class ImageWindowContent extends BaseWindowContent
{
	public function new(parent:BaseWindow, relativeX:Int, relativeY:Int, asset:String)
	{
		super(parent, relativeX, relativeY);
		
		loadGraphic(asset);
	}
}
