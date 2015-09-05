package thx;

import thx.bigint.*;

@:forward(scale)
abstract Decimal(DecimalImpl) from DecimalImpl to DecimalImpl {
  public static var divisionScale(get, set) : Int;
  public static var zero(default, null) = DecimalImpl.zero;
  public static var one(default, null)  = DecimalImpl.one;

  public static function fromInt64(value : haxe.Int64) : Decimal
    return new DecimalImpl(BigInt.fromInt64(value), 0);

  public static function fromBigInt(value : BigInt) : Decimal
    return new DecimalImpl(value, 0);

  @:from public static function fromInt(value : Int) : Decimal
    return Decimals.fromInt(value);

  @:from inline public static function fromFloat(value : Float) : Decimal
    return Decimals.fromFloat(value);

  @:from public inline static function fromString(value : String) : Decimal
    return Decimals.parse(value);

  inline public static function randomBetween(a : Decimal, b : Decimal) : Decimal
    return DecimalImpl.randomBetween(a, b);

  inline public function isZero() : Bool
    return this.isZero();

  inline public function abs() : Decimal
    return this.abs();

  inline public function compare(that : Decimal) : Int
    return this.compare(that);

  inline public function compareAbs(that : Decimal) : Int
    return this.compareAbs(that);

  inline public function next() : Decimal
    return this.next();

  inline public function prev() : Decimal
    return this.prev();

  inline public function square() : Decimal
    return this.square();

  inline public function pow(exp : Int) : Decimal
    return this.pow(exp);

  inline public function isEven() : Bool
    return this.isEven();

  inline public function isOdd() : Bool
    return this.isOdd();

  inline public function isNegative() : Bool
    return this.isNegative();

  inline public function isPositive() : Bool
    return this.compare(zero) > 0;

  inline public function max(that : Decimal) : Decimal
    return greater(that) ? this : that;

  inline public function min(that : Decimal) : Decimal
    return less(that) ? this : that;

  inline public function scaleTo(decimals : Int) : Decimal
    return this.scaleTo(decimals);

  inline public function trim(?mindecimals : Int) : Decimal
    return this.trim(mindecimals);

  @:op(A>B) public function greater(that : Decimal) : Bool
    return this.compare(that) > 0;

  @:op(A>=B) public function greaterEqual(that : Decimal) : Bool
    return this.compare(that) >= 0;

  @:op(A<B) public function less(that : Decimal) : Bool
    return this.compare(that) < 0;

  @:op(A<=B) public function lessEqual(that : Decimal) : Bool
    return this.compare(that) <= 0;

  @:op(A==B) @:commutative
  public function equals(that : Decimal) : Bool
    return this.compare(that) == 0;

  @:op(A!=B) @:commutative
  public function notEquals(that : Decimal) : Bool
    return this.compare(that) != 0;

  @:op(A+B) @:commutative
  inline public function add(that : Decimal) : Decimal
    return this.add(that);

  @:op(A-B)
  inline public function subtract(that : Decimal) : Decimal
    return this.subtract(that);

  @:op(-A)
  inline public function negate() : Decimal
    return this.negate();

  @:op(++A)
  inline public function preIncrement() : Decimal
    return this = add(Decimal.one);

  @:op(A++)
  inline public function postIncrement() : Decimal {
    var v = this;
    this = add(Decimal.one);
    return v;
  }

  @:op(--A)
  inline public function preDecrement() : Decimal
    return this = subtract(Decimal.one);

  @:op(A--)
  inline public function postDecrement() : Decimal {
    var v = this;
    this = subtract(Decimal.one);
    return v;
  }

  @:op(A*B) @:commutative
  inline public function multiply(that : Decimal) : Decimal
    return this.multiply(that);

  @:op(A/B)
  inline public function divide(that : Decimal) : Decimal
    return this.divide(that);

  @:op(A%B)
  inline public function modulo(that : Decimal) : Decimal
    return this.modulo(that);

  @:to inline public function toInt() : Int
    return this.toInt();

  @:to inline public function toFloat() : Float
    return this.toFloat();

  @:to inline public function toString() : String
    return this.toString();

  inline static function get_divisionScale()
    return Decimals.divisionExtraScale;

  inline static function set_divisionScale(v : Int)
    return Decimals.divisionExtraScale = v;
}
