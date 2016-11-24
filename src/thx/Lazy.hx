package thx;

import haxe.macro.Expr;

@:callable
abstract Lazy<T>(Void -> T) from Void -> T to Void -> T {
  @:from macro public static function ofExpression<T>(expr: ExprOf<T>): ExprOf<Lazy<T>> {
    return macro function() { return $expr; };
  }

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

  @:op(-A) public static function negate<T: Float>(l: Lazy<T>): Lazy<T>
    return l.map(function(v) return -v);
  @:op(A+B) public static function add<T: Float>(l1: Lazy<T>, l2: Lazy<T>): Lazy<T>
    return function() return l1.value + l2.value;
  @:op(A-B) public static function subtract<T: Float>(l1: Lazy<T>, l2: Lazy<T>): Lazy<T>
    return function() return l1.value - l2.value;
  @:op(A*B) public static function multiply<T: Float>(l1: Lazy<T>, l2: Lazy<T>): Lazy<T>
    return function() return l1.value * l2.value;
  @:op(A/B) public static function divide<T: Float>(l1: Lazy<T>, l2: Lazy<T>): Lazy<Float>
    return function() return l1.value / l2.value;
  @:op(A%B) public static function mod<T: Float>(l1: Lazy<T>, l2: Lazy<T>): Lazy<T>
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
