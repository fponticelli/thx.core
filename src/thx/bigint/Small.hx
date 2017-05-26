package thx.bigint;

class Small implements BigIntImpl {
  public static var zero(default, null) = new Small(0);
  public static var one(default, null) = new Small(1);
  public static var two(default, null) = new Small(2);
  public static var ten(default, null) = new Small(10);
  public static var negativeOne(default, null) = new Small(-1);

  public var value(default, null) : Int;
  public var sign(default, null) : Bool;
  public var isSmall(default, null) : Bool;

  public function new(value : Int) {
    this.sign = value < 0;
    this.value = value;
    this.isSmall = true;
  }

  public function add(that : BigIntImpl) : BigIntImpl {
    if(this.isZero())
      return that;
    if(that.isZero())
      return this;
    if(sign != that.sign)
      return subtract(that.negate());
    return that.isSmall ? addSmall(cast that) : addBig(cast that);
  }

  public function addSmall(small : Small) : BigIntImpl {
    #if (cs || java || cpp || neko || flash || eval)
    if(Bigs.canAdd(value, small.value))
    #else
    if(Bigs.isPrecise(value + small.value))
    #end
    {
      return new Small(value + small.value);
    } else {
      return new Big(Bigs.addSmall(
        Bigs.smallToArray(Ints.abs(small.value)),
        Ints.abs(value)),
        sign
      );
    }
  }

  public function addBig(big : Big) : BigIntImpl
    return new Big(
      Bigs.addSmall(big.value, Ints.abs(value)),
      sign
    );

  public function subtract(that : BigIntImpl) : BigIntImpl {
    if(this.isZero())
      return that.negate();
    if(that.isZero())
      return this;
    if(sign != that.sign)
      return add(that.negate());
    return that.isSmall ? subtractSmall(cast that) : subtractBig(cast that);
  }

  public function subtractSmall(small : Small) : BigIntImpl
    return new Small(value - small.value);

  public function subtractBig(big : Big) : BigIntImpl {
    if(big.compareToAbsSmall(this) < 0)
      return new Small(value - big.toInt());
    return Bigs.subtractSmall(big.value, Ints.abs(value), value >= 0);
  }

  public function divide(that : BigIntImpl) : BigIntImpl
    return divMod(that).quotient;

  public function divMod(that : BigIntImpl) : { quotient : BigIntImpl, remainder : BigIntImpl } {
    if(that.isZero())
      throw new Error('division by zero');
    return that.isSmall ? divModSmall(cast that) : divModBig(cast that);
  }

  public function divModSmall(small : Small) : { quotient : BigIntImpl, remainder : BigIntImpl }
    return {
      quotient  : new Small(Floats.trunc(value / small.value)),
      remainder : new Small(#if python value - Std.int(value/small.value) * small.value  #else value % small.value #end)
    };

  public function divModBig(big : Big) : { quotient : BigIntImpl, remainder : BigIntImpl }
    return new Big(Bigs.smallToArray(Ints.abs(this.value)), this.value < 0).divModBig(big);

  public function multiply(that : BigIntImpl) : BigIntImpl
    return that.isSmall ? multiplySmall(cast that) : multiplyBig(cast that);

  public function multiplySmall(small : Small) : BigIntImpl {
    #if (cs || java || cpp || neko || flash || eval)
    if(Bigs.canMultiply(value, small.value))
    #else
    if(Bigs.isPrecise(value * small.value))
    #end
      return new Small(value * small.value);
    var arr = Bigs.smallToArray(Ints.abs(small.value));
    var abs = Ints.abs(value);
    if(abs < Bigs.BASE) {
      return new Big(Bigs.multiplySmall(arr, abs), sign != small.sign);
    } else {
      return new Big(Bigs.multiplyLong(arr, Bigs.smallToArray(abs)), sign != small.sign);
    }
  }

  public function multiplyBig(big : Big) : BigIntImpl {
    return new Big(Bigs.multiplyLong(big.value, Bigs.smallToArray(Ints.abs(value))), sign != big.sign);
  }

  public function modulo(that : BigIntImpl) : BigIntImpl
    return divMod(that).remainder;

  public function random() : BigIntImpl
    return Bigs.fromInt(Std.int(Math.random() * value));

  public function abs() : BigIntImpl
    return new Small(Ints.abs(value));

  public function negate() : BigIntImpl
    return new Small(-value);

  public function next() : BigIntImpl
    return addSmall(Small.one);

  public function prev() : BigIntImpl
    return addSmall(Small.negativeOne);

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
    var b = (cast exp : Small).value;
    if(Bigs.canPower(value, b))
      return new Small(Std.int(Math.pow(value, b)));
    return new Big(Bigs.smallToArray(Ints.abs(value)), sign).pow(exp);
  }

  public function shiftLeft(n : Int) : BigIntImpl {
    if(n < 0)
      return shiftRight(-n);
    if(Ints.abs(n) > Bigs.BASE) {
      return multiply(Small.two.pow(Bigs.fromInt(n)));
    }
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
    var remQuo;
    if(Ints.abs(n) > Bigs.BASE) {
      remQuo = divMod(Small.two.pow(Bigs.fromInt(n)));
      return remQuo.remainder.sign ? remQuo.quotient.prev() : remQuo.quotient;
    }
    var result : BigIntImpl = this;
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

  public function square() : BigIntImpl {
    #if (cs || java || cpp || neko || flash || eval)
    if(Bigs.canMultiply(value, value))
    #else
    if(Bigs.isPrecise(value * value))
    #end
      return new Small(value * value);
    return new Big(Bigs.square(Bigs.smallToArray(Ints.abs(value))), false);
  }

  public function isEven() : Bool
    return (value & 1) == 0;

  public function isOdd() : Bool
    return (value & 1) == 1;

  public function isZero() : Bool
    return value == 0;

  public function isUnit() : Bool
    return Ints.abs(value) == 1;

  public function compareTo(that : BigIntImpl) : Int {
    if(sign != that.sign)
      return sign ? -1 : 1;
    return that.isSmall ? compareToSmall(cast that) : compareToBig(cast that);
  }

  public function compareToSmall(small : Small) : Int
    return Ints.compare(value, small.value);

  public function compareToBig(big : Big) : Int
    return Bigs.compareToAbs(Bigs.smallToArray(Ints.abs(value)), big.value) * (sign ? -1 : 1);

  public function compareToAbs(that : BigIntImpl) : Int {
    if(that.isSmall)
      return compareToAbsSmall(cast that);
    else
      return compareToAbsBig(cast that);
  }

  public function compareToAbsSmall(small : Small) : Int
    return Ints.compare(Ints.abs(value), Ints.abs(small.value));

  public function compareToAbsBig(big : Big) : Int
    return Bigs.compareToAbs(Bigs.smallToArray(Ints.abs(value)), big.value);

  public function not() : BigIntImpl
    return negate().prev();

  public function and(that : BigIntImpl) : BigIntImpl
    return Bigs.bitwise(this, that, function(a : Int, b : Int) return a & b);

  public function or(that : BigIntImpl) : BigIntImpl
    return Bigs.bitwise(this, that, function(a : Int, b : Int) return a | b);

  public function xor(that : BigIntImpl) : BigIntImpl
    return Bigs.bitwise(this, that, function(a : Int, b : Int) return a ^ b);

  public function toFloat() : Float
    return value;

  public function toInt() : Int
    return value;

  public function toString()
    return '$value';

  public function toStringWithBase(base : Int) : String
    return Ints.toString(value, base);
}
