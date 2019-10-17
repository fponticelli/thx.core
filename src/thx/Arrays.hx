package thx;

import haxe.ds.Option;
import haxe.ds.StringMap;

import thx.Functions.Functions in F;
import thx.Functions;
import thx.Validation;
import thx.Semigroup;
import thx.Monoid;
using thx.Arrays;
using thx.Eithers;
using thx.Options;

#if macro
import haxe.macro.Expr;
#end
import thx.Tuple;

/**
`Arrays` provides additional extension methods on top of the `Array` type.

Note that some of the examples imply `using thx.Arrays;`.
**/
class Arrays {
/**
Arrays.add pushes an element at the end of the `array` and returns it. Practical
for chaining push operations.
**/
  public static function append<T>(array : Array<T>, element : T) : Array<T> {
    array.push(element);
    return array;
  }

/**
Arrays.addIf conditionaly pushes an element at the end of the `array` and returns it.
Practical for chaining push operations.
**/
  public static function appendIf<T>(array : Array<T>, cond : Bool, element : T) : Array<T> {
    if(cond)
      array.push(element);
    return array;
  }

/**
Arrays.applyIndexes takes an `array` and returns a copy of it with its elements rearranged according to `indexes`.

If the `indexes` array does not contain continuous values, you may want to set `incrementDuplicates` to `true`.

var result = Arrays.applyIndexes(["B", "C", "A"], [1, 2, 0]);
trace(result); // output ["A", "B", "C"]
**/
  public static function applyIndexes<T>(array : ReadonlyArray<T>, indexes : Array<Int>, ?incrementDuplicates = false) : Array<T> {
    if(indexes.length != array.length)
      throw new thx.Error('`Arrays.applyIndexes` can only be applied to two arrays with the same length');
    var result = [];
    if(incrementDuplicates) {
      var usedIndexes = thx.Set.createInt();
      for(i in 0...array.length) {
        var index = indexes[i];
        while(usedIndexes.exists(index))
          index++;
        usedIndexes.add(index);
        result[index] = array[i];
      }
    } else {
      for(i in 0...array.length) {
        result[indexes[i]] = array[i];
      }
    }
    return result;
  }

