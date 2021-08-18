package files;

enum FileType
{
	Text;
	Image;
}

class FileFactory
{
	public function newFile(x:Float, y:Float, values:Null<Dynamic>):BaseFile
	{
		var fileType = FileType.createByName(values.type);

		switch (fileType)
		{
			case Text:
				return new TextFile(x, y, values);
			case Image:
				return new TextFile(x, y, values);
			default:
				return new TextFile(x, y, values);
		}
	}
}
