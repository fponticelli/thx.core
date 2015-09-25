package thx.bigint;

interface BigIntImpl {
  var sign(default, null) : Bool;
  var isSmall(default, null) : Bool;
  function abs() : BigIntImpl;
  function add(that : BigIntImpl) : BigIntImpl;
  function subtract(that : BigIntImpl) : BigIntImpl;
  function divide(that : BigIntImpl) : BigIntImpl;
  function multiply(that : BigIntImpl) : BigIntImpl;
  function modulo(that : BigIntImpl) : BigIntImpl;
  function random() : BigIntImpl;
  function negate() : BigIntImpl;
  function next() : BigIntImpl;
  function prev() : BigIntImpl;
  function pow(exp : BigIntImpl) : BigIntImpl;
  function shiftLeft(value : Int) : BigIntImpl;
  function shiftRight(value : Int) : BigIntImpl;
  function square() : BigIntImpl;
  function isEven() : Bool;
  function isOdd() : Bool;
  function isUnit() : Bool;
  function isZero() : Bool;
  function compareTo(that : BigIntImpl) : Int;
  function compareToAbs(that : BigIntImpl) : Int;
  function not() : BigIntImpl;
  function and(that : BigIntImpl) : BigIntImpl;
  function or(that : BigIntImpl) : BigIntImpl;
  function xor(that : BigIntImpl) : BigIntImpl;
  function toFloat() : Float;
  function toInt() : Int;
  function toString() : String;
  function toStringWithBase(base : Int) : String;
  function divMod(that : BigIntImpl) : { quotient : BigIntImpl, remainder : BigIntImpl };
}
