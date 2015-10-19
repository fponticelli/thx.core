package thx.rational;

using thx.BigInt;
using thx.Ints;
using thx.Decimal;
using haxe.Int64;

class RationalInt implements RationalImpl<Int> {
  public var num(default, never) : Int;
  public var den(default, never) : Int;

  public static function create(num : Int, den : Int) {
    if(den == 0)
      throw new thx.Error('division by zero');
    var g = thx.Ints.gcd(num, den);
    num = Std.int(num / g);
    den = Std.int(den / g);
    if(den < 0)
      num = -num;
    return new RationalInt(num, den);
  }

  public function new(num : Int, den : Int) {
    this.num = num;
    this.den = den;
  }

  public function abs() : Rational
    return new RationalInt(num.abs(), den);

  public function negate() : Rational
    return new RationalInt(-num, den);

  public function add(that : Rational) : Rational;
  public function subtract(that : Rational) : Rational;
  public function multiply(that : Rational) : Rational
    return new RationalInt(num * that.num, den * that.den);
  public function divide(that : Rational) : Rational;
  public function modulo(that : Rational) : Rational;

  public function isZero() : Bool
    return num == 0;

  public function isNegative() : Bool
    return num < 0;

  public function compareTo(that : Rational) : Int {
    var lhs = num * that.den,
        rhs = den * that.num;
    if(lhs < rhs) return -1;
    if(lhs > rhs) return 1;
    return 0;
  }

  public function toFloat() : Float
    return num / den;

  public function toInt() : Int
    return Std.int(num / den);

  public function toInt64() : Int64
    return (num : Int64) / (den : Int64);

  public function toDecimal() : thx.Decimal
    return (num : Decimal) / (den : Decimal);

  public function toBigInt() : thx.BigInt
    return (num : BigInt) / (den : BigInt);

  public function toString() : String {
    if(den == 1)
      return '$num';
    else
      return '$num⁄$den'; // ⁄ or /
  }
}
