package thx;

import thx.Either;
import thx.Tuple;
import thx.Validation;
using thx.Functions;
using thx.Eithers;

typedef VNel<E, A> = Validation<Nel<E>, A>;
/**
 * A right-biased disjunctive type with applicative functor requiring a semigroup
 * on the left type. This is useful for composing validation functions.
 */
abstract Validation<E, A> (Either<E, A>) from Either<E, A> {
  inline public static function validation<E, A>(e: Either<E, A>): Validation<E, A>
    return e;

  inline public static function vnel<E, A>(e: Either<Nel<E>, A>): VNel<E, A>
    return e;

  inline public static function pure<E, A>(a: A): Validation<E, A>
    return Right(a);

  inline public static function success<E, A>(a: A): Validation<E, A>
    return pure(a);

  inline public static function failure<E, A>(e: E): Validation<E, A>
    return Left(e);

  // nonNull
  inline public static function nn<E, A>(a: Null<A>, e: E): Validation<E, A>
    return (a == null) ? failure(e) : success(a);

  inline public static function successNel<E, A>(a: A): VNel<E, A>
    return pure(a);

  inline public static function failureNel<E, A>(e: E): VNel<E, A>
    return Left(Nel.pure(e));

  // nonNullNel
  inline public static function nnNel<E, A>(a: Null<A>, e: E): VNel<E, A>
    return (a == null) ? failureNel(e) : successNel(a);

  public var either(get, never): Either<E, A>;
  public inline function get_either(): Either<E, A>
    return this;

  inline public function map<B>(f: A -> B): Validation<E, B>
    return ap(Right(f), function(e1: E, e2: E) { throw "Unreachable"; });

  public function foldLeft<B>(b: B, f: B -> A -> B): B
    return switch this {
      case Left(_): b;
      case Right(a): f(b, a);
    };

  /**
   * Fold by mapping the contained value into some monoidal type and reducing with that monoid.
   */
  public function foldMap<B>(f: A -> B, m: Monoid<B>): B
    return (map(f): Validation<E, B>).foldLeft(m.zero, m.append);

  public function ap<B>(v: Validation<E, A -> B>, s: Semigroup<E>): Validation<E, B>
    return switch this {
      case Left(e0):
        switch v.either {
          case Left(e1): Left(s.append(e0, e1));
          case Right(b): Left(e0);
        }
      case Right(a):
        switch v.either {
          case Left(e): Left(e);
          case Right(f): Right(f(a));
        }
    };

  inline public function zip<B>(v: Validation<E, B>, s: Semigroup<E>): Validation<E, Tuple2<A, B>>
    return ap((v.either.map(function(b: B){ return Tuple2.of.bind(_, b); }): Either<E, A -> Tuple2<A, B>>), s);

  inline public function leftMap<E0>(f: E -> E0): Validation<E0, A>
    return (either.leftMap(f) : Either<E0, A>);

  inline public function wrapNel(): VNel<E, A>
    return (either.leftMap(Nel.pure) : Either<Nel<E>, A>);

  public function ensure(p: A -> Bool, error: E): Validation<E, A>
    return switch this {
      case Right(a): if (p(a)) this else failure(error);
      case left: left;
    };

  // This is not simply flatMap because it is not consistent with ap,
  // as should be the case in other monads. It is equivalent to
  // `this.either.flatMap(f).validation`
  inline public function flatMapV<B>(f: A -> Validation<E, B>): Validation<E, B>
    return switch this {
      case Left(a) : Left(a);
      case Right(b): f(b);
    };

  //// UTILITY FUNCTIONS ////
  inline static public function val2<X, A, B, C>(f: A -> B -> C, v1: Validation<X, A>, v2: Validation<X, B>, s: Semigroup<X>): Validation<X, C>
    return v2.ap(v1.map(f.curry()), s);

  inline static public function val3<X, A, B, C, D>(f: A -> B -> C -> D, v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, s: Semigroup<X>): Validation<X, D>
    return v3.ap(val2(f.curry(), v1, v2, s), s);

  inline static public function val4<X, A, B, C, D, E>(
      f: A -> B -> C -> D -> E,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>,
      s: Semigroup<X>): Validation<X, E>
    return v4.ap(val3(f.curry(), v1, v2, v3, s), s);

  inline static public function val5<X, A, B, C, D, E, F>(
      f: A -> B -> C -> D -> E -> F,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>,
      s: Semigroup<X>): Validation<X, F>
    return v5.ap(val4(f.curry(), v1, v2, v3, v4, s), s);

  inline static public function val6<X, A, B, C, D, E, F, G>(
      f: A -> B -> C -> D -> E -> F -> G,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>,
      s: Semigroup<X>): Validation<X, G>
    return v6.ap(val5(f.curry(), v1, v2, v3, v4, v5, s), s);

  inline static public function val7<X, A, B, C, D, E, F, G, H>(
      f: A -> B -> C -> D -> E -> F -> G -> H,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>,
      s: Semigroup<X>): Validation<X, H>
    return v7.ap(val6(f.curry(), v1, v2, v3, v4, v5, v6, s), s);

  inline static public function val8<X, A, B, C, D, E, F, G, H, I>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>,
      s: Semigroup<X>): Validation<X, I>
    return v8.ap(val7(f.curry(), v1, v2, v3, v4, v5, v6, v7, s), s);
}

class ValidationExtensions {
  public static inline function leftMapNel<E, E0, A>(n: VNel<E, A>, f: E -> E0): VNel<E0, A>
    return n.leftMap(function(n) return n.map(f));

  public static function ensureNel<E, A>(v: VNel<E, A>, p: A -> Bool, error: E): VNel<E, A>
    return switch v {
      case Right(a): if (p(a)) v else Validation.failureNel(error);
      case left: left;
    };

}

