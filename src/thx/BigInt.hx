package thx;

using haxe.Int64;

/**
Based on code realized by Mike Welsh: https://github.com/Herschel/hxmath/blob/master/src/hxmath/BigInt.hx
*/
// TODO
// ++ ?
// -- ?
// ~ bitwise negation
// &
// |
// ^
// <<
// >>
// >>>

@:access(thx.Big)
abstract BigInt(BigIntImpl) from BigIntImpl to BigIntImpl {
  public static var zero(default, null) : BigInt = new Small(0);

  @:from public static function fromFloat(value : Float) : BigInt
    return zero;

  @:from public static function fromInt(value : Int) : BigInt
    return (new Small(value) : BigIntImpl);

  @:from public inline static function fromString(value : String) : BigInt
    return Big.parseBigInteger(value, 10);

  public inline static function fromStringWithBase(value : String, base : Int) : BigInt
    return Big.parseBigInteger(value, base);

  inline public function isZero() : Bool
    return this.isZero();

  inline public function compare(that : BigInt)
    return this.compare(that);

  @:op(A>B) public function greater(that : BigInt) : Bool
    return this.compare(that) > 0;

  @:op(A>=B) public function greaterEqual(that : BigInt) : Bool
    return this.compare(that) >= 0;

  @:op(A<B) public function less(that : BigInt) : Bool
    return this.compare(that) < 0;

  @:op(A<=B) public function lessEqual(that : BigInt) : Bool
    return this.compare(that) <= 0;

  @:op(A=B) @:commutative
  public function equals(that : BigInt) : Bool
    return this.compare(that) == 0;

  @:op(A!=B) @:commutative
  public function notEquals(that : BigInt) : Bool
    return this.compare(that) != 0;

  @:op(A+B) @:commutative
  inline public function add(that : BigInt) : BigInt
    return this.add(that);

  @:op(A-B)
  inline public function subtract(that : BigInt) : BigInt
    return this.subtract(that);

  @:op(-A)
  inline public function negate() : BigInt
    return this.negate();

  @:op(A*B) @:commutative
  inline public function multiply(that : BigInt) : BigInt
    return this.multiply(that);

  @:op(A/B)
  inline public function divide(that : BigInt) : BigInt
    return this.divide(that);

  @:op(A%B)
  inline public function modulo(that : BigInt) : BigInt
    return this.modulo(that);

  @:to inline public function toFloat() : Float
    return this.toFloat();

  @:to inline public function toInt() : Int
    return this.toInt();

  @:to inline public function toString() : String
    return this.toStringWithBase(10);
}

interface BigIntImpl {
  var isSmall(default, null) : Bool;
  function add(that : BigIntImpl) : BigIntImpl;
  function subtract(that : BigIntImpl) : BigIntImpl;
  function divide(that : BigIntImpl) : BigIntImpl;
  function multiply(that : BigIntImpl) : BigIntImpl;
  function modulo(that : BigIntImpl) : BigIntImpl;
  function negate() : BigIntImpl;
  function isZero() : Bool;
  function compare(that : BigIntImpl) : Int;
  function toFloat() : Float;
  function toInt() : Int;
  function toStringWithBase(base : Int) : String;
}

class Small implements BigIntImpl{
  public var value : Int;
  public var isSmall(default, null) : Bool;
  public function new(value : Int) {
    this.value = value;
    isSmall = true;
  }

  public function add(that : BigIntImpl) : BigIntImpl {
    if(that.isSmall) {
      var x = (cast that : Small).value;
      var value = x + value;
      if (value > -Big.BASE && value < Big.BASE) {
        return new Small(value);
      } else {
        return Big.addImpl(Floats.sign(x), null, Floats.sign(Math.abs(x)), Ints.abs(x), Ints.sign(value), null, Ints.sign(Ints.abs(value)), Ints.abs(value));
      }
    } else {
      var x = (cast that : Big);
      return Big.addImpl(x.signum, x.magnitude, x.length, 0, Ints.sign(value), null, Floats.sign(Ints.abs(value)), Ints.abs(value));
    }
  }

