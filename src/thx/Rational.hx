package thx;

import thx.rational.*;

abstract Rational<T>(RationalImpl<T>) from RationalImpl<T> to RationalImpl<T> {
  public static function fromInts(num : Int, den : Int) : Rational<Int>
    return thx.rational.RationalInt.create(num, den);

/*
inline public static function compare(a : Rational<T>, b : Rational<T>)
  return a.compareTo(b);

inline public function isZero() : Bool
  return this.isZero();

inline public function abs() : Rational<T>
  return this.abs();

inline public function compareTo(that : Rational<T>) : Int
  return this.compareTo(that);

inline public function compareAbs(that : Rational<T>) : Int
  return this.compareToAbs(that);

inline public function next() : Rational<T>
  return this.next();

inline public function prev() : Rational<T>
  return this.prev();

inline public function square() : Rational<T>
  return this.square();

inline public function pow(exp : Int) : Rational<T>
  return this.pow(exp);

inline public function isEven() : Bool
  return this.isEven();

inline public function isOdd() : Bool
  return this.isOdd();

inline public function isNegative() : Bool
  return this.isNegative();

inline public function isPositive() : Bool
  return this.compareTo(zero) > 0;

inline public function max(that : Rational<T>) : Rational<T>
  return greater(this, that) ? this : that;

inline public function min(that : Rational<T>) : Rational<T>
  return less(this, that) ? this : that;

inline public function ceil() : Rational<T>
  return this.ceilTo(0);

inline public function ceilTo(decimals : Int) : Rational<T>
  return this.ceilTo(decimals);

inline public function floor() : Rational<T>
  return this.floorTo(0);

inline public function floorTo(decimals : Int) : Rational<T>
  return this.floorTo(decimals);

inline public function round() : Rational<T>
  return this.roundTo(0);

inline public function roundTo(decimals : Int) : Rational<T>
  return this.roundTo(decimals);

inline public function scaleTo(decimals : Int) : Rational<T>
  return this.scaleTo(decimals);

inline public function trim(?mindecimals : Int) : Rational<T>
  return this.trim(mindecimals);

public function greaterThan(that : Rational<T>) : Bool
  return compareTo(that) > 0;

@:op(A>B)
static public function greater(self : Rational<T>, that : Rational<T>) : Bool
  return self.compareTo(that) > 0;

public function greaterEqualsTo(that : Rational<T>) : Bool
  return compareTo(that) >= 0;

@:op(A>=B)
static public function greaterEquals(self : Rational<T>, that : Rational<T>) : Bool
  return self.compareTo(that) >= 0;

public function lessThan(that : Rational<T>) : Bool
  return compareTo(that) < 0;

@:op(A<B)
static public function less(self : Rational<T>, that : Rational<T>) : Bool
  return self.compareTo(that) < 0;

public function lessEqualsTo(that : Rational<T>) : Bool
  return compareTo(that) <= 0;

@:op(A<=B)
static public function lessEquals(self : Rational<T>, that : Rational<T>) : Bool
  return self.compareTo(that) <= 0;

public function equalsTo(that : Rational<T>) : Bool
  return compareTo(that) == 0;

@:op(A==B)
static public function equals(self : Rational<T>, that : Rational<T>) : Bool
  return self.compareTo(that) == 0;

public function notEqualsTo(that : Rational<T>) : Bool
  return compareTo(that) != 0;

@:op(A!=B)
static public function notEquals(self : Rational<T>, that : Rational<T>) : Bool
  return self.compareTo(that) != 0;
*/
@:op(A+B) @:commutative
inline public function add(that : Rational<T>) : Rational<T>
  return this.add(that);

@:op(A-B)
inline public function subtract(that : Rational<T>) : Rational<T>
  return this.subtract(that);

@:op(-A)
inline public function negate() : Rational<T>
  return this.negate();
/*
@:op(++A)
inline public function preIncrement() : Rational<T>
  return this = add(Rational<T>.one);

@:op(A++)
inline public function postIncrement() : Rational<T> {
  var v = this;
  this = add(Rational<T>.one);
  return v;
}

@:op(--A)
inline public function preDecrement() : Rational<T>
  return this = subtract(Rational<T>.one);

@:op(A--)
inline public function postDecrement() : Rational<T> {
  var v = this;
  this = subtract(Rational<T>.one);
  return v;
}
*/
@:op(A*B) @:commutative
inline public function multiply(that : Rational<T>) : Rational<T>
  return this.multiply(that);

@:op(A/B)
inline public function divide(that : Rational<T>) : Rational<T>
  return this.divide(that);
/*
@:op(A%B)
inline public function modulo(that : Rational<T>) : Rational<T>
  return this.modulo(that);
*/

// @:to inline public function toInt() : Int
//   return Std.int(this.num.toInt() / this.den.toInt());
/*
@:to inline public function toInt64() : haxe.Int64
  return toBigInt().toInt64();

@:to public function toBigInt() : BigInt
  return this.value.divide(Small.ten.pow(Bigs.fromInt(this.scale)));
*/
@:to inline public function toFloat() : Float
  return this.toFloat();

@:to inline public function toString() : String
  return this.toString();
/*
inline static function get_divisionScale()
  return Decimals.divisionExtraScale;

inline static function set_divisionScale(v : Int)
  return Decimals.divisionExtraScale = v;
*/
}
