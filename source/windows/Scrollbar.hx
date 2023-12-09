package windows;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import utils.Hitbox;
import utils.AttachableSprite;

enum ScrollbarState {
    Idle;
    Dragging;
}

class Scrollbar extends AttachableSprite {
    public static inline final MIN_THUMB_LENGTH = 4;

    var currentState:ScrollbarState = Idle;

    var mouseOffset:FlxPoint;
    var startY:Int;
    var scrollbarLength:Int;
    var thumbLength:Int;
    var currentStep:Int;
    var maxStep:Int;
    var rowsPerStep:Int;

    var scrollbarHitbox:Hitbox;
    var upHitbox:Hitbox;
    var downHitbox:Hitbox;

    var window:BaseWindow;

    public function new(parent:BaseWindow, relativeX:Int, relativeY:Int,
            rowsPerScreen:Int, numRows:Int) {
        this.scrollbarLength = Global.CELL_SIZE * parent.heightInTiles;

        this.rowsPerStep = 0;
        do {
            rowsPerStep++;
            this.thumbLength = Std.int(scrollbarLength
                - (numRows - rowsPerScreen) / rowsPerStep);
            trace('$thumbLength = $scrollbarLength - ($numRows - $rowsPerScreen) / $rowsPerStep');
        } while (thumbLength < MIN_THUMB_LENGTH);

        this.maxStep = scrollbarLength - thumbLength;
        this.currentStep = 0;
        this.window = parent;

        super(parent.x + relativeX, parent.y + relativeY);

        attach(parent, relativeX, relativeY);
        this.startY = this.relativeY;

        loadGraphic("assets/images/box/box_1_thumb.png");
        setGraphicSize(BaseWindow.SCROLL_SIDE, thumbLength);
        updateHitbox();

        this.scrollbarHitbox = new Hitbox(parent, relativeX,
            relativeY - BaseWindow.SCROLL_SIDE, BaseWindow.SCROLL_SIDE,
            BaseWindow.SCROLL_SIDE * 2 +
            Global.CELL_SIZE * parent.heightInTiles);
        this.upHitbox = new Hitbox(parent, relativeX,
            relativeY - BaseWindow.SCROLL_SIDE, BaseWindow.SCROLL_SIDE,
            BaseWindow.SCROLL_SIDE);
        this.downHitbox = new Hitbox(parent, relativeX,
            relativeY + scrollbarLength, BaseWindow.SCROLL_SIDE,
            BaseWindow.SCROLL_SIDE);
        this.scrollbarHitbox.scrollFactor.set(0, 0);
        this.upHitbox.scrollFactor.set(0, 0);
        this.downHitbox.scrollFactor.set(0, 0);

        trace('ROWSPERSTEP: $rowsPerStep');
        trace('SCROLLBAR: $scrollbarLength');
        trace('THUMB: $thumbLength');
        trace('ITEMS: $numRows');
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        scrollbarHitbox.update(elapsed);
        upHitbox.update(elapsed);
        downHitbox.update(elapsed);
    }

    override public function kill():Void {
        super.kill();
        scrollbarHitbox.kill();
        upHitbox.kill();
        downHitbox.kill();
    }

    public function activateDragging(point:FlxPoint):Void {
        mouseOffset = new FlxPoint(point.x - x, point.y - y);
        currentState = Dragging;
    }

    public function getScrollbarHitbox():Hitbox {
        return scrollbarHitbox;
    }

    public function handleInput(point:FlxPoint, click:Bool, pressing:Bool,
            scroll:Int) {
        var _previousStep = currentStep;

        if (currentState != Dragging) {
            if (click && scrollbarHitbox.overlapsPoint(point)) {
                if (upHitbox.overlapsPoint(point)) {
                    currentStep--;
                } else if (downHitbox.overlapsPoint(point)) {
                    currentStep++;
                } else if (this.overlapsPoint(point)) {
                    activateDragging(point);
                } else {
                    currentStep = Std.int((point.y - (parent.y + startY))
                        - (thumbLength / 2));
                }
            } else {
                currentStep -= scroll;
            }
        }

        if (currentState == Dragging) {
            if (!pressing) {
                currentState = Idle;
            } else {
                currentStep = Std.int((point.y - (parent.y + startY))
                    - mouseOffset.y);
            }
        }

        currentStep = Std.int(Math.min(maxStep, Math.max(0, currentStep)));
        relativeY = startY + currentStep;

        if (currentStep != _previousStep) {
            trace('STEP: ${rowsPerStep * currentStep}');
            window.notifyScrollUpdate(rowsPerStep * currentStep);
        }
    }
}
