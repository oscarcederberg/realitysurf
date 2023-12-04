package files;

import files.FileFactory.FileType;
import flixel.FlxG;
import flixel.FlxSprite;

abstract class BaseFile extends FlxSprite {
	static inline final OFFSET_Y:Int = -8;
	static inline final AMP_Y:Int = 2;
	static inline final FREQ_Y:Float = 1 / 4;

	var phase_y:Int;
	var start_y:Float;
	var delta_y:Float;
	var old_steps:Int;

	var parent:PlayState;

	public var fileName:String;
	public var fileData:String;
	public var windowWidth:Int;
	public var windowHeight:Int;
	public var fileType:FileType;

	public function new(x:Float, y:Float, values:Dynamic) {
		this.start_y = y + OFFSET_Y;
		this.phase_y = Std.int(y % Global.CELL_SIZE + x % Global.CELL_SIZE);
		this.old_steps = -1;

		super(x, start_y);

		this.parent = cast(FlxG.state);

		this.fileName = values.name;
		this.fileData = values.data;
		this.windowWidth = Std.parseInt(values.width);
		this.windowHeight = Std.parseInt(values.height);
	}

	public override function update(elapsed:Float) {
		if (Global.stepsTaken != old_steps) {
			floatInPlace();
			y = start_y + delta_y;
		}

		super.update(elapsed);
	}

	function floatInPlace() {
		delta_y = AMP_Y * Math.sin(FREQ_Y * Global.stepsTaken + phase_y);
		old_steps = Global.stepsTaken;
	}

	public function interact() {
		parent.createWindow(this);
	}
}
