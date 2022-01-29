package windows;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxSliceSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

enum FileWindowState
{
	Idle;
	Dragging;
}

class BaseWindow extends FlxSliceSprite
{
	public static inline final OFFSET_TOP:Int = 6;
	public static inline final OFFSET_SIDE:Int = 9;
	public static inline final OFFSET_BOTTOM:Int = 11;
	public static inline final OFFSET_BAR:Int = 7;

	public var depth:Int;
	public var currentState:FileWindowState;

	public var hitboxWindow:Hitbox;
	public var hitboxBar:Hitbox;
	public var hitboxClose:Hitbox;

	var handler:WindowHandler;

	var widthInTiles:Int;
	var heightInTiles:Int;
	var widthInPixels:Int;
	var heightInPixels:Int;

	var mouseOffsetX:Int;
	var mouseOffsetY:Int;

	var openSound:FlxSound;
	var dragSound:FlxSound;
	var dropSound:FlxSound;
	var closeSound:FlxSound;

	public function new(x:Float, y:Float, width:Int, height:Int, handler:WindowHandler)
	{
		this.depth = 0;
		this.currentState = FileWindowState.Idle;
		this.mouseOffsetX = 0;
		this.mouseOffsetY = 0;

		this.handler = handler;
		this.widthInTiles = width;
		this.heightInTiles = height;
		this.widthInPixels = Global.CELL_SIZE * (width + 2) - (OFFSET_SIDE * 2);
		this.heightInPixels = Global.CELL_SIZE * (height + 2) - (OFFSET_TOP + OFFSET_BOTTOM);

		var sliceRect:FlxRect = new FlxRect(7, 10, Global.CELL_SIZE, Global.CELL_SIZE);
		this.stretchTop = this.stretchLeft = this.stretchCenter = this.stretchRight = this.stretchBottom = true;
		setPosition(x, y);

		super("assets/images/box/box_1.png", sliceRect, widthInPixels, heightInPixels);

		// COLLISION BOXES
		this.hitboxWindow = new Hitbox(this, 0, 0, widthInPixels, heightInPixels);
		this.hitboxWindow.scrollFactor.set(0, 0);
		this.hitboxBar = new Hitbox(this, 0, 0, widthInPixels, OFFSET_BAR);
		this.hitboxBar.scrollFactor.set(0, 0);
		this.hitboxClose = new Hitbox(this, widthInPixels - OFFSET_BAR, 0, OFFSET_BAR, OFFSET_BAR);
		this.hitboxClose.scrollFactor.set(0, 0);

		// SOUNDS
		this.openSound = FlxG.sound.load("assets/sounds/open.wav");
		this.dragSound = FlxG.sound.load("assets/sounds/drag.wav");
		this.dropSound = FlxG.sound.load("assets/sounds/drop.wav");
		this.closeSound = FlxG.sound.load("assets/sounds/close.wav");

		openSound.play();
	}

	override public function update(elapsed:Float):Void
	{
		if (currentState == FileWindowState.Dragging)
		{
			if (!handler.isWindowActive(this))
				handler.setWindowAsActive(this);
			handleDragging();
		}

		// CLAMP WINDOW POSITION
		x = Math.min(Math.max(x, 0), FlxG.width - widthInPixels);
		y = Math.min(Math.max(y, Global.CELL_SIZE), FlxG.height - Global.CELL_SIZE - widthInPixels);

		hitboxWindow.update(elapsed);
		hitboxBar.update(elapsed);
		hitboxClose.update(elapsed);
	}

	override public function kill():Void
	{
		closeSound.play();

		super.kill();
		hitboxWindow.kill();
		hitboxBar.kill();
		hitboxClose.kill();
	}

	public function activateDragging():Void
	{
		dragSound.play();

		var _mouse_point:FlxPoint = FlxG.mouse.getScreenPosition();

		mouseOffsetX = Std.int(_mouse_point.x - x);
		mouseOffsetY = Std.int(_mouse_point.y - y);
		currentState = FileWindowState.Dragging;
	}

	private function handleDragging():Void
	{
		var _click_pressed:Bool = FlxG.mouse.pressed;
		var _mouse_point:FlxPoint = FlxG.mouse.getScreenPosition();

		if (_click_pressed)
		{
			setPosition(_mouse_point.x - mouseOffsetX, _mouse_point.y - mouseOffsetY);
		}
		else
		{
			dropSound.play();
			currentState = FileWindowState.Idle;
		}
	}
}
