package thx;

import thx.bigint.*;

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

abstract BigInt(BigIntImpl) from BigIntImpl to BigIntImpl {
  public static var zero(default, null) : BigInt = new Small(0);
  // TODO
  @:from public static function fromFloat(value : Float) : BigInt
    return zero;

  @:from public static function fromInt(value : Int) : BigInt
    return (new Small(value) : BigIntImpl);

  // TODO
  @:from public inline static function fromString(value : String) : BigInt
    return null; //Big.parseBigInteger(value, 10);

  // TODO
  public inline static function fromStringWithBase(value : String, base : Int) : BigInt
    return null; //Big.parseBigInteger(value, base);

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
