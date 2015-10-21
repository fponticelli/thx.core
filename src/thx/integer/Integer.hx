package thx.integer;

interface Integer<T> {
  // operations
  function add(that : Integer<T>) : Integer<T>;
  function subtract(that : Integer<T>) : Integer<T>;
  function divide(that : Integer<T>) : Integer<T>;
  function fdivide(that : Integer<T>) : Float;
  function multiply(that : Integer<T>) : Integer<T>;
  function modulo(that : Integer<T>) : Integer<T>;

  function pow(exp : Integer<T>) : Integer<T>;
  function modPow(exp : Integer<T>, mod : Integer<T>) : Integer<T>;
  function euclideanModPow(exp : Integer<T>, mod : Integer<T>) : Integer<T>;
  function divMod(that : Integer<T>) : { quotient : Integer<T>, remainder : Integer<T> };

  // query
  function compareTo(that : Integer<T>) : Bool;

  function isNegative() : Bool;
  function isZero() : Bool;
  function isEven() : Bool;
  function isOdd() : Bool;
  function isNegative() : Bool;
  function isPositive() : Bool;
  function isPrime() : Bool;
  function isUnit() : Bool;
  function isDivisibleBy(that : Integer<T>) : Bool;

  function max(that : Integer<T>) : Integer<T>;
  function min(that : Integer<T>) : Integer<T>;
  function gcd(that : Integer<T>) : Integer<T>;
  function lcm(that : Integer<T>) : Integer<T>;

  function greaterThan(that : Integer<T>) : Bool;
  function greaterEqualsTo(that : Integer<T>) : Bool;
  function lessThan(that : Integer<T>) : Bool;
  function lessEqualsTo(that : Integer<T>) : Bool;
  function equalsTo(that : Integer<T>) : Bool;
  function notEqualsTo(that : Integer<T>) : Bool;

  // transform
  function abs() : Integer<T>;
  function next() : Integer<T>;
  function prev() : Integer<T>;
  function square() : Integer<T>;

  function preIncrement() : Integer<T>;
  function postIncrement() : Integer<T>;
  function preDecrement() : Integer<T>;
  function postDecrement() : Integer<T>;
  function negate() : Integer<T>;

  // bitwise
  function shiftLeft(that : Int) : Integer<T>;
  function shiftRight(that : Int) : Integer<T>;
  function not() : Integer<T>;
  function and(that : Integer<T>) : Integer<T>;
  function or(that : Integer<T>) : Integer<T>;
  function xor(that : Integer<T>) : Integer<T>;

  // conversions
  function toInt() : Int;
  function toBigInt() : BigInt;
  function toFloat() : Float;
  function toInt64() : haxe.Int64;
  function toString() : String;
  function toStringWithBase(base : Int) : String;
}
