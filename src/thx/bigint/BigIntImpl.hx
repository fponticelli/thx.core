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
  function negate() : BigIntImpl;
  function isZero() : Bool;
  function compare(that : BigIntImpl) : Int;
  function toFloat() : Float;
  function toInt() : Int;
  function toStringWithBase(base : Int) : String;
}
