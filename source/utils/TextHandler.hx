package utils;

using StringTools;

class TextHandler {
	var unformatted:String;
	var formatted:Array<String>;

	public function new(text:String) {
		this.unformatted = text;
		this.formatted = new Array<String>();
	}

	public function format(charsPerLine:Int):Array<String> {
		var processing:String = unformatted;
		processing = processing.replace("\r", "").replace("\t", "").trim();

		while (processing.length > charsPerLine) {
			var newlinePos = processing.indexOf("\n");

			if (newlinePos != -1 && newlinePos < charsPerLine) {
				formatted.push(processing.substring(0, newlinePos).rtrim());
				processing = processing.substring(newlinePos + 1);
			} else if (processing.charAt(charsPerLine - 2) != " "
				&& processing.charAt(charsPerLine - 1) != " "
				&& processing.charAt(charsPerLine) != " ") {
				formatted.push(processing.substring(0, charsPerLine - 1) + "-");
				processing = processing.substring(charsPerLine - 1);
			} else if (processing.charAt(charsPerLine - 2) == " "
				&& processing.charAt(charsPerLine - 1) != " "
				&& processing.charAt(charsPerLine) != " ") {
				formatted.push(processing.substring(0, charsPerLine - 1) + " ");
				processing = processing.substring(charsPerLine - 1);
			} else {
				formatted.push(processing.substring(0, charsPerLine));
				processing = processing.substring(charsPerLine);
			}
		}

		while (processing.length > 0 && processing.contains("\n")) {
			var index = processing.indexOf("\n");
			formatted.push(processing.substring(0, index));
			processing = processing.substring(index + 1);
		}

		if (processing.length > 0) {
			formatted.push(processing);
		}

		return formatted;
	}
}
