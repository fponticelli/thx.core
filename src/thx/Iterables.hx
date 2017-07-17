package thx;

import haxe.ds.Option;

import thx.Ord;
import thx.Tuple;
import thx.Functions;
using thx.Options;

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
  inline public static function eachPair<TIn, TOut>(it : Iterable<TIn>, handler : TIn -> TIn -> Bool)
    return Iterators.eachPair(it.iterator(), handler);

/**
It compares the lengths and elements of two given iterables and returns `true` if they match.

An optional equality function can be passed as the last argument. If not provided, strict equality is adopted.
**/
  inline public static function equals<T>(a : Iterable<T>, b : Iterable<T>, ?equality : T -> T -> Bool)
    return Iterators.equals(a.iterator(), b.iterator(), equality);

/**
Refer to `Array.filter`.
**/
  inline public static function filter<T>(it : Iterable<T>, predicate : T -> Bool) : Array<T>
    return Iterators.filter(it.iterator(), predicate);

/**
Refer to `thx.Arrays.find`.
**/
  inline public static function find<T, TFind>(it : Iterable<T>, predicate : T -> Bool) : Null<T>
    return Iterators.find(it.iterator(), predicate);

/**
Refer to `thx.Arrays.findOption`.
**/
  inline public static function findOption<T, TFind>(it : Iterable<T>, predicate : T -> Bool) : Option<T>
    return Options.ofValue(find(it, predicate));

/**
Refer to `thx.Arrays.first`.
**/
  inline public static function first<T, TFind>(it : Iterable<T>) : Null<T>
    return Iterators.first(it.iterator());

/**
Get the element at the `index` position.
**/
  inline public static function get<T>(it : Iterable<T>, index : Int) : Null<T>
    return Iterators.get(it.iterator(), index);

/**
Refer to `thx.Arrays.getOption`.
**/
  inline public static function getOption<T>(it : Iterable<T>, index : Int) : Option<T>
    return Options.ofValue(get(it, index));

/**
Refer to `thx.Arrays.last`.
**/
  inline public static function last<T, TFind>(it : Iterable<T>) : Null<T>
    return Iterators.last(it.iterator());

/**
Returns `true` if the iterable contains at least one element.
**/
  inline public static function hasElements<T>(it : Iterable<T>) : Bool
    return Iterators.hasElements(it.iterator());

/**
Returns the position of element in the iterable. It returns -1 if not found.
**/
  inline public static function indexOf<T>(it : Iterable<T>, element : T) : Int
    return Iterators.indexOf(it.iterator(), element);

/**
Refer to `thx.Arrays.isEmpty`.
**/
  inline public static function isEmpty<T>(it : Iterable<T>) : Bool
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
  inline public static function map<T, S>(it : Iterable<T>, f : T -> S) : Array<S>
    return Iterators.map(it.iterator(), f);

  /**
   * A proper Functor-like map function that preverses iterable structure.
   */
  inline public static function fmap<T, S>(it : Iterable<T>, f : T -> S) : Iterable<S>
    return { iterator: function() return Iterators.fmap(it.iterator(), f) };

/**
Refer to `thx.Arrays.mapi`.
**/
  inline public static function mapi<T, S>(it : Iterable<T>, f : T -> Int -> S) : Array<S>
    return Iterators.mapi(it.iterator(), f);

  /**
   * A proper Functor-like mapi function that preverses iterable structure, with index information.
   */
  inline public static function fmapi<T, S>(it : Iterable<T>, f : T -> Int -> S) : Iterable<S>
    return { iterator: function() return Iterators.fmapi(it.iterator(), f) };

/**
Refer to `thx.Arrays.order`.
**/
  inline public static function order<T>(it : Iterable<T>, sort : T -> T -> Int) : Array<T>
    return Iterators.order(it.iterator(), sort);

/**
Refer to `thx.Arrays.reduce`.
**/
  inline public static function reduce<TElement, TAcc>(it : Iterable<TElement>, callback : TAcc -> TElement -> TAcc, initial : TAcc) : TAcc
    return Iterators.reduce(it.iterator(), callback, initial);

/**
Refer to `thx.Arrays.reducei`.
**/
  inline public static function reducei<TElement, TAcc>(it : Iterable<TElement>, callback : TAcc -> TElement -> Int -> TAcc, initial : TAcc) : TAcc
    return Iterators.reducei(it.iterator(), callback, initial);

/**
`toArray` transforms an `Iterable<T>` into an `Array<T>`.
**/
  inline public static function toArray<T>(it : Iterable<T>) : Array<T>
    return Iterators.toArray(it.iterator());

/**
`minBy` finds the minimum value included in the iterable, as compared by some
function of the values contained within the iterable.
**/
  public static function minBy<A, B>(it: Iterable<A>, f: A -> B, ord: Ord<B>): Option<A> {
    var found: Option<A> = None;
    for (a in it) {
      found = found.any(function(a0) { return ord(f(a0), f(a)) == LT; }) ? found : Some(a);
    }
    return found;
  }

