package thx;

import thx.Functions;
import thx.Functions.*;
import thx.Tuple;
import haxe.ds.Option;

/**
Extension methods for the `haxe.ds.Option` type.
**/
class Options {
  inline public static function ofValue<T>(value : Null<T>) : Option<T>
    return null == value ? None : Some(value);

  inline public static function maybe<T>(value : Null<T>) : Option<T>
    return null == value ? None : Some(value);

/**
Equality function to campare two `Option` values of the same type. An optional equality
function can be provided if values inside `Some` should be compared using something
different than strict equality.
**/
  public static function equals<T>(a : Option<T>, b : Option<T>, ?eq : T -> T -> Bool)
    return switch [a, b] {
      case [None, None]: true;
      case [Some(a), Some(b)]:
        if(null == eq)
          eq = function(a, b) return a == b;
        eq(a,b);
      case [_, _]:
        false;
    };

/**
`equalsValue` compares an `Option<T>` with a value `T`. The logic adopted to compare
values is the same as in `Options.equals()`.
**/
  public static function equalsValue<T>(a : Option<T>, b : Null<T>, ?eq : T -> T -> Bool)
    return equals(a, toOption(b), eq);

/**
`map` transforms a value contained in `Option<T>` to `Option<TOut>` using a `callback`.
`callback` is used only if `Option` is `Some(value)`.
**/
  public static function map<T, TOut>(option : Option<T>, callback : T -> TOut) : Option<TOut>
    return switch option {
      case None: None;
      case Some(v): Some(callback(v));
    };

/**
`ap` transforms a value contained in `Option<T>` to `Option<TOut>` using a `callback`
wrapped in another Option.
**/
  public static function ap<T, U>(option : Option<T>, fopt: Option<T -> U>): Option<U>
    return switch option {
      case None: None;
      case Some(v): map(fopt, function(f) return f(v));
    };

/**
`flatMap` is shortcut for `map(cb).join()`
**/
  public static function flatMap<T, TOut>(option : Option<T>, callback : T -> Option<TOut>) : Option<TOut>
    return switch option {
      case None: None;
      case Some(v): callback(v);
    };

/**
`join` collapses a nested option into a single optional value.
**/
  public static function join<T>(option: Option<Option<T>>): Option<T>
    return switch option {
      case None: None;
      case Some(v): v;
    };

/**
`cata` the option catamorphism, useful for inline deconstruction.
**/
  public static function cata<A, B>(option: Option<A>, ifNone: B, f: A -> B): B
    return switch option {
      case None: ifNone;
      case Some(v): f(v);
    };

/**
Lazy version of `thx.Options.cata`
**/
  public static function cataf<A, B>(option : Option<A>, ifNone : Void -> B, f : A -> B) : B
    return switch option {
      case None: ifNone();
      case Some(v) : f(v);
    };


/**
`foldLeft` reduce using an accumulating function and an initial value.
**/
  public static function foldLeft<T, B>(option: Option<T>, b: B, f: B -> T -> B): B
    return switch option {
      case None: b;
      case Some(v): f(b, v);
    };

/**
Lazy version of `thx.Options.foldLeft`
**/
  public static function foldLeftf<T, B>(option: Option<T>, b: Void -> B, f: B -> T -> B) : B
    return switch option {
      case None: b();
      case Some(v) : f(b(), v);
    };

/**
 * Fold by mapping the contained value into some monoidal type and reducing with that monoid.
 */
  public static function foldMap<A, B>(option: Option<A>, f: A -> B, m: Monoid<B>): B
    return foldLeft(map(option, f), m.zero, m.append);

/**
`filter` returns the current value if any contained value matches the predicate, None otherwise.
**/
  public static function filter<A>(option: Option<A>, f: A -> Bool): Option<A>
    return switch option {
      case Some(v) if (f(v)): option;
      case _: None;
    };

/**
`toArray` transforms an `Option<T>` value into an `Array<T>` value. The result array
will be empty if `Option` is `None` or will contain one value otherwise.
**/
  public static function toArray<T>(option : Option<T>) : Array<T>
    return switch option {
      case None: [];
      case Some(v) : [v];
    };

/**
`toBool` transforms an `Option` value into a boolean: `None` maps to `false`, and
`Some(_)` to `true`. The value in `Some` has no play in the conversion.
**/
  #if ((haxe_ver <= 3.2) && java) @:generic #end
  public static function toBool<T>(option : Option<T>) : Bool
    return switch option {
      case None: false;
      case Some(_) : true;
    };

/**
`isNone` determines whether the option is a None
**/
  #if ((haxe_ver <= 3.2) && java) @:generic #end
  public static function isNone<T>(option: Option<T>): Bool
    return !toBool(option);

/**
`toOption` transforms any type T into `Option<T>`. If the value is null, the result
is be `None`.
**/
  inline public static function toOption<T>(value : Null<T>) : Option<T>
    return null == value ? None : Some(value);

/**
`toValue` extracts the value from `Option`. If the `Option` is `None`, `null` is returned.
**/
  public static function get<T>(option : Option<T>) : Null<T>
    return switch option {
      case None: null;
      case Some(v) : v;
    };

/**
`getOrElse` extracts the value from `Option`. If the `Option` is `None`, `alt` value is returned.
**/
  public static function getOrElse<T>(option : Option<T>, alt : T) : T
    return switch option {
      case None: alt;
      case Some(v) : v;
    };

/**
`getOrElseF` extracts the value from `Option`. If the `Option` is `None`, `alt` function is called to produce a default value..
**/
  public static function getOrElseF<T>(option: Option<T>, alt: Void -> T) : T
    return switch option {
      case None: alt();
      case Some(v) : v;
    };

/**
Extract the value from `Option` or throw a thx.Error if the `Option` is `None`.
**/
  public static function getOrThrow<T>(option: Option<T>, ?err: thx.Error, ?posInfo: haxe.PosInfos): T {
    if(null == err) err = new thx.Error("Could not extract value from option", posInfo);
    return switch option {
      case None: throw err;
      case Some(v): v;
    };
  }

/**
Extract the value from `Option` or throw a thx.Error with the provided message.
**/
  public static function getOrFail<T>(option: Option<T>, msg: String, ?posInfo: haxe.PosInfos): T
    return getOrThrow(option, new thx.Error(msg, posInfo));

/**
`orElse` returns `option` if it holds a value or `alt` otherwise.
**/
  public static function orElse<T>(option : Option<T>, alt : Option<T>) : Option<T>
    return switch option {
      case None: alt;
      case Some(_) : option;
    };

/**
`orElseF` returns `option` if it holds a value or calls `alt` to produce a default `Option<T>`.
**/
  public static function orElseF<T>(option: Option<T>, alt: Void -> Option<T>) : Option<T>
    return switch option {
      case None: alt();
      case Some(_) : option;
    }

