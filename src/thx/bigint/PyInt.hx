package thx.bigint;

#if python
class PyInt implements BigIntImpl {
  public static var zero(default, null) = new PyInt(0);
  public static var one(default, null) = new PyInt(1);
  public static var two(default, null) = new PyInt(2);
  public static var negativeOne(default, null) = new PyInt(-1);

  public var value(default, null) : Int;
  public var sign(default, null) : Bool;
  public var isSmall(default, null) : Bool;

  public function new(value : Int) {
    this.sign = value < 0;
    this.value = value;
    this.isSmall = false;
  }

  public function add(that : BigIntImpl) : BigIntImpl
    return new PyInt(value + (cast that : PyInt).value);

  public function subtract(that : BigIntImpl) : BigIntImpl
    return new PyInt(value - (cast that : PyInt).value);

  public function divide(that : BigIntImpl) : BigIntImpl
    return new PyInt(Std.int(value / (cast that : PyInt).value));

  public function divMod(that : BigIntImpl) : { quotient : BigIntImpl, remainder : BigIntImpl }
    return {
      quotient : new PyInt(Std.int(value / (cast that : PyInt).value)),
      remainder : new PyInt(value % (cast that : PyInt).value)
    };

  public function multiply(that : BigIntImpl) : BigIntImpl
    return new PyInt(value * (cast that : PyInt).value);

  public function modulo(that : BigIntImpl) : BigIntImpl
    return new PyInt(value % (cast that : PyInt).value);

  public function abs() : BigIntImpl
    return new PyInt(value < 0 ? -value : value);

  public function negate() : BigIntImpl
    return new PyInt(-value);

  public function next() : BigIntImpl
    return new PyInt(value + 1);

  public function prev() : BigIntImpl
    return new PyInt(value - 1);

  public function pow(exp : BigIntImpl) : BigIntImpl
    return new PyInt(Std.int(Math.pow(value, (cast exp : PyInt).value)));

  public function shiftLeft(n : Int) : BigIntImpl
    return new PyInt(value << n);

  public function shiftRight(n : Int) : BigIntImpl
    return new PyInt(value >> n);

  public function square() : BigIntImpl
    return new PyInt(value * value);

  public function isEven() : Bool
    return (value & 1) == 0;

  public function isOdd() : Bool
    return (value & 1) == 1;

  public function isZero() : Bool
    return value == 0;

  public function isUnit() : Bool
    return Ints.abs(value) == 1;

  public function compare(that : BigIntImpl) : Int
    return Ints.compare(value, (cast that : PyInt).value);

  public function compareAbs(that : BigIntImpl) : Int
    return Ints.compare(Ints.abs(value), Ints.abs((cast that : PyInt).value));

  public function toFloat() : Float
    return value;

  public function toInt() : Int
    return value;

  public function toString()
    return '$value';

  public function toStringWithBase(base : Int) : String
    return Ints.toString(value, base);
}
#end
