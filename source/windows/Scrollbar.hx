package windows;

import flixel.math.FlxPoint;
import utils.Hitbox;
import utils.AttachableSprite;

class Scrollbar extends AttachableSprite
{
    var startY:Int;

    public var thumbHitbox:Hitbox;
 
    public var barLength:Int;
    public var thumbLength:Int;
    public var currentStep:Int;
    public var maxStep:Int;
    public var stepAmount:Int;
    
    var beingDragged:Bool;
	var mouseOffsetY:Int;

	public function new(parent:BaseWindow, x:Int, y:Int, elementsPerScreen:Int, elements:Int)
    {
        super(parent.x + x, parent.y + y);
        
        super.attach(parent, x, y);
        
        this.barLength = parent.heightInTiles * Global.CELL_SIZE;
        this.thumbLength = Math.floor((elementsPerScreen / elements) * barLength);
        this.maxStep = barLength - thumbLength + 1;
        this.stepAmount = Std.int((elements - elementsPerScreen) / (maxStep - 1));
        this.currentStep = 0;
        
        loadGraphic("assets/images/box/box_1_thumb.png");
        setGraphicSize(BaseWindow.SCROLL_WIDTH, thumbLength);
        this.startY = relativeY;
      
        this.thumbHitbox = new Hitbox(this, 0, 0, Std.int(this.width), Std.int(this.height));
        this.thumbHitbox.scrollFactor.set(0, 0);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        
        thumbHitbox.update(elapsed);
    }
	
    public function activateDragging():Void {}
	
    private function handleDragging():Void {}

	public function handleInput(point:FlxPoint, click:Bool, scroll:Int)
    {
        if (scroll < 0)
        {
            if (currentStep < maxStep)
            {
                currentStep++;
            }
        }
        else if (scroll > 0)
        {
            if (currentStep > 0)
            {
                currentStep--;
            }
        }

        relativeY = startY + currentStep;
    }
}