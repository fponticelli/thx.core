package thx.core;

#if macro
import haxe.macro.Expr;
#end

/**
Helper class for `Iterable`. Implementations usually fallback on `thx.core.Iterators`.

For documentation of specific methods refer to the equivalent methods in `thx.core.Arrays`;
**/
class Iterables {
  public inline static function eachPair<TIn, TOut>(it : Iterable<TIn>, handler : TIn -> TIn -> Bool)
    return Iterators.eachPair(it.iterator(), handler);

  public inline static function filter<T>(it : Iterable<T>, predicate : T -> Bool) : Array<T>
    return Iterators.filter(it.iterator(), predicate);

  macro public static function filterPluck<T>(it : ExprOf<Iterable<T>>, expr : ExprOf<Bool>) : ExprOf<Array<T>>
    return macro thx.core.Iterators.filter($e{it}.iterator(), function(_) return $e{expr});

  public inline static function find<T, TFind>(it : Iterable<T>, predicate : T -> Bool) : Null<T>
    return Iterators.find(it.iterator(), predicate);

  public inline static function first<T, TFind>(it : Iterable<T>) : Null<T>
    return Iterators.first(it.iterator());

  public inline static function last<T, TFind>(it : Iterable<T>) : Null<T>
    return Iterators.last(it.iterator());

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

  public inline static function map<T, S>(it : Iterable<T>, f : T -> S) : Array<S>
    return Iterators.map(it.iterator(), f);

  public inline static function mapi<T, S>(it : Iterable<T>, f : T -> Int -> S) : Array<S>
    return Iterators.mapi(it.iterator(), f);

  public inline static function order<T>(it : Iterable<T>, sort : T -> T -> Int) : Array<T>
    return Iterators.order(it.iterator(), sort);

  macro public static function pluck<T, TOut>(it : ExprOf<Iterable<T>>, expr : ExprOf<TOut>) : ExprOf<Array<TOut>>
    return macro thx.core.Iterators.map($e{it}.iterator(), function(_) return ${expr});

  macro public static function plucki<T, TOut>(it : ExprOf<Iterable<T>>, expr : ExprOf<TOut>) : ExprOf<Array<TOut>>
    return macro thx.core.Iterators.mapi($e{it}.iterator(), function(_, i) return ${expr});

  public inline static function reduce<TItem, TAcc>(it : Iterable<TItem>, callback : TAcc -> TItem -> TAcc, initial : TAcc) : TAcc
    return Iterators.reduce(it.iterator(), callback, initial);

  public inline static function reducei<TItem, TAcc>(it : Iterable<TItem>, callback : TAcc -> TItem -> Int -> TAcc, initial : TAcc) : TAcc
    return Iterators.reducei(it.iterator(), callback, initial);

/**
`toArray` transforms an `Iterable<T>` into an `Array<T>`.
**/
  public inline static function toArray<T>(it : Iterable<T>) : Array<T>
    return Iterators.toArray(it.iterator());
}