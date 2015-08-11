/*
 * Copyright (C)2005-2015 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

/**
Code temporarily borrowed from the haxe std library
(https://github.com/HaxeFoundation/haxe/pull/4179) waiting for it to merge
and make into an official release.
**/
package thx;

using haxe.Int64;

import StringTools;

class Int64s {
  public static var one  = Int64.make(0, 1);
  public static var zero = Int64.make(0, 0);

  public static var maxValue = haxe.Int64.make(0x7fffffff,0xffffffff);
  public static var minValue = haxe.Int64.make(0x80000000,0x00000001);

  public static function abs(value : Int64)
    return value < zero ? -value : value;

  public static function compare(a : Int64, b : Int64)
    if(a > b)
      return 1;
    else if(a < b)
      return -1;
    else
      return 0;

  static var base = Int64.ofInt(10);
  public static function parse(s : String) : Int64 {
    var sIsNegative = false,
        multiplier = Int64.ofInt(1),
        current = Int64.ofInt(0);
    if(s.charAt(0) == "-") {
      sIsNegative = true;
      s = s.substring(1, s.length);
    }
    var len = s.length;

    for (i in 0...len) {
      var digitInt = s.charCodeAt(len - 1 - i) - '0'.code;

      if(digitInt < 0 || digitInt > 9)
        throw new Error("String should only contain digits (and an optional - sign)");

      var digit = Int64.ofInt(digitInt);
      if(sIsNegative) {
        current = Int64.sub(current, Int64.mul(multiplier, digit));
        if(!Int64.isNeg(current))
          throw new Error("Int64 parsing error: Underflow");
      } else {
        current = Int64.add(current, Int64.mul(multiplier, digit));
        if(Int64.isNeg(current))
          throw new Error("Int64 parsing error: Overflow");
      }
      multiplier = Int64.mul(multiplier, base);
    }
    return current;
  }

  static var min = Int64.make(0x80000000, 0);

/**
Converts an `Int64` to `Float`;

Implementation by Elliott Stoneham.
*/
  public static function toFloat(i : Int64) : Float {
    var isNegative = false;
    if(i < 0) {
      if(i < min)
        return -9223372036854775808.0; // most -ve value can't be made +ve
      isNegative = true;
      i = -i;
    }
    var multiplier = 1.0,
        ret = 0.0;
    for(_ in 0...64) {
      if(i.and(one) != zero)
        ret += multiplier;
      multiplier *= 2.0;
      i = i.shr(1);
    }
    return (isNegative ? -1 : 1) * ret;
  }

  public static function fromFloat(f : Float) : Int64 {
    if(Math.isNaN(f) || !Math.isFinite(f))
      throw new Error("Conversion to Int64 failed. Number is NaN or Infinite");

    var noFractions = f - (f % 1);

    // 2^53-1 and -2^53: these are parseable without loss of precision
    if(noFractions > 9007199254740991.0)
      throw new Error("Conversion to Int64 failed. Conversion overflow");
    if(noFractions < -9007199254740991.0)
      throw new Error("Conversion to Int64 failed. Conversion underflow");

    var result = zero,
        neg    = noFractions < 0.0,
        rest   = neg ? -noFractions : noFractions;

    var i = 0, curr;
    while (rest >= 1) {
      curr = rest % 2;
      rest = rest / 2;
      if(curr >= 1)
        result = Int64.add(result, Int64.shl(Int64.ofInt(1), i));
      i++;
    }

    if(neg)
      return Int64.neg(result);
    else
      return result;
  }
}

typedef Int64 = haxe.Int64;
