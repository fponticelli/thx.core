package thx;

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

abstract BigInt(Array<Int>) {
  static inline var CHUNK_SIZE = 30;
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

    var mul = isNegative ? -one : one,
        len = s.length,
        digit;
    for(i in 0...len) {
      digit = s.charCodeAt(len - 1 - i) - '0'.code;
      if(digit < 0 || digit > 9)
        throw new Error("String should only contain digits (and an optional - sign)");
      current += mul * decs[digit];
      mul *= ten;
    }

    return current;
  }

  // TODO
  public function fromStringWithBase(s : String, base : Int) : BigInt {
    return zero;
  }

  function new(arr : Array<Int>)
    this = arr;

  // TODO
  public function compare(that : BigInt) : Int {
    if(sign > that.sign) return 1;
    if(sign < that.sign) return -1;
    if(sign == 0) return 0;
    return sign * compareMagnitude(that);
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
/*
  // TODO
  @:op(A*B) public function multiply(that : BigInt) : BigInt {
    var out = [],
        product,
        carry = 0,
        other = that.toArray();
    for(i in 0...chunks + that.chunks)
      out[i] = 0;
    for(j in 0...that.chunks) {
      for(i in 0...chunks) {
        product = out[i+j] + this[i+1] * other[j+1] + carry;
        out[i+j] = product & CHUNK_MASK;
        carry = product >>> CHUNK_SIZE;
      }
      out[j+chunks] = carry;
    }

    var i = out.length - 1;
    while(i >= 1 && out[i] == 0)
      i--;
    return new BigInt([sign * that.sign].concat(out.slice(0, i)));
  }
*/
///*
  @:op(A*B) public function multiply(that : BigInt) : BigInt {
    var out = [];
    var product;
    var carry = 0;
    var other = that.toArray();

    for(i in 0...chunks + that.chunks)
      out[i] = 0;

    var rLow;
    var rHigh;
    var lLow;
    var lHigh;
    var p00;
    var p01;
    var p10;
    var p11;
    var productLow;
    var productHigh;
    for(j in 0...that.chunks) {
      for(i in 0...chunks) {
        rLow = other[i+1] & MUL_MASK;
        rHigh = other[i+1] >>> MUL_BITS;
        lLow = this[j+1] & MUL_MASK;
        lHigh = this[j+1] >>> MUL_BITS;
        p00 = rLow * lLow;
        p01 = rLow * lHigh;
        p10 = rHigh * lLow;
        p11 = rHigh * lHigh;
        //trace('$rHigh $rLow  $lHigh $lLow');
        //trace('$p00 $p01 $p10 $p11');
        productLow = ((p01 & MUL_MASK) << MUL_BITS) + ((p10 & MUL_MASK) << MUL_BITS) + p00;
        productLow += out[i+j] + carry;
        productHigh = p11 + (p01 >>> MUL_BITS) + (p10 >>> MUL_BITS);
        productHigh += productLow >>> CHUNK_SIZE;
        productLow &= CHUNK_MASK;
        out[i+j] = productLow;
        carry = productHigh;
      }
      out[j+chunks] = carry;
    }

    var before = out.length;
    while(out[out.length - 1] == 0)
      out.pop();
/*
    if(out.length != before) {
      trace(this, that.toArray());
      trace('before $before, after ${out.length}');
    }
*/
    return new BigInt([sign * that.sign].concat(out));
  }
//*/
  // TODO
  @:op(A+B) public function add(that : BigInt) : BigInt {
    if(sign == 0) return that;
    if(that.sign == 0) return self();
    var lhs, rhs;
    if(compareMagnitude(that) < 0) {
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

  function compareMagnitude(that : BigInt) {
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

  @:op(A==B) public function equals(that : BigInt) : Bool {
    if(sign != that.sign || chunks != that.chunks) return false;
    var other = that.toArray();
    for(i in 1...chunks + 1)
      if(this[i] != other[i]) return false;
    return true;
  }

  @:op(A!=B) public function notEquals(that : BigInt) : Bool
    return !equals(that);

  inline function toArray() : Array<Int>
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
    var comp = compareMagnitude(that);
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
    if(chunks <= 3) { // TODO check chunk size is reasonable
      var a = toInt(),
          b = that.toInt();
      return {
        quotient : fromInt(Std.int(a / b)),
        modulus : fromInt(a % b)
      };
    }

    return {
      quotient : zero,
      modulus : zero
    };
  }

  // TODO needs intDivision and less
  @:to public function toString() : String {
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

  static function addBig(big : Array<Int>, small : Array<Int>) : BigInt {
    var out = [big[0]],
        carry = 0,
        sum;
/*
    if(big.length != 2 || small.length != 2)
      trace(big.length + " " + small.length);
*/
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
/*
    if(big.length != 2 || small.length != 2)
      trace(big.length + " " + small.length);
*/
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

    return new BigInt(out);
  }
}
