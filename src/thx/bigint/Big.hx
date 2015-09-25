package thx.bigint;

import thx.bigint.Bigs;
using thx.Strings;

class Big implements BigIntImpl {
  public var value(default, null) : Array<Int>;
  public var sign(default, null) : Bool;
  public var isSmall(default, null) : Bool;

  public function new(value : Array<Int>, sign : Bool) {
    this.sign = sign;
    this.value = value;
    this.isSmall = false;
  }

  public function add(that : BigIntImpl) : BigIntImpl {
    if(that.isZero())
      return this;
    if(this.isZero())
      return that;
    if(sign != that.sign)
      return subtract(that.negate());
    return that.isSmall ? addSmall(cast that) : addBig(cast that);
  }

  public function addSmall(small : Small) : BigIntImpl
    return new Big(Bigs.addSmall(value, Ints.abs(small.value)), sign);

  public function addBig(big : Big) : BigIntImpl
    return new Big(Bigs.addAny(value, big.value), sign);

  public function subtract(that : BigIntImpl) : BigIntImpl {
    if(that.isZero())
      return this;
    if(this.isZero())
      return that.negate();
    if(sign != that.sign)
      return add(that.negate());
    return that.isSmall ? subtractSmall(cast that) : subtractBig(cast that);
  }

  public function subtractSmall(small : Small) : BigIntImpl
    return Bigs.subtractSmall(value, Ints.abs(small.value), sign);

  public function subtractBig(big : Big) : BigIntImpl {
    return Bigs.subtractAny(value, big.value, sign);
  }

  public function divide(that : BigIntImpl) : BigIntImpl
    return divMod(that).quotient;

  public function divMod(that : BigIntImpl) : { quotient : BigIntImpl, remainder : BigIntImpl } {
    if(that.isZero())
      throw new Error('division by zero');
    return that.isSmall ? divModSmall(cast that) : divModBig(cast that);
  }

  public function divModSmall(small : Small) : { quotient : BigIntImpl, remainder : BigIntImpl } {
    var values = Bigs.divModSmall(value, Ints.abs(small.value));
    var quotient = Bigs.arrayToSmall(values.q);
    var remainder = values.r;
    if(sign) remainder = -remainder;
    if(null != quotient) {
      if(sign != small.sign)
        quotient = -quotient;
      return {
        quotient : new Small(quotient),
        remainder : new Small(remainder)
      };
    }
    return {
      quotient : new Big(values.q, sign != small.sign),
      remainder : new Small(remainder)
    };
  }

  public function divModBig(big : Big) : { quotient : BigIntImpl, remainder : BigIntImpl } {
    var comparison = Bigs.compareToAbs(value, big.value);
    if(comparison == -1) return {
      quotient : Small.zero,
      remainder : this
    };
    if(comparison == 0) return {
      quotient : sign == big.sign ? Small.one : Small.negativeOne,
      remainder : Small.zero
    };

    // divMod1 is faster on smaller input sizes
    var values = (value.length + big.value.length <= 200) ? Bigs.divMod1(value, big.value): Bigs.divMod2(value, big.value);
    var q = values[0].small;
    var quotient : BigIntImpl, remainder : BigIntImpl;
    var qSign = sign != big.sign,
        r = values[1].small,
        mSign = sign;
    if(null != q) {
      if(qSign) q = -q;
      quotient = new Small(q);
    } else
      quotient = new Big(values[0].big, qSign);
    if(null != r) {
      if(mSign) r = -r;
      remainder = new Small(r);
    } else
      remainder = new Big(values[1].big, mSign);
    return {
      quotient : quotient,
      remainder : remainder
    };
  }

  public function multiply(that : BigIntImpl) : BigIntImpl {
    if(that.isZero())
      return Small.zero;
    return that.isSmall ? multiplySmall(cast that) : multiplyBig(cast that);
  }

  public function multiplySmall(small : Small) : BigIntImpl {
    return new Big(Bigs.multiplyLong(value, Bigs.smallToArray(Ints.abs(small.value))), sign != small.sign);
  }

  public function multiplyBig(big : Big) : BigIntImpl {
    if(value.length + big.value.length > 4000)
      return new Big(Bigs.multiplyKaratsuba(value, big.value), sign != big.sign);
    return new Big(Bigs.multiplyLong(value, big.value), sign != big.sign);
  }

  public function modulo(that : BigIntImpl) : BigIntImpl
    return divMod(that).remainder;

  public function random() : BigIntImpl {
    var length = value.length - 1,
        result = [],
        restricted = true,
        i = length,
        top, digit;
    while(i >= 0) {
      top = restricted ? value[i] : Bigs.BASE;
      digit = Floats.trunc(Math.random() * top);
      result.unshift(digit);
      if(digit < top)
        restricted = false;
      i--;
    }
    var v = Bigs.arrayToSmall(result);
    if(null != v)
      return new Small(v);
    else
      return new Big(result, false);
  }

  public function abs() : BigIntImpl
    return new Big(value, false);

