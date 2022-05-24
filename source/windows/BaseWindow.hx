package windows;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

enum FileWindowState
{
	Idle;
	Dragging;
}

abstract class BaseWindow extends FlxSprite
{
	public static inline final OFFSET_TOP:Int = 6;
	public static inline final OFFSET_SIDE:Int = 8;
	public static inline final OFFSET_BOTTOM:Int = 11;
	public static inline final OFFSET_BAR:Int = 7;
	public static inline final OFFSET_CONTENT_X:Int = Global.CELL_SIZE - OFFSET_SIDE;
	public static inline final OFFSET_CONTENT_Y:Int = Global.CELL_SIZE - OFFSET_TOP;
	
	public var depth:Int;
	public var currentState:FileWindowState;
	public var hitboxWindow:Hitbox;
	public var hitboxBar:Hitbox;
	public var hitboxClose:Hitbox;
	
	var handler:WindowHandler;
	var content:BaseWindowContent;

	public var widthInTiles:Int;
	public var heightInTiles:Int;
	var widthInPixels:Int;
	var heightInPixels:Int;

	var mouseOffsetX:Int;
	var mouseOffsetY:Int;

	var openSound:FlxSound;
	var dragSound:FlxSound;
	var dropSound:FlxSound;
	var closeSound:FlxSound;

	private function makeWindowGraphic()
	{
		makeGraphic(widthInPixels, heightInPixels, FlxColor.TRANSPARENT);
		
		// NOTE: Is it possible to stamp the bitmap directly, instead through sprites?
		var TILE_TL:FlxSprite = new FlxSprite("assets/images/box/box_1_tl.png");
		var TILE_TM:FlxSprite = new FlxSprite("assets/images/box/box_1_tm.png");
		var TILE_TR:FlxSprite = new FlxSprite("assets/images/box/box_1_tr.png");
		var TILE_ML:FlxSprite = new FlxSprite("assets/images/box/box_1_ml.png");
		var TILE_MM:FlxSprite = new FlxSprite("assets/images/box/box_1_mm.png");
		var TILE_MR:FlxSprite = new FlxSprite("assets/images/box/box_1_mr.png");
		var TILE_BL:FlxSprite = new FlxSprite("assets/images/box/box_1_bl.png");
		var TILE_BM:FlxSprite = new FlxSprite("assets/images/box/box_1_bm.png");
		var TILE_BR:FlxSprite = new FlxSprite("assets/images/box/box_1_br.png");

		TILE_TM.scale.set(widthInTiles, 1);
		TILE_ML.scale.set(1, heightInTiles);
		TILE_MM.scale.set(widthInTiles, heightInTiles);
		TILE_MR.scale.set(1, heightInTiles);
		TILE_BM.scale.set(widthInTiles, 1);

		var _x0:Int = -OFFSET_SIDE;
		var _x1:Int = Std.int(Global.CELL_SIZE / 2) * (widthInTiles + 1) - OFFSET_SIDE;
		var _x2:Int = Global.CELL_SIZE * (widthInTiles + 1) - OFFSET_SIDE;
		var _y0:Int = -OFFSET_TOP;
		var _y1:Int = Std.int(Global.CELL_SIZE / 2) * (heightInTiles + 1) - OFFSET_TOP;
		var _y2:Int = Global.CELL_SIZE * (heightInTiles + 1) - OFFSET_TOP;

		stamp(TILE_TL, _x0, _y0);
		stamp(TILE_TM, _x1, _y0);
		stamp(TILE_TR, _x2, _y0);
		stamp(TILE_ML, _x0, _y1);
		stamp(TILE_MM, _x1, _y1);
		stamp(TILE_MR, _x2, _y1);
		stamp(TILE_BL, _x0, _y2);
		stamp(TILE_BM, _x1, _y2);
		stamp(TILE_BR, _x2, _y2);
		
		TILE_TL.kill();
		TILE_TM.kill();
		TILE_TR.kill();
		TILE_ML.kill();
		TILE_MM.kill();
		TILE_MR.kill();
		TILE_BL.kill();
		TILE_BM.kill();
		TILE_BR.kill();		
	}

	public function new(x:Float, y:Float, width:Int, height:Int, handler:WindowHandler)
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
		makeWindowGraphic();

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


		if (content != null) content.update(elapsed);
		hitboxWindow.update(elapsed);
		hitboxBar.update(elapsed);
		hitboxClose.update(elapsed);
		
		super.update(elapsed);
	}

	override public function kill():Void
	{
		closeSound.play();

		super.kill();
		hitboxWindow.kill();
		hitboxBar.kill();
		hitboxClose.kill();
		content.kill();
	}

	override public function draw():Void
	{
		super.draw();
		content.draw();
	}

	public function activateDragging():Void
	{
		dragSound.play();

		var _mousePoint:FlxPoint = FlxG.mouse.getScreenPosition();

		mouseOffsetX = Std.int(_mousePoint.x - x);
		mouseOffsetY = Std.int(_mousePoint.y - y);
		currentState = FileWindowState.Dragging;
	}

	private function handleDragging():Void
	{
		var _mousePressed:Bool = FlxG.mouse.pressed;
		var _mousePoint:FlxPoint = FlxG.mouse.getScreenPosition();

		if (_mousePressed)
		{
			setPosition(_mousePoint.x - mouseOffsetX, _mousePoint.y - mouseOffsetY);
		}
		else
		{
			dropSound.play();
			currentState = FileWindowState.Idle;
		}
	}
}
