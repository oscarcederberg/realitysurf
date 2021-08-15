package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.ui.Keyboard;

enum FileWindowState
{
	Idle;
	Dragging;
}

class FileWindow extends FlxSprite
{
	public static inline final OFFSET_TOP:Int = 6;
	public static inline final OFFSET_SIDE:Int = 9;
	public static inline final OFFSET_BOTTOM:Int = 11;
	public static inline final OFFSET_BAR:Int = 7;

	public var depth:Int;

	var TILE_TL:FlxSprite = new FlxSprite("assets/images/box/box_1_tl.png");
	var TILE_TM:FlxSprite = new FlxSprite("assets/images/box/box_1_tm.png");
	var TILE_TR:FlxSprite = new FlxSprite("assets/images/box/box_1_tr.png");
	var TILE_ML:FlxSprite = new FlxSprite("assets/images/box/box_1_ml.png");
	var TILE_MM:FlxSprite = new FlxSprite("assets/images/box/box_1_mm.png");
	var TILE_MR:FlxSprite = new FlxSprite("assets/images/box/box_1_mr.png");
	var TILE_BL:FlxSprite = new FlxSprite("assets/images/box/box_1_bl.png");
	var TILE_BM:FlxSprite = new FlxSprite("assets/images/box/box_1_bm.png");
	var TILE_BR:FlxSprite = new FlxSprite("assets/images/box/box_1_br.png");

	public var currentState:FileWindowState;
	public var hitboxWindow:Hitbox;
	public var hitboxBar:Hitbox;
	public var hitboxClose:Hitbox;

	var handler:FileWindowHandler;

	var widthInTiles:Int;
	var heightInTiles:Int;
	var widthInPixels:Int;
	var heightInPixels:Int;

	var mouseOffsetX:Int;
	var mouseOffsetY:Int;

	public function new(x:Float, y:Float, width:Int, height:Int, handler:FileWindowHandler)
	{
		super(x, y);
		this.depth = 0;
		this.currentState = FileWindowState.Idle;
		this.mouseOffsetX = 0;
		this.mouseOffsetY = 0;

		this.handler = handler;
		this.widthInTiles = width;
		this.heightInTiles = height;
		this.widthInPixels = Global.CELL_SIZE * (width + 2) - (OFFSET_SIDE * 2);
		this.heightInPixels = Global.CELL_SIZE * (height + 2) - (OFFSET_TOP + OFFSET_BOTTOM);

		// GRAPHICS
		makeGraphic(widthInPixels, heightInPixels, FlxColor.TRANSPARENT);

		TILE_TM.scale.set(width, 1);
		TILE_ML.scale.set(1, height);
		TILE_MM.scale.set(width, height);
		TILE_MR.scale.set(1, height);
		TILE_BM.scale.set(width, 1);

		var x0:Int = -OFFSET_SIDE;
		var x1:Int = Std.int(Global.CELL_SIZE / 2) * (width + 1) - OFFSET_SIDE;
		var x2:Int = Global.CELL_SIZE * (width + 1) - OFFSET_SIDE;
		var y0:Int = -OFFSET_TOP;
		var y1:Int = Std.int(Global.CELL_SIZE / 2) * (height + 1) - OFFSET_TOP;
		var y2:Int = Global.CELL_SIZE * (height + 1) - OFFSET_TOP;

		stamp(TILE_TL, x0, y0);
		stamp(TILE_TM, x1, y0);
		stamp(TILE_TR, x2, y0);
		stamp(TILE_ML, x0, y1);
		stamp(TILE_MM, x1, y1);
		stamp(TILE_MR, x2, y1);
		stamp(TILE_BL, x0, y2);
		stamp(TILE_BM, x1, y2);
		stamp(TILE_BR, x2, y2);

		// COLLISION BOXES
		hitboxWindow = new Hitbox(this, 0, 0, widthInPixels, heightInPixels);
		hitboxWindow.scrollFactor.set(0, 0);
		hitboxBar = new Hitbox(this, 0, 0, widthInPixels, OFFSET_BAR);
		hitboxBar.scrollFactor.set(0, 0);
		hitboxClose = new Hitbox(this, widthInPixels - OFFSET_BAR, 0, OFFSET_BAR, OFFSET_BAR);
		hitboxClose.scrollFactor.set(0, 0);
	}

	override public function update(elapsed:Float):Void
	{
		if (currentState == FileWindowState.Dragging)
		{
			if (!handler.isWindowActive(this))
				handler.setWindowAsActive(this);
			handleDragging();
		}

		x = Math.min(Math.max(x, 0), FlxG.width - widthInPixels);
		y = Math.min(Math.max(y, Global.CELL_SIZE), FlxG.height - Global.CELL_SIZE - widthInPixels);

		hitboxWindow.update(elapsed);
		hitboxBar.update(elapsed);
		hitboxClose.update(elapsed);
	}

	override public function kill():Void
	{
		super.kill();
		hitboxWindow.kill();
		hitboxBar.kill();
		hitboxClose.kill();
	}

	public function activateDragging():Void
	{
		var _mouse_point:FlxPoint = FlxG.mouse.getPositionInCameraView();

		mouseOffsetX = Std.int(_mouse_point.x - x); // offset wrong?
		mouseOffsetY = Std.int(_mouse_point.y - y); // offset wrong?
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
			currentState = FileWindowState.Idle;
		}
	}
}
