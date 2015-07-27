package thx;

import haxe.Utf8;

/**
Represents a sequence of Utf8 characters stored as an array of integers.
**/
@:forward(concat,copy,indexOf,insert,iterator,join,lastIndexOf,length,map,pop,
  push,remove,reverse,shift,slice,sort,splice,unshift)
@:arrayAccess
abstract Chars(Array<Char>)  {
  @:from public static function fromString(s : String) : Chars
    return Strings.map(s, function(s : String) : Char
      return Utf8.charCodeAt(s, 0));

  @:from inline public static function fromArray(arr : Array<Int>) : Chars
    return fromChars(cast arr);

  @:from inline public static function fromChars(arr : Array<Char>) : Chars
    return new Chars(arr);

  inline function new(chars : Array<Char>)
    this = chars;

  @:to public function toString()
    return this.map(function(c : Char) : String return c.toString()).join("");
}
