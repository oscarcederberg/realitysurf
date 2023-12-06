package;

import files.BaseFile;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxSort;
import windows.WindowHandler;

class PlayState extends FlxState {
    public var level:LevelMap;
    public var windowHandler:WindowHandler;
    public var hud:HUD;

    override public function create() {
        this.bgColor = Global.RGB_BLACK;
        this.level = new LevelMap("level_dev.json");
        this.hud = new HUD();
        this.windowHandler = new WindowHandler();

        FlxG.camera.follow(level.player, LOCKON, 0.1);
        FlxG.camera.snapToTarget();

        add(level.tiles);
        add(level.entities);
        add(windowHandler.windows);
        add(hud);

        super.create();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        windowHandler.update(elapsed);

        sortEntities();
    }

    public function sortEntities() {
        level.entities.sort((_, obj1, obj2) -> FlxSort.byValues(FlxSort.ASCENDING, obj1.y + obj1.height, obj2.y + obj2.height));
    }

    public function createWindow(file:BaseFile) {
        windowHandler.createWindow(file);
    }
}
