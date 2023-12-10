package windows;

import flixel.system.FlxAssets;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.display.BitmapData;
import utils.Hitbox;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;

enum WindowState {
    Idle;
    Dragging;
}

enum WindowTile {
    TOP_LEFT;
    TOP_MIDDLE;
    TOP_RIGHT;
    TOP_RIGHT_SCROLL;
    MIDDLE_LEFT;
    MIDDLE_MIDDLE;
    MIDDLE_RIGHT;
    MIDDLE_RIGHT_SCROLL;
    BOTTOM_LEFT;
    BOTTOM_MIDDLE;
    BOTTOM_RIGHT;
    BOTTOM_RIGHT_SCROLL;
}

abstract class BaseWindow extends FlxSprite {
    // NOTE: Offsets based on the window graphics.
    public static inline final OFFSET_TOP:Int = 6;
    public static inline final OFFSET_SIDE:Int = 8;
    public static inline final OFFSET_BOTTOM:Int = 12;
    public static inline final OFFSET_BAR:Int = 7;
    public static inline final OFFSET_SCROLL_X:Int = 4;
    public static inline final OFFSET_CONTENT_X:Int = Global.CELL_SIZE
        - OFFSET_SIDE;
    public static inline final OFFSET_CONTENT_Y:Int = Global.CELL_SIZE
        - OFFSET_TOP;
    public static inline final SCROLL_SIDE:Int = 4;
    public static var bitmaps:haxe.ds.Map<WindowTile, BitmapData> = new Map();

    public var currentState:WindowState = Idle;
    public var depth:Int = 0;

    public var widthInTiles:Int;
    public var heightInTiles:Int;
    public var widthInPixels:Int;
    public var heightInPixels:Int;

    public var x0:Int;
    public var x1:Int;
    public var x2:Int;
    public var y0:Int;
    public var y1:Int;
    public var y2:Int;

    var handler:WindowHandler;

    var hasContent:Bool = false;
    var content:BaseWindowContent;

    var windowHitbox:Hitbox;
    var topbarHitbox:Hitbox;
    var closeHitbox:Hitbox;

    var hasScrollbar:Bool = false;
    var scrollbar:Scrollbar;

    var mouseOffset:FlxPoint;

    var openSound:FlxSound;
    var dragSound:FlxSound;
    var dropSound:FlxSound;
    var closeSound:FlxSound;

    public function new(x:Float, y:Float, width:Int, height:Int,
            handler:WindowHandler) {
        super(x, y);

        this.handler = handler;
        this.widthInTiles = width;
        this.heightInTiles = height;
        this.widthInPixels = calculateWidthInPixels(width);
        this.heightInPixels = calculateHeightInPixels(height);

        this.x0 = -OFFSET_SIDE;
        this.x1 = Global.CELL_SIZE - OFFSET_SIDE;
        this.x2 = Global.CELL_SIZE * (widthInTiles + 1) - OFFSET_SIDE;
        this.y0 = -OFFSET_TOP;
        this.y1 = Global.CELL_SIZE - OFFSET_TOP;
        this.y2 = Global.CELL_SIZE * (heightInTiles + 1) - OFFSET_TOP;

        makeWindowGraphic();

        this.windowHitbox = new Hitbox(this, 0, 0, widthInPixels,
            heightInPixels);
        this.topbarHitbox = new Hitbox(this, 0, 0, widthInPixels, OFFSET_BAR);
        this.closeHitbox = new Hitbox(this, widthInPixels - OFFSET_BAR, 0,
            OFFSET_BAR, OFFSET_BAR);
        this.windowHitbox.scrollFactor.set(0, 0);
        this.topbarHitbox.scrollFactor.set(0, 0);
        this.closeHitbox.scrollFactor.set(0, 0);

        this.openSound = FlxG.sound.load("assets/sounds/open.wav");
        this.dragSound = FlxG.sound.load("assets/sounds/drag.wav");
        this.dropSound = FlxG.sound.load("assets/sounds/drop.wav");
        this.closeSound = FlxG.sound.load("assets/sounds/close.wav");

        openSound.play();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (currentState == WindowState.Dragging) {
            if (!handler.isWindowActive(this)) {
                handler.setWindowAsActive(this);
            }

            handleDragging();
        }

        x = Math.min(Math.max(x, 0), FlxG.width - widthInPixels);
        y = Math.min(Math.max(y, Global.CELL_SIZE),
            FlxG.height - Global.CELL_SIZE - heightInPixels);

        if (hasContent) {
            content.update(elapsed);
        }
        if (hasScrollbar) {
            scrollbar.update(elapsed);
        }

        windowHitbox.update(elapsed);
        topbarHitbox.update(elapsed);
        closeHitbox.update(elapsed);
    }

    override public function draw():Void {
        super.draw();
        if (hasContent) {
            content.draw();
        }
        if (hasScrollbar) {
            scrollbar.draw();
        }
    }

    override public function kill():Void {
        closeSound.play();

        super.kill();
        windowHitbox.kill();
        topbarHitbox.kill();
        closeHitbox.kill();
        if (hasScrollbar) {
            scrollbar.kill();
        }
        if (hasContent) {
            content.kill();
        }
    }

    public function addContent(content:BaseWindowContent):Void {
        hasContent = true;
        this.content = content;
        content.scrollFactor.set(0, 0);

        if (content.numRows > content.rowsPerScreen) {
            addScrollbar();
        }
    }

    public function addScrollbar():Void {
        hasScrollbar = true;

        stampTile(TOP_RIGHT_SCROLL);
        stampTile(MIDDLE_RIGHT_SCROLL);
        stampTile(BOTTOM_RIGHT_SCROLL);

        scrollbar = new Scrollbar(this, x2 + OFFSET_SCROLL_X, y1,
            content.rowsPerScreen, content.numRows);
        scrollbar.scrollFactor.set(0, 0);
    }

