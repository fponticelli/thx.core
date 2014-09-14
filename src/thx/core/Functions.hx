package thx.core;

class Function0 {
  public static function noop() : Void {}
  public inline static function join(fa : Void -> Void, fb : Void -> Void)
    return function() {
      fa();
      fb();
    }

  public inline static function once(f : Void -> Void)
    return function() {
      f();
      f = function(){}
    };
}

class Function1 {
  public static function noop<T>(_ : T) : Void {}
  public inline static function compose<TIn, TRet1, TRet2>(fa : TRet2 -> TRet1, fb : TIn -> TRet2)
    return function(v : TIn) return fa(fb(v));

  public inline static function join<TIn>(fa : TIn -> Void, fb : TIn -> Void)
    return function(v : TIn) {
      fa(v);
      fb(v);
    }
}

class Function {
  public static function equality<T>(a : T, b : T) return a == b;
}