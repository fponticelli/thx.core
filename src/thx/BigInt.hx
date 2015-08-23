package thx;

using haxe.Int64;

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

@:access(thx.Big)
abstract BigInt(BigIntImpl) from BigIntImpl to BigIntImpl {
  public static var zero(default, null) : BigInt = new Small(0);

  @:from public static function fromFloat(value : Float) : BigInt
    return zero;

  @:from public static function fromInt(value : Int) : BigInt
    return (new Small(value) : BigIntImpl);

  @:from public inline static function fromString(value : String) : BigInt
    return Big.parseBigInteger(value, 10);

  public inline static function fromStringWithBase(value : String, base : Int) : BigInt
    return Big.parseBigInteger(value, base);

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

interface BigIntImpl {
  var isSmall(default, null) : Bool;
  function add(that : BigIntImpl) : BigIntImpl;
  function subtract(that : BigIntImpl) : BigIntImpl;
  function divide(that : BigIntImpl) : BigIntImpl;
  function multiply(that : BigIntImpl) : BigIntImpl;
  function modulo(that : BigIntImpl) : BigIntImpl;
  function negate() : BigIntImpl;
  function isZero() : Bool;
  function compare(that : BigIntImpl) : Int;
  function toFloat() : Float;
  function toInt() : Int;
  function toStringWithBase(base : Int) : String;
}

class Small implements BigIntImpl{
  public function new(value : Int) {

  }

  public function add(that : BigIntImpl) : BigIntImpl {

  }

  public function subtract(that : BigIntImpl) : BigIntImpl {

  }

  public function divide(that : BigIntImpl) : BigIntImpl {
  }

  public function multiply(that : BigIntImpl) : BigIntImpl {

  }

  public function modulo(that : BigIntImpl) : BigIntImpl {

  }

  public function negate() : BigIntImpl {

  }

  public function isZero() : Bool {

  }

  // TODO
  public function compare(that : BigIntImpl) : Int {

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

class Big implements BigIntImpl {
  public function new(signum : Int, magnitude : Array<Int>, length : Int) {
  }

  public function add(that : BigIntImpl) : BigIntImpl {
  }

  public function subtract(that : BigIntImpl) : BigIntImpl {

  }

  public function divide(that : BigIntImpl) : BigIntImpl {

  }

  public function multiply(that : BigIntImpl) : BigIntImpl {
  }

  public function modulo(that : BigIntImpl) : BigIntImpl {
  }

  public function negate() : BigIntImpl {
  }

  public function isZero() : Bool {
  }

  // TODO
  public function compare(that : BigIntImpl) : Int {
  }

  // TODO
  public function toFloat() : Float
    return 0;

  // TODO
  public function toInt() : Int
    return 0;

  public function toStringWithBase(base : Int) : String
    return toStringImpl(signum, magnitude, length, base);

  // helpers
  static function createArray(length : Int) {
    var x = #if js untyped __js__("new Array")(length) #else [] #end;
    for(i in 0...length)
      x[i] = 0;
    return x;
  }
}