    public function activateDragging():Void {
        dragSound.play();

        var _mousePoint:FlxPoint = FlxG.mouse.getScreenPosition();

        mouseOffset = _mousePoint.subtract(x, y);
        currentState = WindowState.Dragging;
    }

    public function getWindowHitbox():Hitbox {
        return windowHitbox;
    }

    private function handleDragging():Void {
        var _mousePressed:Bool = FlxG.mouse.pressed;
        var _mousePoint:FlxPoint = FlxG.mouse.getScreenPosition();

        if (_mousePressed) {
            var _newPosition = _mousePoint.subtractPoint(mouseOffset);
            setPosition(_newPosition.x, _newPosition.y);
        } else {
            dropSound.play();
            currentState = WindowState.Idle;
        }
    }

    public function handleInput(point:FlxPoint, click:Bool, pressing:Bool,
            scroll:Int):Void {
        if (closeHitbox.overlapsPoint(point)) {
            if (click) {
                handler.deleteWindow(this);
            }
        } else if (topbarHitbox.overlapsPoint(point)) {
            if (click) {
                activateDragging();
                if (!handler.isWindowActive(this)) {
                    handler.setWindowAsActive(this);
                }
            }
        } else {
            if (click) {
                if (!handler.isWindowActive(this)) {
                    handler.setWindowAsActive(this);
                }
            }

            if (hasContent) {
                content.handleInput(point, click, scroll);
            }

            if (hasScrollbar) {
                scrollbar.handleInput(point, click, pressing, scroll);
            }
        }
    }

    public function notifyScrollUpdate(step:Int):Void {
        if (hasContent) {
            content.notifyScrollUpdate(step);
        }
    }

    private function makeWindowGraphic() {
        makeGraphic(widthInPixels, heightInPixels, FlxColor.TRANSPARENT);

        for (tile in WindowTile.createAll()) {
            switch (tile) {
            case TOP_RIGHT_SCROLL | MIDDLE_RIGHT_SCROLL | BOTTOM_RIGHT_SCROLL:
                // do nothing
            default:
                stampTile(tile);
            }
        }
    }

    private function stampTile(tile:WindowTile) {
        var _point = new Point();

        _point.x = switch (tile) {
        case TOP_LEFT | MIDDLE_LEFT | BOTTOM_LEFT:
            x0;
        case TOP_MIDDLE | MIDDLE_MIDDLE | BOTTOM_MIDDLE:
            x1;
        case TOP_RIGHT | TOP_RIGHT_SCROLL | MIDDLE_RIGHT |
            MIDDLE_RIGHT_SCROLL | BOTTOM_RIGHT | BOTTOM_RIGHT_SCROLL:
            x2;
        }

        _point.y = switch (tile) {
        case TOP_LEFT | TOP_MIDDLE | TOP_RIGHT | TOP_RIGHT_SCROLL:
            y0;
        case MIDDLE_LEFT | MIDDLE_MIDDLE | MIDDLE_RIGHT | MIDDLE_RIGHT_SCROLL:
            y1;
        case BOTTOM_LEFT | BOTTOM_MIDDLE | BOTTOM_RIGHT | BOTTOM_RIGHT_SCROLL:
            y2;
        }

        switch (tile) {
        case TOP_LEFT | TOP_RIGHT | TOP_RIGHT_SCROLL | BOTTOM_LEFT |
            BOTTOM_RIGHT | BOTTOM_RIGHT_SCROLL:
            this.graphic.bitmap.copyPixels(bitmaps[tile], bitmaps[tile].rect,
                _point);
        case TOP_MIDDLE | BOTTOM_MIDDLE:
            var _matrix = new Matrix(widthInTiles, 0, 0, 1, _point.x, _point.y);
            this.graphic.bitmap.draw(bitmaps[tile], _matrix);
        case MIDDLE_LEFT | MIDDLE_RIGHT | MIDDLE_RIGHT_SCROLL:
            var _matrix = new Matrix(1, 0, 0, heightInTiles, _point.x,
                _point.y);
            this.graphic.bitmap.draw(bitmaps[tile], _matrix);
        case MIDDLE_MIDDLE:
            var _matrix = new Matrix(widthInTiles, 0, 0, heightInTiles,
                _point.x, _point.y);
            this.graphic.bitmap.draw(bitmaps[tile], _matrix);
        }
    }

    public static function calculateHeightInPixels(heigthTiles:Int):Int {
        return Global.CELL_SIZE * (heigthTiles + 2)
            - BaseWindow.OFFSET_TOP
            - BaseWindow.OFFSET_BOTTOM;
    }

    public static function calculateWidthInPixels(widthTiles:Int):Int {
        return Global.CELL_SIZE * (widthTiles + 2)
            - (2 * BaseWindow.OFFSET_SIDE);
    }

    public static function loadAllTileAssets() {
        for (_tile in WindowTile.createAll()) {
            var _name = _tile.getName().toLowerCase();
            var _split = _name.indexOf("_");

            var _asset = switch (_tile) {
            case TOP_RIGHT_SCROLL | MIDDLE_RIGHT_SCROLL | BOTTOM_RIGHT_SCROLL:
                'assets/images/box/box_1_${_name.substring(0, 1)}${_name.substring(_split + 1, _split + 2)}_scroll.png';
            default:
                'assets/images/box/box_1_${_name.substring(0, 1)}${_name.substring(_split + 1, _split + 2)}.png';
            }

            bitmaps[_tile] = FlxAssets.getBitmapData(_asset);
        }
    }
}