  public static function all<T>(option: Option<T>, f: T -> Bool): Bool
    return switch option {
      case None: true;
      case Some(v): f(v);
    };

  public static function any<T>(option: Option<T>, f: T -> Bool): Bool
    return switch option {
      case None: false;
      case Some(v): f(v);
    };

  /**
  Traverse the array with a function that may return values wrapped in Validation.
  If any of the values are Failures, return a Failure that accumulates all errors
  from the failed values, otherwise return the array of mapped values in a Success.
  **/
  public static function traverseValidation<E, T, U>(option: Option<T>, f: T -> Validation<E, U>): Validation<E, Option<U>>
    return switch option {
      case Some(v): f(v).map(function(v) return Some(v));
      case None: Validation.success(None);
    };

  public static function toSuccess<E, T>(option: Option<T>, error: E): Validation<E, T>
    return switch option {
      case None: Validation.failure(error);
      case Some(v): Validation.success(v);
    };

  public static function toLazySuccess<E, T>(option: Option<T>, error: Void -> E): Validation<E, T>
    return switch option {
      case None: Validation.failure(error());
      case Some(v): Validation.success(v);
    };

  public static function toSuccessNel<E, T>(option: Option<T>, error: E): Validation.VNel<E, T>
    return switch option {
      case None: Validation.failureNel(error);
      case Some(v): Validation.successNel(v);
    };

