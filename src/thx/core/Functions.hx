package thx.core;

#if macro
import haxe.macro.Expr;
import haxe.macro.ExprTools;
#end

/**
Helper functions for functions with arity 0 (functions that do not take arguments).
**/
class Function0 {
/**
Returns a function that invokes `callback` after being being invoked `n` times.
**/
  inline public function after(n : Int, callback : Void -> Void)
    return function()
      if(--n == 0)
        callback();
/**
`join` creates a function that calls the 2 functions passed as arguments in sequence.
**/
  public inline static function join(fa : Void -> Void, fb : Void -> Void)
    return function() {
      fa();
      fb();
    }

/**
`once` wraps and returns the argument function. `once` ensures that `f` will be called
at most once even if the returned function is invoked multiple times.
**/
  public inline static function once(f : Void -> Void)
    return function() {
      var t = f;
      f = Functions.noop;
      t();
    };

/**
Creates a function that calls `callback` `n` times and returns an array of results.
**/
  public inline static function times<T>(n : Int, callback : Void -> T)
    return function()
      return Ints.range(n).map(function(_) return callback());

/**
Creates a function that calls `callback` `n` times and returns an array of results.

Callback takes an additional argument `index`.
**/
  public inline static function timesi<T>(n : Int, callback : Int -> T)
    return function()
      return Ints.range(n).map(function(i) return callback(i));
}

/**
Helper functions for functions with arity 1 (functions that take exactly 1 argument).
**/
class Function1 {
 /**
`compose` returns a function that calls the first arguemnt function with the result
of the following one.
 **/
  public inline static function compose<TIn, TRet1, TRet2>(fa : TRet2 -> TRet1, fb : TIn -> TRet2)
    return function(v : TIn) return fa(fb(v));

/**
`join` creates a function that calls the 2 functions passed as arguments in sequence
and passes the same argument value to the both of them.
**/
  public inline static function join<TIn>(fa : TIn -> Void, fb : TIn -> Void)
    return function(v : TIn) {
      fa(v);
      fb(v);
    }

/**
`noop` is a function that has no side effects and doesn't return any value.
**/
  public static function noop<T>(_ : T) : Void {}

/**
Creates a function that calls `callback` `n` times and returns an array of results.
**/
  public inline static function times<TIn, TOut>(n : Int, callback : TIn -> TOut)
    return function(value : TIn)
      return Ints.range(n).map(function(_) return callback(value));

/**
Creates a function that calls `callback` `n` times and returns an array of results.

Callback takes an additional argument `index`.
**/
  public inline static function timesi<TIn, TOut>(n : Int, callback : TIn -> Int -> TOut)
    return function(value : TIn)
      return Ints.range(n).map(function(i) return callback(value, i));

/**

**/
  public inline static function swapArguments<T1, T2, TReturn>(callback : T1 -> T2 -> TReturn) : T2 -> T1 -> TReturn
    return function(a2 : T2, a1 : T1)
      return callback(a1, a2);
}

/**
Generic helper for functions.
**/
class Functions {
/**
`constant` creates a function that always returns the same value.
**/
  public static function constant<T>(v : T)
    return function() return v;

/**
It provides strict equality between the two arguments `a` and `b`.
**/
  public static function equality<T>(a : T, b : T) : Bool
    return a == b;

/**
The `identity` function returns the value of its argument.
**/
  public static function identity<T>(value : T) : T
    return value;

/**
`noop` is a function that has no side effects and doesn't return any value.
**/
  public static function noop() : Void {}
}