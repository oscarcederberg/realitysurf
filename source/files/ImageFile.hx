package files;

import files.FileFactory.FileType;

class ImageFile extends BaseFile {
	public function new(x:Float, y:Float, values:Null<Dynamic>) {
		super(x, y, values);

		this.fileType = FileType.Image;

		// GRAPHICS
		loadGraphic("assets/images/files/image.png", false, Global.CELL_SIZE, Global.CELL_SIZE);
	}
}
