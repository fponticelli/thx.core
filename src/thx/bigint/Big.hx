package thx.bigint;

import thx.bigint.Bigs;

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
    if(sign != that.sign)
      return subtract(that.negate());
    return that.isSmall ? addSmall(cast that) : addBig(cast that);
  }

  public function addSmall(small : Small) : BigIntImpl {
    return new Big(Bigs.addSmall(value, Ints.abs(small.value)), sign);
  }

  public function addBig(big : Big) : BigIntImpl {
    return new Big(Bigs.addAny(value, big.value), sign);
  }

  public function subtract(that : BigIntImpl) : BigIntImpl {
    if(sign != that.sign)
      return add(that.negate());
    return that.isSmall ? subtractSmall(cast that) : subtractBig(cast that);
  }

  public function subtractSmall(small : Small) : BigIntImpl {
    return Bigs.subtractSmall(value, Ints.abs(small.value), sign);
  }

  public function subtractBig(big : Big) : BigIntImpl {
    return Bigs.subtractAny(value, big.value, sign);
  }

  public function divide(that : BigIntImpl) : BigIntImpl {
    return that.isSmall ? divideSmall(cast that) : divideBig(cast that);
  }

  public function divideSmall(small : Small) : BigIntImpl {
    return null;
  }

  public function divideBig(big : Big) : BigIntImpl {
    return null;
  }

  public function multiply(that : BigIntImpl) : BigIntImpl {
    return that.isSmall ? multiplySmall(cast that) : multiplyBig(cast that);
  }

  public function multiplySmall(small : Small) : BigIntImpl {
    return null;
  }

  public function multiplyBig(big : Big) : BigIntImpl {
    return null;
  }

  public function modulo(that : BigIntImpl) : BigIntImpl {
    return that.isSmall ? moduloSmall(cast that) : moduloBig(cast that);
  }

  public function moduloSmall(small : Small) : BigIntImpl {
    return null;
  }

  public function moduloBig(big : Big) : BigIntImpl {
    return null;
  }

  public function abs() : BigIntImpl {
    return new Big(value, false);
  }

  public function negate() : BigIntImpl {
    return new Big(value, !sign);
  }

  public function isZero() : Bool {
    return false;
  }

  // TODO
  public function compare(that : BigIntImpl) : Int {
    return that.isSmall ? compareSmall(cast that) : compareBig(cast that);
  }

  public function compareSmall(small : Small) : Int {
    return null;
  }

  public function compareBig(big : Big) : Int {
    return null;
  }

  // TODO
  public function toFloat() : Float
    return 0.1;

  // TODO
  public function toInt() : Int
    return 1;

  public function toStringWithBase(base : Int) : String
    return "";
}
