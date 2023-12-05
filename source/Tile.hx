package;

import flixel.FlxSprite;

class Tile extends FlxSprite {
    public function new(x:Float, y:Float) {
        super(x, y);
        loadGraphic("assets/images/tile.png", false, 16, 16);
    }
}