  /**
   * The concatenation monoid for arrays.
   */
  public static function monoid<A>(): Monoid<Array<A>>
    return {
      zero: [],
      append: function(a: Array<A>, b: Array<A>) return a.concat(b)
    };

/**
Finds the first occurrance of `element` and returns all the elements after it.
**/
  inline public static function after<T>(array : ReadonlyArray<T>, element : T)
    return array.slice(array.indexOf(element)+1);

/**
Safe indexed access to array elements. Deprecated in favor of `getOption`.
**/
  @:deprecated("atIndex is deprecated, use getOption instead")
  public static function atIndex<T>(array : ReadonlyArray<T>, i: Int): Option<T>
    return if (i >= 0 && i < array.length) Some(array[i]) else None;

/**
Safe indexed access to array elements.
Null values within `array` will also return `None` instead of `Some(null)`.
**/
  public static function getOption<T>(array : ReadonlyArray<T>, i : Int) : Option<T>
    return Options.ofValue(array[i]);

/**
Applies a side-effect function to all elements in the array.
**/
  public static function each<T>(arr : ReadonlyArray<T>, effect : T -> Void): Void {
    for (i in 0...arr.length) effect(arr[i]);
  }

/**
Applies a side-effect function to all elements in the array.
**/
  public static function eachi<T>(arr : ReadonlyArray<T>, effect : T -> Int -> Void): Void {
    for (i in 0...arr.length) effect(arr[i], i);
  }

/**
Checks if `predicate` returns true for all elements in the array.
**/
  public static function all<T>(arr : ReadonlyArray<T>, predicate : T -> Bool) {
    for(i in 0...arr.length)
      if(!predicate(arr[i]))
        return false;
    return true;
  }

/**
Checks if `predicate` returns true for at least one element in the array.
**/
  public static function any<T>(arr : ReadonlyArray<T>, predicate : T -> Bool) {
    for(i in 0...arr.length)
      if(predicate(arr[i]))
        return true;
    return false;
  }

/**
Creates an array of elements from the specified indexes.
**/
  public static function at<T>(arr : ReadonlyArray<T>, indexes : ReadonlyArray<Int>) : Array<T>
    return indexes.map(function(i) return arr[i]);

/**
Finds the first occurrance of `element` and returns all the elements before it.
**/
  inline public static function before<T>(array : ReadonlyArray<T>, element : T)
    return array.slice(0, array.indexOf(element));

/**
Traverse both arrays from the beginning and collect the elements that are the
same. It stops as soon as the arrays differ.
**/
  public static function commonsFromStart<T, PT>(self : ReadonlyArray<T>, other : ReadonlyArray<PT>, ?equality : T -> PT -> Bool) : Array<T> {
    if(null == equality) equality = cast F.equality;
    var count = 0;
    for(pair in zip(self, other))
      if(equality(pair._0, pair._1))
        count++;
      else
        break;
    return self.slice(0, count);
  }
/**
Filters out all null elements in the array
**/
  @:deprecated("Arrays.compact is deprecated, use Arrays.filterNull instead.")
  public static function compact<T>(arr : ReadonlyArray<Null<T>>) : Array<T> {
#if cs
    var result : Array<T> = [];
    for(element in arr) {
      if(null != element)
        result.push(element);
    }
    return result;
#else
    return arr.filter(function(v : Null<T>) return null != v);
#end
  }

/**
Compares two arrays returning a negative integer, zero or a positive integer.

The first comparison is made on the array length.

If they match each pair of elements is compared using `thx.Dynamics.compare`.
**/
  public static function compare<T>(a : ReadonlyArray<T>, b : ReadonlyArray<T>) {
    var v : Int;
    if ((v = Ints.compare(a.length, b.length)) != 0)
      return v;
    for (i in 0...a.length) {
      if ((v = Dynamics.compare(a[i], b[i])) != 0)
        return v;
    }
    return 0;
  }

/**
Returns a Map containing the number of occurrances for each value in the array.
**/
  @:generic
  public static function count<T>(arr : ReadonlyArray<T>) : Map<T, Int> {
    var map = new Map<T, Int>();
    arr.each(function(v)
      map.set(v, map.exists(v) ? map.get(v) + 1 : 1)
    );
    return map;
  }

/**
Returns `true` if `element` is found in the array.

An optional equality function can be passed as the last argument. If not provided, strict equality is adopted.
**/
  public static function contains<T, PT>(array : ReadonlyArray<T>, element : PT, ?eq : T -> PT -> Bool) : Bool {
    if(null == eq) {
      return array.indexOf(cast element) >= 0;
    } else {
      for(i in 0...array.length)
        if(eq(array[i], element))
          return true;
      return false;
    }
  }

/**
Returns `true` if all elements in `elements` are found in the array.

An optional equality function can be passed as the last argument. If not provided, strict equality is adopted.
**/
  public static function containsAll<T, PT>(array : Array<T>, elements : Iterable<PT>, ?eq : T -> PT -> Bool) : Bool {
    for (el in elements) {
      if (!contains(array, el, eq)) return false;
    }
    return true;
  }

/**
Returns `true` if any element in `elements` is found in the array.

An optional equality function can be passed as the last argument. If not provided, strict equality is adopted.
**/
  public static function containsAny<T, PT>(array : ReadonlyArray<T>, elements : Iterable<PT>, ?eq : T -> PT -> Bool) : Bool {
    for (el in elements) {
      if (contains(array, el, eq)) return true;
    }
    return false;
  }

/**
Creates a new `Array` with `length` elements all set to `fillWith`.
**/
  public static function create<T>(length : Int, fillWith : T) {
    var arr = #if js length > 0 ? untyped __js__("new Array")(length) : [] #else [] #end;
    for(i in 0...length)
      arr[i] = fillWith;
    return arr;
  }

/**
Creates an `Array<T>` containing the given item
**/
  public static function fromItem<T>(t : T) : Array<T>
    return [t];

/**
It returns the cross product between two arrays.

```haxe
var r = [1,2,3].cross([4,5,6]);
trace(r); // [[1,4],[1,5],[1,6],[2,4],[2,5],[2,6],[3,4],[3,5],[3,6]]
```
**/
  public static function cross<T>(a : ReadonlyArray<T>, b : ReadonlyArray<T>) {
    var r = [];
    for (va in a)
      for (vb in b)
        r.push([va, vb]);
    return r;
  }

/**
It produces the cross product of each array element.

```haxe
var r = [[1,2],[3,4],[5,6]].crossMulti();
trace(r); // [[1,3,5],[2,3,5],[1,4,5],[2,4,5],[1,3,6],[2,3,6],[1,4,6],[2,4,6]]
```
**/
  public static function crossMulti<T>(array : ReadonlyArray<ReadonlyArray<T>>) {
    var acopy  = array.copy(),
        result = acopy.shift().map(function(v) return [v]);
    while (acopy.length > 0) {
      var array = acopy.shift(),
          tresult = result;
      result = [];
      for (v in array) {
        for (ar in tresult) {
          var t = ar.copy();
          t.push(v);
          result.push(t);
        }
      }
    }
    return result;
  }

/**
Returns a new array containing only unique values from the input array.
Input array does not need to be sorted.
A predicate comparison function can be provided for comparing values.  Default
comparison is ==.
**/
  public static function distinct<T>(array : ReadonlyArray<T>, ?predicate : T -> T -> Bool) : Array<T> {
    var result = [];

    if (array.length <= 1)
      return array.toArray();

    if (null == predicate)
      predicate = Functions.equality;

    for (v in array) {
      var keep = !any(result, function(r) {
	  return (predicate(r, v) : Bool);
      });
      if (keep) result.push(v);
    }

    return result;
  }

/**
It allows to iterate an array pairing each element with every other element in the array.

The iteration ends as soon as the `callback` returns `false`.
**/
  public static function eachPair<TIn, TOut>(array : ReadonlyArray<TIn>, callback : TIn -> TIn -> Bool)
    for(i in 0...array.length)
      for(j in i...array.length)
        if(!callback(array[i], array[j]))
          return;

/**
It compares the lengths and elements of two given arrays and returns `true` if all elements match.

An optional equality function can be passed as the last argument. If not provided, strict equality is adopted.
**/
  public static function equals<T, PT>(a : ReadonlyArray<T>, b : ReadonlyArray<PT>, ?equality : T -> PT -> Bool) {
    if(a == null || b == null || a.length != b.length) return false;
    if(null == equality) equality = cast F.equality;
    for(i in 0...a.length)
      if(!equality(a[i], b[i]))
        return false;
    return true;
  }

/**
It finds an element in the array using `predicate` and returns it. The element is also
removed from the original array.

If no element satisfies `predicate` the array is left unmodified and `null` is returned.
**/
  public static function extract<T>(a : Array<T>, predicate : T -> Bool) : T {
    for(i in 0...a.length)
      if(predicate(a[i]))
        return a.splice(i, 1)[0];
    return null;
  }

/**
Filters out all `null` values from an array.
**/
  public static function filterNull<T>(a : ReadonlyArray<Null<T>>) : Array<T> {
    var arr : Array<T> = [];
    for(v in a)
      if(null != v) arr.push(v);
    return arr;
  }

/**
Filters out all `None` values from an array and extracts `Some(value)` to `value`.
**/
  public static function filterOption<T>(a : ReadonlyArray<Option<T>>) : Array<T>
    return reduce(a, function(acc : Array<T>, maybeV) {
      switch maybeV {
        case Some(v): acc.push(v);
        case None: // don't do anything
      }
      return acc;
    }, []);

/**
Converts an `Array<Option<T>>` to `Option<Array<T>>` only if all elements in the input
array contain a `Some` value. The input and the output array (if any) will have
the same length.
**/
  public static function flattenOptions<T>(a: ReadonlyArray<Option<T>>) : Option<Array<T>> {
    var acc = [];
    for(e in a) switch e {
      case None: return None;
      case Some(v): acc.push(v);
    }
    return Some(acc);
  }

/**
It returns the first element of the array that matches the predicate function.
If none is found it returns null.
**/
  public static function find<T>(array : ReadonlyArray<T>, predicate : T -> Bool) : Null<T> {
    for(element in array)
      if(predicate(element))
        return element;
    return null;
  }

/**
Like `find`, but each item's index is also passed to the predicate.
**/
  public static function findi<T>(array : ReadonlyArray<T>, predicate : T -> Int -> Bool) : Null<T> {
    for(i in 0...array.length)
      if(predicate(array[i], i))
        return array[i];
    return null;
  }

/**
Like `findOption`, but each item's index is also passed to the predicate.
**/
  public static function findiOption<T>(array : ReadonlyArray<T>, predicate : T -> Int -> Bool) : Option<T> {
    for(i in 0...array.length)
      if(predicate(array[i], i))
        return Some(array[i]);
    return None;
  }


/**
It returns the first element of the array that matches the predicate function.
If none is found it returns null.
**/
  public static function findOption<T>(array : ReadonlyArray<T>, predicate : T -> Bool) : Option<T> {
    for(element in array)
      if(predicate(element))
        return Some(element);
    return None;
  }

/**
Finds the first item in an array where the given function `f` returns a `Option.Some` value.
If no items map to `Some`, `None` is returned.
**/
  public static function findMap<TIn, TOut>(values : ReadonlyArray<TIn>, f : TIn -> Option<TOut>) : Option<TOut> {
    for (value in values) {
      var opt = f(value);
      if (!opt.isNone()) return opt;
    }
    return None;
  }

/**
Performs a `filter` and `map` operation at once. It uses predicate to get either
`None` or a transformed value `Some` of `TOut`.
**/
  public static function filterMap<TIn, TOut>(values : ReadonlyArray<TIn>, f : TIn -> Option<TOut>) : Array<TOut> {
    var acc = [];
    for (value in values) {
      switch f(value) {
        case Some(v): acc.push(v);
        case None:
      }
    }
    return acc;
  }

/**
Finds the first item in an `Array<Option<T>>` that is `Some`, otherwise `None`.
**/
  public static function findSome<T>(options : ReadonlyArray<Option<T>>) : Option<T> {
    for (option in options) {
      if (!option.isNone()) return option;
    }
    return None;
  }

/**
It returns the index of the first element of the array that matches the predicate function.
If none is found it returns `-1`.
**/
  public static function findIndex<T>(array : ReadonlyArray<T>, predicate : T -> Bool) : Int {
    for(i in 0...array.length)
      if(predicate(array[i]))
        return i;
    return -1;
  }

/**
It returns the last element of the array that matches the provided predicate function.
If none is found it returns null.
**/
  public static function findLast<T>(array : ReadonlyArray<T>, predicate : T -> Bool) : Null<T> {
    var len = array.length,
        j;
    for(i in 0...len) {
      j = len - i - 1;
      if(predicate(array[j]))
        return array[j];
    }
    return null;
  }

/**
It returns the first element of the array or null if the array is empty.
**/
  inline public static function first<T>(array : ReadonlyArray<T>) : Null<T>
    return array[0];


/**
It returns an option of the first element or None if the array is empty.
**/
  inline public static function firstOption<T>(array : ReadonlyArray<T>) : Option<T>
    return Options.ofValue(array[0]);

/**
It traverses an array of elements. Each element is split using the `callback` function and a 'flattened' array is returned.

```haxe
var chars = ['Hello', 'World'].flatMap(function(s) return s.split(''));
trace(chars); // ['H','e','l','l','o','W','o','r','l','d']
```
**/
  inline public static function flatMap<TIn, TOut>(array : ReadonlyArray<TIn>, callback : TIn -> Array<TOut>) : Array<TOut>
    return flatten(array.map(callback));

/**
It takes an array of arrays and 'flattens' it into an array.

```haxe
var arr = [[1,2,3],[4,5,6],[7,8,9]];
trace(arr); // [1,2,3,4,5,6,7,8,9]
```
**/
  #if js inline #end
  public static function flatten<T>(array : ReadonlyArray<Array<T>>) : Array<T>
    #if js
      return untyped __js__('Array.prototype.concat.apply')([], array);
    #else
      return reduce(array, function(acc : Array<T>, element) return acc.concat(element), []);
    #end

/**
Finds the first occurrance of `element` and returns all the elements from that point on.
**/
  inline public static function from<T>(array : ReadonlyArray<T>, element : T)
    return array.slice(array.indexOf(element));

/**
Returns a Map of arrays. Each value in the array is passed to `resolver` that returns a key to use
to group such element.

This method is tagged with `@:generic` and needs a compatible type to be used (ex: no anonymous objects).

In case you have to use a type that is not supported by `@:generic`, please use `groupByAppend`.
**/
  @:generic
  public static function groupBy<TKey, TValue>(arr : ReadonlyArray<TValue>, resolver : TValue -> TKey) : Map<TKey, Array<TValue>> {
    var map : Map<TKey, Array<TValue>> = new Map<TKey, Array<TValue>>();

    for (i in 0...arr.length) {
      var v = arr[i];
      var key : TKey = resolver(v),
          acc : Array<TValue> = map.get(key);

      if(null == acc) {
        map.set(key, [v]);
      } else {
        acc.push(v);
      }
    };

    return map;
  }

#if !cs
  /**
  Each value in the array is passed to `resolver` that returns a key to use to group such element.
  Groups are appended to the passed map.
  **/
  public static function groupByAppend<TKey, TValue>(arr : ReadonlyArray<TValue>, resolver : TValue -> TKey, map : Map<TKey, Array<TValue>>) : Map<TKey, Array<TValue>> {
    for (i in 0...arr.length) {
      var v = arr[i];
      var key : TKey = resolver(v),
          acc : Array<TValue> = map.get(key);

      if (null == acc) {
        map.set(key, [v]);
      } else {
        acc.push(v);
      }
    }

    return map;
  }
#end

