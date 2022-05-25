package windows;

import openfl.utils.IAssetCache;
import utils.AttachableSprite;

class Scrollbar extends AttachableSprite
{
    public var barLength:Int;
    public var thumbLength:Int;
    public var currentStep:Int;
    public var maxStep:Int;
    public var stepAmount:Int;

	public function new(parent:BaseWindow, x:Int, y:Int, elementsPerScreen:Int, elements:Int)
    {
        super(x, y);
        
        super.attach(parent, x, y);
        
        this.barLength = parent.heightInTiles * Global.CELL_SIZE;
        this.thumbLength = Math.floor((elementsPerScreen / elements) * barLength);
        this.maxStep = barLength - thumbLength + 1;
        this.stepAmount = Std.int((elements - elementsPerScreen) / (maxStep - 1));
        this.currentStep = 0;
        
        loadGraphic("assets/images/box/box_1_thumb.png");
        scale.set(1, thumbLength);
    }
}