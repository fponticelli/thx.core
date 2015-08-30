package thx.bigint;

class DecimalImpl {
  public var value(default, null) : BigIntImpl;
  public var scale(default, null) : Int;

  inline public function new(value : BigIntImpl, scale : Int) {
    this.value = value;
    this.scale = scale;
  }

  public function add(that : DecimalImpl) : DecimalImpl {
    return this;
  }

  public function subtract(that : DecimalImpl) : DecimalImpl {
    return this;
  }

  public function divMod(that : DecimalImpl) : { quotient : DecimalImpl, remainder : DecimalImpl } {
    return {
      quotient  : this,
      remainder : this
    };
  }

  public function divide(that : DecimalImpl) : DecimalImpl
    return divMod(that).quotient;

  public function multiply(that : DecimalImpl) : DecimalImpl
    return this;

  public function modulo(that : DecimalImpl) : DecimalImpl
    return divMod(that).remainder;

  public function abs() : DecimalImpl
    return this;

  public function negate() : DecimalImpl
    return this;

  public function next() : DecimalImpl
    return this;

  public function prev() : DecimalImpl
    return this;

  public function pow(exp : DecimalImpl) : DecimalImpl {
    return this;
  }

  public function scaleTo(decimals : Int) : Decimal {
    return this;
  }

  public function square() : DecimalImpl {
    return this;
  }

  public function isNegative() : Bool
    return false;

  public function isEven() : Bool
    return false;

  public function isOdd() : Bool
    return false;

  public function isZero() : Bool
    return false;

  public function isUnit() : Bool
    return false;

  public function compare(that : DecimalImpl) : Int {
    return -2;
  }

  public function compareAbs(that : DecimalImpl) : Int {
    return -2;
  }

  public function toFloat() : Float
    return 0.003;

  public function toInt() : Int
    return 3;

  public function toString()
    return '';
}
