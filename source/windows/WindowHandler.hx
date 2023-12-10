package windows;

import files.*;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import haxe.ds.GenericStack;

class WindowHandler {
    public var random:FlxRandom;
    public var windows:FlxTypedSpriteGroup<BaseWindow>;
    public var stack:GenericStack<BaseWindow>;

    public function new() {
        this.random = new FlxRandom();
        this.windows = new FlxTypedSpriteGroup<BaseWindow>();
        this.stack = new GenericStack<BaseWindow>();
        this.windows.scrollFactor.set(0, 0);
    }

    public function update(elapsed:Float):Void {
        var _point:FlxPoint = FlxG.mouse.getPositionInCameraView();
        var _click:Bool = FlxG.mouse.justPressed;
        var _scroll:Int = FlxG.mouse.wheel;

        for (window in stack) {
            if (window.getWindowHitbox().overlapsPoint(_point)) {
                window.handleInput(_point, _click, _scroll);
                break;
            }
        }
    }

    public function sortWindows():Void {
        var index:Int = 0;
        for (window in stack) {
            window.depth = index;
            index++;
        }

        // NOTE: Is this necessary? Only one window is moved at a time.
        windows.members.sort(function(w1, w2) return w2.depth - w1.depth);
    }

    public function createWindow(file:BaseFile):Void {
        var windowWidth:Int = file.windowWidth;
        var windowHeight:Int = file.windowHeight;

        var maxWindowX = FlxG.width
            - BaseWindow.calculateWidthInPixels(windowWidth);
        var maxWindowY = FlxG.height
            - HUD.BAR_HEIGHT
            - BaseWindow.calculateHeightInPixels(windowHeight);

        var windowX:Int = random.int(0, maxWindowX);
        var windowY:Int = random.int(HUD.BAR_HEIGHT, maxWindowY);

        var window:BaseWindow = switch (file.fileType) {
        case Text:
            new TextWindow(windowX, windowY, windowWidth, windowHeight, this,
                Global.levelAssetsPath + file.fileData);
        case Image:
            new ImageWindow(windowX, windowY, windowWidth, windowHeight, this,
                Global.levelAssetsPath + file.fileData);
        }

        windows.add(window);
        stack.add(window);

        sortWindows();
    }

    public function deleteWindow(window:BaseWindow) {
        stack.remove(window);
        window.kill();

        sortWindows();
    }

    public function setWindowAsActive(window:BaseWindow) {
        stack.remove(window);
        stack.add(window);

        sortWindows();
    }

    public function isWindowActive(window:BaseWindow):Bool {
        return stack.first() == window;
    }
}
