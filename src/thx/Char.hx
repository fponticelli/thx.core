package thx;

import haxe.Utf8;

abstract Char(Int) to Int  {
  @:from inline public static function fromInt(i : Int) : Char {
    Assert.isTrue(i >= 0, 'Char value should be greater than zero: $i');
    return new Char(i);
  }

  @:from inline public static function fromString(s : String) : Char
    return Utf8.charCodeAt(s, 0);

  inline function new(i : Int)
    this = i;

  public function compare(other : Char)
    return Utf8.compare(toString(), other);

  public function isControl()
    return (this >= 0x0000 && this <= 0x001F) || this == 0x007F || (this >= 0x0080 && this <= 0x009F);

  public function next() : Char
    return this + 1;

  public function prev() : Char
    return this - 1;

  public function toUpperCase() : Char
    return toString().toUpperCase();

  public function toLowerCase() : Char
    return toString().toLowerCase();

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
