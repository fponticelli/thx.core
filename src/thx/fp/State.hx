package thx.fp;

import thx.Tuple;

@:callable
abstract State<S, A> (S -> Tuple<S, A>) from S -> Tuple<S, A> {
  public static function void<S>(): State<S, Void>
    return pure(null);

  public static function pure<S, A>(a: A): State<S, A>
    return function(s: S) (return new Tuple2(s, a));

  public static function getState<S>(): State<S, S>
    return (function(s: S) return new Tuple2(s, s));

  public static function putState<S>(s: S): State<S, Void>
    return (function(_: S) return new Tuple2(s, null));

  public inline function map<B>(f: A -> B): State<S, B> 
    return (function(s: S) return this(s).map(f));

  @:op(S1 * F)
  public function flatMap<B>(f: A -> State<S, B>): State<S, B> {
    return function(s: S) {
      var res0 = this(s);
      return f(res0._1)(res0._0);
    };
  }

  public function voided(): State<S, Void>
    return map(function(a) return null);

  @:op(S1 >> S2)
  public function then<B>(next: State<S, B>): State<S, B> 
    return function(s: S) (return next(this(s)._0));

  public function modify(f: S -> S): State<S, A>
    return function(s: S) (return this(f(s)));

  /** Run the composed computation, returning the result */
  public function run(s: S): A
    return this(s)._1;

  /** Run the composed computation just for the purpose of obtaining the final state. */
  public function runState(s: S): S
    return this(s)._0;
}
