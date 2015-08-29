package thx.bigint;

class Small implements BigIntImpl {
  public static var zero(default, null) = new Small(0);
  public static var one(default, null) = new Small(1);
  public static var two(default, null) = new Small(2);
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
    if(sign != that.sign)
      return subtract(that.negate());
    return that.isSmall ? addSmall(cast that) : addBig(cast that);
  }

  public function addSmall(small : Small) : BigIntImpl {
    #if (js || cs || java || cpp || neko)
    if(Bigs.canAdd(value, small.value))
    #else
    if(Bigs.isPrecise(value + small.value))
    #end
    //if(Bigs.isPrecise(value + small.value))
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
    if(sign != that.sign)
      return add(that.negate());
    return that.isSmall ? subtractSmall(cast that) : subtractBig(cast that);
  }

  public function subtractSmall(small : Small) : BigIntImpl {
    return new Small(value - small.value);
  }

  public function subtractBig(big : Big) : BigIntImpl
    return Bigs.subtractSmall(big.value, Ints.abs(value), value >= 0);

  public function divide(that : BigIntImpl) : BigIntImpl
    return divMod(that).quotient;

  public function divMod(that : BigIntImpl) : { quotient : BigIntImpl, remainder : BigIntImpl } {
    if(that.isZero())
      throw new Error('division by zero');
    return that.isSmall ? divModSmall(cast that) : divModBig(cast that);
  }

  public function divModSmall(small : Small) : { quotient : BigIntImpl, remainder : BigIntImpl } {
    return {
      quotient : new Small(Floats.trunc(value / small.value)),
      remainder : new Small(value % small.value)
    };
  }

  public function divModBig(big : Big) : { quotient : BigIntImpl, remainder : BigIntImpl } {
    return {
      quotient : Small.zero,
      remainder : this
    };
  }

  public function multiply(that : BigIntImpl) : BigIntImpl
    return that.isSmall ? multiplySmall(cast that) : multiplyBig(cast that);

  public function multiplySmall(small : Small) : BigIntImpl {
    #if (js || cs || java || cpp || neko)
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

  public function abs() : BigIntImpl
    return new Small(Ints.abs(value));

  public function negate() : BigIntImpl
    return new Small(-value);

  public function next() : BigIntImpl
    return addSmall(Small.one);

  public function prev() : BigIntImpl
    return addSmall(Small.negativeOne);

  public function pow(exp : BigIntImpl) : BigIntImpl {
    //if(!exp.isSmall) throw new Error('The exponent $exp is too large.');
    if(isZero())
      return exp.isZero() ? Small.one : this;
    if(isUnit())
      return sign ?
        (exp.isEven() ? Small.one : Small.negativeOne) :
        Small.one;
    if(exp.sign)
      return Small.zero;
    var b = (cast exp : Small).value,
        res;
    if(Bigs.isPrecise(res = Floats.trunc(Math.pow(value, b))))
      return new Small(res);
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
    #if (js || cs || java || cpp || neko)
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

  public function compare(that : BigIntImpl) : Int {
    if(sign != that.sign)
      return sign ? -1 : 1;
    return that.isSmall ? compareSmall(cast that) : compareBig(cast that);
  }

  public function compareSmall(small : Small) : Int
    return Ints.compare(value, small.value);

  public function compareBig(big : Big) : Int
    return Bigs.compareAbs(Bigs.smallToArray(value), big.value) * (sign ? -1 : 1);

  public function compareAbs(that : BigIntImpl) : Int {
    if(that.isSmall)
      return compareAbsSmall(cast that);
    else
      return compareAbsBig(cast that);
  }

  public function compareAbsSmall(small : Small) : Int
    return Ints.compare(Ints.abs(value), Ints.abs(small.value));

  public function compareAbsBig(big : Big) : Int
    return Bigs.compareAbs(Bigs.smallToArray(value), big.value);

  public function toFloat() : Float
    return value;

  public function toInt() : Int
    return value;

  public function toString()
    return '$value';

  public function toStringWithBase(base : Int) : String
    return Ints.toString(value, base);
}
