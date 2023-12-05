package windows;

import flixel.system.FlxAssets;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.display.BitmapData;
import utils.Hitbox;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
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
	public static inline final OFFSET_BOTTOM:Int = 11;
	public static inline final OFFSET_BAR:Int = 7;
	public static inline final OFFSET_SCROLL_X:Int = 4;
	public static inline final OFFSET_CONTENT_X:Int = Global.CELL_SIZE - OFFSET_SIDE;
	public static inline final OFFSET_CONTENT_Y:Int = Global.CELL_SIZE - OFFSET_TOP;
	public static inline final SCROLL_WIDTH:Int = 4;
	public static var bitmaps:haxe.ds.Map<WindowTile, BitmapData> = new Map();

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

	var x0:Int;
	var x1:Int;
	var x2:Int;
	var y0:Int;
	var y1:Int;
	var y2:Int;

	var mouseOffsetX:Int;
	var mouseOffsetY:Int;

	var openSound:FlxSound;
	var dragSound:FlxSound;
	var dropSound:FlxSound;
	var closeSound:FlxSound;

	public function new(x:Float, y:Float, width:Int, height:Int, handler:WindowHandler) {
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

		x0 = -OFFSET_SIDE;
		x1 = Global.CELL_SIZE - OFFSET_SIDE;
		x2 = Global.CELL_SIZE * (widthInTiles + 1) - OFFSET_SIDE;
		y0 = -OFFSET_TOP;
		y1 = Global.CELL_SIZE - OFFSET_TOP;
		y2 = Global.CELL_SIZE * (heightInTiles + 1) - OFFSET_TOP;

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

	override public function update(elapsed:Float):Void {
		if (currentState == WindowState.Dragging) {
			if (!handler.isWindowActive(this))
				handler.setWindowAsActive(this);
			handleDragging();
		}

		// CLAMP WINDOW POSITION
		x = Math.min(Math.max(x, 0), FlxG.width - widthInPixels);
		y = Math.min(Math.max(y, Global.CELL_SIZE), FlxG.height - Global.CELL_SIZE - widthInPixels);

		if (content != null)
			content.update(elapsed);
		if (scrollbar != null)
			scrollbar.update(elapsed);

		hitboxWindow.update(elapsed);
		hitboxTopbar.update(elapsed);
		hitboxClose.update(elapsed);
		if (hitboxScroll != null)
			hitboxScroll.update(elapsed);

		super.update(elapsed);
	}

	override public function draw():Void {
		super.draw();
		if (content != null)
			content.draw();
		if (scrollbar != null)
			scrollbar.draw();
	}

	override public function kill():Void {
		closeSound.play();

		super.kill();
		hitboxWindow.kill();
		hitboxTopbar.kill();
		hitboxClose.kill();
		if (hitboxScroll != null)
			hitboxScroll.kill();
		if (content != null)
			content.kill();
		if (scrollbar != null)
			scrollbar.kill();
	}

	public function addScrollbar():Void {
		stampTile(TOP_RIGHT_SCROLL);
		stampTile(MIDDLE_RIGHT_SCROLL);
		stampTile(BOTTOM_RIGHT_SCROLL);

		this.hitboxScroll = new Hitbox(this, x2 + OFFSET_SCROLL_X, Global.CELL_SIZE - OFFSET_TOP, SCROLL_WIDTH, heightInTiles * Global.CELL_SIZE);
		this.hitboxScroll.scrollFactor.set(0, 0);

		this.scrollbar = new Scrollbar(this, x2 + OFFSET_SCROLL_X, y1, content.elementsPerScreen, content.elements);
		this.scrollbar.scrollFactor.set(0, 0);
	}

	public function activateDragging():Void {
		dragSound.play();

		var _mousePoint:FlxPoint = FlxG.mouse.getScreenPosition();

		mouseOffsetX = Std.int(_mousePoint.x - x);
		mouseOffsetY = Std.int(_mousePoint.y - y);
		currentState = WindowState.Dragging;
	}

	public function handleInput(point:FlxPoint, click:Bool, scroll:Int):Void {
		if (hitboxClose.overlapsPoint(point)) {
			if (click)
				handler.deleteWindow(this);
		} else if (hitboxTopbar.overlapsPoint(point)) {
			if (click) {
				activateDragging();
				if (!handler.isWindowActive(this))
					handler.setWindowAsActive(this);
			}
		} else if (hitboxScroll != null && hitboxScroll.overlapsPoint(point)) {
			scrollbar.handleInput(point, click, scroll);
		} else if (hitboxWindow.overlapsPoint(point)) {
			if (click) {
				if (!handler.isWindowActive(this))
					handler.setWindowAsActive(this);
			}

			if (content != null)
				content.handleInput(point, click, scroll);
			if (scrollbar != null)
				scrollbar.handleInput(point, false, scroll);
		}
	}

	private function handleDragging():Void {
		var _mousePressed:Bool = FlxG.mouse.pressed;
		var _mousePoint:FlxPoint = FlxG.mouse.getScreenPosition();

		if (_mousePressed) {
			setPosition(_mousePoint.x - mouseOffsetX, _mousePoint.y - mouseOffsetY);
		} else {
			dropSound.play();
			currentState = WindowState.Idle;
		}
	}

	private function stampTile(tile:WindowTile) {
		var point = new Point();

		point.x = switch (tile) {
			case TOP_LEFT | MIDDLE_LEFT | BOTTOM_LEFT:
				x0;
			case TOP_MIDDLE | MIDDLE_MIDDLE | BOTTOM_MIDDLE:
				x1;
			case TOP_RIGHT | TOP_RIGHT_SCROLL | MIDDLE_RIGHT | MIDDLE_RIGHT_SCROLL | BOTTOM_RIGHT | BOTTOM_RIGHT_SCROLL:
				x2;
		}

		point.y = switch (tile) {
			case TOP_LEFT | TOP_MIDDLE | TOP_RIGHT | TOP_RIGHT_SCROLL:
				y0;
			case MIDDLE_LEFT | MIDDLE_MIDDLE | MIDDLE_RIGHT | MIDDLE_RIGHT_SCROLL:
				y1;
			case BOTTOM_LEFT | BOTTOM_MIDDLE | BOTTOM_RIGHT | BOTTOM_RIGHT_SCROLL:
				y2;
		}

		switch (tile) {
			case TOP_LEFT | TOP_RIGHT | TOP_RIGHT_SCROLL | BOTTOM_LEFT | BOTTOM_RIGHT | BOTTOM_RIGHT_SCROLL:
				this.graphic.bitmap.copyPixels(bitmaps[tile], bitmaps[tile].rect, point);
			case TOP_MIDDLE | BOTTOM_MIDDLE:
				var matrix = new Matrix(widthInTiles, 0, 0, 1, point.x, point.y);
				this.graphic.bitmap.draw(bitmaps[tile], matrix);
			case MIDDLE_LEFT | MIDDLE_RIGHT | MIDDLE_RIGHT_SCROLL:
				var matrix = new Matrix(1, 0, 0, heightInTiles, point.x, point.y);
				this.graphic.bitmap.draw(bitmaps[tile], matrix);
			case MIDDLE_MIDDLE:
				var matrix = new Matrix(widthInTiles, 0, 0, heightInTiles, point.x, point.y);
				this.graphic.bitmap.draw(bitmaps[tile], matrix);
		}
	}

	private function makeWindowGraphic() {
		makeGraphic(widthInPixels, heightInPixels, FlxColor.TRANSPARENT);

		for (tile in WindowTile.createAll()) {
			switch (tile) {
				case TOP_RIGHT_SCROLL | MIDDLE_RIGHT_SCROLL | BOTTOM_RIGHT_SCROLL:
				default:
					stampTile(tile);
			}
		}
	}

	public static function loadTileAsset(tile:WindowTile, asset:String) {
		bitmaps[tile] = FlxAssets.getBitmapData(asset);
	}

	public static function loadAllTileAssets() {
		for (tile in WindowTile.createAll()) {
			var name = tile.getName().toLowerCase();
			var split = name.indexOf("_");

			var asset = switch (tile) {
				case TOP_RIGHT_SCROLL | MIDDLE_RIGHT_SCROLL | BOTTOM_RIGHT_SCROLL:
					'assets/images/box/box_1_${name.substring(0, 1)}${name.substring(split + 1, split + 2)}_scroll.png';
				default:
					'assets/images/box/box_1_${name.substring(0, 1)}${name.substring(split + 1, split + 2)}.png';
			}

			loadTileAsset(tile, asset);
		}
	}
}
