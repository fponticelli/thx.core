package thx;

abstract Char(Int) from Int to Int  {
  @:from inline public static function fromString(s : String) : Char
    return haxe.Utf8.charCodeAt(s, 0);

  @:to inline public function toString() : String
    return String.fromCharCode(this);
}
