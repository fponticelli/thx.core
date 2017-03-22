package thx;

import thx.Either;
import thx.Tuple;
import thx.Eithers;
using thx.Arrays;
using thx.Functions;

typedef VNel<E, A> = Validation<Nel<E>, A>;
/**
 * A right-biased disjunctive type with applicative functor requiring a semigroup
 * on the left type. This is useful for composing validation functions.
 */
abstract Validation<E, A> (Either<E, A>) from Either<E, A> {
  public var either(get, never): Either<E, A>;
  inline public function get_either(): Either<E, A>
    return this;

  inline public static function pure<E, A>(a: A): Validation<E, A>
    return Right(a);

  inline public static function success<E, A>(a: A): Validation<E, A>
    return pure(a);

  inline public static function failure<E, A>(e: E): Validation<E, A>
    return Left(e);

  inline public static function successNel<E, A>(a: A): VNel<E, A>
    return pure(a);

  inline public static function failureNel<E, A>(e: E): VNel<E, A>
    return Left(Nel.pure(e));

  // nonNull
  inline public static function nn<E, A>(a: Null<A>, e: E): Validation<E, A>
    return (a == null) ? failure(e) : success(a);

  // nonNullNel
  inline public static function nnNel<E, A>(a: Null<A>, e: E): VNel<E, A>
    return (a == null) ? failureNel(e) : successNel(a);

  public function map<B>(f: A -> B): Validation<E, B>
    return Eithers.map(this, f);

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

  /**
   * This is not simply flatMap because it is not consistent with ap,
   * as should be the case in other monads. It is equivalent to
   * `this.either.flatMap(f).validation`
   */
  inline public function flatMapV<B>(f: A -> Validation<E, B>): Validation<E, B>
    return switch this {
      case Left(a) : Left(a);
      case Right(b): f(b);
    };

  /**
   * If `this` validation is a Right, keep it. Otherwise, try `other` as an
   * alternative, merging their errors if both are Left.
  **/
  public function orElseV(other: Validation<E, A>, s: Semigroup<E>): Validation<E, A>
    return switch [this, other.either] {
      case [Right(_), _]: this;
      case [_, Right(_)]: other;
      case [Left(e1), Left(e2)]: Left(s.append(e1, e2));
    }

  inline public function foldLeft<B>(b: B, f: B -> A -> B): B
    return Eithers.foldLeft(this, b, f);

  inline public function foldMap<B>(f: A -> B, m: Monoid<B>): B
    return Eithers.foldMap(this, f, m);

  inline public function leftMap<E0>(f: E -> E0): Validation<E0, A>
    return Eithers.leftMap(this, f);

  inline public function wrapNel(): VNel<E, A>
    return Eithers.leftMap(this, Nel.pure);

  inline public function ensure(p: A -> Bool, error: E): Validation<E, A>
    return Eithers.ensure(this, p, error);

  //// UTILITY FUNCTIONS ////
  inline public static function vnel<E, A>(e: Either<Nel<E>, A>): VNel<E, A>
    return e;

  inline static public function val1<X, A, B>(f : A -> B, v1: Validation<X, A>) : Validation<X, B>
    return v1.map(f);

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

  inline static public function val9<X, A, B, C, D, E, F, G, H, I, J>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>,
      s: Semigroup<X>): Validation<X, J>
    return v9.ap(val8(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, s), s);

  inline static public function val10<X, A, B, C, D, E, F, G, H, I, J, K>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>, v10: Validation<X, J>,
      s: Semigroup<X>): Validation<X, K>
    return v10.ap(val9(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, v9, s), s);

  inline static public function val11<X, A, B, C, D, E, F, G, H, I, J, K, L>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>, v10: Validation<X, J>, v11: Validation<X, K>,
      s: Semigroup<X>): Validation<X, L>
    return v11.ap(val10(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, s), s);

  inline static public function val12<X, A, B, C, D, E, F, G, H, I, J, K, L, M>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>, v10: Validation<X, J>, v11: Validation<X, K>, v12: Validation<X, L>,
      s: Semigroup<X>): Validation<X, M>
    return v12.ap(val11(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, s), s);

  inline static public function val13<X, A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>, v10: Validation<X, J>, v11: Validation<X, K>, v12: Validation<X, L>, v13: Validation<X, M>,
      s: Semigroup<X>): Validation<X, N>
    return v13.ap(val12(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, s), s);

  inline static public function val14<X, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>, v10: Validation<X, J>, v11: Validation<X, K>, v12: Validation<X, L>, v13: Validation<X, M>, v14: Validation<X, N>,
      s: Semigroup<X>): Validation<X, O>
    return v14.ap(val13(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, s), s);

  inline static public function val15<X, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>, v10: Validation<X, J>, v11: Validation<X, K>, v12: Validation<X, L>, v13: Validation<X, M>, v14: Validation<X, N>, v15: Validation<X, O>,
      s: Semigroup<X>): Validation<X, P>
    return v15.ap(val14(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, s), s);

  inline static public function val16<X, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>, v10: Validation<X, J>, v11: Validation<X, K>, v12: Validation<X, L>, v13: Validation<X, M>, v14: Validation<X, N>, v15: Validation<X, O>, v16: Validation<X, P>,
      s: Semigroup<X>): Validation<X, Q>
    return v16.ap(val15(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, s), s);

  inline static public function val17<X, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>, v10: Validation<X, J>, v11: Validation<X, K>, v12: Validation<X, L>, v13: Validation<X, M>, v14: Validation<X, N>, v15: Validation<X, O>, v16: Validation<X, P>, v17: Validation<X, Q>,
      s: Semigroup<X>): Validation<X, R>
    return v17.ap(val16(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, s), s);

  inline static public function val18<X, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>, v10: Validation<X, J>, v11: Validation<X, K>, v12: Validation<X, L>, v13: Validation<X, M>, v14: Validation<X, N>, v15: Validation<X, O>, v16: Validation<X, P>, v17: Validation<X, Q>, v18: Validation<X, R>,
      s: Semigroup<X>): Validation<X, S>
    return v18.ap(val17(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, s), s);

  inline static public function val19<X, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>, v10: Validation<X, J>, v11: Validation<X, K>, v12: Validation<X, L>, v13: Validation<X, M>, v14: Validation<X, N>, v15: Validation<X, O>, v16: Validation<X, P>, v17: Validation<X, Q>, v18: Validation<X, R>, v19: Validation<X, S>,
      s: Semigroup<X>): Validation<X, T>
    return v19.ap(val18(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, s), s);

  inline static public function val20<X, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L -> M -> N -> O -> P -> Q -> R -> S -> T -> U,
      v1: Validation<X, A>, v2: Validation<X, B>, v3: Validation<X, C>, v4: Validation<X, D>, v5: Validation<X, E>, v6: Validation<X, F>, v7: Validation<X, G>, v8: Validation<X, H>, v9: Validation<X, I>, v10: Validation<X, J>, v11: Validation<X, K>, v12: Validation<X, L>, v13: Validation<X, M>, v14: Validation<X, N>, v15: Validation<X, O>, v16: Validation<X, P>, v17: Validation<X, Q>, v18: Validation<X, R>, v19: Validation<X, S>, v20: Validation<X, T>,
      s: Semigroup<X>): Validation<X, U>
    return v20.ap(val19(f.curry(), v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, s), s);
}

