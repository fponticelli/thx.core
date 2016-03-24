package thx;

import thx.Functions;
import thx.Functions.*;
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
`foldLeft` reduce using an accumulating function and an initial value.
**/
  public static function foldLeft<T, B>(option: Option<T>, b: B, f: B -> T -> B): B
    return switch option {
      case None: b;
      case Some(v): f(b, v);
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
  #if ((haxe <= 3.2) && java) @:generic #end
  public static function toBool<T>(option : Option<T>) : Bool
    return switch option {
      case None: false;
      case Some(_) : true;
    };

/**
`isNone` determines whether the option is a None
**/
  #if ((haxe <= 3.2) && java) @:generic #end
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
`orElse` returns `option` if it holds a value or `alt` otherwise.
**/
  public static function orElse<T>(option : Option<T>, alt : Option<T>) : Option<T>
    return switch option {
      case None: alt;
      case Some(_) : option;
    };

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

  public static function toSuccessNel<E, T>(option: Option<T>, error: E): Validation.VNel<E, T>
    return switch option {
      case None: Validation.failureNel(error);
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
}
