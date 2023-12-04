package windows;

class ImageWindow extends BaseWindow {
	public function new(x:Float, y:Float, width:Int, height:Int, handler:WindowHandler, assetPath:String) {
		super(x, y, width, height, handler);

		this.content = new ImageWindowContent(this, BaseWindow.OFFSET_CONTENT_X, BaseWindow.OFFSET_CONTENT_Y, assetPath);
		this.content.scrollFactor.set(0, 0);
	}
}
