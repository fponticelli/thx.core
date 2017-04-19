package thx;

import thx.Functions;
import thx.Functions.*;
import thx.Tuple;
import haxe.ds.Option;

abstract Maybe<T>(Null<T>) from Null<T> {
  inline public static function of<T>(value: Null<T>): Maybe<T>
    return value;

  inline public static function none<T>(): Maybe<T>
    return null;

  inline function new(value: Null<T>): Maybe<T>
    this = value;

  inline public function getUnsafe(): T
    return this;

  inline public function get(): Null<T>
    return this;

  inline public function isNull()
    return null == this;

  inline public function hasValue()
    return null != this;

  inline public function toOption(): Option<T>
    return Options.ofValue(this);

  inline public function ofOption(opt: Option<T>): Maybe<T>
    return Options.get(opt);

/**
Equality function to campare this `Maybe` value with another of the same type.
An optional equality function can be provided if values inside `Maybe` should
be compared using something different than strict equality.
**/
  public function equals(b : Maybe<T>, ?eq : T -> T -> Bool)
    return switch [get(), b.get()] {
      case [null, null]: true;
      case [null, _] | [_, null]: false;
      case [a, b]:
        if(null == eq)
          eq = function(a, b) return a == b;
        eq(a,b);
    };

  @:op(A==B)
  inline function _equals(b: Maybe<T>): Bool
    return equals(b);

/**
`map` transforms a value contained in `Maybe<T>` to `Maybe<TOut>` using a `callback`.
`callback` is used only if `Maybe` has a value that is not `null`.
**/
  public function map<TOut>(callback : T -> TOut) : Maybe<TOut>
    return if(null == this) null else callback(this);

/**
`ap` transforms a value contained in `Maybe<T>` to `Maybe<TOut>` using a `callback`
wrapped in another Maybe.
**/
  public function ap<U>(fopt: Maybe<T -> U>): Maybe<U>
    return if(null == this) null else fopt.map(function(f) return f(this));

/**
`flatMap` is shortcut for `map(cb).join()`
**/
  public function flatMap<TOut>(callback : T -> Maybe<TOut>) : Maybe<TOut>
    return if(null == this) null else callback(this);

/**
`join` collapses a nested maybe into a single optional value.
**/
  public function join(maybe: Maybe<Maybe<T>>): Maybe<T>
    return if(null == this) null else this;

/**
`cata` the maybe catamorphism, useful for inline deconstruction.
**/
  public function cata<B>(ifNone: B, f: T -> B): B
    return if(null == this) ifNone else f(this);

/**
Lazy version of `thx.Options.cata`
**/
  public function cataf<B>(ifNone : Void -> B, f : T -> B) : B
    return if(null == this) ifNone() else f(this);

/**
`foldLeft` reduce using an accumulating function and an initial value.
**/
  public function foldLeft<B>(b: B, f: B -> T -> B): B
    return if(null == this) b else f(b, this);

/**
Lazy version of `thx.Options.foldLeft`
**/
  public function foldLeftf<B>(b: Void -> B, f: B -> T -> B) : B
    return if(null == this) b() else f(b(), this);

/**
 * Fold by mapping the contained value into some monoidal type and reducing with that monoid.
 */
  public function foldMap<B>(f: T -> B, m: Monoid<B>): B
    return map(f).foldLeft(m.zero, m.append);

/**
`filter` returns the current value if any contained value matches the predicate, `Maybe.none()` otherwise.
**/
  public function filter(f: T -> Bool): Maybe<T>
    return if(null == this || !f(this)) null else this;

/**
`toArray` transforms an `Maybe<T>` value into an `Array<T>` value. The result array
will be empty if `Maybe` is `null` or will contain one value otherwise.
**/
  public function toArray() : Array<T>
    return if(null == this) [] else [this];

/**
`toBool` transforms an `Maybe` value into a boolean: `null` maps to `false`, and
any value to `true`. The value itself has no play in the conversion.
**/
  public function toBool<T>(maybe : Maybe<T>) : Bool
    return null != this;

/**
`isNone` determines whether the maybe is a null value.
**/
  inline public function isNone(): Bool
    return isNull();

/**
`getOrElse` extracts the value from `Maybe`. If the `Maybe` is `None`, `alt` value is returned.
**/
  public function getOrElse(alt : T) : T
    return if(null == this) alt else this;

/**
Extract the value from `Maybe` or throw a thx.Error if the `Maybe` is `None`.
**/
  public function getOrThrow(?err: thx.Error, ?posInfo: haxe.PosInfos): T {
    return if(null == this) {
      if(null == err)
        err = new thx.Error("Could not extract value from maybe", posInfo);
      throw err;
    } else {
      this;
    };
  }

/**
Extract the value from `Maybe` or throw a thx.Error with the provided message.
**/
  public function getOrFail(msg: String, ?posInfo: haxe.PosInfos): T
    return getOrThrow(new thx.Error(msg, posInfo));

/**
`orElse` returns `maybe` if it holds a value or `alt` otherwise.
**/
  public function orElse(alt : Maybe<T>) : Maybe<T>
    return if(null == this) alt else this;

  public function all<T>(maybe: Maybe<T>, f: T -> Bool): Bool
    return if(null == this) true else f(this);

  public function any<T>(maybe: Maybe<T>, f: T -> Bool): Bool
    return if(null == this) false else f(this);

  /**
  Traverse the maybe with a function that may return values wrapped in Validation.
  If any of the values are Failures, return a Failure that accumulates all errors
  from the failed values, otherwise return the array of mapped values in a Success.
  **/
  public function traverseValidation<E, U>(f: T -> Validation<E, U>): Validation<E, Maybe<U>>
    return if(null == this) Validation.success(null) else f(this).map(of);

  public function toSuccess<E>(error: E): Validation<E, T>
    return if(null == this) Validation.failure(error) else Validation.success(this);

  public function toSuccessNel<E, T>(maybe: Maybe<T>, error: E): Validation.VNel<E, T>
    return if(null == this) Validation.failureNel(error) else Validation.successNel(this);

  public function toFailure<TSuccess>(value: TSuccess): Validation<T, TSuccess>
    return if(null == this) Validation.success(value) else Validation.failure(this);

  public function toFailureNel<TSuccess>(value: TSuccess): Validation.VNel<T, TSuccess>
    return if(null == this) Validation.successNel(value) else Validation.failureNel(this);

  public function toRight<E>(left: E): Either<E, T>
    return if(null == this) Left(left) else Right(this);

  public function toLeft<TSuccess>(right: TSuccess): Either<T, TSuccess>
    return if(null == this) Right(right) else Left(this);

/**
	Performs `f` on the contents of `o` if `o` != `null`
**/
  public function each(f: T -> Void): Maybe<T>
    return if(null == this) null else {
      f(this);
      this;
    };

  inline static public function ap2<A, B, C>(f: A -> B -> C, v1: Maybe<A>, v2: Maybe<B>): Maybe<C>
    return v2.ap(v1.map(Functions2.curry(f)));

  inline static public function ap3<A, B, C, D>(f: A -> B -> C -> D, v1: Maybe<A>, v2: Maybe<B>, v3: Maybe<C>): Maybe<D>
    return v3.ap(ap2(Functions3.curry(f), v1, v2));

  inline static public function ap4<A, B, C, D, E>(
      f: A -> B -> C -> D -> E,
      v1: Maybe<A>, v2: Maybe<B>, v3: Maybe<C>, v4: Maybe<D>): Maybe<E>
    return v4.ap(ap3(Functions4.curry(f), v1, v2, v3));

  inline static public function ap5<A, B, C, D, E, F>(
      f: A -> B -> C -> D -> E -> F,
      v1: Maybe<A>, v2: Maybe<B>, v3: Maybe<C>, v4: Maybe<D>, v5: Maybe<E>): Maybe<F>
    return v5.ap(ap4(Functions5.curry(f), v1, v2, v3, v4));

  inline static public function ap6<A, B, C, D, E, F, G>(
      f: A -> B -> C -> D -> E -> F -> G,
      v1: Maybe<A>, v2: Maybe<B>, v3: Maybe<C>, v4: Maybe<D>, v5: Maybe<E>, v6: Maybe<F>): Maybe<G>
    return v6.ap(ap5(Functions6.curry(f), v1, v2, v3, v4, v5));

  inline static public function ap7<A, B, C, D, E, F, G, H>(
      f: A -> B -> C -> D -> E -> F -> G -> H,
      v1: Maybe<A>, v2: Maybe<B>, v3: Maybe<C>, v4: Maybe<D>, v5: Maybe<E>, v6: Maybe<F>, v7: Maybe<G>): Maybe<H>
    return v7.ap(ap6(Functions7.curry(f), v1, v2, v3, v4, v5, v6));

  inline static public function ap8<A, B, C, D, E, F, G, H, I>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I,
      v1: Maybe<A>, v2: Maybe<B>, v3: Maybe<C>, v4: Maybe<D>, v5: Maybe<E>, v6: Maybe<F>, v7: Maybe<G>, v8: Maybe<H>): Maybe<I>
    return v8.ap(ap7(Functions8.curry(f), v1, v2, v3, v4, v5, v6, v7));

  inline static public function combine<A, B>(a : Maybe<A>, b : Maybe<B>) : Maybe<Tuple2<A, B>>
    return ap2(Tuple2.of, a, b);

  inline static public function combine2<A, B>(a : Maybe<A>, b : Maybe<B>) : Maybe<Tuple2<A, B>>
    return combine(a, b);

  inline static public function combine3<A, B, C>(a : Maybe<A>, b : Maybe<B>, c : Maybe<C>) : Maybe<Tuple3<A, B, C>>
    return ap3(Tuple3.of, a, b, c);

  inline static public function combine4<A, B, C, D>(a : Maybe<A>, b : Maybe<B>, c : Maybe<C>, d : Maybe<D>) : Maybe<Tuple4<A, B, C, D>>
    return ap4(Tuple4.of, a, b, c, d);

  inline static public function combine5<A, B, C, D, E>(a : Maybe<A>, b : Maybe<B>, c : Maybe<C>, d : Maybe<D>, e : Maybe<E>) : Maybe<Tuple5<A, B, C, D, E>>
    return ap5(Tuple5.of, a, b, c, d, e);

  inline static public function combine6<A, B, C, D, E, F>(a : Maybe<A>, b : Maybe<B>, c : Maybe<C>, d : Maybe<D>, e : Maybe<E>, f : Maybe<F>) : Maybe<Tuple6<A, B, C, D, E, F>>
    return ap6(Tuple6.of, a, b, c, d, e, f);

  inline static public function spread2<A, B, C>(v : Maybe<Tuple2<A, B>>, f : A -> B -> C) : Maybe<C>
    return v.map(function(t) {
      return f(t._0, t._1);
    });

  inline static public function spread<A, B, C>(v : Maybe<Tuple2<A, B>>, f : A -> B -> C) : Maybe<C>
    return spread2(v, f);

  inline static public function spread3<A, B, C, D>(v : Maybe<Tuple3<A, B, C>>, f : A -> B -> C -> D) : Maybe<D>
    return v.map(function(t) {
      return f(t._0, t._1, t._2);
    });

  inline static public function spread4<A, B, C, D, E>(v : Maybe<Tuple4<A, B, C, D>>, f : A -> B -> C -> D -> E) : Maybe<E>
    return v.map(function(t) {
      return f(t._0, t._1, t._2, t._3);
    });

  inline static public function spread5<A, B, C, D, E, F>(v : Maybe<Tuple5<A, B, C, D, E>>, f : A -> B -> C -> D -> E -> F) : Maybe<F>
    return v.map(function(t) {
      return f(t._0, t._1, t._2, t._3, t._4);
    });

  inline static public function spread6<A, B, C, D, E, F, G>(v : Maybe<Tuple6<A, B, C, D, E, F>>, f : A -> B -> C -> D -> E -> F -> G) : Maybe<G>
    return v.map(function(t) {
      return f(t._0, t._1, t._2, t._3, t._4, t._5);
    });
}