/**
`maxBy` finds the maximum value included in the iterable, as compared by some
function of the values contained within the iterable.
**/
  inline public static function maxBy<A, B>(it: Iterable<A>, f: A -> B, ord: Ord<B>): Option<A>
    return minBy(it, f, ord.inverse());

/**
`min` finds the minimum value included in the iterable, accorrding
to the specified ordering.
**/
  inline public static function min<A>(it: Iterable<A>, ord: Ord<A>): Option<A>
    return minBy(it, Functions.identity, ord);

/**
`max` finds the maximum value included in the iterable, accorrding
to the specified ordering.
**/
  inline public static function max<A>(it: Iterable<A>, ord: Ord<A>): Option<A>
    return min(it, ord.inverse());

/**
`extremaBy` finds both the minimum and maximum value included in the iterable,
as compared by some function of the values contained within the iterable and
the specified ordering.
**/
  public static function extremaBy<A, B>(it: Iterable<A>, f: A -> B, ord: Ord<B>): Option<Tuple<A, A>> {
    var found: Option<Tuple2<A, A>> = None;
    for (a in it) {
      found = switch found {
        case None: Some(new Tuple(a, a));
        case Some(t) if (ord(f(a), f(t._0)) == LT): Some(new Tuple(a, t._1));
        case Some(t) if (ord(f(a), f(t._1)) == GT): Some(new Tuple(t._0, a));
        case _: found;
      }
    }
    return found;
  }

/**
`extrema` finds both the minimum and maximum value included in the iterable,
as compared by the specified ordering.
**/
  inline public static function extrema<A>(it: Iterable<A>, ord: Ord<A>): Option<Tuple<A, A>>
    return extremaBy(it, Functions.identity, ord);

/**
  Take values until the first time `fn` produced false.
**/
  public static function takeUntil<A>(it: Iterable<A>,fn: A -> Bool): Array<A>{
    return Iterators.takeUntil(it.iterator(),fn);
  }
/**
	Produces an Array from `a[n]` to the last element of `a`.
**/
  static public function dropLeft<A>(itr: Iterable<A>, n: Int): Iterable<A> {
    return {
      iterator : function(){
        var itr   = itr.iterator();
        var count = n;
        while(count > 0){
          if(itr.hasNext()){
            itr.next();
          }
        }
        return {
          next : itr.next,
          hasNext : itr.hasNext
        };
      }
    };
  }
/**
  Drop values until the first time `fn` produced false.
**/
  public static function dropUntil<A>(it:Iterable<A>, fn : A -> Bool) : Array<A>{
    return Iterators.dropUntil(it.iterator(),fn);
  }

/**
  Returns an Array that contains all elements from `a` which are also elements of `b`.
  If `a` contains duplicates, so will the result.
**/
  public static function unionBy<T>(a: Iterable<T>, b: Iterable<T>, eq: T -> T -> Bool): Array<T>{
    var res: Array<T>  = [];
    for(e in a.iterator()){
      res.push(e);
    }
    for (e in b.iterator()) {
      if (!any(res, function (x: T) return (eq(x, e): Bool)))
        res.push(e);
    }
    return res;
  }

/**
 Returns an Array that contains all elements from a which are not elements of b.
  If a contains duplicates, the resulting Array contains duplicates.
**/
  public static function differenceBy<T>(a:Iterable<T>, b:Iterable<T>, eq: T -> T -> Bool): Array<T> {
    var res: Array<T> = [];
    for (e in a.iterator()) {
      if (!any(b, function (x: T) return (eq(x, e): Bool)))
        res.push(e);
    }
    return res;
  }
/**
Unzip an iterable of Tuple2<T1, T2> to a Tuple2<Array<T1>, Array<T2>>.
**/
  public static function unzip<T1, T2>(it : Iterable<Tuple2<T1, T2>>)
    return Iterators.unzip(it.iterator());

/**
Unzip an iterable of Tuple3<T1, T2, T3> to a Tuple3<Array<T1>, Array<T2>, Array<T3>>.
**/
  public static function unzip3<T1, T2, T3>(it : Iterable<Tuple3<T1, T2, T3>>)
  return Iterators.unzip3(it.iterator());

/**
Unzip an iterable of Tuple4<T1, T2, T3, T4> to a Tuple4<Array<T1>, Array<T2>, Array<T3>, Array<T4>>.
**/
  public static function unzip4<T1, T2, T3, T4>(it : Iterable<Tuple4<T1, T2, T3, T4>>)
    return Iterators.unzip4(it.iterator());

/**
Unzip an iterable of Tuple5<T1, T2, T3, T4, T5> to a Tuple5<Array<T1>, Array<T2>, Array<T3>, Array<T4>, Array<T5>>.
**/
  public static function unzip5<T1, T2, T3, T4, T5>(it : Iterable<Tuple5<T1, T2, T3, T4, T5>>)
    return Iterators.unzip5(it.iterator());

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
