package thx.core;

/**
Helper functions for functions with arity 0 (functions that do not take arguments).
**/
class Function0 {
/**
`join` creates a function that calls the 2 functions passed as arguments in sequence.
**/
  public inline static function join(fa : Void -> Void, fb : Void -> Void)
    return function() {
      fa();
      fb();
    }

/**
`noop` is a function that has no side effects and doesn't return any value.
**/
  public static function noop() : Void {}

/**
`once` wraps and returns the argument function. `once` ensures that `f` will be called
at most once even if the returned function is invoked multiple times.
**/
  public inline static function once(f : Void -> Void)
    return function() {
      var t = f;
      f = noop;
      t();
    };
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

}

/**
Generic helper for functions.
**/
class Functions {
/**
It provides strict equality between the two arguments `a` and `b`.
**/
  public static function equality<T>(a : T, b : T) return a == b;
}