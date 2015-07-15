package thx;

import haxe.Utf8;

abstract Char(Int) from Int to Int  {
  @:from inline public static function fromString(s : String) : Char
    return Utf8.charCodeAt(s, 0);

  public function compare(other : Char)
    return Utf8.compare(toString(), other);

  @:op(A==B) inline public function equals(other : Char)
    return compare(other) == 0;

  @:op(A>B) inline public function greater(other : Char)
    return compare(other) > 0;

  @:op(A>=B) inline public function greaterEquals(other : Char)
    return compare(other) >= 0;

  @:op(A<=B) inline public function lessEquals(other : Char)
    return compare(other) <= 0;

  @:op(A<B) inline public function less(other : Char)
    return compare(other) < 0;

  @:to inline public function toString() : String
    return String.fromCharCode(this);
}
