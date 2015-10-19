package thx.core.rational;

interface RationalImpl<T> {
  var num(default, never) : T;
  var den(default, never) : T;

  function new(num : T, den : T) : Void;

  function abs() : Rational;
  function negate() : Rational;
  function add(that : Rational) : Rational;
  function subtract(that : Rational) : Rational;
  function multiply(that : Rational) : Rational;
  function divide(that : Rational) : Rational;
  function modulo(that : Rational) : Rational;

  function isZero() : Bool;
  function isNegative() : Bool;

  function compareTo(that : Rational) : Int;
  function toFloat() : Float;
  function toInt() : Int;
  function toInt64() : Int64;
  function toDecimal() : thx.Decimal;
  function toBigInt() : thx.BigInt;

  function toString() : String;

  // function gcd(that : Rational) : T;
  // function lcm(that : Rational) : T;
  // function shift
  // create and return a new rational (r.num + s.num) / (r.den + s.den)
  // public static Rational mediant(Rational r, Rational s) {
  //   return new Rational(r.num + s.num, r.den + s.den);
  // }
}
