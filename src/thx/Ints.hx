package thx;

using thx.Arrays;
using thx.Strings;
import thx.Ord;
import thx.Monoid;
using StringTools;

/**
Extension methods for integer values.
**/
class Ints {
  static var pattern_parse = ~/^[ \t\r\n]*[+-]?(\d+|0x[0-9A-F]+)/i;
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
  public static function compare(a : Int, b : Int) : Int
    return a - b;

/**
Returns the greater common denominator
**/
  public static function gcd(m : Int, n : Int) : Int {
    m = abs(m);
    n = abs(n);
    var t;
    do {
      if(n == 0) return m;
      t = m;
      m = n;
      n = t % m;
    } while(true);
  }

/**
Given a value `t` between 0 and 1, it interpolates that value in the range between `a` and `b`.

The returned value is a rounded integer.
*/
  public static function interpolate(f : Float, a : Float, b : Float) : Int
    return Math.round(a + (b - a) * f);

/**
`isEven` returns `true` if `v` is even, `false` otherwise.
**/
  inline public static function isEven(v : Int)
    return v % 2 == 0;

/**
`isOdd` returns `true` if `v` is odd, `false` otherwise.
**/
  inline public static function isOdd(v : Int)
    return v % 2 != 0;

  public static function lpad(v : Int, ?pad = "0", len : Int) : String {
    var neg = false;
    if(v < 0) {
      neg = true;
      v = -v;
    }
    return (neg ? "-" : "") + StringTools.lpad('$v', pad, len);
  }

/**
Returns the least common multiple
**/
  public static function lcm(m : Int, n : Int) : Int {
    m = abs(m);
    n = abs(n);
    if(n == 0) return m;
    return m * Std.int(n / gcd(m, n));
  }

  inline public static function rpad(v : Int, ?pad = "0", len : Int) : String
    return StringTools.rpad('$v', pad, len);

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

/**
Parses a string into an Int value using the provided base. Default base is 16 for strings that begin with
0x (after optional sign) or 10 otherwise.
**/
  public static function parse(s : String, ?base : Int) : Null<Int> {
    #if js
    if(null == base) {
      if(s.substring(0, 2) == "0x")
        base = 16;
      else
        base = 10;
    }
    var v : Int = untyped __js__("parseInt")(s, base);
    return Math.isNaN(v) ? null : v;
    #elseif flash9
    if(base == null) base = 0;
    var v : Int = untyped __global__["parseInt"](s, base);
    return Math.isNaN(v) ? null : v;
    #else

    if(base != null && (base < 2 || base > BASE.length))
      return throw 'invalid base $base, it must be between 2 and ${BASE.length}';

    s = s.trim().toLowerCase();

    var sign = if(s.startsWith("+")) {
          s = s.substring(1);
          1;
        } else if(s.startsWith("-")) {
          s = s.substring(1);
          -1;
        } else {
          1;
        };

    if(s.length == 0)
      return null;

    if(s.startsWith('0x')) {
      if(null != base && 16 != base)
        return null; // attempting at converting a hex using a different base
      base = 16;
      s = s.substring(2);
    } else if(null == base) {
      base = 10;
    }

    var acc = 0;
    try s.map(function(c) {
      var i = BASE.indexOf(c);
      if(i < 0 || i >= base) throw 'invalid';
      acc = (acc * base) + i;
    }) catch(e : Dynamic) {};
    return acc * sign;
    #end
  }

/**
Integer random function that includes both upper and lower limits. A roll on a die with
6 sides would be the equivalent to the following:

```haxe
var d6 = Ints.random(1, 6);
```
**/
  inline public static function random(min = 0, max : Int)
    return Std.random(max - min + 1) + min;

/**
`range` creates an array of integer containing values between  start (included) and stop (excluded)
with a progression set by `step`. A negative value for `step` can be used but in that
case start will need to be a greater value than stop.
**/
  public static function range(start : Int, ?stop : Int, step = 1) : Array<Int> {
    if(null == stop) {
      stop = start;
      start = 0;
    }
    if((stop - start) / step == Math.POSITIVE_INFINITY) throw "infinite range";
    var range = [], i = -1, j;
    if(step < 0)
      while ((j = start + step * ++i) > stop) range.push(j);
    else
      while ((j = start + step * ++i) < stop) range.push(j);
    return range;
  }

  public static function rangeIter(start: Int, ?stop: Int, step = 1): Iterator<Int> {
    return new RangeIterator(start, stop, step);
  }

  // Base used for toString/parseInt conversions. Supporting base 2 to 36 for now as common standard.
  static var BASE = "0123456789abcdefghijklmnopqrstuvwxyz";

/**
Transform an `Int` value to a `String` using the specified `base`
**/
  #if(js || flash) inline #end
  public static function toString(value : Int, base : Int) : String {
    #if(js || flash)
    return untyped value.toString(base);
    #else

    if(base < 2 || base > BASE.length)
      return throw 'invalid base $base, it must be between 2 and ${BASE.length}';
    if(base == 10 || value == 0)
      return '$value';

    var buf = "",
        abs = Ints.abs(value);
    while(abs > 0) {
      buf = BASE.charAt(abs % base) + buf;
      abs = Std.int(abs / base);
    }

    return (value < 0 ? "-" : "") + buf;
    #end
  }

/**
Alias for toString, mainly for disambig. with standard toString using mega Thx.
Should toString just be renamed to this? At least with this, existing code
doesn't break.
**/
  inline public static function toBase(value : Int, base : Int) : String
    return Ints.toString(value, base);

/**
Converts an integer value into a boolean. Any value different from `0` will evaluate to `true`.
**/
  public static inline function toBool(v : Int)
    return v != 0;

/**
Alias for parse, mainly for disambiguation with other parses using mega Thx.
**/
  inline public static function toInt(s : String, ?base : Int) : Int
    return Ints.parse(s, base);

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
    if(v < 0)
      v += max;
    return v;
  }

  public static var order(default, never): Ord<Int> =
    function(i0, i1) { return if (i0 > i1) GT else if (i0 == i1) EQ else LT; };

  public static var monoid(default, never): Monoid<Int> =
    { zero: 0, append: function(a: Int, b: Int) return a + b };
}

class RangeIterator {
  var current: Int;
  var stop: Null<Int>;
  var step: Int;

  public function new(start: Int, stop: Null<Int> = null, step = 1) {
    this.current = start;
    this.stop = stop;
    this.step = step;
  }

  public function hasNext() {
    return stop == null || (step >= 0 && current < stop) || (step < 0 && current > stop);
  }

  public function next() {
    var result = current;
    current += step;
    return result;
  }
}
