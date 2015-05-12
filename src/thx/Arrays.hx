package thx;

import thx.Functions.Functions in F;
import thx.Functions;

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
Finds the first occurrance of `element` and returns all the elements after it.
**/
  inline public static function after<T>(array : Array<T>, element : T)
    return array.slice(array.indexOf(element)+1);

/**
Checks if `predicate` returns true for all elements in the array.
**/
  public static function all<T>(arr : Array<T>, predicate : T -> Bool) {
    for(item in arr)
      if(!predicate(item))
        return false;
    return true;
  }

/**
Checks if `predicate` returns true for at least one element in the array.
**/
  public static function any<T>(arr : Array<T>, predicate : T -> Bool) {
    for(item in arr)
      if(predicate(item))
        return true;
    return false;
  }

/**
Creates an array of elements from the specified indexes.
**/
  public static function at<T>(arr : Array<T>, indexes : Array<Int>) : Array<T>
    return indexes.map(function(i) return arr[i]);

/**
Finds the first occurrance of `element` and returns all the elements before it.
**/
  inline public static function before<T>(array : Array<T>, element : T)
    return array.slice(0, array.indexOf(element));

/**
Filters out all null elements in the array
**/
  public static function compact<T>(arr : Array<Null<T>>) : Array<T> {
#if cs
    var result : Array<T> = [];
    for(item in arr) {
      if(null != item)
        result.push(item);
    }
    return result;
#else
    return arr.filter(function(v : Null<T>) return null != v);
#end
  }

/**
Returns a Map containing the number of occurrances for each value in the array.
**/
  @:generic
  public static function count<T>(arr : Array<T>) : Map<T, Int> {
    var map = new Map<T, Int>();
    arr.map(function(v)
      map.set(v, map.exists(v) ? map.get(v) + 1 : 1)
    );
    return map;
  }

/**
Returns `true` if `element` is found in the array.

An optional equality function can be passed as the last argument. If not provided, strict equality is adopted.
**/
  public static function contains<T>(array : Array<T>, element : T, ?eq : T -> T -> Bool) : Bool {
    if(null == eq) {
      return array.indexOf(element) >= 0;
    } else {
      for(i in 0...array.length)
        if(eq(array[i], element))
          return true;
      return false;
    }
  }

/**
Returns `true` if any element in `elements` is found in the array.

An optional equality function can be passed as the last argument. If not provided, strict equality is adopted.
**/
 public static function containsAny<T>(array : Array<T>, elements : Iterable<T>, ?eq : T -> T -> Bool) : Bool {
  for (el in elements) {
    if (contains(array, el, eq)) return true;
  }
  return false;
 }