  public static function toLazySuccessNel<E, T>(option: Option<T>, error: Void -> E): Validation.VNel<E, T>
    return switch option {
      case None: Validation.failureNel(error());
      case Some(v): Validation.successNel(v);
    };

  public static function toFailure<E, T>(error: Option<E>, value: T): Validation<E, T>
    return switch error {
      case None: Validation.success(value);
      case Some(e): Validation.failure(e);
    };

  public static function toFailureNel<E, T>(error: Option<E>, value: T): Validation.VNel<E, T>
    return switch error {
      case None: Validation.successNel(value);
      case Some(e): Validation.failureNel(e);
    };

  public static function toRight<E, T>(opt: Option<T>, left: E): Either<E, T>
    return switch opt {
      case None: Left(left);
      case Some(r): Right(r);
    };

  public static function toLazyRight<E, T>(opt: Option<T>, left: Void -> E): Either<E, T>
    return switch opt {
      case None: Left(left());
      case Some(r): Right(r);
    };

  public static function toLeft<E, T>(opt: Option<E>, right: T): Either<E, T>
    return switch opt {
      case None: Right(right);
      case Some(l): Left(l);
    };

/**
	Performs `f` on the contents of `o` if `o` != None
**/
  public static function each<T>(o: Option<T>, f: T -> Void): Option<T> {
    return switch (o) {
      case None     : o;
      case Some(v)  : f(v); o;
    }
  }

/**
  Returns the first Some value, or None
  Alias for `orElse`, but intended for static use, and leads into alt3, alt4, alts, etc.
 */
  inline static public function alt2<A>(a : Option<A>, b : Option<A>) : Option<A> {
    return switch [a, b] {
      case [None, r] : r;
      case [l, _] : l;
    };
  }

/**
  Returns the first Some value, or None
 */
  inline static public function alt3<A>(a : Option<A>, b : Option<A>, c : Option<A>) : Option<A> {
    return alt2(alt2(a, b), c);
  }

/**
  Returns the first Some value, or None
 */
  inline static public function alt4<A>(a : Option<A>, b : Option<A>, c : Option<A>, d : Option<A>) : Option<A> {
    return alt2(alt3(a, b, c), d);
  }

/**
  Returns the first Some value, or None
 */
  static public function alts<A>(as : ReadonlyArray<Option<A>>) : Option<A> {
    return Arrays.reduce(as, alt2, None);
  }

/**
  Returns the result of the first function that produces a `Some` value, or `None`
 */
  static public function altsF<A>(fs : ReadonlyArray<Void -> Option<A>>) : Option<A> {
    return Arrays.reduce(fs, orElseF, None);
  }

  inline static public function ap2<A, B, C>(f: A -> B -> C, v1: Option<A>, v2: Option<B>): Option<C>
    return ap(v2, map(v1, Functions2.curry(f)));

  inline static public function ap3<A, B, C, D>(f: A -> B -> C -> D, v1: Option<A>, v2: Option<B>, v3: Option<C>): Option<D>
    return ap(v3, ap2(Functions3.curry(f), v1, v2));

  inline static public function ap4<A, B, C, D, E>(
      f: A -> B -> C -> D -> E,
      v1: Option<A>, v2: Option<B>, v3: Option<C>, v4: Option<D>): Option<E>
    return ap(v4, ap3(Functions4.curry(f), v1, v2, v3));

  inline static public function ap5<A, B, C, D, E, F>(
      f: A -> B -> C -> D -> E -> F,
      v1: Option<A>, v2: Option<B>, v3: Option<C>, v4: Option<D>, v5: Option<E>): Option<F>
    return ap(v5, ap4(Functions5.curry(f), v1, v2, v3, v4));

