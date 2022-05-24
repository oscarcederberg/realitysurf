package utils;

using StringTools;

class TextHandler
{
    var unformatted:String;
    var formatted:Array<String>;

    public function new(text:String)
    {
        this.unformatted = text;
        this.formatted = new Array<String>();
    }

    public function format(charsPerLine:Int):Array<String> 
    {
        var processing:String = unformatted;
        processing = processing.replace("\r", "").replace("\t", "");

        while (processing.length > charsPerLine)
        {
            if (processing.charAt(charsPerLine - 2) != " " &&
                processing.charAt(charsPerLine - 1) != " " &&
                processing.charAt(charsPerLine    ) != " ")
            {
                formatted.push(processing.substring(0, charsPerLine - 1) + "-");
                processing = processing.substring(charsPerLine - 1);
            }
            else if (processing.charAt(charsPerLine - 2) == " " &&
                     processing.charAt(charsPerLine - 1) != " " &&
                     processing.charAt(charsPerLine    ) != " ")
            {
                formatted.push(processing.substring(0, charsPerLine - 1) + " ");
                processing = processing.substring(charsPerLine - 1);
            }
            else
            {
                formatted.push(processing.substring(0, charsPerLine));
                processing = processing.substring(charsPerLine);
            }
        }
        if (processing.length > 0)
        {
            formatted.push(processing);
        }
        
        return formatted;
    }
}