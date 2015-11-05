package thx;

import thx.Functions.*;
import haxe.ds.Option;

/**
Extension methods for the `haxe.ds.Option` type.
**/
class Options {
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
`flatMap` reduces an `Option<T>` value into an `Array<T>` value applying the `callback`
function if `Option` contains a value. If `Option` is `None` an empty array is returned.
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
    return flatMap(option, identity);

/**
`foldLeft` reduce using an accumulating function and an initial value.
**/
  public static function foldLeft<T, B>(option: Option<T>, b: B, f: B -> T -> B): B
    return switch option {
      case None: b;
      case Some(v): f(b, v);
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
  #if java @:generic #end
  public static function toBool<T>(option : Option<T>) : Bool
    return switch option {
      case None: false;
      case Some(_) : true;
    };

/**
`toOption` transforms any type T into `Option<T>`. If the value is null, the result
is be `None`.
**/
  inline public static function toOption<T>(value : Null<T>) : Option<T>
    return null == value ? None : Some(value);

/**
`toValue` extracts the value from `Option`. If the `Option` is `None`, `null` is returned.
**/
  public static function toValue<T>(option : Option<T>) : Null<T>
    return switch option {
      case None: null;
      case Some(v) : v;
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
}
