package thx;

import haxe.ds.Option;
import thx.Functions.Functions in F;
import thx.Tuple;
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
    for(element in it)
      if(!predicate(element))
        return false;
    return true;
  }

/**
Checks if `predicate` returns true for at least one element in the iterator.
**/
  public static function any<T>(it : Iterator<T>, predicate : T -> Bool) {
    for(element in it)
      if(predicate(element))
        return true;
    return false;
  }

/**
It compares the lengths and elements of two given iterators and returns `true` if they match.

An optional equality function can be passed as the last argument. If not provided, strict equality is adopted.
**/
  public static function equals<T>(a : Iterator<T>, b : Iterator<T>, ?equality : T -> T -> Bool) {
    if(null == equality) equality = F.equality;
    var ae, be, an, bn;
    while(true) {
      an = a.hasNext();
      bn = b.hasNext();
      if(!an && !bn)
        return true;
      if(!an || !bn)
        return false;
      if(!equality(a.next(), b.next()))
        return false;
    }
    #if (haxe_ver < 3.3)
    return true;
    #end
  }

/**
Get the element at the `index` position.
**/
  public static function get<T>(it : Iterator<T>, index : Int) : Null<T> {
    var pos = 0;
    for(i in it) {
      if(pos++ == index)
        return i;
    }
    return null;
  }

/**
Refer to `thx.Arrays.getOption`
**/
  public static function getOption<T>(it : Iterator<T>, index : Int) : Option<T>
    return Options.ofValue(get(it, index));

/**
Refer to `thx.Arrays.eachPair`.
**/
  public static function eachPair<TIn, TOut>(it : Iterator<TIn>, handler : TIn -> TIn -> Bool)
    Arrays.eachPair(toArray(it), handler);

/**
Refer to `Array.filter`.
**/
  public static function filter<TElement>(it : Iterator<TElement>, predicate : TElement -> Bool) : Array<TElement>
    return reduce(it, function(acc : Array<TElement>, element) {
        if(predicate(element))
          acc.push(element);
        return acc;
      }, []);

/**
Refer to `thx.Arrays.find`.
**/
  public static function find<T, TFind>(it : Iterator<T>, f : T -> Bool) : Null<T> {
    for(element in it)
      if(f(element))
        return element;
    return null;
  }

/**
Refer to `thx.Arrays.findOption`.
**/
  public static function findOption<T, TFind>(it : Iterator<T>, f : T -> Bool) : Option<T>
    return Options.ofValue(find(it, f));

/**
Refer to `thx.Arrays.first`.
**/
  public static function first<T, TFind>(it : Iterator<T>) : Null<T>
    return it.hasNext() ? it.next() : null;

/**
Returns `true` if the iterator contains at least one element.
**/
  inline public static function hasElements<T>(it : Iterator<T>) : Bool
    return it.hasNext();

