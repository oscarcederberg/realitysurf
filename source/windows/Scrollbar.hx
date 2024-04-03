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
    var currentSubstep:Int;
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
        } while (thumbLength < MIN_THUMB_LENGTH);

        this.maxStep = scrollbarLength - thumbLength;
        this.currentStep = 0;
        this.currentSubstep = 0;
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
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (currentState == Dragging) {
            handleDragging();
        }

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

    public function handleInput(point:FlxPoint, click:Bool, scroll:Int) {
        var _previousStep = currentStep;
        var _previousSubstep = currentSubstep;

        if (currentState != Dragging) {
            if (click && scrollbarHitbox.overlapsPoint(point)) {
                if (upHitbox.overlapsPoint(point)) {
                    currentSubstep--;
                } else if (downHitbox.overlapsPoint(point)) {
                    currentSubstep++;
                } else if (this.overlapsPoint(point)) {
                    currentSubstep = 0;
                    activateDragging(point);
                } else {
                    currentStep = Std.int((point.y - (parent.y + startY))
                        - (thumbLength / 2));
                }
            } else {
                currentSubstep -= scroll;
            }
        }
        if (currentSubstep < 0) {
            currentStep--;
            currentSubstep = rowsPerStep + currentSubstep;
        } else if (currentSubstep >= rowsPerStep) {
            currentStep++;
            currentSubstep = currentSubstep - rowsPerStep;
        }
        currentStep = Std.int(Math.min(maxStep, Math.max(0, currentStep)));
        relativeY = startY + currentStep;

        if (currentStep == 0 && currentSubstep < 0) {
            currentSubstep = 0;
        } else if (currentStep == maxStep) {
            currentSubstep = 0;
        }

        if (currentStep != _previousStep || currentSubstep != _previousSubstep) {
            window.notifyScrollUpdate(rowsPerStep * currentStep + currentSubstep);
        }
    }

    private function handleDragging():Void {
        var _mousePressed:Bool = FlxG.mouse.pressed;
        var _mousePoint:FlxPoint = FlxG.mouse.getScreenPosition();
        var _previousStep = currentStep;

        if (_mousePressed) {
            currentSubstep = 0;
            currentStep = Std.int((_mousePoint.y - (parent.y + startY))
                - mouseOffset.y);

            currentStep = Std.int(Math.min(maxStep, Math.max(0, currentStep)));
            relativeY = startY + currentStep;

            if (currentStep != _previousStep) {
                window.notifyScrollUpdate(rowsPerStep * currentStep + currentSubstep);
            }
        } else {
            currentState = Idle;
        }
    }
}
