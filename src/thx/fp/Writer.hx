package thx.fp;

import thx.Tuple;
import thx.Monoid;
import thx.Unit;
using thx.Functions;
import thx.fp.Functions.const;

@:callable
abstract Writer<W, A> (Tuple3<Monoid<W>, W, A>) {
  // Private constructor
  function new(t3: Tuple3<Monoid<W>, W, A>) { this = t3; }
  function repr(): Tuple3<Monoid<W>, W, A> return this;

  public static function void<W>(mw: Monoid<W>): Writer<W, Unit>
    return pure(unit, mw);

  public static function pure<W, A>(a: A, mw: Monoid<W>): Writer<W, A>
    return new Writer(new Tuple3(mw, mw.zero, a));

  public static function tell<W, A>(w: W, mw: Monoid<W>): Writer<W, Unit>
    return new Writer(new Tuple3(mw, w, unit));

  public function map<B>(f: A -> B): Writer<W, B>
    return new Writer(this.map(f));

  public function ap<B>(s2: Writer<W, A -> B>): Writer<W, B>
    return flatMap(function(a: A) return s2.map(function(f: A -> B) return f(a)));

  public function flatMap<B>(f: A -> Writer<W, B>): Writer<W, B> {
    var res0 = f(this._2).repr();
    return new Writer(new Tuple3(this._0, this._0.append(this._1, res0._1), res0._2));
  }

  public function log(w: W): Writer<W, A>
    return new Writer(new Tuple3(this._0, this._0.append(this._1, w), this._2));

  @:op(S1 >> S2)
  public function then<B>(next: Writer<W, B>): Writer<W, B>
    return flatMap(const(next));

  public function foreachM<B>(f: A -> Writer<W, B>): Writer<W, A> {
    var res0: Writer<W, B> = flatMap(f);
    return new Writer(new Tuple3(this._0, res0.repr()._1, this._2));
  }

  public function voided(): Writer<W, Unit>
    return map(const(unit));

  /** Run the composed computation, returning the result */
  public function run(): Tuple<W, A>
    return new Tuple2(this._1, this._2);

  /** Run the composed computation just for the purpose of obtaining the final state. */
  public function runLog(): W
    return this._1;

  /** Convenience functions for applicative programming style */

  static public function ap2<W, A, B, C>(f: A -> B -> C, s1: Writer<W, A>, s2: Writer<W, B>): Writer<W, C>
    return s2.ap(s1.map(f.curry()));

  static public function ap3<X, A, B, C, D>(f: A -> B -> C -> D, s1: Writer<X, A>, s2: Writer<X, B>, s3: Writer<X, C>): Writer<X, D>
    return s3.ap(ap2(f.curry(), s1, s2));

  static public function ap4<W, A, B, C, D, E>(
      f: A -> B -> C -> D -> E,
      s1: Writer<W, A>, s2: Writer<W, B>, s3: Writer<W, C>, s4: Writer<W, D>): Writer<W, E>
    return s4.ap(ap3(f.curry(), s1, s2, s3));

  static public function ap5<W, A, B, C, D, E, F>(
      f: A -> B -> C -> D -> E -> F,
      s1: Writer<W, A>, s2: Writer<W, B>, s3: Writer<W, C>, s4: Writer<W, D>, s5: Writer<W, E>): Writer<W, F>
    return s5.ap(ap4(f.curry(), s1, s2, s3, s4));

  static public function ap6<W, A, B, C, D, E, F, G>(
      f: A -> B -> C -> D -> E -> F -> G,
      s1: Writer<W, A>, s2: Writer<W, B>, s3: Writer<W, C>, s4: Writer<W, D>, s5: Writer<W, E>, s6: Writer<W, F>): Writer<W, G>
    return s6.ap(ap5(f.curry(), s1, s2, s3, s4, s5));

  static public function ap7<W, A, B, C, D, E, F, G, H>(
      f: A -> B -> C -> D -> E -> F -> G -> H,
      s1: Writer<W, A>, s2: Writer<W, B>, s3: Writer<W, C>, s4: Writer<W, D>, s5: Writer<W, E>, s6: Writer<W, F>, s7: Writer<W, G>): Writer<W, H>
    return s7.ap(ap6(f.curry(), s1, s2, s3, s4, s5, s6));

  static public function ap8<W, A, B, C, D, E, F, G, H, I>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I,
      s1: Writer<W, A>, s2: Writer<W, B>, s3: Writer<W, C>, s4: Writer<W, D>, s5: Writer<W, E>, s6: Writer<W, F>, s7: Writer<W, G>, s8: Writer<W, H>): Writer<W, I>
    return s8.ap(ap7(f.curry(), s1, s2, s3, s4, s5, s6, s7));
}
