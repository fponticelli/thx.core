package thx.rational;

using thx.BigInt;
using thx.Ints;
using thx.Decimal;
using haxe.Int64;

class RationalInt implements RationalImpl<Int> {
  public static var(default, never) : RationalInt = new RationalInt(0, 1);
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

  public function add(that : Rational) : Rational {
    if(compareTo(zero) == 0) return that;
    if(that.compareTo(zero) == 0) return this;
    var f = Ints.gcd(num, that.num),
        g = Ints.gcd(den, that.den),
        s = create(
              Std.int(num / f) * Std.int(that.den / g) +
              Std.int(that.num / f) * Std.int(den / g),
              Ints.lcm(a.den, b.den)
            );

    // multiply back in
    s.num *= f;
    return s;
  }
  public function subtract(that : Rational) : Rational
    return add(that.negate());
  // minimize overflow by cross-cancellation
  public function multiply(that : Rational) : Rational {
    var c = create(num, that.den),
        d = create(that.num, den);
    return create(c.num * d.num, c.den * d.num);
  }
  public function divide(that : Rational) : Rational
    return multiply(that.reciprocal());

  function reciprocal() : Rational
    return create(den, num);

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
