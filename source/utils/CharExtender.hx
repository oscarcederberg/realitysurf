package utils;

using hx.strings.Char;

class CharExtender {
    static public function isSymbol(char:Char):Bool {
        return !char.isWhitespace() && !char.isAsciiAlphanumeric();
    }
}
