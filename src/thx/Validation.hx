package thx;

import thx.Disjunction;
import thx.Either;
import thx.Tuple;

using thx.Functions.Functions2;
using thx.Functions.Functions3;
using thx.Functions.Functions4;

/**
 * A right-biased disjunctive type with applicative functor requiring a semigroup 
 * on the left type. This is useful for composing validation functions.
 */
abstract Validation<E, A> (Either<E, A>) from Either<E, A> {
  public static function pure<E, A>(a: A): Validation<E, A>
    return Right(a);

  var disjunction(get, never): Disjunction<E, A>;

  inline public function map<B>(f: A -> B): Validation<E, B> 
    return ap(Right(f), function(e1: E, e2: E) { throw "Unreachable"; });

  public function ap<B>(v: Validation<E, A -> B>, appendErrors: E -> E -> E): Validation<E, B> 
    return switch this {
      case Left(e0):
        switch v.disjunction {
          case Left(e1): Left(appendErrors(e0, e1));
          case Right(b): Left(e0);
        }
      case Right(a): 
        switch v.disjunction {
          case Left(e): Left(e);
          case Right(f): Right(f(a));
        }
    };

  inline public function zip<B>(v: Validation<E, B>, appendErrors: E -> E -> E): Validation<E, Tuple2<A, B>> 
    return ap((v.disjunction.map(function(b: B){ return function(a: A){ return new Tuple2(a, b); }; }): Either<E, A -> Tuple2<A, B>>), appendErrors);

  inline public function leftMap<E0>(f: E -> E0): Validation<E0, A> 
    return (disjunction.leftMap(f) : Either<E0, A>);

  public function get_disjunction(): Disjunction<E, A>
    return this;

  //// UTILITY FUNCTIONS ////
  inline static public function val2<X, A, B, C>(f: A -> B -> C, v1: Validation<X, A>, v2: Validation<X, B>, appendErrors: X -> X -> X): Validation<X, C> 
    return v2.ap(v1.map(f.curry()), appendErrors);

  inline static public function val3<X, A, B, C, D>(f: A -> B -> C -> D, v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, appendErrors: X -> X -> X): Validation<X, D> 
    return v3.ap(val2(f.curry(), v1, v2, appendErrors), appendErrors);

  inline static public function val4<X, A, B, C, D, E>(
      f: A -> B -> C -> D -> E, 
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>,
      appendErrors: X -> X -> X): Validation<X, E> 
    return v4.ap(val3(f.curry(), v1, v2, v3, appendErrors), appendErrors);
}
