package thx.rational;

import haxe.Int64;
import thx.Decimal;
import thx.BigInt;

interface RationalImpl<T> {
  var num(default, null) : T;
  var den(default, null) : T;

  function abs() : RationalImpl<T>;
  function negate() : RationalImpl<T>;
  function add(that : RationalImpl<T>) : RationalImpl<T>;
  function subtract(that : RationalImpl<T>) : RationalImpl<T>;
  function multiply(that : RationalImpl<T>) : RationalImpl<T>;
  function divide(that : RationalImpl<T>) : RationalImpl<T>;
  function reciprocal() : RationalImpl<T>;

  function isZero() : Bool;
  function isNegative() : Bool;

  function compareTo(that : RationalImpl<T>) : Int;
  function toFloat() : Float;
  function toInt() : Int;
  function toInt64() : Int64;
  function toDecimal() : thx.Decimal;
  function toBigInt() : thx.BigInt;

  function toString() : String;

  // function gcd(that : RationalImpl<T>) : T;
  // function lcm(that : RationalImpl<T>) : T;
  // function shift
  // create and return a new RationalImpl (r.num + s.num) / (r.den + s.den)
  // public static RationalImpl mediant(RationalImpl r, RationalImpl s) {
  //   return new RationalImpl(r.num + s.num, r.den + s.den);
  // }
  // reciprocal(den, num)
}
