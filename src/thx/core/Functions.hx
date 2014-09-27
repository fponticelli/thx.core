package thx.core;

/**
Helper functions for functions with arity 0 (functions that do not take arguments).
**/
class Function0 {
  public inline static function join(fa : Void -> Void, fb : Void -> Void)
    return function() {
      fa();
      fb();
    }

  public static function noop() : Void {}

  public inline static function once(f : Void -> Void)
    return function() {
      f();
      f = function(){}
    };
}

/**
Helper functions for functions with arity 1 (functions that take exactly 1 argument).
**/
class Function1 {
  public inline static function compose<TIn, TRet1, TRet2>(fa : TRet2 -> TRet1, fb : TIn -> TRet2)
    return function(v : TIn) return fa(fb(v));

  public static function noop<T>(_ : T) : Void {}

  public inline static function join<TIn>(fa : TIn -> Void, fb : TIn -> Void)
    return function(v : TIn) {
      fa(v);
      fb(v);
    }
}

/**
Generic helper for functions.
**/
class Functions {
  public static function equality<T>(a : T, b : T) return a == b;
}