  /**
   * Group the array by a function of the index.
   */
  @:generic
  public static function groupByIndex<A, K>(arr: ReadonlyArray<A>, groupKey: Int -> K): Map<K, Array<A>> {
    var map : Map<K, Array<A>> = new Map<K, Array<A>>();
    for(i in 0...arr.length) {
      var k: K = groupKey(i),
          acc: Array<A> = map.get(k);
      if(null == acc) {
        acc = [arr[i]];
        map.set(k, acc);
      } else {
        acc.push(arr[i]);
      }
    }
    return map;
  }

  public static function spanByIndex<A, K>(arr: ReadonlyArray<A>, spanKey: Int -> K): Array<Array<A>> {
    var acc: Array<Array<A>> = [];
    var cur: K = null;
    var j: Int = -1;
    for(i in 0...arr.length) {
      var k: K = spanKey(i);
      if (k == null) throw new thx.Error('spanKey function returned null for index $i');
      if (cur == k) {
        acc[j].push(arr[i]);
      } else {
        cur = k;
        j++;
        acc.push([arr[i]]);
      }
    }
    return acc;
  }

/**
Returns `true` if the array contains at least one element.
**/
  inline public static function hasElements<T>(array : ReadonlyArray<T>) : Bool
    return null != array && array.length > 0;

/**
It returns the first element of the array or null if the array is empty. Same as `first`.
**/
  inline public static function head<T>(array : ReadonlyArray<T>) : Null<T>
    return array[0];

/**
`ifEmpty` returns `array` if it is neither `null` or empty, otherwise it returns `alt`
**/
  public static inline function ifEmpty<T>(array : Array<T>, alt : Array<T>) : Array<T>
    return null != array && 0 != array.length ? array : alt;

/**
Get all the elements from `array` except for the last one.
**/
  inline public static function initial<T>(array : ReadonlyArray<T>) : Array<T>
    return array.slice(0, array.length - 1);

/**
Creates a new array that alternates the values in `array` with `value`.
**/
  public static function intersperse<T>(array : ReadonlyArray<T>, value : T) : Array<T>
    return reducei(array, function(acc, v, i) {
      acc[i * 2] = v;
      return acc;
    }, create(array.length * 2 - 1, value));

/**
Lazy version of `intersperse`. It creates a new array that alternates the values in `array` with the result of `f`.
**/
  public static function interspersef<T>(array : ReadonlyArray<T>, f : Void -> T) : Array<T> {
    if(array.length == 0)
      return [];
    var acc = [array[0]];
    for(i in 1...array.length) {
      acc.push(f());
      acc.push(array[i]);
    }
    return acc;
  }

/**
It returns `true` if the array contains zero elements.
**/
  inline public static function isEmpty<T>(array : ReadonlyArray<T>) : Bool
    return null == array || array.length == 0;

/**
It returns the last element of the array or null if the array is empty.
**/
  inline public static function last<T>(array : ReadonlyArray<T>) : Null<T>
    return array[array.length-1];

/**
It returns an option of the last element, `None` if the array is empty.
**/
  inline public static function lastOption<T>(array : ReadonlyArray<T>) : Option<T>
    return Options.ofValue(last(array));

/**
Static wrapper for `Array` `map` function.
**/
  #if js inline #end
  public static function map<TIn, TOut>(array : ReadonlyArray<TIn>, callback : TIn -> TOut) : Array<TOut> {
    var r = [];
    for(i in 0...array.length)
      r.push(callback(array[i]));
    return r;
  }

/**
Same as `Array.map` but it adds a second argument to the `callback` function with the current index value.
**/
  #if js inline #end
  public static function mapi<TIn, TOut>(array : ReadonlyArray<TIn>, callback : TIn -> Int -> TOut) : Array<TOut> {
    var r = [];
    for(i in 0...array.length)
      r.push(callback(array[i], i));
    return r;
  }

/**
Same as `Array.map` but traverses the array from the last to the first element.
**/
  public static function mapRight<TIn, TOut>(array : ReadonlyArray<TIn>, callback : TIn -> TOut) : Array<TOut> {
    var i = array.length,
        result = [];
    while(--i >= 0)
      result.push(callback(array[i]));
    return result;
  }

/**
It works the same as `Array.sort()` but doesn't change the original array and returns a sorted copy it.
**/
  public static function order<T>(array : ReadonlyArray<T>, sort : T -> T -> Int) {
    var n = array.copy();
    n.sort(sort);
    return n;
  }

/**
Pulls from `array` all occurrences of all the elements in `toRemove`. Optionally takes
an `equality` function.
**/
  public static function pull<T, PT>(array : Array<T>, toRemove : ReadonlyArray<PT>, ?equality : T -> PT -> Bool)
    for(element in toRemove)
      removeAll(array, element, equality);

/**
It pushes `value` onto the array if `condition` is true. Also returns the array for easy method chaining.
**/
  public static function pushIf<T>(array : Array<T>, condition : Bool, value : T) {
    if (condition)
      array.push(value);
    return array;
  }

/**
Given an array of values, it returns an array of indexes permutated applying the function `compare`.

By default `rank` will return continuous values. If you know that your set does not contain duplicates you might want to turn off that feature by setting `incrementDuplicates` to `false`.

```
var arr = ["C","A","B"];
var indexes = Arrays.rank(arr, Strings.compare);
trace(indexes); // output [2,0,1]
```
**/
  public static function rank<T>(array : ReadonlyArray<T>, compare : T -> T -> Int, ?incrementDuplicates = true) : Array<Int> {
    var arr = Arrays.mapi(array, function(v, i) return Tuple.of(v, i));
    arr.sort(function(a, b) return (compare(a.left, b.left) : Int));
    if(incrementDuplicates) {
      var usedIndexes = thx.Set.createInt();
      return Arrays.reducei(arr, function(acc, x, i) {
        var index = i > 0 && compare(arr[i-1].left, x.left) == 0 ? acc[arr[i-1].right] : i;
        while(usedIndexes.exists(index)) {
          index++;
        }
        usedIndexes.add(index);
        acc[x.right] = index;
        return acc;
      }, []);
    } else {
      return  Arrays.reducei(arr, function(acc, x, i) {
        acc[x.right] = i > 0 && compare(arr[i-1].left, x.left) == 0 ? acc[arr[i-1].right] : i;
        return acc;
      }, []);
    }
  }

/**
It applies a function against an accumulator and each value of the array (from left-to-right) has to reduce it to a single value.
**/
  public static function reduce<A, B>(array : ReadonlyArray<A>, f : B -> A -> B, initial : B) : B {
    for(v in array)
      initial = f(initial, v);
    return initial;
  }

