package windows;

class TextWindow extends BaseWindow {
    public function new(x:Float, y:Float, width:Int, height:Int,
            handler:WindowHandler, assetPath:String) {
        super(x, y, width, height, handler);

        addContent(new TextWindowContent(this, BaseWindow.OFFSET_CONTENT_X,
            BaseWindow.OFFSET_CONTENT_Y, assetPath));
    }
}
