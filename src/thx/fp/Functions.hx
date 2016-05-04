package thx.fp;

class Functions {
  /**
   * The proper constant function, which returns a function of
   * one argument.
   */
  inline public static function const<A, B>(b: B): A -> B
    return function(a: A) : B return b;

  inline public static function flip<A, B, C>(f: A -> (B -> C)): B -> (A -> C)
    return function(b: B) : A -> C {
      return function(a: A) : C return f(a)(b);
    };
}
