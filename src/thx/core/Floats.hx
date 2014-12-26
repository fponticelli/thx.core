package thx.core;

/**
`Floats` contains helper methods to work with `Float` values.
**/
class Floats {
  public static inline var TOLERANCE : Float = 10e-5;
/**
  Constant value employed to see if two `Float` values are very close.
**/
  public static inline var EPSILON : Float = 10e-10;

  static var pattern_parse = ~/^(\+|-)?\d+(\.\d+)?(e-?\d+)?$/;

/**
Rounds a number up to the specified number of decimals.
**/
  static public function ceilTo(f : Float, decimals : Int) : Float {
    var p = Math.pow(10, decimals);
    return Math.fceil(f * p) / p;
  }

/**
`canParse` checks if a string value can be safely converted into a `Float` value.
**/
  public static function canParse(s : String)
    return pattern_parse.match(s);

/**
`clamp` restricts a value within the specified range.

```haxe
trace(1.3.clamp(0, 1)); // prints 1
trace(0.8.clamp(0, 1)); // prints 0.8
trace(-0.5.clamp(0, 1)); // prints 0.0
```
**/
  public static inline function clamp(v : Float, min : Float, max : Float) : Float
    return v < min ? min : (v > max ? max : v);

/**
Like clamp but you only pass one argument (`max`) that is used as the upper limit
and the opposite (additive inverse or `-max`) as the lower limit.
**/
  public static inline function clampSym(v : Float, max : Float) : Float
    return clamp(v, -max, max);

/**
It returns the comparison value (an integer number) between two `float` values.
**/
  inline public static function compare(a : Float, b : Float) : Int
    return a < b ? -1 : (b > a ? 1 : 0);

/**
Rounds a number down to the specified number of decimals.
**/
  static public function floorTo(f : Float, decimals : Int) : Float {
    var p = Math.pow(10, decimals);
    return Math.ffloor(f * p) / p;
  }

/**
`interpolate` returns a value between `a` and `b` for any value of `f` between 0 and 1.
**/
  public static function interpolate(f : Float, a : Float, b : Float)
    return (b - a) * f + a;

/**
Float numbers can sometime introduce tiny errors even for simple operations. `nearEquals`
comapres floats using a tiny tollerance defined as `EPSILON`.
**/
  inline public static function nearEquals(a : Float, b : Float)
    return Math.abs(a - b) <= EPSILON;

/**
`nearZero` finds if the passed number is zero or very close to it. `EPSILON` is used
as the tollerance value.
**/
  inline public static function nearZero(n : Float)
    return Math.abs(n) <= EPSILON;

/**
`normalize` clamps the passwed value between 0 and 1.
**/
  public static inline function normalize(v : Float) : Float
    return clamp(v, 0, 1);

/**
`parse` can parse a string and tranform it into a `Float` value.
**/
  public static function parse(s : String) {
    if (s.substring(0, 1) == "+")
      s = s.substring(1);
    return Std.parseFloat(s);
  }

/**
Computes the nth root (`index`) of `base`.
**/
  inline public static function root(base : Float, index : Float)
    return Math.pow(base, 1 / index);

/**
Rounds a number to the specified number of decimals.
**/
  static public function roundTo(f : Float, decimals : Int) : Float {
    var p = Math.pow(10, decimals);
    return Math.fround(f * p) / p;
  }

/**
`sign` returns `-1` if `value` is a negative number, `1` otherwise.
*/
  inline public static function sign(value : Float) : Int
    return value < 0 ? -1 : 1;

/**
Passed two boundaries values (`min`, `max`), `wrap` ensures that the passed value `v` will
be included in the boundaries. If the value exceeds `max`, the value is reduced by `min`
repeatedely until it falls within the range. Similar and inverted treatment is performed if
the value is below `min`.
**/
  public static function wrap(v : Float, min : Float, max : Float) : Float {
    var range = max - min + 1;
    if (v < min) v += range * ((min - v) / range + 1);
    return min + (v - min) % range;
  }

/**
Similar to `wrap`, it works for numbers between 0 and `max`.
**/
  public static function wrapCircular(v : Float, max : Float) : Float {
    v = v % max;
    if (v < 0)
      v += max;
    return v;
  }
}

typedef HaxeMath = Math;