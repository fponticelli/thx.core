package thx;

import thx.Tuple;
#if macro
import haxe.macro.Expr;
#end

/**
Helper class for `Iterable`. Implementations usually fallback on `thx.Iterators`.

For documentation of specific methods refer to the equivalent methods in `thx.Arrays`;
**/
class Iterables {
/**
Checks if `predicate` returns true for all elements in the iterable.
**/
  public static function all<T>(it : Iterable<T>, predicate : T -> Bool)
    return Iterators.all(it.iterator(), predicate);

/**
Checks if `predicate` returns true for at least one element in the iterable.
**/
  public static function any<T>(it : Iterable<T>, predicate : T -> Bool)
    return Iterators.any(it.iterator(), predicate);

/**
Refer to `thx.Arrays.eachPair`.
**/
  public inline static function eachPair<TIn, TOut>(it : Iterable<TIn>, handler : TIn -> TIn -> Bool)
    return Iterators.eachPair(it.iterator(), handler);

/**
Refer to `Array.filter`.
**/
  public inline static function filter<T>(it : Iterable<T>, predicate : T -> Bool) : Array<T>
    return Iterators.filter(it.iterator(), predicate);

/**
Refer to `thx.Arrays.filterPluck`.
**/
  macro public static function filterPluck<T>(it : ExprOf<Iterable<T>>, expr : ExprOf<Bool>) : ExprOf<Array<T>>
    return macro thx.Iterators.filter($e{it}.iterator(), function(_) return $e{expr});

/**
Refer to `thx.Arrays.find`.
**/
  public inline static function find<T, TFind>(it : Iterable<T>, predicate : T -> Bool) : Null<T>
    return Iterators.find(it.iterator(), predicate);

/**
Refer to `thx.Arrays.first`.
**/
  public inline static function first<T, TFind>(it : Iterable<T>) : Null<T>
    return Iterators.first(it.iterator());

/**
Refer to `thx.Arrays.last`.
**/
  public inline static function last<T, TFind>(it : Iterable<T>) : Null<T>
    return Iterators.last(it.iterator());

/**
Refer to `thx.Arrays.isEmpty`.
**/
  public inline static function isEmpty<T>(it : Iterable<T>) : Bool
    return Iterators.isEmpty(it.iterator());

/**
`isIterable` checks that the passed argument has all the requirements to be an `Iterable`.

Note that no type checking is performed at runtime, only if a method `iterator` exists regardless
of its signature.
**/
  public static function isIterable(v : Dynamic) {
    var fields = Types.isAnonymousObject(v) ? Reflect.fields(v) : Type.getInstanceFields(Type.getClass(v));
    if(!Lambda.has(fields, "iterator")) return false;
    return Reflect.isFunction(Reflect.field(v, "iterator"));
  }

/**
Refer to `Array.map`.
**/
  public inline static function map<T, S>(it : Iterable<T>, f : T -> S) : Array<S>
    return Iterators.map(it.iterator(), f);

/**
Refer to `thx.Arrays.mapi`.
**/
  public inline static function mapi<T, S>(it : Iterable<T>, f : T -> Int -> S) : Array<S>
    return Iterators.mapi(it.iterator(), f);

/**
Refer to `thx.Arrays.order`.
**/
  public inline static function order<T>(it : Iterable<T>, sort : T -> T -> Int) : Array<T>
    return Iterators.order(it.iterator(), sort);

/**
Refer to `thx.Arrays.pluck`.
**/
  macro public static function pluck<T, TOut>(it : ExprOf<Iterable<T>>, expr : ExprOf<TOut>) : ExprOf<Array<TOut>>
    return macro thx.Iterators.map($e{it}.iterator(), function(_) return ${expr});

/**
Refer to `thx.Arrays.plucki`.
**/
  macro public static function plucki<T, TOut>(it : ExprOf<Iterable<T>>, expr : ExprOf<TOut>) : ExprOf<Array<TOut>>
    return macro thx.Iterators.mapi($e{it}.iterator(), function(_, i) return ${expr});

/**
Refer to `thx.Arrays.reduce`.
**/
  public inline static function reduce<TItem, TAcc>(it : Iterable<TItem>, callback : TAcc -> TItem -> TAcc, initial : TAcc) : TAcc
    return Iterators.reduce(it.iterator(), callback, initial);

/**
Refer to `thx.Arrays.reducei`.
**/
  public inline static function reducei<TItem, TAcc>(it : Iterable<TItem>, callback : TAcc -> TItem -> Int -> TAcc, initial : TAcc) : TAcc
    return Iterators.reducei(it.iterator(), callback, initial);

/**
`toArray` transforms an `Iterable<T>` into an `Array<T>`.
**/
  public inline static function toArray<T>(it : Iterable<T>) : Array<T>
    return Iterators.toArray(it.iterator());

/**
Pairs the elements of two iterables in an array of `Tuple2`.
**/
  public static function zip<T1, T2>(it1 : Iterable<T1>, it2 : Iterable<T2>) : Array<Tuple2<T1, T2>>
    return Iterators.zip(it1.iterator(), it2.iterator());

/**
Pairs the elements of three iterables in an array of `Tuple3`.
**/
  public static function zip3<T1, T2, T3>(it1 : Iterable<T1>, it2 : Iterable<T2>, it3 : Iterable<T3>) : Array<Tuple3<T1, T2, T3>>
    return Iterators.zip3(it1.iterator(), it2.iterator(), it3.iterator());

/**
Pairs the elements of four iterables in an array of `Tuple4`.
**/
  public static function zip4<T1, T2, T3, T4>(it1 : Iterable<T1>, it2 : Iterable<T2>, it3 : Iterable<T3>, it4 : Iterable<T4>) : Array<Tuple4<T1, T2, T3, T4>>
    return Iterators.zip4(it1.iterator(), it2.iterator(), it3.iterator(), it4.iterator());

/**
Pairs the elements of five iterables in an array of `Tuple5`.
**/
  public static function zip5<T1, T2, T3, T4, T5>(it1 : Iterable<T1>, it2 : Iterable<T2>, it3 : Iterable<T3>, it4 : Iterable<T4>, it5 : Iterable<T5>) : Array<Tuple5<T1, T2, T3, T4, T5>>
    return Iterators.zip5(it1.iterator(), it2.iterator(), it3.iterator(), it4.iterator(), it5.iterator());
}