  /**
   * Alias for reduce that puts the arguments in the proper order.
   */
  public static inline function foldLeft<A, B>(array: ReadonlyArray<A>, init: B, f: B -> A -> B): B
    return reduce(array, f, init);

/**
 * As with foldLeft, but uses first element as Init.
 */
    public static inline function foldLeft1<A, B>(array: ReadonlyArray<A>, f: A -> A -> A): Option<A>{
      var tail = array.dropLeft(1);
      var head = array.first();
      return if(head  == null){
        None;
      }else{
        Some(reduce(tail,f,head));
      }
    }


  public static function foldLeftEither<A, E, B>(array: ReadonlyArray<A>, init: B, f: B -> A -> Either<E, B>): Either<E, B> {
    var acc: Either<E, B> = Right(init);
    for (a in array) {
      switch acc {
        case Left(error): return acc;
        case Right(b): acc = f(b, a);
      }
    }

    return acc;
  }

  /**
   * Fold by mapping the contained values into some monoidal type and reducing with that monoid.
   */
  public static function foldMap<A, B>(array: ReadonlyArray<A>, f: A -> B, m: Monoid<B>): B
    return foldLeft(array.map(f), m.zero, m.append);

  /**
   * Reduce with a monoid
   */
  public static function fold<A>(array: ReadonlyArray<A>, m: Monoid<A>): A
    return foldMap(array, Functions.identity, m);