  inline static public function ap6<A, B, C, D, E, F, G>(
      f: A -> B -> C -> D -> E -> F -> G,
      v1: Option<A>, v2: Option<B>, v3: Option<C>, v4: Option<D>, v5: Option<E>, v6: Option<F>): Option<G>
    return ap(v6, ap5(Functions6.curry(f), v1, v2, v3, v4, v5));

  inline static public function ap7<A, B, C, D, E, F, G, H>(
      f: A -> B -> C -> D -> E -> F -> G -> H,
      v1: Option<A>, v2: Option<B>, v3: Option<C>, v4: Option<D>, v5: Option<E>, v6: Option<F>, v7: Option<G>): Option<H>
    return ap(v7, ap6(Functions7.curry(f), v1, v2, v3, v4, v5, v6));

  inline static public function ap8<A, B, C, D, E, F, G, H, I>(
      f: A -> B -> C -> D -> E -> F -> G -> H -> I,
      v1: Option<A>, v2: Option<B>, v3: Option<C>, v4: Option<D>, v5: Option<E>, v6: Option<F>, v7: Option<G>, v8: Option<H>): Option<I>
    return ap(v8, ap7(Functions8.curry(f), v1, v2, v3, v4, v5, v6, v7));

  inline static public function combine<A, B>(a : Option<A>, b : Option<B>) : Option<Tuple2<A, B>>
    return ap2(Tuple2.of, a, b);

  inline static public function combine2<A, B>(a : Option<A>, b : Option<B>) : Option<Tuple2<A, B>>
    return combine(a, b);

  inline static public function combine3<A, B, C>(a : Option<A>, b : Option<B>, c : Option<C>) : Option<Tuple3<A, B, C>>
    return ap3(Tuple3.of, a, b, c);

  inline static public function combine4<A, B, C, D>(a : Option<A>, b : Option<B>, c : Option<C>, d : Option<D>) : Option<Tuple4<A, B, C, D>>
    return ap4(Tuple4.of, a, b, c, d);

  inline static public function combine5<A, B, C, D, E>(a : Option<A>, b : Option<B>, c : Option<C>, d : Option<D>, e : Option<E>) : Option<Tuple5<A, B, C, D, E>>
    return ap5(Tuple5.of, a, b, c, d, e);

  inline static public function combine6<A, B, C, D, E, F>(a : Option<A>, b : Option<B>, c : Option<C>, d : Option<D>, e : Option<E>, f : Option<F>) : Option<Tuple6<A, B, C, D, E, F>>
    return ap6(Tuple6.of, a, b, c, d, e, f);

  inline static public function spread2<A, B, C>(v : Option<Tuple2<A, B>>, f : A -> B -> C) : Option<C>
    return map(v, function(t) {
      return f(t._0, t._1);
    });

  inline static public function spread<A, B, C>(v : Option<Tuple2<A, B>>, f : A -> B -> C) : Option<C>
    return spread2(v, f);

  inline static public function spread3<A, B, C, D>(v : Option<Tuple3<A, B, C>>, f : A -> B -> C -> D) : Option<D>
    return map(v, function(t) {
      return f(t._0, t._1, t._2);
    });

  inline static public function spread4<A, B, C, D, E>(v : Option<Tuple4<A, B, C, D>>, f : A -> B -> C -> D -> E) : Option<E>
    return map(v, function(t) {
      return f(t._0, t._1, t._2, t._3);
    });

  inline static public function spread5<A, B, C, D, E, F>(v : Option<Tuple5<A, B, C, D, E>>, f : A -> B -> C -> D -> E -> F) : Option<F>
    return map(v, function(t) {
      return f(t._0, t._1, t._2, t._3, t._4);
    });

  inline static public function spread6<A, B, C, D, E, F, G>(v : Option<Tuple6<A, B, C, D, E, F>>, f : A -> B -> C -> D -> E -> F -> G) : Option<G>
    return map(v, function(t) {
      return f(t._0, t._1, t._2, t._3, t._4, t._5);
    });
}
