package overlays;

import haxe.ds.Option;
import files.BaseFile;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite> {
    public static inline final BAR_HEIGHT = Global.CELL_SIZE;
    public static inline final PROMPT_TEXT_OFFSET = 2;

    var upperBar:FlxSprite;
    var lowerBar:FlxSprite;
    var promptField:PromptField;

    public function new() {
        super();
        upperBar = new FlxSprite(0, 0);
        upperBar.makeGraphic(FlxG.width, BAR_HEIGHT, Global.RGB_BLACK);
        upperBar.scrollFactor.set(0, 0);

        lowerBar = new FlxSprite(0, FlxG.height - Global.CELL_SIZE);
        lowerBar.makeGraphic(FlxG.width, BAR_HEIGHT, Global.RGB_BLACK);
        lowerBar.scrollFactor.set(0, 0);

        promptField = new PromptField(0,
            FlxG.height - BAR_HEIGHT / 2 - PromptField.TEXT_SIZE / 2 - PROMPT_TEXT_OFFSET);

        add(upperBar);
        add(lowerBar);
        add(promptField);
    }

    public function updateOverlayPrompt(file:Option<String>) {
        promptField.updatePrompt(file);
    }
}
