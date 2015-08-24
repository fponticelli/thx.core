package thx.bigint;

class Small implements BigIntImpl {
  public static var zero(default, null) = new Small(0);
  public static var one(default, null) = new Small(1);
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
    if(Bigs.isPrecise(value + small.value)) {
      return new Small(value + small.value);
    } else {
      return new Big(Bigs.addSmall(
        Bigs.smallToArray(Ints.abs(small.value)),
        Ints.abs(small.value)),
        sign
      );
    }
  }

  public function addBig(big : Big) : BigIntImpl {
    return new Big(
      Bigs.addSmall(big.value, Ints.abs(value)),
      sign
    );
  }

  public function subtract(that : BigIntImpl) : BigIntImpl {
    if(sign != that.sign)
      return add(that.negate());
    return that.isSmall ? subtractSmall(cast that) : subtractBig(cast that);
  }

  public function subtractSmall(small : Small) : BigIntImpl {
    return new Small(value - small.value);
  }

  public function subtractBig(big : Big) : BigIntImpl {
    return Bigs.subtractSmall(big.value, Ints.abs(value), value >= 0);
  }

  public function divide(that : BigIntImpl) : BigIntImpl {
    return divMod(that).quotient;
  }

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

  public function multiply(that : BigIntImpl) : BigIntImpl {
    return that.isSmall ? multiplySmall(cast that) : multiplyBig(cast that);
  }

  public function multiplySmall(small : Small) : BigIntImpl {
    if(Bigs.isPrecise(value * small.value)) {
      return new Small(value * small.value);
    }
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

  public function modulo(that : BigIntImpl) : BigIntImpl {
    return divMod(that).remainder;
  }


  public function abs() : BigIntImpl {
    return new Small(Ints.abs(value));
  }

  public function negate() : BigIntImpl {
    var small = new Small(-value);
    small.sign = !sign;
    return small;
  }

  public function next() : BigIntImpl {
    return addSmall(Small.one);
  }

  public function prev() : BigIntImpl {
    return addSmall(Small.negativeOne);
  }

  public function isZero() : Bool {
    return value == 0;
  }

  public function compare(that : BigIntImpl) : Int {
    return that.isSmall ? compareSmall(cast that) : compareBig(cast that);
  }

  public function compareAbs(that : BigIntImpl) : Int {
    return abs().compare(that.abs());
  }

  public function compareSmall(small : Small) : Int {
    return Ints.compare(value, small.value);
  }

  public function compareBig(big : Big) : Int {
    return big.sign ? 1 : -1;
  }

  public function toFloat() : Float
    return value;

  public function toInt() : Int
    return value;

  public function toString()
    return toStringWithBase(10);

  public function toStringWithBase(base : Int) : String
    return Ints.toString(value, base);
}
