package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

enum PlayerState
{
	Idle;
	Walking;
}

class Player extends FlxSprite
{
	static final STEPS:Int = 4;
	static final SPEED:Int = 6;

	var parent:PlayState;
	var currentState:PlayerState;
	var stepsLeft:Int;
	var moveSpeed:Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		this.parent = cast(FlxG.state);

		this.currentState = PlayerState.Idle;
		this.facing = FlxObject.DOWN;
		this.stepsLeft = STEPS;
		this.moveSpeed = SPEED;

		loadGraphic("assets/images/player.png", true, 16, 32);
		animation.add("idle_up", [0]);
		animation.add("walk_up", [1, 2, 3, 4], SPEED);
		animation.add("idle_left", [5]);
		animation.add("walk_left", [6, 7, 8, 9], SPEED);
		animation.add("idle_down", [10]);
		animation.add("walk_down", [11, 12, 13, 14], SPEED);
		animation.add("idle_right", [15]);
		animation.add("walk_right", [16, 17, 18, 19], SPEED);

		animation.play("idle_down");
	}

	override public function update(elapsed:Float):Void
	{
		handleInput();
		animate();

		super.update(elapsed);
	}

	public function handleInput()
	{
		var _up:Bool = FlxG.keys.anyPressed([UP, W,]);
		var _down:Bool = FlxG.keys.anyPressed([DOWN, S]);
		var _left:Bool = FlxG.keys.anyPressed([LEFT, A]);
		var _right:Bool = FlxG.keys.anyPressed([RIGHT, D]);
		var _action:Bool = FlxG.keys.anyPressed([Z, J]);

		if (_up && _down)
		{
			_up = _down = false;
		}
		if (_left && _right)
		{
			_left = _right = false;
		}

		if (currentState == PlayerState.Idle)
		{
			stepsLeft = STEPS;
			if (_up)
			{
				facing = FlxObject.UP;
				currentState = PlayerState.Walking;
				move();
			}
			else if (_left)
			{
				facing = FlxObject.LEFT;
				currentState = PlayerState.Walking;
				move();
			}
			else if (_down)
			{
				facing = FlxObject.DOWN;
				currentState = PlayerState.Walking;
				move();
			}
			else if (_right)
			{
				facing = FlxObject.RIGHT;
				currentState = PlayerState.Walking;
				move();
			}
		}
	}

	public function animate()
	{
		switch (currentState)
		{
			case Idle:
				switch (facing)
				{
					case FlxObject.UP:
						animation.play("idle_up");
					case FlxObject.LEFT:
						animation.play("idle_left");
					case FlxObject.DOWN:
						animation.play("idle_down");
					case FlxObject.RIGHT:
						animation.play("idle_right");
				}
			case Walking:
				switch (facing)
				{
					case FlxObject.UP:
						animation.play("walk_up");
					case FlxObject.LEFT:
						animation.play("walk_left");
					case FlxObject.DOWN:
						animation.play("walk_down");
					case FlxObject.RIGHT:
						animation.play("walk_right");
				}
		}
	}

	private function move()
	{
		if (stepsLeft > 0)
		{
			stepsLeft--;
			switch (facing)
			{
				case FlxObject.UP:
					y -= 4;
				case FlxObject.LEFT:
					x -= 4;
				case FlxObject.DOWN:
					y += 4;
				case FlxObject.RIGHT:
					x += 4;
			}
			new FlxTimer().start(1 / moveSpeed, (_) -> move(), 1);
		}
		else
		{
			currentState = PlayerState.Idle;
		}
	}
}