/**
It returns the cross product between two arrays.

```haxe
var r = [1,2,3].cross([4,5,6]);
trace(r); // [[1,4],[1,5],[1,6],[2,4],[2,5],[2,6],[3,4],[3,5],[3,6]]
```
**/
  public static function cross<T>(a : Array<T>, b : Array<T>) {
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
  public static function crossMulti<T>(array : Array<Array<T>>) {
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
  public static function distinct<T>(array : Array<T>, ?predicate : T -> T -> Bool) : Array<T> {
    var result = [];

    if (array.length <= 1)
      return array;

    if (null == predicate)
      predicate = Functions.equality;

    for (v in array) {
      var keep = !any(result, function(r) {
        return predicate(r, v);
      });
      if (keep) result.push(v);
    }

    return result;
  }

/**
It allows to iterate an array pairing each element with every other element in the array.

The iteration ends as soon as the `callback` returns `false`.
**/
  public static function eachPair<TIn, TOut>(array : Array<TIn>, callback : TIn -> TIn -> Bool)
    for(i in 0...array.length)
      for(j in i...array.length)
        if(!callback(array[i], array[j]))
          return;

/**
It compares the lengths and elements of two given arrays and returns `true` if they match.

An optional equality function can be passed as the last argument. If not provided, strict equality is adopted.
**/
  public static function equals<T>(a : Array<T>, b : Array<T>, ?equality : T -> T -> Bool) {
    if(a == null || b == null || a.length != b.length) return false;
    if(null == equality) equality = F.equality;
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
Filters an array according to the expression passed as the second argument.

The special symbol `_` refers to the current item.

```haxe
[1,2,3,4,5,6].filterPluck(_ % 2 != 0); // holds [1,3,5]
```
**/
  macro public static function filterPluck<T>(a : ExprOf<Array<T>>, expr : ExprOf<Bool>) : ExprOf<Array<T>>
    return macro $e{a}.filter(function(_) return $e{expr});

/**
It returns the first element of the array that matches the provided predicate function.
If none is found it returns null.
**/
  public static function find<T>(array : Array<T>, predicate : T -> Bool) : Null<T> {
    for(item in array)
      if(predicate(item))
        return item;
    return null;
  }

/**
It returns the last element of the array that matches the provided predicate function.
If none is found it returns null.
**/
  public static function findLast<T>(array : Array<T>, predicate : T -> Bool) : Null<T> {
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
It returns the same result as `find`, but using the pluck strategy.
**/
  macro public static function findPluck<T>(a : ExprOf<Array<T>>, expr : ExprOf<Bool>) : ExprOf<Array<T>>
    return macro $e{a}.find(function(_) return $e{expr});


/**
It returns the same result as `findLast`, but using the pluck strategy.
**/
  macro public static function findPluckLast<T>(a : ExprOf<Array<T>>, expr : ExprOf<Bool>) : ExprOf<Array<T>>
    return macro $e{a}.findLast(function(_) return $e{expr});

/**
It returns the first element of the array or null if the array is empty.
**/
  inline public static function first<T>(array : Array<T>) : Null<T>
    return array[0];

/**
It traverses an array of elements. Each element is split using the `callback` function and a 'flattened' array is returned.

```haxe
var chars = ['Hello', 'World'].flatMap(function(s) return s.split(''));
trace(chars); // ['H','e','l','l','o','W','o','r','l','d']
```
**/
  inline public static function flatMap<TIn, TOut>(array : Array<TIn>, callback : TIn -> Array<TOut>) : Array<TOut>
    return flatten(array.map(callback));

/**
It takes an array of arrays and 'flattens' it into an array.

```haxe
var arr = [[1,2,3],[4,5,6],[7,8,9]];
trace(arr); // [1,2,3,4,5,6,7,8,9]
```
**/
  #if js inline #end
  public static function flatten<T>(array : Array<Array<T>>) : Array<T>
    #if js
      return untyped __js__('Array.prototype.concat.apply')([], array);
    #else
      return reduce(array, function(acc : Array<T>, item) return acc.concat(item), []);
    #end

/**
Finds the first occurrance of `element` and returns all the elements from that point on.
**/
  inline public static function from<T>(array : Array<T>, element : T)
    return array.slice(array.indexOf(element));

/**
Returns a Map of arrays. Each value in the array is passed to `resolver` that returns a key to use
to group such element.

This method is tagged with `@:generic` and needs a compatible type to be used (ex: no anonymous objects).

In case you have to use a type that is not supported by `@:generic`, please use `groupByAppend`.
**/
  @:generic
  public static function groupBy<TKey, TValue>(arr : Array<TValue>, resolver : TValue -> TKey) : Map<TKey, Array<TValue>> {
    var map : Map<TKey, Array<TValue>> = new Map<TKey, Array<TValue>>();
    arr.map(function(v : TValue) {
      var key : TKey = resolver(v),
          arr : Array<TValue> = map.get(key);
      if(null == arr) {
        arr = [v];
        map.set(key, arr);
      } else {
        arr.push(v);
      }
    });
    return map;
  }

#if !cs
  /**
  Each value in the array is passed to `resolver` that returns a key to use to group such element.
  Groups are appended to the passed map.
  **/
  public static function groupByAppend<TKey, TValue>(arr : Array<TValue>, resolver : TValue -> TKey, map : Map<TKey, Array<TValue>>) : Map<TKey, Array<TValue>> {
    arr.map(function(v : TValue) {
      var key : TKey = resolver(v),
          arr : Array<TValue> = map.get(key);
      if(null == arr) {
        arr = [v];
        map.set(key, arr);
      } else {
        arr.push(v);
      }
    });
    return map;
  }
#end

/**
It returns the first element of the array or null if the array is empty. Same as `first`.
**/
  inline public static function head<T>(array : Array<T>) : Null<T>
    return array[0];

/**
`ifEmpty` returns `value` if it is neither `null` or empty, otherwise it returns `alt`
**/
  public static inline function ifEmpty<T>(value : Array<T>, alt : Array<T>) : Array<T>
    return null != value && 0 != value.length ? value : alt;

/**
Get all the elements from `array` except for the last one.
**/
  inline public static function initial<T>(array : Array<T>) : Array<T>
    return array.slice(0, array.length - 1);

/**
It returns `true` if the array contains zero elements.
**/
  inline public static function isEmpty<T>(array : Array<T>) : Bool
    return array.length == 0;

/**
It returns the last element of the array or null if the array is empty.
**/
  inline public static function last<T>(array : Array<T>) : Null<T>
    return array[array.length-1];

/**
Same as `Array.map` but it adds a second argument to the `callback` function with the current index value.
**/
  #if js inline #end
  public static function mapi<TIn, TOut>(array : Array<TIn>, callback : TIn -> Int -> TOut) : Array<TOut> {
    var r = [];
    for(i in 0...array.length)
      r.push(callback(array[i], i));
    return r;
  }

/**
Same as `Array.map` but traverses the array from the last to the first element.
**/
  public static function mapRight<TIn, TOut>(array : Array<TIn>, callback : TIn -> TOut) : Array<TOut> {
    var i = array.length,
        result = [];
    while(--i >= 0)
      result.push(callback(array[i]));
    return result;
  }

/**
It works the same as `Array.sort()` but doesn't change the original array and returns a sorted copy it.
**/
  public static function order<T>(array : Array<T>, sort : T -> T -> Int) {
    var n = array.copy();
    n.sort(sort);
    return n;
  }

/**
Uses the pluck strategy to order an array.  Returns an ordered copy of the Array, leaving the original unchanged.
Arguments for pluck are `_0` and `_1`.
**/
  macro public static function orderPluck<T>(array : ExprOf<Array<T>>, expr : ExprOf<Int>)
    return macro $e{array}.order(function(_0, _1) return $e{expr});

/**
The method works like a normal `Array.map()` but instead of passing a function that
receives an item, you can pass an expression that defines how to access to a member
of the item itself.

The following two examples are equivalent:

```
var r = ['a','b','c'].pluck(_.toUppercase());
trace(r); // ['A','B','C']
```

Alternative using traditional `map`.

```
var r = ['a','b','c'].map(function(o) return o.toUppercase());
trace(r); // ['A','B','C']
```

You can use `pluck` on any kind of field including properties and methods and you can even pass arguments
to such functions.

The method is a macro method that guarantees that the correct types and identifiers are used.
**/
  macro public static function pluck<T, TOut>(a : ExprOf<Array<T>>, expr : ExprOf<TOut>) : ExprOf<Array<TOut>>
    return macro $e{a}.map(function(_) return ${expr});

/**
Same as pluck but in reverse order.
**/
  macro public static function pluckRight<T, TOut>(a : ExprOf<Array<T>>, expr : ExprOf<TOut>) : ExprOf<Array<TOut>>
    return macro thx.Arrays.mapRight($e{a}, function(_) return ${expr});

/**
Like `pluck` but with an extra argument `i` that can be used to infer the index of the iteration.

```haxe
var r = arr.plucki(_.increment(i)); // where increment() is a method of the elements in the array
```
**/
  macro public static function plucki<T>(a : ExprOf<Array<T>>, expr : Expr)
    return macro thx.Arrays.mapi($e{a}, function(_, i) return ${expr});

/**
Pulls from `array` all occurrences of all the elements in `toRemove`. Optionally takes
an `equality` function.
**/
  public static function pull<T>(array : Array<T>, toRemove : Array<T>, ?equality : T -> T -> Bool)
    for(item in toRemove)
      removeAll(array, item, equality);

/**
It pushes `value` onto the array if `condition` is true. Also returns the array for easy method chaining.
**/
  public static function pushIf<T>(array : Array<T>, condition : Bool, value : T) {
    if (condition)
      array.push(value);
    return array;
  }

/**
It applies a function against an accumulator and each value of the array (from left-to-right) has to reduce it to a single value.
**/
  inline public static function reduce<TItem, TAcc>(array : Array<TItem>, callback : TAcc -> TItem -> TAcc, initial : TAcc) : TAcc {
    #if js
      return untyped array.reduce(callback, initial);
    #else
      array.map(function(v) initial = callback(initial, v));
      return initial;
    #end
  }

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
It is the same as `reduce` but with the extra integer `index` parameter.
**/
  inline public static function reducei<TItem, TAcc>(array : Array<TItem>, callback : TAcc -> TItem -> Int -> TAcc, initial : TAcc) : TAcc {
    #if js
      return untyped array.reduce(callback, initial);
    #else
      Arrays.mapi(array, function(v, i) initial = callback(initial, v, i));
      return initial;
    #end
  }

/**
Same as `Arrays.reduce` but starting from the last element and traversing to the first
**/
  inline public static function reduceRight<TItem, TAcc>(array : Array<TItem>, callback : TAcc -> TItem -> TAcc, initial : TAcc) : TAcc {
    var i = array.length;
    while(--i >= 0)
      initial = callback(initial, array[i]);
    return initial;
  }

/**
Remove every occurrance of `element` from `array`. If `equality` is not specified, strict equality
will be adopted.
**/
  public static function removeAll<T>(array : Array<T>, element : T, ?equality : T -> T -> Bool) {
    if(null == equality)
      equality = Functions.equality;
    var i = array.length;
    while(--i >= 0)
      if(equality(array[i], element))
        array.splice(i, 1);
  }

/**
Returns all but the first element of the array
**/
  inline public static function rest<T>(array : Array<T>) : Array<T>
    return array.slice(1);

/**
Returns `n` elements at random from the array. Elements will not be repeated.
**/
  inline public static function sample<T>(array : Array<T>, n : Int) : Array<T> {
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
  inline public static function sampleOne<T>(array : Array<T>) : Null<T>
    return array[Std.random(array.length)];

/**
It returns a copy of the array with its elements randomly changed in position.
**/
  public static function shuffle<T>(a : Array<T>) : Array<T> {
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
Uses the plcuk strategy to sort an array. Arguments for pluck are `_0` and `_1`.
**/
  macro public static function sortPluck<T>(array : ExprOf<Array<T>>, expr : ExprOf<Int>)
    return macro $e{array}.sort(function(_0, _1) return $e{expr});

/**
Splits an array into a specified number of `parts`.
**/
  public static function split<T>(array : Array<T>, parts : Int) {
    var len = Math.ceil(array.length / parts);
    return splitBy(array, len);
  }

/**
Splits an array into smaller arrays at most of length equal to `len`.
**/
  public static function splitBy<T>(array : Array<T>, len : Int) {
    var res = [];
    len = Ints.min(len, array.length);
    for(p in 0...Math.ceil(array.length / len)) {
      res.push(array.slice(p * len, (p+1) * len));
    }
    return res;
  }

/**
Returns the first `n` elements from the array.
**/
  inline public static function take<T>(arr : Array<T>, n : Int) : Array<T>
    return arr.slice(0, n);
/**
Returns the last `n` elements from the array.
**/
  inline public static function takeLast<T>(arr : Array<T>, n : Int) : Array<T>
    return arr.slice(arr.length - n);

/**
Transforms an array like `[[a0,b0],[a1,b1],[a2,b2]]` into
`[[a0,a1,a2],[b0,b1,b2]]`.
**/
  public static function rotate<T>(arr : Array<Array<T>>) : Array<Array<T>> {
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

/**
Unzip an array of Tuple2<T1, T2> to a Tuple2<Array<T1>, Array<T2>>.
**/
  public static function unzip<T1, T2>(array : Array<Tuple2<T1, T2>>) {
    var a1 = [], a2 = [];
    array.map(function(t) {
      a1.push(t._0);
      a2.push(t._1);
    });
    return new Tuple2(a1, a2);
  }

/**
Unzip an array of Tuple3<T1, T2, T3> to a Tuple3<Array<T1>, Array<T2>, Array<T3>>.
**/
  public static function unzip3<T1, T2, T3>(array : Array<Tuple3<T1, T2, T3>>) {
    var a1 = [], a2 = [], a3 = [];
    array.map(function(t) {
      a1.push(t._0);
      a2.push(t._1);
      a3.push(t._2);
    });
    return new Tuple3(a1, a2, a3);
  }

/**
Unzip an array of Tuple4<T1, T2, T3, T4> to a Tuple4<Array<T1>, Array<T2>, Array<T3>, Array<T4>>.
**/
  public static function unzip4<T1, T2, T3, T4>(array : Array<Tuple4<T1, T2, T3, T4>>) {
    var a1 = [], a2 = [], a3 = [], a4 = [];
    array.map(function(t) {
      a1.push(t._0);
      a2.push(t._1);
      a3.push(t._2);
      a4.push(t._3);
    });
    return new Tuple4(a1, a2, a3, a4);
  }

/**
Unzip an array of Tuple5<T1, T2, T3, T4, T5> to a Tuple5<Array<T1>, Array<T2>, Array<T3>, Array<T4>, Array<T5>>.
**/
  public static function unzip5<T1, T2, T3, T4, T5>(array : Array<Tuple5<T1, T2, T3, T4, T5>>) {
    var a1 = [], a2 = [], a3 = [], a4 = [], a5 = [];
    array.map(function(t) {
      a1.push(t._0);
      a2.push(t._1);
      a3.push(t._2);
      a4.push(t._3);
      a5.push(t._4);
    });
    return new Tuple5(a1, a2, a3, a4, a5);
  }

/**
Pairs the elements of two arrays in an array of `Tuple2`.
**/
  public static function zip<T1, T2>(array1 : Array<T1>, array2 : Array<T2>) : Array<Tuple2<T1, T2>> {
    var length = Ints.min(array1.length, array2.length),
        array  = [];
    for(i in 0...length)
      array.push(new Tuple2(array1[i], array2[i]));
    return array;
  }

/**
Pairs the elements of three arrays in an array of `Tuple3`.
**/
  public static function zip3<T1, T2, T3>(array1 : Array<T1>, array2 : Array<T2>, array3 : Array<T3>) : Array<Tuple3<T1, T2, T3>> {
    var length = ArrayInts.min([array1.length, array2.length, array3.length]),
        array  = [];
    for(i in 0...length)
      array.push(new Tuple3(array1[i], array2[i], array3[i]));
    return array;
  }

/**
Pairs the elements of four arrays in an array of `Tuple4`.
**/
  public static function zip4<T1, T2, T3, T4>(array1 : Array<T1>, array2 : Array<T2>, array3 : Array<T3>, array4 : Array<T4>) : Array<Tuple4<T1, T2, T3, T4>> {
    var length = ArrayInts.min([array1.length, array2.length, array3.length, array4.length]),
        array  = [];
    for(i in 0...length)
      array.push(new Tuple4(array1[i], array2[i], array3[i], array4[i]));
    return array;
  }

/**
Pairs the elements of five arrays in an array of `Tuple5`.
**/
  public static function zip5<T1, T2, T3, T4, T5>(array1 : Array<T1>, array2 : Array<T2>, array3 : Array<T3>, array4 : Array<T4>, array5 : Array<T5>) : Array<Tuple5<T1, T2, T3, T4, T5>> {
    var length = ArrayInts.min([array1.length, array2.length, array3.length, array4.length, array5.length]),
        array  = [];
    for(i in 0...length)
      array.push(new Tuple5(array1[i], array2[i], array3[i], array4[i], array5[i]));
    return array;
  }

#if js
  static function __init__() {
    untyped __js__("
      // Production steps of ECMA-262, Edition 5, 15.4.4.21
      // Reference: http://es5.github.io/#x15.4.4.21
      if (!Array.prototype.reduce) {
        Array.prototype.reduce = function(callback /*, initialValue*/) {
          'use strict';
          if (this == null) {
            throw new TypeError('Array.prototype.reduce called on null or undefined');
          }
          if (typeof callback !== 'function') {
            throw new TypeError(callback + ' is not a function');
          }
          var t = Object(this), len = t.length >>> 0, k = 0, value;
          if (arguments.length == 2) {
            value = arguments[1];
          } else {
            while (k < len && ! k in t) {
              k++;
            }
            if (k >= len) {
              throw new TypeError('Reduce of empty array with no initial value');
            }
            value = t[k++];
          }
          for (; k < len; k++) {
            if (k in t) {
              value = callback(value, t[k], k, t);
            }
          }
          return value;
        };
      }
    ");
  }
#end
}

/**
Helper class for `Array<Float>`.
**/
class ArrayFloats {
/**
Finds the average of all the elements in the array.

It returns `NaN` if the array is empty.
**/
  public static function average(arr : Array<Float>) : Float {
    return sum(arr) / arr.length;
  }

/**
Filters out all null or Math.NaN floats in the array
**/
  public static function compact(arr : Array<Null<Float>>) : Array<Float>
    // the cast is required to compile safely to C#
    return cast arr.filter(function(v) return null != v && Math.isFinite(v));

/**
Finds the max float element in the array.
**/
  public static function max(arr : Array<Float>) : Null<Float>
    return arr.length == 0 ? null : Arrays.reduce(arr, function(max, v) return v > max ? v : max, arr[0]);

/**
Finds the min float element in the array.
**/
  public static function min(arr : Array<Float>) : Null<Float>
    return arr.length == 0 ? null : Arrays.reduce(arr, function(min, v) return v < min ? v : min, arr[0]);

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
Finds the sum of all the elements in the array.
**/
  public static function sum(arr : Array<Float>) : Null<Float>
    return Arrays.reduce(arr, function(tot, v) return tot + v, 0.0);
}

/**
Helper class for `Array<Int>`.
**/
class ArrayInts {
/**
Finds the average of all the elements in the array.
**/
  public static function average(arr : Array<Int>) : Null<Float>
    return sum(arr) / arr.length;

/**
Finds the max int element in the array.
**/
  public static function max(arr : Array<Int>) : Null<Int>
    return arr.length == 0 ? null : Arrays.reduce(arr, function(max, v) return v > max ? v : max, arr[0]);

/**
Finds the min int element in the array.
**/
  public static function min(arr : Array<Int>) : Null<Int>
    return arr.length == 0 ? null : Arrays.reduce(arr, function(min, v) return v < min ? v : min, arr[0]);

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
Finds the sum of all the elements in the array.
**/
  public static function sum(arr : Array<Int>) : Null<Int>
    return Arrays.reduce(arr, function(tot, v) return tot + v, 0);
}

/**
Helper class for `Array<String>`.
**/
class ArrayStrings {
/**
Filters out all null or empty strings in the array
**/
  public static function compact(arr : Array<String>) : Array<String>
    return arr.filter(function(v) return !Strings.isEmpty(v));

/**
Finds the max string element in the array.
**/
  public static function max(arr : Array<String>) : Null<String>
    return arr.length == 0 ? null : Arrays.reduce(arr, function(max, v) return v > max ? v : max, arr[0]);

/**
Finds the min string element in the array.
**/
  public static function min(arr : Array<String>) : Null<String>
    return arr.length == 0 ? null : Arrays.reduce(arr, function(min, v) return v < min ? v : min, arr[0]);
}
