package thx;

/**
`Floats` contains helper methods to work with `Float` values.
**/
class Floats {
  public static inline var TOLERANCE : Float = 10e-5;
/**
  Constant value employed to see if two `Float` values are very close.
**/
  public static inline var EPSILON : Float = 1e-9;

  static var pattern_parse = ~/^(\+|-)?(:?\d+(\.\d+)?(e-?\d+)?|nan|NaN|NAN)$/;
  static var pattern_inf = ~/^\+?(inf|Inf|INF)$/;
  static var pattern_neg_inf = ~/^-(inf|Inf|INF)$/;

/**
Returns the angular distance between 2 angles.
**/
  static public function angleDifference(a : Float, b : Float, ?turn : Float = 360.0) {
    var r = (b - a) % turn;
    if(r < 0)
      r += turn;
    if(r > turn / 2)
      r -= turn;
    return r;
  }

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
    return pattern_parse.match(s) || pattern_inf.match(s) || pattern_neg_inf.match(s);

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
    return a < b ? -1 : (a > b ? 1 : 0);

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
Interpolates values in a polar coordinate system looking for the narrowest delta angle.

It can be either clock-wise or counter-clock-wise.
**/
  public static function interpolateAngle(f : Float, a : Float, b : Float, turn : Float = 360)
    return wrapCircular(interpolate(f, a, a + angleDifference(a, b, turn)), turn);

/**
Interpolates values in a polar coordinate system looking for the wideset delta angle.

It can be either clock-wise or counter-clock-wise.
**/
  public static function interpolateAngleWidest(f : Float, a : Float, b : Float, turn : Float = 360) {
    return wrapCircular(interpolateAngle(f, a, b, turn) - turn / 2, turn);
  }

/**
Interpolates values in a polar coordinate system always in clock-wise direction.
**/
  public static function interpolateAngleCW(f : Float, a : Float, b : Float, turn : Float = 360) {
    a = wrapCircular(a, turn);
    b = wrapCircular(b, turn);
    if(b < a)
      b += turn;
    return wrapCircular(interpolate(f, a, b), turn);
  }

/**
Interpolates values in a polar coordinate system always in counter-clock-wise direction.
**/
  public static function interpolateAngleCCW(f : Float, a : Float, b : Float, turn : Float = 360) {
    a = wrapCircular(a, turn);
    b = wrapCircular(b, turn);
    if(b > a)
      b -= turn;
    return wrapCircular(interpolate(f, a, b), turn);
  }

/**
Return the maximum value between two integers or floats.
**/
  inline public static function max<T : Float>(a : T, b : T) : T
    return a > b ? a : b;

/**
Return the minimum value between two integers or floats.
**/
  inline public static function min<T : Float>(a : T, b : T) : T
    return a < b ? a : b;

/**
Float numbers can sometime introduce tiny errors even for simple operations.
`nearEquals` compares two floats using a tiny tollerance (last optional
argument). By default it is defined as `EPSILON`.
**/
  public static function nearEquals(a : Float, b : Float, ?tollerance = EPSILON) {
    if(Math.isFinite(a)) {
      #if (php || java)
      if(!Math.isFinite(b))
        return false;
      #end
      return Math.abs(a - b) <= tollerance;
    }
    if(Math.isNaN(a))
      return Math.isNaN(b);
    if(Math.isNaN(b))
      return false;
    if(!Math.isFinite(b))
      return (a > 0) == (b > 0);
    // a is Infinity and b is finite
    return false;
  }

/**
Float numbers can sometime introduce tiny errors even for simple operations.
`nearEqualAngles` compares two angles (default is 360deg) using a tiny
tollerance (last optional argument). By default the tollerance is defined as
`EPSILON`.
**/
  inline public static function nearEqualAngles(a : Float, b : Float, ?turn = 360.0, ?tollerance = EPSILON)
    return Math.abs(angleDifference(a, b, turn)) <= tollerance;

/**
`nearZero` finds if the passed number is zero or very close to it. By default
`EPSILON` is used as the tollerance value.
**/
  inline public static function nearZero(n : Float, ?tollerance = EPSILON)
    return Math.abs(n) <= tollerance;

/**
`normalize` clamps the passwed value between 0 and 1.
**/
  inline public static function normalize(v : Float) : Float
    return clamp(v, 0, 1);

/**
`parse` can parse a string and tranform it into a `Float` value.
**/
  public static function parse(s : String) {
    if (s.substring(0, 1) == "+")
      s = s.substring(1);
    return if (pattern_inf.match(s)) Math.POSITIVE_INFINITY else if (pattern_neg_inf.match(s)) Math.NEGATIVE_INFINITY else Std.parseFloat(s);
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
  inline public static function sign<T : Float>(value : T) : Int
    return value < 0 ? -1 : 1;

  inline public static function toString(v : Float) : String
    return '$v';

/**
Alias for parse, mainly for disambiguation with other parses using mega Thx.
**/
  inline public static function toFloat(s : String) : Float
    return Floats.parse(s);

  inline public static function trunc(value : Float) : Int
    return value < 0.0 ? Math.ceil(value) : Math.floor(value);

  inline public static function ftrunc(value : Float) : Float
    return value < 0.0 ? Math.fceil(value) : Math.ffloor(value);

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

  /**
   * The ordering instance for floating-point values.
   */
  public static var order(default, never) = Ord.fromIntComparison(compare);

  public static var monoid(default, never): Monoid<Float> = 
    { zero: 0.0, append: function(a: Float, b: Float) return a + b };
}

typedef HaxeMath = Math;
