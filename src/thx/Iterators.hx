package thx;

#if macro
import haxe.macro.Expr;
#end

/**
Helper class to work with `Iterator`.

For documentation of specific methods refer to the equivalent methods in `thx.Arrays`;
**/
class Iterators {
/**
Checks if `predicate` returns true for all elements in the iterator.
**/
  public static function all<T>(it : Iterator<T>, predicate : T -> Bool) {
    for(item in it)
      if(!predicate(item))
        return false;
    return true;
  }

/**
Checks if `predicate` returns true for at least one element in the iterator.
**/
  public static function any<T>(it : Iterator<T>, predicate : T -> Bool) {
    for(item in it)
      if(predicate(item))
        return true;
    return false;
  }

/**
Refer to `thx.Arrays.eachPair`.
**/
  public static function eachPair<TIn, TOut>(it : Iterator<TIn>, handler : TIn -> TIn -> Bool)
    Arrays.eachPair(toArray(it), handler);

/**
Refer to `Array.filter`.
**/
  public static function filter<TItem>(it : Iterator<TItem>, predicate : TItem -> Bool) : Array<TItem>
    return reduce(it, function(acc : Array<TItem>, item) {
        if(predicate(item))
          acc.push(item);
        return acc;
      }, []);

/**
Refer to `thx.Arrays.filterPluck`.
**/
  macro public static function filterPluck<T>(it : ExprOf<Iterator<T>>, expr : ExprOf<Bool>) : ExprOf<Array<T>>
    return macro thx.Iterators.filter($e{it}, function(_) return $e{expr});

/**
Refer to `thx.Arrays.find`.
**/
  public static function find<T, TFind>(it : Iterator<T>, f : T -> Bool) : Null<T> {
    for(item in it)
      if(f(item))
        return item;
    return null;
  }

/**
Refer to `thx.Arrays.first`.
**/
  public static function first<T, TFind>(it : Iterator<T>) : Null<T>
    return it.hasNext() ? it.next() : null;

/**
Refer to `thx.Arrays.isEmpty`.
**/
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

/**
Refer to `thx.Arrays.last`.
**/
  public static function last<T, TFind>(it : Iterator<T>) : Null<T> {
    var buf = null;
    while(it.hasNext()) buf = it.next();
    return buf;
  }

/**
Refer to `Array.map`.
**/
  public static function map<T, S>(it : Iterator<T>, f : T -> S) : Array<S> {
    var acc = [];
    for(v in it)
      acc.push(f(v));
    return acc;
  }

/**
Refer to `thx.Arrays.mapi`.
**/
  public static function mapi<T, S>(it : Iterator<T>, f : T -> Int -> S) : Array<S> {
    var acc = [],
        i = 0;
    for(v in it)
      acc.push(f(v, i++));
    return acc;
  }

/**
Refer to `thx.Arrays.order`.
**/
  public static function order<T>(it : Iterator<T>, sort : T -> T -> Int) {
    var n = Iterators.toArray(it);
    n.sort(sort);
    return n;
  }

/**
Refer to `thx.Arrays.pluck`.
**/
  macro public static function pluck<T, TOut>(it : ExprOf<Iterator<T>>, expr : ExprOf<TOut>) : ExprOf<Array<TOut>>
    return macro thx.Iterators.map($e{it}, function(_) return ${expr});

/**
Refer to `thx.Arrays.plucki`.
**/
  macro public static function plucki<T, TOut>(it : ExprOf<Iterator<T>>, expr : ExprOf<TOut>) : ExprOf<Array<TOut>>
    return macro thx.Iterators.mapi($e{it}, function(_, i) return ${expr});

/**
Refer to `thx.Arrays.reduce`.
**/
  public static function reduce<TItem, TAcc>(it : Iterator<TItem>, callback : TAcc -> TItem -> TAcc, initial : TAcc) : TAcc {
    map(it, function(v) initial = callback(initial, v));
    return initial;
  }

/**
Refer to `thx.Arrays.reducei`.
**/
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