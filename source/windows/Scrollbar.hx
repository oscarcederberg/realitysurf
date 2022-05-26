package windows;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import utils.Hitbox;
import openfl.utils.IAssetCache;
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
        
        this.startY = relativeY;
        this.barLength = parent.heightInTiles * Global.CELL_SIZE;
        this.thumbLength = Math.floor((elementsPerScreen / elements) * barLength);
        this.maxStep = barLength - thumbLength + 1;
        this.stepAmount = Std.int((elements - elementsPerScreen) / (maxStep - 1));
        this.currentStep = 0;
        
        loadGraphic("assets/images/box/box_1_thumb.png");
        setGraphicSize(1, this.thumbLength);
        
        this.thumbHitbox = new Hitbox(this, 0, 0, Std.int(width), this.thumbLength);
        this.thumbHitbox.scrollFactor.set(0, 0);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        
        thumbHitbox.update(elapsed);
    }

    override function kill() {
        super.kill();
    }
	
    public function activateDragging():Void
	{
		var _mousePoint:FlxPoint = FlxG.mouse.getScreenPosition();

        beingDragged = true;
		mouseOffsetY = Std.int(_mousePoint.y - y);
	}
	
    private function handleDragging():Void
	{
		var _mousePressed:Bool = FlxG.mouse.pressed;
		var _mousePoint:FlxPoint = FlxG.mouse.getScreenPosition();

		if (_mousePressed)
		{
            y = Std.int(_mousePoint.y - mouseOffsetY);
            
            if (y < 0)
                y = 0;
            else if (y > maxStep)
                y = maxStep;
        }
		else
		{
            beingDragged = false;
		}
	}

	public function handleInput(point:FlxPoint, click:Bool, scroll:Int)
    {
        // if (click)
        // {
        //     if (this.thumbHitbox.overlapsPoint(point))
        //     {
        //         activateDragging();
        //     }
        //     else
        //     {
        //         y = Std.int(point.y - this.y);
                
        //         if (y < 0)
        //             y = 0;
        //         else if (y > maxStep)
        //             y = maxStep;
        //     }
        // }
        
        if (scroll > 0)
        {
            if (currentStep < maxStep)
            {
                currentStep++;
            }
        }
        else if (scroll < 0)
        {
            if (currentStep > 0)
            {
                currentStep--;
            }
        }

        relativeY = startY + currentStep;
    }
}