  /**
   * Safely convert to a non-empty list.
   */
  public static function nel<A>(array: ReadonlyArray<A>): Option<Nel<A>>
    return Nel.fromArray(array);

  /**
   * Reduce with a semigroup, returning None if the array is empty.
   */
  public static function foldS<A>(array: ReadonlyArray<A>, s: Semigroup<A>): Option<A>
    return nel(array).map(function(x) return x.fold(s));

/**
Resizes an array of `T` to an arbitrary length by adding more elements to its end
or by removing extra elements.

Note that the function changes the passed array and doesn't create a copy.
**/
  public static function resize<T>(array : Array<T>, length : Int, fill : T) {
    while(array.length < length)
      array.push(fill);
    array.splice(length, array.length - length);
    return array;
  }

/**
Copies and resizes an array of `T` to an arbitrary length by adding more
elements to its end or by removing extra elements.

Note that the function creates and returns a copy of the passed array.
**/
public static function resized<T>(array : Array<T>, length : Int, fill : T) {
  array = array.copy();
  return resize(array, length, fill);
}

/**
It is the same as `reduce` but with the extra integer `index` parameter.
**/
  public static function reducei<A, B>(array : ReadonlyArray<A>, f : B -> A -> Int -> B, initial : B) : B {
    for(i in 0...array.length)
      initial = f(initial, array[i], i);
    return initial;
  }

/**
Same as `Arrays.reduce` but starting from the last element and traversing to the first
**/
  inline public static function reduceRight<A, B>(array : ReadonlyArray<A>, f : B -> A -> B, initial : B) : B {
    var i = array.length;
    while(--i >= 0)
      initial = f(initial, array[i]);
    return initial;
  }

/**
Remove every occurrance of `element` from `array`. If `equality` is not specified, strict equality
will be adopted.
**/
  public static function removeAll<T, PT>(array : Array<T>, element : PT, ?equality : T -> PT -> Bool) {
    if(null == equality)
      equality = cast Functions.equality;
    var i = array.length;
    while(--i >= 0)
      if(equality(array[i], element))
        array.splice(i, 1);
  }

/**
Returns all but the first element of the array
**/
  inline public static function rest<T>(array : ReadonlyArray<T>) : Array<T>
    return array.slice(1);

/**
Creates a copy of the array with its elements in reverse order.
*/
  inline public static function reversed<T>(array: ReadonlyArray<T>): Array<T> {
    var result = array.copy();
    result.reverse();
    return result;
  }


/**
Returns `n` elements at random from the array. Elements will not be repeated.
**/
  inline public static function sample<T>(array : ReadonlyArray<T>, n : Int) : Array<T> {
    n = Ints.min(n, array.length);
    var copy   = array.copy(),
        result = [];
    for(i in 0...n)
      result.push(copy.splice(Std.random(copy.length), 1)[0]);
    return result;
  }

/**
Returns one element at random from the array or null if the array is empty.
**/
  inline public static function sampleOne<T>(array : ReadonlyArray<T>) : Null<T>
    return array[Std.random(array.length)];

/**
Converts an `Array<T>` into a string.
**/
  public static function string<T>(arr : ReadonlyArray<T>) : String {
    var strings : Array<String> = arr.map(Dynamics.string);
    return "[" + strings.join(", ") + "]";
  }

/**
It returns a copy of the array with its elements randomly changed in position.
**/
  public static function shuffle<T>(a : ReadonlyArray<T>) : Array<T> {
    var t = Ints.range(a.length),
        array = [];
    while (t.length > 0) {
      var pos = Std.random(t.length),
        index = t[pos];
      t.splice(pos, 1);
      array.push(a[index]);
    }
    return array;
  }

/**
Splits an array into a specified number of `parts`.
**/
  public static function split<T>(array : ReadonlyArray<T>, parts : Int) {
    var len = Math.ceil(array.length / parts);
    return splitBy(array, len);
  }

/**
Splits an array into smaller arrays at most of length equal to `len`.
**/
  public static function splitBy<T>(array : ReadonlyArray<T>, len : Int) {
    var res = [];
    len = Ints.min(len, array.length);
    for(p in 0...Math.ceil(array.length / len)) {
      res.push(array.slice(p * len, (p+1) * len));
    }
    return res;
  }

/**
Splits an array by the given number and pads last group with the given element if necessary.
**/
  public static function splitByPad<T>(arr : Array<T>, len : Int, pad : T) {
    var res = Arrays.splitBy(arr, len);
    while (Arrays.last(res).length < len)
      Arrays.last(res).push(pad);
    return res;
  }

/**
It returns the elements of the array after the first.
**/
inline public static function tail<T>(array : ReadonlyArray<T>) : Array<T>
  return array.slice(1);

/**
Returns the first `n` elements from the array.
**/
  inline public static function take<T>(arr : ReadonlyArray<T>, n : Int) : Array<T>
    return arr.slice(0, n);
/**
Returns the last `n` elements from the array.
**/
  inline public static function takeLast<T>(arr : ReadonlyArray<T>, n : Int) : Array<T>
    return arr.slice(arr.length - n);

/**
Traverse the array with a function that may return values wrapped in Option.
If any of the values are None, return None, otherwise return the array of mapped
values in a Some.
**/
  public static function traverseOption<T, U>(arr: ReadonlyArray<T>, f: T -> Option<U>): Option<Array<U>>
    return reduce(arr, function(acc: Option<Array<U>>, t: T) {
      return f(t).ap(acc.map(function(ux: Array<U>) return function(u: U) { ux.push(u); return ux; }));
    }, Some([]));

/**
Traverse the array with a function that may return values wrapped in Either.
If any result is in Left, the first such value is returned; if all results
are in Right, then the array of those results is returned in Right.

If you want to instead collect errors rather than fail on the first error,
see traverseValidation.
**/
  public static function traverseEither<E, T, U>(arr: ReadonlyArray<T>, f: T -> Either<E, U>): Either<E, Array<U>>
    return reduce(arr, function(acc: Either<E, Array<U>>, t: T) {
      return f(t).ap(acc.map(function(ux: Array<U>) return function(u: U) { ux.push(u); return ux; }));
    }, Right([]));

/**
Traverse the array with a function that may return values wrapped in Validation.
If any of the values are Failures, return a Failure that accumulates all errors
from the failed values, otherwise return the array of mapped values in a Success.
**/
  public static function traverseValidation<E, T, U>(arr: ReadonlyArray<T>, f: T -> Validation<E, U>, s: Semigroup<E>): Validation<E, Array<U>>
    return reduce(arr, function(acc: Validation<E, Array<U>>, t: T) {
      return f(t).ap(acc.map(function(ux) return function(u) { ux.push(u); return ux; }), s);
    }, Validation.success([]));

/**
Traverse the array with a function that may return values wrapped in Validation.
If any of the values are Failures, return a Failure that accumulates all errors
from the failed values, otherwise return the array of mapped values in a Success.
**/
  public static function traverseValidationIndexed<E, T, U>(arr: ReadonlyArray<T>, f: T -> Int -> Validation<E, U>, s: Semigroup<E>): Validation<E, Array<U>>
    return reducei(arr, function(acc: Validation<E, Array<U>>, t: T, i: Int) {
      return f(t, i).ap(acc.map(function(ux) return function(u) { ux.push(u); return ux; }), s);
    }, Validation.success([]));

/**
Transforms an array like `[[a0,b0],[a1,b1],[a2,b2]]` into
`[[a0,a1,a2],[b0,b1,b2]]`.
**/
  public static function rotate<T>(arr : ReadonlyArray<ReadonlyArray<T>>) : Array<Array<T>> {
    var result = [];
    for(i in 0...arr[0].length) {
      var row = [];
      result.push(row);
      for(j in 0...arr.length) {
        row.push(arr[j][i]);
      }
    }
    return result;
  }

