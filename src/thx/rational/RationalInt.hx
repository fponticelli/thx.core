package thx.rational;

using thx.BigInt;
using thx.Ints;
using thx.Decimal;
using haxe.Int64;

class RationalInt implements RationalImpl<Int> {
  public static var zero(default, never) : RationalImpl<Int> = new RationalInt(0, 1);
  public var num(default, null) : Int;
  public var den(default, null) : Int;

  public static function create(num : Int, den : Int) {
    if(den == 0)
      throw new thx.Error('division by zero');
    var g = Ints.gcd(num, den);
    num = Std.int(num / g);
    den = Std.int(den / g);
    if(den < 0) {
      num = -num;
      den = -den;
    }
    return new RationalInt(num, den);
  }

  public function new(num : Int, den : Int) {
    this.num = num;
    this.den = den;
  }

  public function abs() : RationalImpl<Int>
    return new RationalInt(num.abs(), den);

  public function negate() : RationalImpl<Int>
    return new RationalInt(-num, den);

  public function add(that : RationalImpl<Int>) : RationalImpl<Int> {
    if(compareTo(zero) == 0) return that;
    if(that.compareTo(zero) == 0) return this;
    var f = Ints.gcd(num, that.num),
        g = Ints.gcd(den, that.den),
        s = create(
              Std.int(num / f) * Std.int(that.den / g) +
              Std.int(that.num / f) * Std.int(den / g),
              Ints.lcm(den, that.den)
            );

    // multiply back in
    s.num *= f;
    return s;
  }
  public function subtract(that : RationalImpl<Int>) : RationalImpl<Int>
    return add(that.negate());
  // minimize overflow by cross-cancellation
  public function multiply(that : RationalImpl<Int>) : RationalImpl<Int> {
    var c = create(num, that.den),
        d = create(that.num, den);
    return create(c.num * d.num, c.den * d.den);
  }
  public function divide(that : RationalImpl<Int>) : RationalImpl<Int>
    return multiply(that.reciprocal());

  public function reciprocal() : RationalImpl<Int>
    return create(den, num);

  public function isZero() : Bool
    return num == 0;

  public function isNegative() : Bool
    return num < 0;

  public function compareTo(that : RationalImpl<Int>) : Int {
    var lhs = num * that.den,
        rhs = den * that.num;
    if(lhs < rhs) return -1;
    if(lhs > rhs) return  1;
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
      return '$num/$den'; // ⁄ or /
  }
}
