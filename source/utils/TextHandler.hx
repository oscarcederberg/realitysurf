package utils;

import hx.strings.StringBuilder;

using utils.CharExtender;
using StringTools;
using hx.strings.Strings;

class TextHandler {
    var unformatted:String;
    var formatted:Array<String>;

    public function new(text:String) {
        this.unformatted = text.replace("\r", "").replace("\t", "    ");
        this.formatted = new Array<String>();
    }

    public function format(charsPerLine:Int):Array<String> {
        var _words = split(unformatted, [" ", "\n", "-"]);

        var _currentLineLength = 0;
        var _builder = new StringBuilder();

        for (_word in _words) {
            if (_currentLineLength + _word.length > charsPerLine
                && _word != "\n") {
                if (_currentLineLength > 0) {
                    _builder.newLine();
                    _currentLineLength = 0;
                }

                while (_word.length > charsPerLine) {
                    _builder.add(_word.substring(0, charsPerLine));
                    _builder.newLine();
                }

                _word.ltrim();
            }

            _builder.add(_word);
            if (_word == "\n") {
                _currentLineLength = 0;
            } else {
                _currentLineLength += _word.length;
            }
        }

        return _builder.toString().split("\n");
    }

    // https://stackoverflow.com/a/17635/14198301
    private function split(text:String,
            delimiters:Array<String>):Array<String> {
        var _parts = new Array<String>();
        var _startIndex = 0;

        while (true) {
            var _index = -1;
            for (_delimiter in delimiters) {
                var _indexOf = text.indexOf(_delimiter, _startIndex);
                if (_index == -1) {
                    _index = _indexOf;
                } else if (_indexOf != -1) {
                    _index = Std.int(Math.min(_index, _indexOf));
                }
            }

            if (_index == -1) {
                _parts.push(text.substring(_startIndex));
                return _parts;
            }

            var _word = text.substring(_startIndex, _index);
            var _char = text.substring(_index, _index + 1).toChars()[0];
            if (_char.isWhitespace()) {
                _parts.push(_word);
                _parts.push(_char);
            } else {
                _parts.push(_word + _char);
            }

            _startIndex = _index + 1;
        }
    }
}