  public static function sliding2<T, U>(arr: ReadonlyArray<T>, f: T -> T -> U): Array<U> {
    if (arr.length < 2) {
      return [];
    } else {
      var result = [];
      for (i in 0...(arr.length - 1)) {
        result.push(f(arr[i], arr[i + 1]));
      }
      return result;
    }
  }

/**
Unzip an array of Tuple2<T1, T2> to a Tuple2<Array<T1>, Array<T2>>.
**/
  public static function unzip<T1, T2>(array : ReadonlyArray<Tuple2<T1, T2>>) {
    var a1 = [], a2 = [];
    array.map(function(t) {
      a1.push(t._0);
      a2.push(t._1);
      return null;
    });
    return new Tuple2(a1, a2);
  }

/**
Unzip an array of Tuple3<T1, T2, T3> to a Tuple3<Array<T1>, Array<T2>, Array<T3>>.
**/
  public static function unzip3<T1, T2, T3>(array : ReadonlyArray<Tuple3<T1, T2, T3>>) {
    var a1 = [], a2 = [], a3 = [];
    array.map(function(t) {
      a1.push(t._0);
      a2.push(t._1);
      a3.push(t._2);
      return null;
    });
    return new Tuple3(a1, a2, a3);
  }

/**
Unzip an array of Tuple4<T1, T2, T3, T4> to a Tuple4<Array<T1>, Array<T2>, Array<T3>, Array<T4>>.
**/
  public static function unzip4<T1, T2, T3, T4>(array : ReadonlyArray<Tuple4<T1, T2, T3, T4>>) {
    var a1 = [], a2 = [], a3 = [], a4 = [];
    array.map(function(t) {
      a1.push(t._0);
      a2.push(t._1);
      a3.push(t._2);
      a4.push(t._3);
      return null;
    });
    return new Tuple4(a1, a2, a3, a4);
  }

/**
Unzip an array of Tuple5<T1, T2, T3, T4, T5> to a Tuple5<Array<T1>, Array<T2>, Array<T3>, Array<T4>, Array<T5>>.
**/
  public static function unzip5<T1, T2, T3, T4, T5>(array : ReadonlyArray<Tuple5<T1, T2, T3, T4, T5>>) {
    var a1 = [], a2 = [], a3 = [], a4 = [], a5 = [];
    array.map(function(t) {
      a1.push(t._0);
      a2.push(t._1);
      a3.push(t._2);
      a4.push(t._3);
      a5.push(t._4);
      return null;
    });
    return new Tuple5(a1, a2, a3, a4, a5);
  }

/**
Pairs the elements of two arrays in an array of `Tuple2`.
**/
  public static function zip<T1, T2>(array1 : ReadonlyArray<T1>, array2 : ReadonlyArray<T2>) : Array<Tuple2<T1, T2>> {
    var length = Ints.min(array1.length, array2.length),
        array  = [];
    for(i in 0...length)
      array.push(new Tuple2(array1[i], array2[i]));
    return array;
  }

/**
Pairs the elements of three arrays in an array of `Tuple3`.
**/
  public static function zip3<T1, T2, T3>(array1 : ReadonlyArray<T1>, array2 : ReadonlyArray<T2>, array3 : ReadonlyArray<T3>) : Array<Tuple3<T1, T2, T3>> {
    var length = ArrayInts.min([array1.length, array2.length, array3.length]),
        array  = [];
    for(i in 0...length)
      array.push(new Tuple3(array1[i], array2[i], array3[i]));
    return array;
  }

/**
Pairs the elements of four arrays in an array of `Tuple4`.
**/
  public static function zip4<T1, T2, T3, T4>(array1 : ReadonlyArray<T1>, array2 : ReadonlyArray<T2>, array3 : ReadonlyArray<T3>, array4 : ReadonlyArray<T4>) : Array<Tuple4<T1, T2, T3, T4>> {
    var length = ArrayInts.min([array1.length, array2.length, array3.length, array4.length]),
        array  = [];
    for(i in 0...length)
      array.push(new Tuple4(array1[i], array2[i], array3[i], array4[i]));
    return array;
  }

/**
Pairs the elements of five arrays in an array of `Tuple5`.
**/
  public static function zip5<T1, T2, T3, T4, T5>(array1 : ReadonlyArray<T1>, array2 : ReadonlyArray<T2>, array3 : ReadonlyArray<T3>, array4 : ReadonlyArray<T4>, array5 : ReadonlyArray<T5>) : Array<Tuple5<T1, T2, T3, T4, T5>> {
    var length = ArrayInts.min([array1.length, array2.length, array3.length, array4.length, array5.length]),
        array  = [];
    for(i in 0...length)
      array.push(new Tuple5(array1[i], array2[i], array3[i], array4[i], array5[i]));
    return array;
  }

