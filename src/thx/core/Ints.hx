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

/**
Like clamp but you only pass one argument (`max`) that is used as the upper limit
and the opposite (additive inverse or `-max`) as the lower limit.
**/
  public static inline function clampSym(v : Int, max : Int) : Int
    return clamp(v, -max, max);

/**
Return a comparison value between `a` and `b`. The number is negative if `a` is
greater than `b`, positive if `a` is lesser than `b` or zero if `a` and `b` are
equals.
**/
  inline public static function compare(a : Int, b : Int) : Int
    return a - b;

/**
Given a value `t` between 0 and 1, it interpolates that value in the range between `a` and `b`.

The returned value is a rounded integer.
*/
  public static function interpolate(t : Float, a : Float, b : Float) : Int
    return Math.round(a + (b - a) * f);

/**
It returns the maximum value between `a` and `b`.
**/
  inline public static function max(a : Int, b : Int) : Int
    return a > b ? a : b;

/**
It returns the minimum value between `a` and `b`.
**/
  inline public static function min(a : Int, b : Int) : Int
    return a < b ? a : b;

  // TODO add proper octal/hex/exp support
  public static function parse(s : String) {
    if (s.substr(0, 1) == "+")
      s = s.substr(1);
    return Std.parseInt(s);
  }

/**
Integer random function that includes both upper and lower limits. A roll on a die with
6 sides would be the equivalent to the following:

```haxe
var d6 = Ints.random(1, 6);
```
**/
  inline public static function random(min = 0, max : Int)
    return Std.random(max + 1) + min;

/**
`range` creates an array of integer containing values between  start (included) and stop (excluded)
with a progression set by `step`. A negative value for `step` can be used but in that
case start will need to be a greater value than stop.
**/
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

/**
`sign` returns `-1` if `value` is a negative number, `1` otherwise.
*/
  inline public static function sign(value : Int) : Int
    return value < 0 ? -1 : 1;

/**
Similar to `wrap`, it works for numbers between 0 and `max`.
**/
  public static function wrapCircular(v : Int, max : Int) : Int {
    v = v % max;
    if (v < 0)
      v += max;
    return v;
  }
}