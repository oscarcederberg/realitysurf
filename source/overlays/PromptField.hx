package overlays;

import haxe.ds.Option;
import files.BaseFile;
import hx.strings.StringBuilder;
import flixel.text.FlxText;

enum PromptFieldProtocol {
    Disk;
    Net;
}

class PromptField extends FlxText {
    public static inline final TEXT_SIZE = 8;
    public static inline final PROMPT_PREFIX = "> ";
    public static inline final PATH_PROTOCOL_SUFFIX = ":";
    public static inline final PATH_DIVIDER = "/";

    var command:Option<String>;
    var protocol:PromptFieldProtocol;
    var directory:String;
    var file:Option<String>;

    override public function new(x:Float, y:Float) {
        super(x, y, 0, PROMPT_PREFIX, TEXT_SIZE);
        this.color = Global.RGB_GREEN;
        this.scrollFactor.set(0, 0);

        this.command = None;
        this.protocol = Disk;
        this.directory = "";
        this.file = None;

        this.text = getText();
    }

    public function getText():String {
        var textBuilder = new StringBuilder();
        textBuilder.add(PROMPT_PREFIX);

        switch (command) {
        case Some(commandText):
            textBuilder.add(commandText).add(" ");
        case None:
        }

        textBuilder.add(protocol.getName().toLowerCase())
            .add(PATH_PROTOCOL_SUFFIX)
            .add(directory)
            .add(PATH_DIVIDER);

        switch (file) {
        case Some(fileText):
            textBuilder.add(fileText);
        case None:
        }

        return textBuilder.toString();
    }

    public function updatePrompt(file:Option<String>) {
        this.file = file;
        switch (file) {
        case Some(_):
            command = Some("open");
        default:
            command = None;
        }
        this.text = getText();
    }
}
