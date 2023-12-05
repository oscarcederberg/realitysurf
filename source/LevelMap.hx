package;

import files.BaseFile;
import files.FileFactory;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxSpriteGroup;
import flixel.tile.FlxTilemap;

class LevelMap {
    var map:FlxOgmo3Loader;
    var tilemap:FlxTilemap;
    var filefactory:FileFactory;

    public var name:String;
    public var player:Player;
    public var tiles:FlxTypedSpriteGroup<Tile>;
    public var files:FlxTypedSpriteGroup<BaseFile>;
    public var entities:FlxSpriteGroup;

    public function new(file:String) {
        this.map = new FlxOgmo3Loader("assets/data/REALITYSURF.ogmo", "assets/data/" + file);
        this.name = Std.string(map.getLevelValue("name"));
        this.tilemap = map.loadTilemap("assets/data/OGMO/tiles.png", "tiles");
        this.filefactory = new FileFactory();

        this.tiles = new FlxTypedSpriteGroup<Tile>();
        this.files = new FlxTypedSpriteGroup<BaseFile>();
        this.entities = new FlxSpriteGroup();

        placeTiles();
        this.map.loadEntities(placeEntities, "entities");
        this.map.loadEntities(placeFiles, "files");

        Global.levelAssetsPath = "assets/levels/" + this.name + "/";
    }

    public function placeTiles() {
        var width = tilemap.widthInTiles;
        var height = tilemap.heightInTiles;
        for (x in 0...width) {
            for (y in 0...height) {
                var index:Int = tilemap.getData()[y * width + x];
                var real_x = x * Global.CELL_SIZE;
                var real_y = y * Global.CELL_SIZE;
                switch (index) {
                case 1:
                    tiles.add(new Tile(real_x, real_y));
                }
            }
        }
    }

    public function placeEntities(entity:EntityData) {
        var real_x = entity.x;
        var real_y = entity.y;
        switch (entity.name) {
        case "player":
            player = new Player(real_x, real_y);

            entities.add(player);
        }
    }

    public function placeFiles(entity:EntityData) {
        var real_x = entity.x;
        var real_y = entity.y;
        switch (entity.name) {
        case "file":
            var values = entity.values;
            var file:BaseFile = filefactory.newFile(real_x, real_y, values);

            files.add(file);
            entities.add(file);
        }
    }
}