  public function subtract(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function divide(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function multiply(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function modulo(that : BigIntImpl) : BigIntImpl {
    return new Small(0);
  }

  public function negate() : BigIntImpl {
    return new Small(-value);
  }

  public function isZero() : Bool {
    return value == 0;
  }

  // TODO
  public function compare(that : BigIntImpl) : Int
    return 0;

  // TODO
  public function toFloat() : Float
    return value;

  // TODO
  public function toInt() : Int
    return value;

  public function toStringWithBase(base : Int) : String
    return Ints.toString(value, base);
}

class Big implements BigIntImpl {
  public var isSmall(default, null) : Bool;
  public var signum : Int;
  public var magnitude : Array<Int>;
  public var length : Int;
  public function new(signum : Int, magnitude : Array<Int>, length : Int) {
    this.signum = signum;
    this.magnitude = magnitude;
    this.length = length;
    this.isSmall = false;
  }

  public function add(that : BigIntImpl) : BigIntImpl {
    if(that.isSmall) {
      var v = (cast that : Small).value;
      return addImpl(Ints.sign(v), null, Floats.sign(Math.abs(v)), Ints.abs(v), signum, magnitude, length, 0);
    } else {
      var big : Big = cast that;
      return addImpl(big.signum, big.magnitude, big.length, 0, signum, magnitude, length, 0);
    }
  }

  public function subtract(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function divide(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function multiply(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function modulo(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function negate() : BigIntImpl {
    return new Big(-signum, magnitude, length);
  }

  public function isZero() : Bool {
    return false;
  }

  // TODO
  public function compare(that : BigIntImpl) : Int
    return 0;

  // TODO
  public function toFloat() : Float
    return 0;

  // TODO
  public function toInt() : Int
    return 0;

  public function toStringWithBase(base : Int) : String
    return toStringImpl(signum, magnitude, length, base);

  // helpers
  static function createArray(length : Int) {
    var x = #if js untyped __js__("new Array")(length) #else [] #end;
    for(i in 0...length)
      x[i] = 0;
    return x;
  }

  static function parseInteger(s : String, from : Int, to : Int, radix : Int) {
    var i = from - 1,
        n = 0,
        y = radix < 10 ? radix : 10,
        code, v;
    // TODO use for()
    while(++i < to) {
      code = s.charCodeAt(i);
      v = code - 48;
      if(v < 0 || y <= v) {
        v = 10 - 65 + code;
        if(v < 10 || radix <= v) {
          v = 10 - 97 + code;
          if(v < 10 || radix <= v) {
            throw new Error('Invalid character $code');
          }
        }
      }
      n = n * radix + v;
    }
    return n;
  }

  static function pow(x : Int, count : Int) {
    var accumulator = 1;
    var v = x;
    // TODO simplify
    var c = count;
    while(c > 1) {
      var q = Floats.trunc(c / 2);
      if(q * 2 != c) {
        accumulator *= v;
      }
      v *= v;
      c = q;
    }
    return accumulator * v;
  }

  static function fastTrunc(x : Float) : Int {
    var v = (x - BASE) + BASE;
    return Std.int(v > x ? v - 1 : v);
  }

  // Veltkamp-Dekker's algorithm
  // see http://web.mit.edu/tabbott/Public/quaddouble-debian/qd-2.3.4-old/docs/qd.pdf
  // with FMA:
  // var product = a * b;
  // var error = Math.fma(a, b, -product);
  static function performMultiplication(carry, a, b) : { lo : Int, hi : Int } {
    //trace(SPLIT);
    var at = SPLIT * a;
    var ahi = at - (at - a);
    var alo = a - ahi;
    var bt = SPLIT * b;
    var bhi = bt - (bt - b);
    var blo = b - bhi;
    var product = a * b;
    var error = ((ahi * bhi - product) + ahi * blo + alo * bhi) + alo * blo;

    var hi = fastTrunc(product / BASE);
    var lo = Std.int(product - hi * BASE + error);

    if(lo < 0) {
      lo += BASE;
      hi -= 1;
    }

    lo += carry - BASE;
    if(lo < 0) {
      lo += BASE;
    } else {
      hi += 1;
    }

    return {lo: lo, hi: hi};
  };

  static function performDivision(a : Int, b : Int, divisor : Int) {
    if(a >= divisor) {
      throw new Error('`a` ($a) is bigger than divisor ($divisor)');
    }
    var p = a * BASE;
    var y = fastTrunc(p / divisor);
    var r : Int = p % divisor;
    var q : Int = y;
    if(y == q && r > divisor - r) {
      q -= 1;
    }
    r += b - divisor;
    if(r < 0) {
      r += divisor;
    } else {
      q += 1;
    }
    y = fastTrunc(r / divisor);
    r -= y * divisor;
    q += y;
    // TODO check
    return {q: q, r: r};
  };


  // TODO inline?
  static function createBigInteger(signum : Int, magnitude : Array<Int>, length : Int) : BigIntImpl {
    if(length < 2) {
      if(length == 0) {
        return new Small(0);
      } else {
        if(signum < 0) {
          return new Small(0 - magnitude[0]);
        } else {
          return new Small(magnitude[0]);
        }
      }
    } else {
      return new Big(signum, magnitude, length);
    }
  }

  static function parseBigInteger(s : String, ?radix : Int = 10) : BigIntImpl {
    if(!(radix >= 2 && radix <= 36)) {
      throw new Error("radix argument must be an integer between 2 and 36");
    }
    var length = s.length;
    if(length == 0) {
      throw new Error("cannot parse empty string");
    }
    var signum = 1;
    var signCharCode = s.charCodeAt(0);
    var from = 0;
    if(signCharCode == 43) { // "+"
      from = 1;
    }
    if(signCharCode == 45) { // "-"
      from = 1;
      signum = -1;
    }

    length -= from;
    if(length == 0) {
      throw new Error('string only contains the sign');
    }
    if(pow(radix, length) <= BASE) {
      var value = parseInteger(s, from, from + length, radix);
      return new Small(signum < 0 ? 0 - value : value);
    }
    var groupLength = 0;
    var groupRadix = 1;
    var limit = fastTrunc(BASE / radix);
    while(groupRadix <= limit) {
      groupLength += 1;
      groupRadix *= radix;
    }
    var size = Floats.trunc((length - 1) / groupLength) + 1;

    var magnitude = createArray(size);
    var k = size;
    var i = length;
    while(i > 0) {
      k -= 1;
      magnitude[k] = parseInteger(s, from + (i > groupLength ? i - groupLength : 0), from + i, radix);
      i -= groupLength;
    }

    var j = -1;
    while(++j < size) {
      var c = magnitude[j];
      var l = -1;
      while(++l < j) {
        var tmp = performMultiplication(c, magnitude[l], groupRadix); //, magnitude, l);
        var lo = tmp.lo;
        var hi = tmp.hi;
        magnitude[l] = lo;
        c = hi;
      }
      magnitude[j] = c;
    }

    while(size > 0 && magnitude[size - 1] == 0) {
      size -= 1;
    }

    return createBigInteger(size == 0 ? 0 : signum, magnitude, size);
  }

  static function compareMagnitude(aMagnitude : Array<Int>, aLength : Int, aValue : Int, bMagnitude : Array<Int>, bLength : Int, bValue : Int) {
    if(aLength != bLength) {
      return aLength < bLength ? -1 : 1;
    }
    var i = aLength;
    while(--i >= 0) {
      if((aMagnitude == null ? aValue : aMagnitude[i]) != (bMagnitude == null ? bValue : bMagnitude[i])) {
        return (aMagnitude == null ? aValue : aMagnitude[i]) < (bMagnitude == null ? bValue : bMagnitude[i]) ? -1 : 1;
      }
    }
    return 0;
  };

  static function compareTo(aSignum : Int, aMagnitude : Array<Int>, aLength : Int, aValue : Int, bSignum : Int, bMagnitude : Array<Int>, bLength : Int, bValue : Int) : Int {
    if(aSignum == bSignum) {
      var c = compareMagnitude(aMagnitude, aLength, aValue, bMagnitude, bLength, bValue);
      return aSignum < 0 ? 0 - c : c; // positive zero will be returned for c == 0
    }
    if(aSignum == 0) {
      return 0 - bSignum;
    }
    return aSignum;
  };

  public static function addImpl(aSignum : Int, aMagnitude : Array<Int>, aLength : Int, aValue : Int, bSignum : Int, bMagnitude : Array<Int>, bLength : Int, bValue : Int) : BigIntImpl {
    var z = compareMagnitude(aMagnitude, aLength, aValue, bMagnitude, bLength, bValue);
    var minSignum = z < 0 ? aSignum : bSignum;
    var minMagnitude = z < 0 ? aMagnitude : bMagnitude;
    var minLength = z < 0 ? aLength : bLength;
    var minValue = z < 0 ? aValue : bValue;
    var maxSignum = z < 0 ? bSignum : aSignum;
    var maxMagnitude = z < 0 ? bMagnitude : aMagnitude;
    var maxLength = z < 0 ? bLength : aLength;
    var maxValue = z < 0 ? bValue : aValue;

    // |a| <= |b|
    if(minSignum == 0) {
      return maxMagnitude == null ? new Small(maxSignum < 0 ? 0 - maxValue : maxValue) : createBigInteger(maxSignum, maxMagnitude, maxLength);
    }
    var subtract = 0;
    var resultLength = maxLength;
    if(minSignum != maxSignum) {
      subtract = 1;
      if(minLength == resultLength) {
        while(resultLength > 0 && (minMagnitude == null ? minValue : minMagnitude[resultLength - 1]) == (maxMagnitude == null ? maxValue : maxMagnitude[resultLength - 1])) {
          resultLength -= 1;
        }
      }
      if(resultLength == 0) { // a == (-b)
        return createBigInteger(0, createArray(0), 0);
      }
    }
    // result != 0
    var result = createArray(resultLength + (1 - subtract));
    var i = -1;
    var c = 0;
    while(++i < resultLength) {
      var aDigit = i < minLength ? (minMagnitude == null ? minValue : minMagnitude[i]) : 0;
      // TODO check
      c += (maxMagnitude == null ? maxValue : maxMagnitude[i]) + (subtract == 1 ? 0 - aDigit : aDigit - BASE);
      if(c < 0) {
        // TODO check
        result[i] = BASE + c;
        c = 0 - subtract;
      } else {
        result[i] = c;
        c = 1 - subtract;
      }
    }
    if(c != 0) {
      result[resultLength] = c;
      resultLength += 1;
    }
    while(resultLength > 0 && result[resultLength - 1] == 0) {
      resultLength -= 1;
    }
    return createBigInteger(maxSignum, result, resultLength);
  };

  static function multiplyImpl(aSignum : Int, aMagnitude : Array<Int>, aLength : Int, aValue : Int, bSignum : Int, bMagnitude : Array<Int>, bLength : Int, bValue : Int) : BigIntImpl {
    if(aLength == 0 || bLength == 0) {
      return createBigInteger(0, createArray(0), 0);
    }
    var resultSign = aSignum < 0 ? 0 - bSignum : bSignum;
    if(aLength == 1 && (aMagnitude == null ? aValue : aMagnitude[0]) == 1) {
      return bMagnitude == null ? new Small(resultSign < 0 ? 0 - bValue : bValue) : createBigInteger(resultSign, bMagnitude, bLength);
    }
    if(bLength == 1 && (bMagnitude == null ? bValue : bMagnitude[0]) == 1) {
      return aMagnitude == null ? new Small(resultSign < 0 ? 0 - aValue : aValue) : createBigInteger(resultSign, aMagnitude, aLength);
    }
    var resultLength = aLength + bLength;
    var result = createArray(resultLength);
    var i = -1;
    while(++i < bLength) {
      var c = 0;
      var j = -1;
      while(++j < aLength) {
        var carry = 0;
        // TODO check
        c += result[j + i] - BASE;
        if(c >= 0) {
          carry = 1;
        } else {
          // TODO check
          c += BASE;
        }
        var tmp = performMultiplication(c, aMagnitude == null ? aValue : aMagnitude[j], bMagnitude == null ? bValue : bMagnitude[i]);
        var lo = tmp.lo;
        var hi = tmp.hi;
        result[j + i] = lo;
        c = hi + carry;
      }
      result[aLength + i] = c;
    }
    while(resultLength > 0 && result[resultLength - 1] == 0) {
      resultLength -= 1;
    }
    return createBigInteger(resultSign, result, resultLength);
  };

  static function divideAndRemainder(aSignum : Int, aMagnitude : Array<Int>, aLength : Int, aValue : Int, bSignum : Int, bMagnitude : Array<Int>, bLength : Int, bValue : Int, divide) {
    if(bLength == 0) {
      throw new Error('division by zero');
    }
    if(aLength == 0) {
      return createBigInteger(0, createArray(0), 0);
    }
    var quotientSign = aSignum < 0 ? 0 - bSignum : bSignum;
    if(bLength == 1 && (bMagnitude == null ? bValue : bMagnitude[0]) == 1) {
      if(divide == 1) {
        return aMagnitude == null ? new Small(quotientSign < 0 ? 0 - aValue : aValue) : createBigInteger(quotientSign, aMagnitude, aLength);
      }
      return createBigInteger(0, createArray(0), 0);
    }

    var divisorOffset = aLength + 1; // `+ 1` for extra digit in case of normalization
    var divisorAndRemainder = createArray(divisorOffset + bLength + 1); // `+ 1` to avoid `index < length` checks
    var divisor = divisorAndRemainder;
    var remainder = divisorAndRemainder;
    var n = -1;
    while(++n < aLength) {
      remainder[n] = aMagnitude == null ? aValue : aMagnitude[n];
    }
    var m = -1;
    while(++m < bLength) {
      divisor[divisorOffset + m] = bMagnitude == null ? bValue : bMagnitude[m];
    }

    var top = divisor[divisorOffset + bLength - 1];

    // normalization
    var lambda = 1;
    if(bLength > 1) {
      // TODO check
      lambda = fastTrunc(BASE / (top + 1));
      if(lambda > 1) {
        var carry = 0;
        var l = -1;
        while(++l < divisorOffset + bLength) {
          var tmp = performMultiplication(carry, divisorAndRemainder[l], lambda);
          var lo = tmp.lo;
          var hi = tmp.hi;
          divisorAndRemainder[l] = lo;
          carry = hi;
        }
        divisorAndRemainder[divisorOffset + bLength] = carry;
        top = divisor[divisorOffset + bLength - 1];
      }
      // assertion
      if(top < fastTrunc(BASE / 2)) {
        throw new Error('failed assertion'); // TODO ?
      }
    }

    var shift = aLength - bLength + 1;
    if(shift < 0) {
      shift = 0;
    }
    var quotient = null;
    var quotientLength = 0;

    var i = shift;
    while(--i >= 0) {
      var t = bLength + i;
      var q = BASE - 1;
      if(remainder[t] != top) {
        var tmp2 = performDivision(remainder[t], remainder[t - 1], top);
        var q2 = tmp2.q;
        var r2 = tmp2.r;
        q = q2;
      }

      var ax = 0;
      var bx = 0;
      var j = i - 1;
      while(++j <= t) {
        var rj = remainder[j];
        // TODO check
        var tmp3 = performMultiplication(bx, q, divisor[divisorOffset + j - i]);
        var lo3 = tmp3.lo;
        var hi3 = tmp3.hi;
        remainder[j] = lo3;
        bx = hi3;
        ax += rj - remainder[j];
        if(ax < 0) {
          // TODO check
          remainder[j] = BASE + ax;
          ax = -1;
        } else {
          remainder[j] = ax;
          ax = 0;
        }
      }
      while(ax != 0) {
        q -= 1;
        var c = 0;
        var k = i - 1;
        while(++k <= t) {
          // TODO check
          c += remainder[k] - BASE + divisor[divisorOffset + k - i];
          if(c < 0) {
            // TODO check
            remainder[k] = BASE + c;
            c = 0;
          } else {
            remainder[k] = c;
            c = 1;
          }
        }
        ax += c;
      }
      if(divide == 1 && q != 0) {
        if(quotientLength == 0) {
          quotientLength = i + 1;
          quotient = createArray(quotientLength);
        }
        // TODO check
        quotient[i] = q;
      }
    }

    if(divide == 1) {
      if(quotientLength == 0) {
        return createBigInteger(0, createArray(0), 0);
      }
      return createBigInteger(quotientSign, quotient, quotientLength);
    }

    var remainderLength = aLength + 1;
    if(lambda > 1) {
      var r = 0;
      var p = remainderLength;
      while(--p >= 0) {
        var tmp4 = performDivision(r, remainder[p], lambda);
        var q4 = tmp4.q;
        var r4 = tmp4.r;
        remainder[p] = q4;
        r = r4;
      }
      if(r != 0) {
        // assertion
        throw new Error('r != 0'); // ?
      }
    }
    while(remainderLength > 0 && remainder[remainderLength - 1] == 0) {
      remainderLength -= 1;
    }
    if(remainderLength == 0) {
      return createBigInteger(0, createArray(0), 0);
    }
    var result = createArray(remainderLength);
    var o = -1;
    while(++o < remainderLength) {
      result[o] = remainder[o];
    }
    return createBigInteger(aSignum, result, remainderLength);
  };

  static function toStringImpl(signum : Int, magnitude : Array<Int>, length : Int, radix : Int) {
    var result = signum < 0 ? "-" : "";

    var remainderLength = length;
    if(remainderLength == 0) {
      return "0";
    }
    if(remainderLength == 1) {
      result += Ints.toString(magnitude[0], radix);
      return result;
    }
    var groupLength = 0;
    var groupRadix = 1;
    var limit = fastTrunc(BASE / radix);
    while(groupRadix <= limit) {
      groupLength += 1;
      groupRadix *= radix;
    }
    // assertion
    if(groupRadix * radix <= BASE) {
      throw new Error('groupRadix * radix <= BASE ($groupRadix * $radix <= $BASE)'); // ?
    }
    var size = remainderLength + Floats.trunc((remainderLength - 1) / groupLength) + 1;
    var remainder = createArray(size);
    var n = -1;
    while(++n < remainderLength) {
      remainder[n] = magnitude[n];
    }

    var k = size;

    while(remainderLength != 0) {
      var groupDigit = 0;
      var i = remainderLength;
      //if(i < 0)
      //  trace(i);
      while(--i >= 0) {
        var tmp = performDivision(groupDigit, remainder[i], groupRadix);
        var q = tmp.q;
        var r = tmp.r;
        remainder[i] = q;
        groupDigit = r;
      }
      while(remainderLength > 0 && remainder[remainderLength - 1] == 0) {
        remainderLength -= 1;
      }
      k -= 1;
      remainder[k] = groupDigit;
    }

    result += Ints.toString(remainder[k], radix);
    while(++k < size) {
      var t = Ints.toString(remainder[k], radix);
      var j = groupLength - t.length;
      while(--j >= 0) {
        result += "0";
      }
      result += t;
    }
    return result;
  }
  /*
  static var EPSILON = (function() {
    var epsilon = 1 / 4503599627370496.0; // TODO test smaller values on other platforms
    // TODO not sure why this is needed since the value of epsilon is
    // already the one defined above
    while(1.0 + epsilon / 2.0 != 1.0) {
      epsilon /= 2;
    }
    epsilon = 0.00005;
    // trace(epsilon);
    // trace(2 / epsilon);
    // trace(Std.int(2 / epsilon));
    // var lg = Math.log(2 / epsilon),
    //     l2 = Math.log(2);
    // trace(67108864 * pow(2, Floats.trunc((Floats.trunc(lg / l2 + 0.5) - 53) / 2) + 1) + 1);
    return epsilon;
  })();
  */
  public static var BASE : Int = 10000000; //Std.parseInt('${2 / EPSILON}');
  // TODO 64 * 1024 * 1024
  //static var SPLIT : Int = 67108864 * pow(2, Floats.trunc((Floats.trunc(Math.log(BASE) / Math.log(2) + 0.5) - 53) / 2) + 1) + 1;
  public static var SPLIT : Float = 14680064 * pow(2, Floats.trunc((Floats.trunc(Math.log(BASE) / Math.log(2) + 0.5) - 53) / 2) + 1) + 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
/*
abstract BigInt(Array<Int>) {
  static inline var CHUNK_SIZE = 15;
  static inline var CHUNK_MASK = (1 << CHUNK_SIZE) - 1;
  static inline var CHUNK_MAX_FLOAT = (1 << (CHUNK_SIZE-1)) * 2.0;
  static inline var MUL_BITS = Std.int(CHUNK_SIZE / 2);
  static inline var MUL_MASK = (1 << MUL_BITS) - 1;

  public static var zero(default, null) = new BigInt([0]);
  public static var one(default, null) = fromInt(1);
  public static var ten(default, null) = fromInt(10);

  static var decs = [zero, one, fromInt(2), fromInt(3), fromInt(4), fromInt(5), fromInt(6), fromInt(7), fromInt(8), fromInt(9)];

  var sign(get, never) : Int;
  var chunks(get, never) : Int;

  public var isNegative(get, never) : Bool;
  public var isZero(get, never) : Bool;

  @:from public static function fromInt(v : Int) {
    var arr;
    if(v < 0) {
      arr = [-1];
      v = -v;
    } else if(v > 0) {
      arr = [1];
    } else {
      arr = [0];
    }
    while(v != 0) {
      arr.push(v & CHUNK_MASK);
      v >>>= CHUNK_SIZE;
    }
    return new BigInt(arr);
  }

  @:from public static function fromFloat(v : Float) {
    var arr;
    v = v < 0 ? Math.fceil(v) : Math.ffloor(v);
    if(v < 0) {
      arr = [-1];
      v = -v;
    } else if(v > 0) {
      arr = [1];
    } else {
      arr = [0];
    }
    while(v != 0) {
      arr.push(Std.int(v % CHUNK_MAX_FLOAT));
      v = Math.ffloor(v / CHUNK_MAX_FLOAT);
    }
    return new BigInt(arr);
  }

  // TODO needs add/subtract/multiply
  @:from public static function fromString(s : String) {
    var isNegative = false,
        current = zero;

    if(s.charAt(0) == "-") {
      isNegative = true;
      s = s.substring(1, s.length);
    }

    var mul = one,
        len = s.length,
        digit;
    for(i in 0...len) {
      digit = s.charCodeAt(len - 1 - i) - '0'.code;
      if(digit < 0 || digit > 9)
        throw new Error("String should only contain digits (and an optional - sign)");
      current = current + (mul * decs[digit]);
      mul *= ten;
      //trace(digit, current, mul);
    }

    if(isNegative)
      return current.negate();
    return current;
  }

  // TODO
  public function fromStringWithBase(s : String, base : Int) : BigInt {
    return zero;
  }

  function new(arr : Array<Int>)
    this = arr;

  public function abs() : BigInt
    return isNegative ? negate() : self();

  // TODO
  public function compare(that : BigInt) : Int {
    if(sign > that.sign) return 1;
    if(sign < that.sign) return -1;
    if(sign == 0) return 0;
    return sign * compareAbs(that);
  }

  // TODO depends on compare
  @:op(A>B) public function greater(that : BigInt) : Bool
    return compare(that) > 0;

  // TODO depends on compare
  @:op(A>=B) public function greaterEqual(that : BigInt) : Bool
    return compare(that) >= 0;

  // TODO depends on compare
  @:op(A<B) public function less(that : BigInt) : Bool
    return compare(that) < 0;

  // TODO depends on compare
  @:op(A<=B) public function lessEqual(that : BigInt) : Bool
    return compare(that) <= 0;

  @:op(-A) public function negate() : BigInt {
    var arr = this.copy();
    arr[0] = -arr[0];
    return new BigInt(arr);
  }

  // TODO
  @:op(A/B) public function divide(that : BigInt) : BigInt
    return intDivision(that).quotient;

  // TODO
  @:op(A%B) public function modulo(that : BigInt) : BigInt
    return intDivision(that).modulus;

  @:op(A*B) @:commutative
  public function multiply(that : BigInt) : BigInt {
    var out = [];
    for(i in 0...chunks + that.chunks)
      out[i] = 0;
    var other = that.toArray(),
        otherChunks = that.chunks,
        a, b, product, carry;

    for(i in 0...chunks) {
      a = this[1+i];
      for(j in 0...otherChunks) {
        b = other[1 + j];
        product = a * b + out[i + j];
        carry = product >>> CHUNK_SIZE;
        out[i + j] = product & CHUNK_MASK;
        out[i + j + 1] += carry;
      }
    }
    return new BigInt(trim([sign * that.sign].concat(out)));
  }

  // TODO
  @:op(A+B) @:commutative
  public function add(that : BigInt) : BigInt {
    if(sign == 0) return that;
    if(that.sign == 0) return self();
    var lhs, rhs;
    if(compareAbs(that) < 0) {
      lhs = that;
      rhs = self();
    } else {
      lhs = self();
      rhs = that;
    }
    if(lhs.sign == rhs.sign)
      return addBig(lhs.toArray(), rhs.toArray());
    else
      return subBig(lhs.toArray(), rhs.toArray());
  }

  public function compareAbs(that : BigInt) {
    if(chunks > that.chunks) return 1;
    if(chunks < that.chunks) return -1;

    var other = that.toArray(),
        i = chunks;
    while(i > 0) {
      if(this[i] > other[i]) return 1;
      if(this[i] < other[i]) return -1;
      i--;
    }
    return 0;
  }

  @:op(A-B) public function subtract(that : BigInt) : BigInt
    return add(-that);

  @:op(A==B) @:commutative
  public function equals(that : BigInt) : Bool {
    if(sign != that.sign || chunks != that.chunks) return false;
    var other = that.toArray();
    for(i in 1...chunks + 1)
      if(this[i] != other[i]) return false;
    return true;
  }

  @:op(A!=B) @:commutative
  public function notEquals(that : BigInt) : Bool
    return !equals(that);

  inline public function toArray() : Array<Int>
    return this;

  @:to public function toFloat() : Float {
    return reduceRightChunks(function(acc : Float, curr : Int) : Float {
      return acc * CHUNK_MAX_FLOAT + curr;
    }, 0.0) * sign;
  }

  // TODO explode on overflow?
  @:to public function toInt() : Int {
    return reduceRightChunks(function(acc : Int, curr : Int) : Int {
      acc <<= CHUNK_SIZE;
      acc |= curr;
      return acc;
    }, 0) * sign;
  }

  // TODO
  public function intDivision(that : BigInt) : { quotient : BigInt, modulus : BigInt } {
    if(that.isZero)
      throw new Error('division by zero');
    if(isZero)
      return {
        quotient : zero,
        modulus : zero
      };
    var comp = compareAbs(that);
    if(comp < 0)
      return {
        quotient : zero,
        modulus : self()
      };
    else if(comp == 0)
      return {
        quotient : one,
        modulus : zero
      };
    if(chunks <= 2) { // TODO check chunk size is reasonable
      var a = toInt(),
          b = that.toInt();
      return {
        quotient : fromInt(Std.int(a / b)),
        modulus : fromInt(a % b)
      };
    }

    var out = [],
        al = chunks + 1,
        bl = that.chunks + 1,
        part : BigInt = new BigInt([1]),
        partArr = part.toArray(),
        other = that.toArray(),
        xlen, highx, highy, guess, check;

    // var base = Std.int(Math.pow(10, CHUNK_SIZE));
    // //trace(base);
    // while(al > 1) {
    //   partArr.insert(1, this[--al]);
    //   if(part.compareAbs(that) < 0) {
    //     out.push(0);
    //     continue;
    //   }
    //   xlen = partArr.length;
    //   highx = partArr[xlen - 1] * base + partArr[xlen - 2];
    //   highy = other[bl - 1] * base + other[bl - 2];
    //   if(xlen > bl) {
    //     highx = (highx + 1) * base;
    //   }
    //   guess = Math.ceil(highx / highy);
    //   trace(guess);
    //
    //   do {
    //     check = that * guess; // inefficient
    //     if(check.compareAbs(part) <= 0)
    //       break;
    //     guess--;
    //     if(guess % 1000000 == 0)
    //       trace(guess);
    //   } while(guess > 0);
    //
    //   out.push(guess);
    //   part = part - check;
    //   partArr = part.toArray();
    // }
    // out.reverse();
    // return {
    //   quotient : new BigInt(trim([sign * that.sign].concat(out))),
    //   modulus : new BigInt(trim([sign].concat(partArr)))
    // };
  }

  // TODO needs intDivision and less
  @:to public function toString() : String {
    //return '['+toArray().join(", ")+']';
    if(sign == 0) return "0";
    var str = "",
        i = isNegative ? -self() : self();

    if(i < ten) {
      str ='${i.toInt()}';
    } else {
      while(!i.isZero) {
        var r = i.intDivision(ten);
        str = r.modulus.toString() + str;
        i = r.quotient;
      }
    }

    return (isNegative ? "-" : "") + str;
  }

  // TODO
  public function toStringWithBase(base : Int) : String {
    return "";
  }

  // TODO this can probably be optimized with a Macro inlining the body
  inline function reduceRightChunks<T>(f : T -> Int -> T, acc : T) : T {
    var i = chunks - 1;
    while(i >= 0)
      acc = f(acc, this[(i--)+1]);
    return acc;
  }

  inline function get_sign()
    return this[0];

  inline function get_chunks() : Int
    return this.length - 1;

  inline function get_isNegative() : Bool
    return sign < 0;

  inline function get_isZero() : Bool
    return sign == 0;

  inline function self() : BigInt
    return new BigInt(this);

  static function trim(arr : Array<Int>) : Array<Int> {
    while(arr[arr.length - 1] == 0 && arr.length > 1)
      arr.pop();
    if(arr.length <= 1)
      arr[0] = 0;
    return arr;
  }

  static function addBig(big : Array<Int>, small : Array<Int>) : BigInt {
    var out = [big[0]],
        carry = 0,
        sum;
    for(i in 1...small.length) {
      sum = big[i] + small[i] + carry;
      carry = sum >>> CHUNK_SIZE;
      sum &= CHUNK_MASK;
      out.push(sum);
    }
    for(i in small.length...big.length) {
      sum = big[i] + carry;
      carry = sum >>> CHUNK_SIZE;
      sum &= CHUNK_MASK;
      out.push(sum);
    }
    if(carry != 0)
      out.push(carry);

    return new BigInt(out);
  }

  static function subBig(big : Array<Int>, small : Array<Int>) : BigInt {
    var out = [big[0]], // set sign
        borrow = 0,
        diff;
    for(i in 1...small.length) {
      diff = big[i] - small[i] - borrow;
      borrow = diff >>> CHUNK_SIZE;
      diff &= CHUNK_MASK;
      out.push(diff);
    }

    for(i in small.length...big.length) {
      diff = big[i] - borrow;
      borrow = diff >>> CHUNK_SIZE;
      diff &= CHUNK_MASK;
      out.push(diff);
    }

    if(borrow != 0)
      out.push(borrow);

    return new BigInt(trim(out));
  }
}
*/
