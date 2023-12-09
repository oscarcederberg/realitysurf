package windows;

import flixel.math.FlxPoint;
import utils.AttachableSprite;

abstract class BaseWindowContent extends AttachableSprite {
    public var currentElement:Int = 0;
    public var numRows:Int;
    public var rowsPerScreen:Int;

    var window:BaseWindow;

    public function new(parent:BaseWindow, relativeX:Int, relativeY:Int) {
        super(parent.x + relativeX, parent.y + relativeY);

        this.window = parent;

        attach(parent, relativeX, relativeY);
    }

    public function handleInput(point:FlxPoint, click:Bool, scroll:Int):Void {}

    public function notifyScrollUpdate(step:Int):Void {}
}
