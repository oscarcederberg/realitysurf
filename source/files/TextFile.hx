package files;

import files.FileFactory.FileType;

class TextFile extends BaseFile {
    public function new(x:Float, y:Float, values:Null<Dynamic>) {
        super(x, y, values);

        this.fileType = FileType.Text;

        loadGraphic("assets/images/files/text.png", false, Global.CELL_SIZE,
            Global.CELL_SIZE);
    }
}
