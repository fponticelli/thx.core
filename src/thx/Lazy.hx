package thx;

import haxe.macro.Expr;

@:callable
abstract Lazy<T>(Void -> T) from Void -> T to Void -> T {
  #if (haxe_ver >= 3.3)
  @:from macro public static function ofExpression<T>(expr: ExprOf<T>): ExprOf<Lazy<T>> {
    return macro function() { return $expr; };
  }
  #end

  public static function ofValue<T>(value: T): Lazy<T>
    return function(): T return value;

  public var value(get, never): T;
  function get_value(): T
    return this();

  public function map<TOut>(f : T -> TOut): Lazy<TOut>
    return function() return f(this());

  @:to public function toValue(): T
    return this();

  public function toString()
    return 'Lazy[${Std.string(value)}]';

  @:op(-A) public static function negatef(l: Lazy<Float>): Lazy<Float>
    return l.map(function(v) return -v);
  @:op(A+B) public static function addf(l1: Lazy<Float>, l2: Lazy<Float>): Lazy<Float>
    return function() return l1.value + l2.value;
  @:op(A-B) public static function subtractf(l1: Lazy<Float>, l2: Lazy<Float>): Lazy<Float>
    return function() return l1.value - l2.value;
  @:op(A*B) public static function multiplyf(l1: Lazy<Float>, l2: Lazy<Float>): Lazy<Float>
    return function() return l1.value * l2.value;
  @:op(A/B) public static function dividef(l1: Lazy<Float>, l2: Lazy<Float>): Lazy<Float>
    return function() return l1.value / l2.value;
  @:op(A%B) public static function modf(l1: Lazy<Float>, l2: Lazy<Float>): Lazy<Float>
    return function() return l1.value % l2.value;

  @:op(-A) public static function negate(l: Lazy<Int>): Lazy<Int>
    return l.map(function(v) return -v);
  @:op(A+B) public static function add(l1: Lazy<Int>, l2: Lazy<Int>): Lazy<Int>
    return function() return l1.value + l2.value;
  @:op(A-B) public static function subtract(l1: Lazy<Int>, l2: Lazy<Int>): Lazy<Int>
    return function() return l1.value - l2.value;
  @:op(A*B) public static function multiply(l1: Lazy<Int>, l2: Lazy<Int>): Lazy<Int>
    return function() return l1.value * l2.value;
  @:op(A/B) public static function divide(l1: Lazy<Int>, l2: Lazy<Int>): Lazy<Float>
    return function() return l1.value / l2.value;
  @:op(A%B) public static function mod(l1: Lazy<Int>, l2: Lazy<Int>): Lazy<Int>
    return function() return l1.value % l2.value;
}

class LazyFloatExtensions {
  public static function min(l1: Lazy<Float>, l2: Lazy<Float>): Lazy<Float>
    return function() return thx.Floats.min(l1.value, l2.value);
  public static function max(l1: Lazy<Float>, l2: Lazy<Float>): Lazy<Float>
    return function() return thx.Floats.max(l1.value, l2.value);
}

class LazyIntExtensions {
  public static function min(l1: Lazy<Int>, l2: Lazy<Int>): Lazy<Int>
    return function() return thx.Ints.min(l1.value, l2.value);
  public static function max(l1: Lazy<Int>, l2: Lazy<Int>): Lazy<Int>
    return function() return thx.Ints.max(l1.value, l2.value);
}