  /**
   * The 'zip' applicative functor operation.
   */
  public static function zipAp<A, B>(ax: ReadonlyArray<A>, fx: ReadonlyArray<A -> B>): Array<B> {
    var result = [];
    for(i in 0...(Ints.min(ax.length, fx.length))) {
      result.push(fx[i](ax[i]));
    }
    return result;
  }

  /**
   * Zip two arrays by applying the provided function to the aligned members.
   */
  public static function zip2Ap<A, B, C>(f: A -> B -> C, ax: ReadonlyArray<A>, bx: ReadonlyArray<B>): Array<C>
    return zipAp(bx, ax.map(Functions2.curry(f)));

  /**
   * Zip three arrays by applying the provided function to the aligned members.
   */
  public static function zip3Ap<A, B, C, D>(f: A -> B -> C -> D, ax: ReadonlyArray<A>, bx: ReadonlyArray<B>, cx: ReadonlyArray<C>): Array<D>
    return zipAp(cx, zip2Ap(Functions3.curry(f), ax, bx));

  /**
   * Zip four arrays by applying the provided function to the aligned members.
   */
  public static function zip4Ap<A, B, C, D, E>(f: A -> B -> C -> D -> E, ax: ReadonlyArray<A>, bx: ReadonlyArray<B>, cx: ReadonlyArray<C>, dx: ReadonlyArray<D>): Array<E>
    return zipAp(dx, zip3Ap(Functions4.curry(f), ax, bx, cx));

  /**
   * Zip five arrays by applying the provided function to the aligned members.
   */
  public static function zip5Ap<A, B, C, D, E, F>(f: A -> B -> C -> D -> E -> F, ax: ReadonlyArray<A>, bx: ReadonlyArray<B>, cx: ReadonlyArray<C>, dx: ReadonlyArray<D>, ex: ReadonlyArray<E>): Array<F>
    return zipAp(ex, zip4Ap(Functions5.curry(f), ax, bx, cx, dx));

/**
Returns a copy of the array with the new element added to the beginning.
**/
  inline public static function withPrepend<T>(arr : ReadonlyArray<T>, el : T) : ReadonlyArray<T>
    return [el].concat(arr.unsafe());

/**
Returns a copy of the array with the new element added to the end.
**/
  inline public static function with<T>(arr : ReadonlyArray<T>, el : T) : ReadonlyArray<T>
    return arr.concat([el]);

/**
Returns a copy of the array with the `other` elements inserted at `start`. The `length` elements after `start` are going to be removed.
**/
  public static function withSlice<T>(arr : ReadonlyArray<T>, other : ReadonlyArray<T>, start : Int, ?length : Int = 0) : ReadonlyArray<T>
    return arr.slice(0, start).concat(other.unsafe()).concat(arr.slice(start + length));

/**
Returns a copy of the array with the new element inserted at position `pos`.
**/
  public static function withInsert<T>(arr : ReadonlyArray<T>, el : T, pos : Int) : ReadonlyArray<T>
    return arr.slice(0, pos).concat([el]).concat(arr.slice(pos));

/**
Finds the min element of the array given the specified ordering.
**/
  public static function maxBy<A>(arr: ReadonlyArray<A>, ord: Ord<A>): Option<A>
    return arr.length == 0 ? None : Some(reduce(arr, ord.max, arr[0]));

/**
Finds the min element of the array given the specified ordering.
**/
  public static function minBy<A>(arr: ReadonlyArray<A>, ord: Ord<A>): Option<A>
    return arr.length == 0 ? None : Some(reduce(arr, ord.min, arr[0]));

  /**
   * Convert an array of tuples to a map. If there are collisions between keys,
   * return an error.
   */
  public static function toMap<K, V>(arr: ReadonlyArray<Tuple<K, V>>, keyOrder: Ord<K>): VNel<K, thx.fp.Map<K, V>> {
    var m = thx.fp.Map.empty();
    var collisions: Array<K> = [];
    for (i in 0...arr.length) {
      var tuple = arr[i];
      if (m.lookup(tuple._0, keyOrder).isNone()) {
        m = m.insert(tuple._0, tuple._1, keyOrder);
      } else {
        collisions.push(tuple._0);
      }
    }

    return Options.toFailure(Nel.fromArray(collisions), m);
  }

