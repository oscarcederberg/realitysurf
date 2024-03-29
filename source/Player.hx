package;

import files.BaseFile;
import haxe.ds.Option;
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxTimer;

enum PlayerState {
    Idle;
    Walking;
    Running;
}

class Player extends FlxSprite {
    public static inline final STEPS:Int = 4;
    public static inline final SPEED_WALK:Int = 6;
    public static inline final SPEED_RUN:Int = 8;
    public static inline final OFFSET_Y:Int = 6;

    var parent:PlayState;

    var currentState:PlayerState;
    var stepsLeft:Int;
    var moveSpeed:Int;
    var midPoint:FlxPoint;

    var stepSounds:Array<FlxSound>;
    var stepIndex:Int;
    var collideSound:FlxSound;

    public function new(x:Float, y:Float) {
        super(x, y - OFFSET_Y - Global.CELL_SIZE);

        this.parent = cast(FlxG.state);

        this.currentState = PlayerState.Idle;
        this.facing = FlxDirectionFlags.DOWN;
        this.stepsLeft = STEPS;
        this.moveSpeed = SPEED_WALK;
        this.midPoint = new FlxPoint(x + Global.CELL_SIZE / 2,
            y + Global.CELL_SIZE + OFFSET_Y);

        loadGraphic("assets/images/player.png", true, Global.CELL_SIZE,
            2 * Global.CELL_SIZE);
        animation.add("idle_up", [0]);
        animation.add("move_up", [1, 2, 3, 4], moveSpeed);
        animation.add("idle_left", [5]);
        animation.add("move_left", [6, 7, 8, 9], moveSpeed);
        animation.add("idle_down", [10]);
        animation.add("move_down", [11, 12, 13, 14], moveSpeed);
        animation.add("idle_right", [15]);
        animation.add("move_right", [16, 17, 18, 19], moveSpeed);
        animation.play("idle_down");

        stepIndex = 0;
        stepSounds = [
            FlxG.sound.load("assets/sounds/step_0.wav"),
            FlxG.sound.load("assets/sounds/step_1.wav")
        ];
        collideSound = FlxG.sound.load("assets/sounds/collide.wav");
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        midPoint = new FlxPoint(x + Global.CELL_SIZE / 2,
            y + Global.CELL_SIZE + OFFSET_Y);
        handleInput();
        animate();

        switch (getFile()) {
        case Some(file):
            parent.updateOverlayPrompt(Some(file.getFilename()));
        case _:
            parent.updateOverlayPrompt(None);
        }
    }

    public function handleInput() {
        var _up:Bool = FlxG.keys.anyPressed([UP, W,]);
        var _down:Bool = FlxG.keys.anyPressed([DOWN, S]);
        var _left:Bool = FlxG.keys.anyPressed([LEFT, A]);
        var _right:Bool = FlxG.keys.anyPressed([RIGHT, D]);
        var _action:Bool = FlxG.keys.anyJustPressed([Z, J]);
        var _shift:Bool = FlxG.keys.anyPressed([SHIFT]);

        if (_up && _down) {
            _up = _down = false;
        }
        if (_left && _right) {
            _left = _right = false;
        }

        if (currentState == PlayerState.Idle) {
            var dx = 0, dy = 0;
            stepsLeft = STEPS;

            if (_up) {
                dy = -Global.CELL_SIZE;
                facing = FlxDirectionFlags.UP;
            } else if (_left) {
                dx = -Global.CELL_SIZE;
                facing = FlxDirectionFlags.LEFT;
            } else if (_down) {
                dy = Global.CELL_SIZE;
                facing = FlxDirectionFlags.DOWN;
            } else if (_right) {
                dx = Global.CELL_SIZE;
                facing = FlxDirectionFlags.RIGHT;
            } else if (_action) {
                interact();
            }

            if (dx != 0 || dy != 0) {
                var point = new FlxPoint(dx, dy).addPoint(midPoint);
                if (!isBlocked(point)) {
                    moveSpeed = (_shift ? SPEED_RUN : SPEED_WALK);
                    currentState = (_shift ? PlayerState.Running : PlayerState.Walking);
                    playStepSound();
                    new FlxTimer().start(1 / moveSpeed,
                        (_) -> playStepSound(), 3);
                    move();
                } else {
                    collideSound.play();
                }
            }
        }
    }

    public function animate() {
        switch (currentState) {
        case Idle:
            switch (facing) {
            case FlxDirectionFlags.UP:
                animation.play("idle_up");
            case FlxDirectionFlags.LEFT:
                animation.play("idle_left");
            case FlxDirectionFlags.DOWN:
                animation.play("idle_down");
            case FlxDirectionFlags.RIGHT:
                animation.play("idle_right");
            default:
            }
        case Walking | Running:
            switch (facing) {
            case FlxDirectionFlags.UP:
                animation.play("move_up");
            case FlxDirectionFlags.LEFT:
                animation.play("move_left");
            case FlxDirectionFlags.DOWN:
                animation.play("move_down");
            case FlxDirectionFlags.RIGHT:
                animation.play("move_right");
            default:
            }
            animation.curAnim.frameRate = moveSpeed;
        }
    }

    private function move() {
        if (stepsLeft > 0) {
            stepsLeft--;
            switch (facing) {
            case FlxDirectionFlags.UP:
                y -= 4;
            case FlxDirectionFlags.LEFT:
                x -= 4;
            case FlxDirectionFlags.DOWN:
                y += 4;
            case FlxDirectionFlags.RIGHT:
                x += 4;
            default:
            }
            Global.stepsTaken++;
            new FlxTimer().start(1 / moveSpeed, (_) -> move(), 1);
        } else {
            currentState = PlayerState.Idle;
        }
    }

    private function interact() {
        switch (getFile()) {
        case Some(file):
            file.interact();
        case _:
        }
    }

    private function getFile():Option<BaseFile> {
        var dx = 0, dy = 0;
        switch (facing) {
        case UP:
            dy = -Global.CELL_SIZE;
        case LEFT:
            dx = -Global.CELL_SIZE;
        case DOWN:
            dy = Global.CELL_SIZE;
        case RIGHT:
            dx = Global.CELL_SIZE;
        case _:
        }

        var point:FlxPoint = new FlxPoint(dx, dy).addPoint(midPoint);
        for (file in parent.level.files) {
            if (file.overlapsPoint(point)) {
                return Some(file);
            }
        }

        return None;
    }

    private function isBlocked(point:FlxPoint):Bool {
        // NOTE: Do we have to check through collisions? 2D-structure instead maybe?
        return !parent.level.tiles.overlapsPoint(point)
            || parent.level.files.overlapsPoint(point);
    }

    private function playStepSound() {
        stepSounds[stepIndex].play();
        stepIndex = (stepIndex + 1) % 2;
    }
}
