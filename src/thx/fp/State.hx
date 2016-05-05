package thx.fp;

import thx.Tuple;
import thx.Unit;
import thx.fp.Functions.const;
using thx.Functions;

@:callable
abstract State<S, A> (S -> Tuple<S, A>) from S -> Tuple<S, A> {
  public static function void<S>(): State<S, Unit>
    return pure(null);

  public static function pure<S, A>(a: A): State<S, A>
    return function(s: S) (return new Tuple2(s, a));

  public static function getState<S>(): State<S, S>
    return (function(s: S) return new Tuple2(s, s));

  public static function putState<S>(s: S): State<S, Unit>
    return (function(_: S) return new Tuple2(s, null));

  public #if !php inline #end function map<B>(f: A -> B): State<S, B>
    return (function(s: S) return this(s).map(f));

  public function ap<B>(s2: State<S, A -> B>): State<S, B>
    return flatMap(function(a: A) : State<S, B> return s2.map(function(f: A -> B) : B return f(a)));

  @:op(S1 * F)
  public function flatMap<B>(f: A -> State<S, B>): State<S, B>
    return function(s: S) {
      var res0 = this(s);
      return f(res0._1)(res0._0);
    };

  public function voided(): State<S, Unit>
    return map(const(null));

  @:op(S1 >> S2)
  public function then<B>(next: State<S, B>): State<S, B>
    return function(s: S) (return next(this(s)._0));

  public function foreachM<B>(f: A -> State<S, B>): State<S, A>
    return function(s: S) {
      var res0 = this(s);
      return f(res0._1)(res0._0).map(const(res0._1));
    };

  public function modify(f: S -> S): State<S, A>
    return function(s: S) (return this(f(s)));

  /** Run the composed computation, returning the result */
  public function run(s: S): A
    return this(s)._1;

  /** Run the composed computation just for the purpose of obtaining the final state. */
  public function runState(s: S): S
    return this(s)._0;

  /** Convenience functions for applicative programming style */

  inline static public function ap2<S, A, B, C>(f: A -> B -> C, s1: State<S, A>, s2: State<S, B>): State<S, C>
    return s2.ap(s1.map(f.curry()));

  inline static public function ap3<S, A, B, C, D>(f: A -> B -> C -> D, s1: State<S, A>, s2: State<S, B>, s3: State<S, C>): State<S, D>
    return s3.ap(ap2(f.curry(), s1, s2));

  inline static public function ap4<S, A, B, C, D, E>(
      f: A -> B -> C -> D -> E,
      s1: State<S, A>, s2: State<S, B>, s3: State<S, C>, s4: State<S, D>): State<S, E>
    return s4.ap(ap3(f.curry(), s1, s2, s3));

  inline static public function ap5<S, A, B, C, D, E, F>(
      f: A -> B -> C -> D -> E -> F,
      s1: State<S, A>, s2: State<S, B>, s3: State<S, C>, s4: State<S, D>, s5: State<S, E>): State<S, F>
    return s5.ap(ap4(f.curry(), s1, s2, s3, s4));

  inline static public function ap6<S, A, B, C, D, E, F, G>(
      f: A -> B -> C -> D -> E -> F -> G,
      s1: State<S, A>, s2: State<S, B>, s3: State<S, C>, s4: State<S, D>, s5: State<S, E>, s6: State<S, F>): State<S, G>
    return s6.ap(ap5(f.curry(), s1, s2, s3, s4, s5));

  inline static public function ap7<S, A, B, C, D, E, F, G, H>(
      f: A -> B -> C -> D -> E -> F -> G -> H,
      s1: State<S, A>, s2: State<S, B>, s3: State<S, C>, s4: State<S, D>, s5: State<S, E>, s6: State<S, F>, s7: State<S, G>): State<S, H>
    return s7.ap(ap6(f.curry(), s1, s2, s3, s4, s5, s6));

  inline static public function ap8<S, A, B, C, D, E, F, G, H, I>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I,
      s1: State<S, A>, s2: State<S, B>, s3: State<S, C>, s4: State<S, D>, s5: State<S, E>, s6: State<S, F>, s7: State<S, G>, s8: State<S, H>): State<S, I>
    return s8.ap(ap7(f.curry(), s1, s2, s3, s4, s5, s6, s7));
}
