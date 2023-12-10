package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite> {
    public static inline final BAR_HEIGHT = Global.CELL_SIZE;

    var upperBar:FlxSprite;
    var lowerBar:FlxSprite;

    public function new() {
        super();
        upperBar = new FlxSprite(0, 0);
        upperBar.makeGraphic(FlxG.width, BAR_HEIGHT, Global.RGB_BLACK);
        upperBar.scrollFactor.set(0, 0);

        lowerBar = new FlxSprite(0, FlxG.height - Global.CELL_SIZE);
        lowerBar.makeGraphic(FlxG.width, BAR_HEIGHT, Global.RGB_BLACK);
        lowerBar.scrollFactor.set(0, 0);

        add(upperBar);
        add(lowerBar);
    }
}