class ValidationExtensions {
  public static inline function leftMapNel<E, E0, A>(n: VNel<E, A>, f: E -> E0): VNel<E0, A>
    return n.leftMap(function(n) return n.map(f));

  public static function ensureNel<E, A>(v: VNel<E, A>, p: A -> Bool, error: E): VNel<E, A>
    return switch v {
      case Right(a): if (p(a)) v else Validation.failureNel(error);
      case left: left;
    };

  public static function appendVNel<E, A>(target: VNel<E, Array<A>>, item: VNel<E, A>) : VNel<E, Array<A>> {
    return switch [target, item] {
      case [Right(values), Right(value)] : Right(values.append(value));
      case [Right(values), Left(errors)] : Left(errors);
      case [Left(errors), Right(value)] : Left(errors);
      case [Left(errors1), Left(errors2)] : Left(errors1.append(errors2));
    };
  }

  public static function appendValidation<E, A>(target: VNel<E, Array<A>>, item: Validation<E, A>) : VNel<E, Array<A>> {
    return appendVNel(target, Eithers.toVNel(item.either));
  }

  public static function appendVNels<E, A>(target: VNel<E, Array<A>>, items: Array<VNel<E, A>>) : VNel<E, Array<A>> {
    return items.reduce(appendVNel, target);
  }

  public static function appendValidations<E, A>(target: VNel<E, Array<A>>, items: Array<Validation<E, A>>) : VNel<E, Array<A>> {
    return items.reduce(appendValidation, target);
  }
}