/**
Returns the position of element in the iterator. It returns -1 if not found.
**/
  public static function indexOf<T>(it : Iterator<T>, element : T) : Int {
    var pos = 0;
    for(v in it) {
      if(element == v)
        return pos;
      pos++;
    }
    return -1;
  }

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
Effectful traversal. Use this instead of .map if producing side-effects.
This method consumes the original iterator.
*/
  public static function forEach<A>(it: Iterator<A>, proc: A -> Void): Void {
    while (it.hasNext()) {
      proc(it.next());
    }
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
   * Produce a new Iterator that lazily applies the provided function to
   * each element of this iterator.
   */
  public static function fmap<T, S>(it : Iterator<T>, f : T -> S) : Iterator<S>
    return new MapIterator(it, f);

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
   * Produce a new Iterator that lazily applies the provided function to
   * each element of this iterator and an index value that increases with
   * each application.
   */
  public static function fmapi<T, S>(it : Iterator<T>, f : T -> Int -> S) : Iterator<S>
    return new MapIIterator(it, f);

/**
Refer to `thx.Arrays.order`.
**/
  public static function order<T>(it : Iterator<T>, sort : T -> T -> Int): Array<T> {
    var n = Iterators.toArray(it);
    n.sort(sort);
    return n;
  }

/**
Refer to `thx.Arrays.reduce`.
**/
  public static function reduce<TElement, TAcc>(it : Iterator<TElement>, callback : TAcc -> TElement -> TAcc, initial : TAcc) : TAcc {
    var result = initial;
    while (it.hasNext()) {
      result = callback(result, it.next());
    }
    return result;
  }

/**
Refer to `thx.Arrays.reducei`.
**/
  public static function reducei<TElement, TAcc>(it : Iterator<TElement>, callback : TAcc -> TElement -> Int -> TAcc, initial : TAcc) : TAcc {
    mapi(it, function(v, i) initial = callback(initial, v, i));
    return initial;
  }

  public static function foldLeft<A, B>(it: Iterator<A>, zero: B, f: B -> A -> B): B
    return reduce(it, f, zero);

  /**
   * Fold by mapping the contained values into some monoidal type and reducing with that monoid.
   */
  public static function foldMap<A, B>(it: Iterator<A>, f: A -> B, m: Monoid<B>): B
    return foldLeft(fmap(it, f), m.zero, m.append);

/**
  Take values until the first time `fn` produced false.
**/
  public static function takeUntil<A>(it:Iterator<A>, f : A -> Bool) : Array<A>{
    var out = [];
    for(v in it){
      if(f(v)){
        out.push(v);
      }else{
        break;
      }
    }
    return out;
  }
/**
  Drop values until the first time `fn` produces false.
**/
  public static function dropUntil<A>(it:Iterator<A>, f : A -> Bool) : Array<A>{
    var done  = false;
    var out   = [];
    for(v in it){
      if(!done){
        if(!f(v)){
          done = true;
          out.push(v);
        }
      }else{
        out.push(v);
      }
    }
    return out;
  }

/**
`toArray` transforms an `Iterator<T>` into an `Array<T>`.
**/
  public static function toArray<T>(it : Iterator<T>) : Array<T> {
    var elements = [];
    for(element in it)
      elements.push(element);
    return elements;
  }

/**
Unzip an iterator of Tuple2<T1, T2> to a Tuple2<Array<T1>, Array<T2>>.
**/
  public static function unzip<T1, T2>(it : Iterator<Tuple2<T1, T2>>) {
    var a1 = [], a2 = [];
    forEach(it, function(t) {
      a1.push(t._0);
      a2.push(t._1);
    });
    return new Tuple2(a1, a2);
  }

/**
Unzip an iterator of Tuple3<T1, T2, T3> to a Tuple3<Array<T1>, Array<T2>, Array<T3>>.
**/
  public static function unzip3<T1, T2, T3>(it : Iterator<Tuple3<T1, T2, T3>>) {
    var a1 = [], a2 = [], a3 = [];
    forEach(it, function(t) {
      a1.push(t._0);
      a2.push(t._1);
      a3.push(t._2);
    });
    return new Tuple3(a1, a2, a3);
  }

/**
Unzip an iterator of Tuple4<T1, T2, T3, T4> to a Tuple4<Array<T1>, Array<T2>, Array<T3>, Array<T4>>.
**/
  public static function unzip4<T1, T2, T3, T4>(it : Iterator<Tuple4<T1, T2, T3, T4>>) {
    var a1 = [], a2 = [], a3 = [], a4 = [];
    forEach(it, function(t) {
      a1.push(t._0);
      a2.push(t._1);
      a3.push(t._2);
      a4.push(t._3);
    });
    return new Tuple4(a1, a2, a3, a4);
  }

/**
Unzip an iterator of Tuple5<T1, T2, T3, T4, T5> to a Tuple5<Array<T1>, Array<T2>, Array<T3>, Array<T4>, Array<T5>>.
**/
  public static function unzip5<T1, T2, T3, T4, T5>(it : Iterator<Tuple5<T1, T2, T3, T4, T5>>) {
    var a1 = [], a2 = [], a3 = [], a4 = [], a5 = [];
    forEach(it, function(t) {
      a1.push(t._0);
      a2.push(t._1);
      a3.push(t._2);
      a4.push(t._3);
      a5.push(t._4);
    });
    return new Tuple5(a1, a2, a3, a4, a5);
  }

/**
Pairs the elements of two iterators in an array of `Tuple2`.
**/
  public static function zip<T1, T2>(it1 : Iterator<T1>, it2 : Iterator<T2>) : Array<Tuple2<T1, T2>> {
    var array  = [];
    while(it1.hasNext() && it2.hasNext())
      array.push(new Tuple2(it1.next(), it2.next()));
    return array;
  }

/**
Pairs the elements of three iterators in an array of `Tuple3`.
**/
  public static function zip3<T1, T2, T3>(it1 : Iterator<T1>, it2 : Iterator<T2>, it3 : Iterator<T3>) : Array<Tuple3<T1, T2, T3>> {
    var array  = [];
    while(it1.hasNext() && it2.hasNext() && it3.hasNext())
      array.push(new Tuple3(it1.next(), it2.next(), it3.next()));
    return array;
  }

/**
Pairs the elements of four iterators in an array of `Tuple4`.
**/
  public static function zip4<T1, T2, T3, T4>(it1 : Iterator<T1>, it2 : Iterator<T2>, it3 : Iterator<T3>, it4 : Iterator<T4>) : Array<Tuple4<T1, T2, T3, T4>> {
    var array  = [];
    while(it1.hasNext() && it2.hasNext() && it3.hasNext() && it4.hasNext())
      array.push(new Tuple4(it1.next(), it2.next(), it3.next(), it4.next()));
    return array;
  }

/**
Pairs the elements of five iterators in an array of `Tuple5`.
**/
  public static function zip5<T1, T2, T3, T4, T5>(it1 : Iterator<T1>, it2 : Iterator<T2>, it3 : Iterator<T3>, it4 : Iterator<T4>, it5 : Iterator<T5>) : Array<Tuple5<T1, T2, T3, T4, T5>> {
    var array  = [];
    while(it1.hasNext() && it2.hasNext() && it3.hasNext() && it4.hasNext() && it5.hasNext())
      array.push(new Tuple5(it1.next(), it2.next(), it3.next(), it4.next(), it5.next()));
    return array;
  }
}

class MapIterator<A, B> {
  private var base: Iterator<A>;
  private var f: A -> B;

  public function new(base: Iterator<A>, f: A -> B) {
    this.base = base;
    this.f = f;
  }

  public function next(): B
    return f(base.next());

  public function hasNext(): Bool
    return base.hasNext();
}

class MapIIterator<A, B> {
  private var base: Iterator<A>;
  private var f: A -> Int -> B;
  private var i: Int = 0;

  public function new(base: Iterator<A>, f: A -> Int -> B) {
    this.base = base;
    this.f = f;
  }

  public function next(): B {
    var result = f(base.next(), i);
    i++;
    return result;
  }

  public function hasNext(): Bool
    return base.hasNext();
}
