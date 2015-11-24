package thx.fp;

class Functions {
  /**
   * The proper constant function, which returns a function of
   * one argument.
   */
  inline public static function const<A, B>(b: B): A -> B
    return function(a: A) return b;
}
