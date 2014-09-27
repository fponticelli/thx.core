package thx.core;

/**
Helper class for integer values.
**/
class Ints {
  static var pattern_parse = ~/^[+-]?(\d+|0x[0-9A-F]+)$/i;
/**
`abs` returns the absolute integer value of the passed argument.
**/
  inline public static function abs(v : Int) : Int
    return v < 0 ? -v : v;
/**
`canParse` takes a string and return a boolean indicating if the argument can be safely transformed
into a valid integer value.
**/
  public static function canParse(s : String)
    return pattern_parse.match(s);
/**
`clamp` restricts a value within the specified range.
**/
  public static inline function clamp(v : Int, min : Int, max : Int) : Int
    return v < min ? min : (v > max ? max : v);

  inline public static function compare(a : Int, b : Int) : Int
    return a - b;

  inline public static function max(a : Int, b : Int) : Int
    return a > b ? a : b;

  inline public static function min(a : Int, b : Int) : Int
    return a < b ? a : b;

  // TODO add proper octal/hex/exp support
  public static function parse(s : String) {
    if (s.substr(0, 1) == "+")
      s = s.substr(1);
    return Std.parseInt(s);
  }

  public static function random(min = 0, max : Int) {
    Std.random
  }

  public static function range(start : Int, ?stop : Int, step = 1) : Array<Int> {
    if (null == stop) {
      stop = start;
      start = 0;
    }
    if ((stop - start) / step == Math.POSITIVE_INFINITY) throw "infinite range";
    var range = [], i = -1, j;
    if (step < 0)
      while ((j = start + step * ++i) > stop) range.push(j);
    else
      while ((j = start + step * ++i) < stop) range.push(j);
    return range;
  }
}