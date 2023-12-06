package windows;

import flixel.math.FlxPoint;
import utils.Hitbox;
import utils.AttachableSprite;

class Scrollbar extends AttachableSprite {
    var startY:Int;

    public var thumbHitbox:Hitbox;

    public var barLength:Int;
    public var thumbLength:Int;
    public var currentStep:Int;
    public var maxStep:Int;
    public var stepAmount:Int;

    var beingDragged:Bool;

    public function new(parent:BaseWindow, x:Int, y:Int, elementsPerScreen:Int, elements:Int) {
        this.barLength = parent.heightInTiles * Global.CELL_SIZE - 1;
        this.thumbLength = Math.ceil((elementsPerScreen / elements) * barLength);
        this.maxStep = barLength - thumbLength + 1;
        this.stepAmount = Std.int((elements - elementsPerScreen) / (maxStep - 1));
        this.currentStep = 0;

        super(parent.x + x, parent.y + y + thumbLength / 2);

        super.attach(parent, x, y + Std.int(thumbLength / 2));

        loadGraphic("assets/images/box/box_1_thumb.png");
        setGraphicSize(BaseWindow.SCROLL_WIDTH, thumbLength);
        this.startY = relativeY;

        this.thumbHitbox = new Hitbox(this, 0, 0, Std.int(this.width), Std.int(this.height));
        this.thumbHitbox.scrollFactor.set(0, 0);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        thumbHitbox.update(elapsed);
    }

    public function activateDragging():Void {}

    private function handleDragging():Void {}

    public function handleInput(point:FlxPoint, click:Bool, scroll:Int) {
        currentStep -= scroll;
        currentStep = Std.int(Math.min(maxStep, Math.max(0, currentStep)));

        relativeY = startY + currentStep;
    }
}