  public function negate() : BigIntImpl
    return new Big(value, !sign);

  public function next() : BigIntImpl
    return add(Small.one);

  public function prev() : BigIntImpl
    return subtract(Small.one);

  public function pow(exp : BigIntImpl) : BigIntImpl {
    if(isZero())
      return exp.isZero() ? Small.one : this;
    if(isUnit())
      return sign ?
        (exp.isEven() ? Small.one : Small.negativeOne) :
        Small.one;
    if(exp.sign)
      return Small.zero;
    if(!exp.isSmall)
      throw new Error('The exponent $exp is too large.');
    var b = (cast exp : Small).value,
        x : BigIntImpl = this,
        y : BigIntImpl = Small.one;
    while(true) {
      if(b & 1 == 1) {
        y = y.multiply(x);
        --b;
      }
      if(b == 0) break;
      b = Std.int(b / 2);
      x = x.square();
    }
    return y;
  }

  public function shiftLeft(n : Int) : BigIntImpl {
    if(n < 0)
      return shiftRight(-n);
    var result : BigIntImpl = this;
    while (n >= Bigs.powers2Length) {
      result = result.multiply(Bigs.bigHighestPower2);
      n -= Bigs.powers2Length - 1;
    }
    return result.multiply(Bigs.bigPowersOfTwo[n]);
  }

  public function shiftRight(n : Int) : BigIntImpl {
    if(n < 0)
      return shiftLeft(-n);
    var result : BigIntImpl = this,
        remQuo;
    while (n >= Bigs.powers2Length) {
      if (result.isZero())
        return result;
      remQuo = result.divMod(Bigs.bigHighestPower2);
      result = remQuo.remainder.sign ? remQuo.quotient.prev() : remQuo.quotient;
      n -= Bigs.powers2Length - 1;
    }
    remQuo = result.divMod(Bigs.bigPowersOfTwo[n]);
    return remQuo.remainder.sign ? remQuo.quotient.prev() : remQuo.quotient;
  }

  public function square() : BigIntImpl
    return new Big(Bigs.square(value), false);

  public function isEven() : Bool
    return (value[0] & 1) == 0;

  public function isOdd() : Bool
    return (value[0] & 1) == 1;

  public function isZero() : Bool
    return value.length == 0;

  public function isUnit() : Bool
    return false;

  public function compareTo(that : BigIntImpl) : Int {
    if(sign != that.sign)
      return sign ? -1 : 1;
    return that.isSmall ? compareToSmall(cast that) : compareToBig(cast that);
  }

  public function compareToSmall(small : Small) : Int
    return Bigs.compareToAbs(value, Bigs.smallToArray(Ints.abs(small.value))) * (sign ? -1 : 1);

  public function compareToBig(big : Big) : Int
    return Bigs.compareToAbs(value, big.value) * (sign ? -1 : 1);

  public function compareToAbs(that : BigIntImpl) : Int {
    if(that.isSmall)
      return compareToAbsSmall(cast that);
    else
      return compareToAbsBig(cast that);
    }

  public function compareToAbsSmall(small : Small) : Int
    return Bigs.compareToAbs(value, Bigs.smallToArray(Ints.abs(small.value)));

  public function compareToAbsBig(big : Big) : Int
    return Bigs.compareToAbs(value, big.value);

  public function not() : BigIntImpl
    return negate().prev();

  public function and(that : BigIntImpl) : BigIntImpl
    return Bigs.bitwise(this, that, function(a : Int, b : Int) return a & b);

  public function or(that : BigIntImpl) : BigIntImpl
    return Bigs.bitwise(this, that, function(a : Int, b : Int) return a | b);

  public function xor(that : BigIntImpl) : BigIntImpl
    return Bigs.bitwise(this, that, function(a : Int, b : Int) return a ^ b);

  public function toFloat() : Float
    return Std.parseFloat(toString());

  public function toInt() : Int {
    var v = Bigs.arrayToSmall(value);
    if(null == v) throw new Error('overflow');
    return (sign ? -1 : 1) * v;
  }

  public function toString()
    return toStringWithBase(10);

  public function toStringWithBase(base : Int) : String {
    if(isZero())
      return "0";
    if(base == 10) {
      var l = value.length,
          out = '${value[--l]}',
          zeros = "0000000",
          digit;
      while(--l >= 0) {
        digit = '${value[l]}';
        out += zeros.substring(digit.length) + digit;
      }
      return (sign ? "-" : "") + out;
    }

    var out = [];
    var baseBig = new Small(base);
    var left : BigIntImpl = this, divmod;
    while(left.sign || left.compareToAbs(baseBig) >= 0) {
      divmod = left.divMod(baseBig);
      left = divmod.quotient;
      var digit = divmod.remainder;
      if(digit.sign) {
        digit = baseBig.subtract(digit).abs();
        left = left.next();
      }
      out.push(digit.toStringWithBase(base));
    }
    out.push(left.toStringWithBase(base));
    out.reverse();
    return (sign ? "-" : "") + out.join("");
  }
}
