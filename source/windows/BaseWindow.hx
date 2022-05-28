package windows;

import utils.Hitbox;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

enum WindowState
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
	public static inline final OFFSET_SCROLL_X:Int = 4;
	public static inline final OFFSET_CONTENT_X:Int = Global.CELL_SIZE - OFFSET_SIDE;
	public static inline final OFFSET_CONTENT_Y:Int = Global.CELL_SIZE - OFFSET_TOP;
	
	public var depth:Int;
	public var currentState:WindowState;
	public var hitboxWindow:Hitbox;
	public var hitboxTopbar:Hitbox;
	public var hitboxScroll:Hitbox;
	public var hitboxClose:Hitbox;
	
	var handler:WindowHandler;
	var content:BaseWindowContent;
	var scrollbar:Scrollbar;

	public var widthInTiles:Int;
	public var heightInTiles:Int;
	public var widthInPixels:Int;
	public var heightInPixels:Int;

	var mouseOffsetX:Int;
	var mouseOffsetY:Int;

	var openSound:FlxSound;
	var dragSound:FlxSound;
	var dropSound:FlxSound;
	var closeSound:FlxSound;

	public function new(x:Float, y:Float, width:Int, height:Int, handler:WindowHandler)
	{
		super(x, y);

		this.depth = 0;
		this.currentState = WindowState.Idle;
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
		this.hitboxTopbar = new Hitbox(this, 0, 0, widthInPixels, OFFSET_BAR);
		this.hitboxTopbar.scrollFactor.set(0, 0);
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
		if (currentState == WindowState.Dragging)
		{
			if (!handler.isWindowActive(this))
				handler.setWindowAsActive(this);
			handleDragging();
		}

		// CLAMP WINDOW POSITION
		x = Math.min(Math.max(x, 0), FlxG.width - widthInPixels);
		y = Math.min(Math.max(y, Global.CELL_SIZE), FlxG.height - Global.CELL_SIZE - widthInPixels);

		if (content != null) content.update(elapsed);
		if (scrollbar != null) scrollbar.update(elapsed);

		hitboxWindow.update(elapsed);
		hitboxTopbar.update(elapsed);
		hitboxClose.update(elapsed);
		if (hitboxScroll != null) hitboxScroll.update(elapsed);
		
		super.update(elapsed);
	}

	override public function draw():Void
	{
		super.draw();
		if (content != null) content.draw();
		if (scrollbar != null) scrollbar.draw();
	}

	override public function kill():Void
	{
		closeSound.play();

		super.kill();
		hitboxWindow.kill();
		hitboxTopbar.kill();
		hitboxClose.kill();
		if (hitboxScroll != null) hitboxScroll.kill();
		if (content != null) content.kill();
		if (scrollbar != null) scrollbar.kill();
	}

	private function makeWindowGraphic()
	{
		makeGraphic(widthInPixels, heightInPixels, FlxColor.TRANSPARENT);
		
		// NOTE: Is it possible to stamp the bitmap directly, instead through sprites?
		var _tileTL:FlxSprite = new FlxSprite("assets/images/box/box_1_tl.png");
		var _tileTM:FlxSprite = new FlxSprite("assets/images/box/box_1_tm.png");
		var _tileTR:FlxSprite = new FlxSprite("assets/images/box/box_1_tr.png");
		var _tileML:FlxSprite = new FlxSprite("assets/images/box/box_1_ml.png");
		var _tileMM:FlxSprite = new FlxSprite("assets/images/box/box_1_mm.png");
		var _tileMR:FlxSprite = new FlxSprite("assets/images/box/box_1_mr.png");
		var _tileBL:FlxSprite = new FlxSprite("assets/images/box/box_1_bl.png");
		var _tileBM:FlxSprite = new FlxSprite("assets/images/box/box_1_bm.png");
		var _tileBR:FlxSprite = new FlxSprite("assets/images/box/box_1_br.png");

		_tileTM.scale.set(widthInTiles, 1);
		_tileML.scale.set(1, heightInTiles);
		_tileMM.scale.set(widthInTiles, heightInTiles);
		_tileMR.scale.set(1, heightInTiles);
		_tileBM.scale.set(widthInTiles, 1);

		var _x0:Int = -OFFSET_SIDE;
		var _x1:Int = Std.int(Global.CELL_SIZE / 2) * (widthInTiles + 1) - OFFSET_SIDE;
		var _x2:Int = Global.CELL_SIZE * (widthInTiles + 1) - OFFSET_SIDE;
		var _y0:Int = -OFFSET_TOP;
		var _y1:Int = Std.int(Global.CELL_SIZE / 2) * (heightInTiles + 1) - OFFSET_TOP;
		var _y2:Int = Global.CELL_SIZE * (heightInTiles + 1) - OFFSET_TOP;

		stamp(_tileTL, _x0, _y0);
		stamp(_tileTM, _x1, _y0);
		stamp(_tileTR, _x2, _y0);
		stamp(_tileML, _x0, _y1);
		stamp(_tileMM, _x1, _y1);
		stamp(_tileMR, _x2, _y1);
		stamp(_tileBL, _x0, _y2);
		stamp(_tileBM, _x1, _y2);
		stamp(_tileBR, _x2, _y2);
		
		_tileTL.kill();
		_tileTM.kill();
		_tileTR.kill();
		_tileML.kill();
		_tileMM.kill();
		_tileMR.kill();
		_tileBL.kill();
		_tileBM.kill();
		_tileBR.kill();		
	}

	public function addScrollbar():Void
	{
		var _tileTR:FlxSprite = new FlxSprite("assets/images/box/box_1_tr_scroll.png");
		var _tileMR:FlxSprite = new FlxSprite("assets/images/box/box_1_mr_scroll.png");
		var _tileBR:FlxSprite = new FlxSprite("assets/images/box/box_1_br_scroll.png");
		
		_tileMR.scale.set(1, heightInTiles);
		
		var _x0:Int = -OFFSET_SIDE;
		var _x1:Int = Std.int(Global.CELL_SIZE / 2) * (widthInTiles + 1) - OFFSET_SIDE;
		var _x2:Int = Global.CELL_SIZE * (widthInTiles + 1) - OFFSET_SIDE;
		var _y0:Int = -OFFSET_TOP;
		var _y1:Int = Std.int(Global.CELL_SIZE / 2) * (heightInTiles + 1) - OFFSET_TOP;
		var _y2:Int = Global.CELL_SIZE * (heightInTiles + 1) - OFFSET_TOP;
		
		stamp(_tileTR, _x2, _y0);
		stamp(_tileMR, _x2, _y1);
		stamp(_tileBR, _x2, _y2);

		_tileTR.kill();
		_tileMR.kill();
		_tileBR.kill();
		
		this.hitboxScroll = new Hitbox(this, _x2 + OFFSET_SCROLL_X, Global.CELL_SIZE - OFFSET_TOP, widthInPixels, heightInPixels - OFFSET_TOP - OFFSET_BOTTOM);
		this.hitboxScroll.scrollFactor.set(0, 0);

		this.scrollbar = new Scrollbar(this, _x2 + OFFSET_SCROLL_X, Global.CELL_SIZE - OFFSET_TOP, content.elementsPerScreen, content.elements);
		this.scrollbar.scrollFactor.set(0, 0);
	}

	public function activateDragging():Void
	{
		dragSound.play();

		var _mousePoint:FlxPoint = FlxG.mouse.getScreenPosition();

		mouseOffsetX = Std.int(_mousePoint.x - x);
		mouseOffsetY = Std.int(_mousePoint.y - y);
		currentState = WindowState.Dragging;
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
			currentState = WindowState.Idle;
		}
	}

	public function handleInput(point:FlxPoint, click:Bool, scroll:Int):Void
	{
		if (hitboxClose.overlapsPoint(point))
		{
			if(click)
				handler.deleteWindow(this);
		}
		else if (hitboxTopbar.overlapsPoint(point))
		{
			if(click)
			{
				activateDragging();
				if (!handler.isWindowActive(this))
					handler.setWindowAsActive(this);
			}
		}
		else if (hitboxScroll != null && hitboxScroll.overlapsPoint(point))
		{
			scrollbar.handleInput(point, click, scroll);
		}
		else if (hitboxWindow.overlapsPoint(point))
		{
			if (click)
			{
				if (!handler.isWindowActive(this))
					handler.setWindowAsActive(this);
			}

			if (content != null) 
				content.handleInput(point, click, scroll);
			if (scrollbar != null)
				scrollbar.handleInput(point, false, scroll);
		}
	}
}