  public static function toStringMap<V>(arr: ReadonlyArray<Tuple<String, V>>): Map<String, V> {
    return reduce(
      arr,
      function(acc: StringMap<V>, t: Tuple<String, V>) {
        acc.set(t._0, t._1);
        return acc;
      },
      new StringMap()
    );
  }
/**
	Produces a `Tuple2` containing two `Array`, the left being elements where `f(e) == true`, the rest in the right.
**/
  static public function partition<T>(arr: ReadonlyArray<T>, f: T -> Bool): Tuple2<Array<T>, Array<T>> {
    return arr.foldLeft(new Tuple2([], []), function(a, b) {
      if(f(b))
        a._0.push(b);
      else
        a._1.push(b);
      return a;
    });
  }
/**
  Produces a `Tuple2` containing two `Arrays`, the difference from partition being that after the predicate
  returns true once, the rest of the elements will be in the right hand of the tuple, regardless of
  the result of the predicate.
**/
  static public function partitionWhile<T>(arr: ReadonlyArray<T>, f: T -> Bool): Tuple2<Array<T>, Array<T>> {
    var partitioning = true;

    return arr.foldLeft(new Tuple2([], []), function(a, b) {
      if (partitioning) {
        if (f(b))
          a._0.push(b);
        else {
          partitioning = false;
          a._1.push(b);
        }
      }
      else
        a._1.push(b);
      return a;
    });
  }
/**
	Produces an Array from `a[n]` to the last element of `a`.
**/
  static public function dropLeft<T>(a: ReadonlyArray<T>, n: Int): Array<T> {
    return if (n >= a.length) [] else a.slice(n);
  }
/**
	Produces an Array from `a[0]` to a[a.length-n].
**/
  static public function dropRight<T>(a: ReadonlyArray<T>, n: Int): Array<T> {
    return if (n >= a.length) [] else a.slice(0,a.length - n);
  }
/**
	Drops values from Array `a` while the predicate returns true.
**/
  static public function dropWhile<T>(a: ReadonlyArray<T>, p: T -> Bool): Array<T> {
    var r : Array<T> = [].concat(
      a.unsafe()
    );

    for (e in a) {
      if (p(e)) r.shift(); else break;
    }

    return r;
  }
/**
  Pads out to len with optional default `def`, ignores if len is less than Array length.
**/
  static public function pad<T>(arr:ReadonlyArray<T>,len:Int,?def:Null<T>):Array<T>{
    var len0 = len - arr.length;
    var arr0 = [];
    for (i in 0...len0){
      arr0.push(def);
    }
    return arr.unsafe().concat(arr0);
  }
/**
  Fills `null` values in `arr` with `def`.
**/
  static public function fill<T>(arr:ReadonlyArray<T>,def:T):Array<T>{
    return arr.map(
      function(x){
        return x == null ? def : x;
      }
    );
  }
}

/**
Helper class for `Array<Float>`.
**/
class ArrayFloats {
/**
Finds the average of all the elements in the array.

It returns `NaN` if the array is empty.
**/
  public static function average(arr : ReadonlyArray<Float>) : Float {
    return sum(arr) / arr.length;
  }

/**
Filters out all null or Math.NaN floats in the array
**/
  public static function compact(arr : ReadonlyArray<Null<Float>>) : Array<Float>
    // the cast is required to compile safely to C#
    return cast arr.filter(function(v) return null != v && Math.isFinite(v));

/**
Finds the max float element in the array.
**/
  public static function max(arr : ReadonlyArray<Float>) : Null<Float>
    return Arrays.maxBy(arr, Floats.order).get();

/**
Finds the min float element in the array.
**/
  public static function min(arr : ReadonlyArray<Float>) : Null<Float>
    return Arrays.minBy(arr, Floats.order).get();

/**
Resizes an array of `Float` to an arbitrary length by adding more elements (default is `0.0`)
to its end or by removing extra elements.

Note that the function changes the passed array and doesn't create a copy.
**/
  public static function resize(array : Array<Float>, length : Int, fill : Float = 0.0) {
    while(array.length < length)
      array.push(fill);
    array.splice(length, array.length - length);
    return array;
  }



/**
Copies and resizes an array of `Float` to an arbitrary length by adding more
elements (default is `0.0`) to its end or by removing extra elements.

Note that the function creates and returns a copy of the passed array.
**/
  public static function resized(array : Array<Float>, length : Int, fill : Float = 0.0) {
    array = array.copy();
    return resize(array, length, fill);
  }

/**
Returns the sample standard deviation of the sampled values.
**/
  public static function standardDeviation(array : ReadonlyArray<Float>) : Float {
    if(array.length < 2)
      return 0.0;
    var mean = average(array),
        variance = Arrays.reduce(array, function(acc, val) {
            return acc + Math.pow(val - mean, 2);
          }, 0) / (array.length - 1);
    return Math.sqrt(variance);
  }

/**
Finds the sum of all the elements in the array.
**/
  public static function sum(arr : ReadonlyArray<Float>) : Null<Float>
    return Arrays.reduce(arr, function(tot, v) return tot + v, 0.0);
}

/**
Helper class for `Array<Int>`.
**/
class ArrayInts {
/**
Finds the average of all the elements in the array.
**/
  public static function average(arr : ReadonlyArray<Int>) : Null<Float>
    return sum(arr) / arr.length;

/**
Finds the max int element in the array.
**/
  public static function max(arr : ReadonlyArray<Int>) : Null<Int>
    return Arrays.maxBy(arr, Ints.order).get();

/**
Finds the min int element in the array.
**/
  public static function min(arr : ReadonlyArray<Int>) : Null<Int>
    return Arrays.minBy(arr, Ints.order).get();

/**
Resizes an array of `Int` to an arbitrary length by adding more elements (default is `0`)
to its end or by removing extra elements.

Note that the function changes the passed array and doesn't create a copy.
**/
  public static function resize(array : Array<Int>, length : Int, fill : Int = 0) {
    while(array.length < length)
      array.push(fill);
    array.splice(length, array.length - length);
    return array;
  }

/**
Copies and resizes an array of `Int` to an arbitrary length by adding more
elements (default is `0`) to its end or by removing extra elements.

Note that the function creates and returns a copy of the passed array.
**/
public static function resized(array : Array<Int>, length : Int, fill : Int = 0) {
  array = array.copy();
  return resize(array, length, fill);
}

/**
Finds the sum of all the elements in the array.
**/
  public static function sum(arr : ReadonlyArray<Int>) : Null<Int>
    return Arrays.reduce(arr, function(tot, v) return tot + v, 0);
}

/**
Helper class for `Array<String>`.
**/
class ArrayStrings {
/**
Filters out all null or empty strings in the array
**/
  public static function compact(arr : ReadonlyArray<String>) : Array<String>
    return arr.filter(function(v) return !Strings.isEmpty(v));

/**
Finds the max string element in the array.
**/
  public static function max(arr : ReadonlyArray<String>) : Null<String>
    return Arrays.maxBy(arr, Strings.order).getOrElse(null);

/**
Finds the min string element in the array.
**/
  public static function min(arr : ReadonlyArray<String>) : Null<String>
    return Arrays.minBy(arr, Strings.order).getOrElse(null);
}
