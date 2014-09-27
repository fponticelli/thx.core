package thx.core;

#if macro
import haxe.macro.Expr;
#end

/**
Helper class to work with `Iterator`.

For documentation of specific methods refer to the equivalent methods in `thx.core.Arrays`;
**/
class Iterators {
  public static function eachPair<TIn, TOut>(it : Iterator<TIn>, handler : TIn -> TIn -> Bool)
    Arrays.eachPair(toArray(it), handler);

  public static function filter<TItem>(it : Iterator<TItem>, predicate : TItem -> Bool) : Array<TItem>
    return reduce(it, function(acc : Array<TItem>, item) {
        if(predicate(item))
          acc.push(item);
        return acc;
      }, []);

  macro public static function filterPluck<T>(it : ExprOf<Iterator<T>>, expr : ExprOf<Bool>) : ExprOf<Array<T>>
    return macro thx.core.Iterators.filter($e{it}, function(_) return $e{expr});

  public static function find<T, TFind>(it : Iterator<T>, f : T -> Bool) : Null<T> {
    for(item in it)
      if(f(item))
        return item;
    return null;
  }

  public static function first<T, TFind>(it : Iterator<T>) : Null<T>
    return it.hasNext() ? it.next() : null;

  inline public static function isEmpty<T>(it : Iterator<T>) : Bool
    return !it.hasNext();

/**
`isIterator` checks that the passed argument has all the requirements to be an `Iterator`.

Note that no type checking is performed at runtime, the method only checks that the value
has two fields `next` and `hasNext` and that they are both functions.
**/
  public static function isIterator(v : Dynamic) {
    var fields = Types.isAnonymousObject(v) ? Reflect.fields(v) : Type.getInstanceFields(Type.getClass(v));
    if(!Lambda.has(fields, "next") || !Lambda.has(fields, "hasNext")) return false;
    return Reflect.isFunction(Reflect.field(v, "next")) && Reflect.isFunction(Reflect.field(v, "hasNext"));
  }

  public static function last<T, TFind>(it : Iterator<T>) : Null<T> {
    var buf = null;
    while(it.hasNext()) buf = it.next();
    return buf;
  }

  public static function map<T, S>(it : Iterator<T>, f : T -> S) : Array<S> {
    var acc = [];
    for(v in it)
      acc.push(f(v));
    return acc;
  }

  public static function mapi<T, S>(it : Iterator<T>, f : T -> Int -> S) : Array<S> {
    var acc = [],
        i = 0;
    for(v in it)
      acc.push(f(v, i++));
    return acc;
  }

  public static function order<T>(it : Iterator<T>, sort : T -> T -> Int) {
    var n = Iterators.toArray(it);
    n.sort(sort);
    return n;
  }

  macro public static function pluck<T, TOut>(it : ExprOf<Iterator<T>>, expr : ExprOf<TOut>) : ExprOf<Array<TOut>>
    return macro thx.core.Iterators.map($e{it}, function(_) return ${expr});

  macro public static function plucki<T, TOut>(it : ExprOf<Iterator<T>>, expr : ExprOf<TOut>) : ExprOf<Array<TOut>>
    return macro thx.core.Iterators.mapi($e{it}, function(_, i) return ${expr});

  public static function reduce<TItem, TAcc>(it : Iterator<TItem>, callback : TAcc -> TItem -> TAcc, initial : TAcc) : TAcc {
    map(it, function(v) initial = callback(initial, v));
    return initial;
  }

  public static function reducei<TItem, TAcc>(it : Iterator<TItem>, callback : TAcc -> TItem -> Int -> TAcc, initial : TAcc) : TAcc {
    mapi(it, function(v, i) initial = callback(initial, v, i));
    return initial;
  }

/**
`toArray` transforms an `Iterator<T>` into an `Array<T>`.
**/
  public static function toArray<T>(it : Iterator<T>) : Array<T> {
    var items = [];
    for(item in it)
      items.push(item);
    return items;
  }

}