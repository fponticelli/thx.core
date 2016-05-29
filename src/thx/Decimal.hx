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

  inline public static function compare(a : Decimal, b : Decimal)
    return a.compareTo(b);

  inline public function isZero() : Bool
    return this.isZero();

  inline public function abs() : Decimal
    return this.abs();

  inline public function compareTo(that : Decimal) : Int
    return this.compareTo(that);

  inline public function compareAbs(that : Decimal) : Int
    return this.compareToAbs(that);

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
    return this.compareTo(zero) > 0;

  inline public function max(that : Decimal) : Decimal
    return greater(this, that) ? this : that;

  inline public function min(that : Decimal) : Decimal
    return less(this, that) ? this : that;

  inline public function ceil() : Decimal
    return this.ceilTo(0);

  inline public function ceilTo(decimals : Int) : Decimal
    return this.ceilTo(decimals);

  inline public function floor() : Decimal
    return this.floorTo(0);

  inline public function floorTo(decimals : Int) : Decimal
    return this.floorTo(decimals);

  inline public function round() : Decimal
    return this.roundTo(0);

  inline public function roundTo(decimals : Int) : Decimal
    return this.roundTo(decimals);

  inline public function scaleTo(decimals : Int) : Decimal
    return this.scaleTo(decimals);

  inline public function trim(?mindecimals : Int) : Decimal
    return this.trim(mindecimals);

  public function greaterThan(that : Decimal) : Bool
    return compareTo(that) > 0;

  @:op(A>B)
  static public function greater(self : Decimal, that : Decimal) : Bool
    return self.compareTo(that) > 0;

  public function greaterEqualsTo(that : Decimal) : Bool
    return compareTo(that) >= 0;

  @:op(A>=B)
  static public function greaterEquals(self : Decimal, that : Decimal) : Bool
    return self.compareTo(that) >= 0;

  public function lessThan(that : Decimal) : Bool
    return compareTo(that) < 0;

  @:op(A<B)
  static public function less(self : Decimal, that : Decimal) : Bool
    return self.compareTo(that) < 0;

  public function lessEqualsTo(that : Decimal) : Bool
    return compareTo(that) <= 0;

  @:op(A<=B)
  static public function lessEquals(self : Decimal, that : Decimal) : Bool
    return self.compareTo(that) <= 0;

  public function equalsTo(that : Decimal) : Bool
    return compareTo(that) == 0;

  @:op(A==B)
  static public function equals(self : Decimal, that : Decimal) : Bool
    return self.compareTo(that) == 0;

  public function notEqualsTo(that : Decimal) : Bool
    return compareTo(that) != 0;

  @:op(A!=B)
  static public function notEquals(self : Decimal, that : Decimal) : Bool
    return self.compareTo(that) != 0;

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

  @:to inline public function toFloat() : Float
    return this.toFloat();

  @:to inline public function toInt() : Int
    return this.toInt();

  @:to inline public function toInt64() : haxe.Int64
    return toBigInt().toInt64();

  @:to public function toBigInt() : BigInt
    return this.value.divide(Small.ten.pow(Bigs.fromInt(this.scale)));

  @:to inline public function toString() : String
    return this.toString();

  inline static function get_divisionScale()
    return Decimals.divisionExtraScale;

  inline static function set_divisionScale(v : Int)
    return Decimals.divisionExtraScale = v;
}
