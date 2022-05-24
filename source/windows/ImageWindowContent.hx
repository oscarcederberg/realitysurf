package windows;

class ImageWindowContent extends BaseWindowContent
{
	public function new(parent:BaseWindow, relativeX:Int, relativeY:Int, assetPath:String)
	{
		super(parent, relativeX, relativeY);
		
		loadGraphic(assetPath);
	}
}
