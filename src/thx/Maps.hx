package thx;

#if (haxe_ver >= 3.200)
import haxe.Constraints.IMap;
#else
import Map.IMap;
#end
import haxe.ds.Option;
import thx.Tuple;
using thx.Iterators;
using thx.Arrays;
using thx.Options;

/**
Extension methods for Maps
**/
class Maps {
/**
Copies all the key/values pairs from `src` to `dst`. It overwrites already existing
keys in `dst` if needed.
**/
  public static function copyTo<TKey, TValue>(src: IMap<TKey, TValue>, dst: IMap<TKey, TValue>) {
    for(key in src.keys())
      dst.set(key, src.get(key));
    return dst;
  }

/**
Converts a Map<TKey, TValue> into an Array<Tuple2<TKey, TValue>>
**/
  public static function tuples<TKey, TValue>(map: IMap<TKey, TValue>): Array<Tuple2<TKey, TValue>>
    return map.keys().map(function(key)
      return new Tuple2(key, map.get(key))
    );

/**
It maps values from one `Map` instance to another.
**/
  public static function mapValues<TKey, TValueA, TValueB>(map : IMap<TKey, TValueA>, f : TValueA -> TValueB, acc : Map<TKey, TValueB>) : Map<TKey, TValueB>
    return reduce(map, function(m : Map<TKey, TValueB>, t) {
      m.set(t._0, f(t._1));
      return m;
    }, acc);

/**
Applies the reduce function on every key/value pair in the map.
**/
  public static function reduce<TKey, TValue, TOut>(map: IMap<TKey, TValue>, f : TOut -> Tuple<TKey, TValue> -> TOut, acc : TOut) : TOut
    return tuples(map).reduce(f, acc);

/**
Extracts the values of a Map<TKey, TValue> into Array<TValue>
**/
  public static function values<TKey, TValue>(map: IMap<TKey, TValue>): Array<TValue>
    return map.keys().map(function(key : TKey) : TValue
      return map.get(key)
    );

/**
Creates a `Map<K, V>` from an `Array<T>` using key extractor `T -> K` and value extractor `T -> V` functions.
`K` must be a string.
**/
  public static function fromArray<T, K : String, V>(array : ReadonlyArray<T>, toKey : T -> K, toVal : T -> V) : Map<K, V>
    return Arrays.reduce(array, function (acc : Map<K, V>, curr : T) {
      acc.set(toKey(curr), toVal(curr));
      return acc;
    }, new Map());

  /**
   * Unordered fold over key/value pairs in the map.
   */
  public static function foldLeftWithKeys<K, A, B>(map: Map<K, A>, f: B -> K -> A -> B, acc: B): B
    return map.keys().reduce(
      function(acc, k) return f(acc, k, map.get(k)),
      acc
    );


/**
Null-safe get.
**/
  public static function getOption<TKey, TValue>(map: IMap<TKey, TValue>, key : TKey): Option<TValue>
    return Options.ofValue(map.get(key));

/**
`mapToObject` transforms a `Map<String, T>` into an anonymous object.
**/
  public static function toObject<T>(map : Map<String, T>) : {}
    return tuples(map).reduce(function(o, t) {
      Reflect.setField(o, t._0, t._1);
      return o;
    }, {});

/**
Given a `key` returns the associated value from `map`. If the key doesn't exist or the associated value is `null`,
it returns the provided `alt` value instead.
**/
  public static function getAlt<TKey, TValue>(map : Map<TKey, TValue>, key : TKey, alt : TValue) : TValue {
    var v = map.get(key);
    return null == v ? alt : v;
  }

/**
Given a `key` returns the associated value from `map`. If the key doesn't exist or the associated value is `null`,
it returns the provided `alt` value instead, and stores the `alt` value in the map.
**/
  public static function getAltSet<TKey, TValue>(map : Map<TKey, TValue>, key : TKey, alt : TValue) : TValue {
    var v = map.get(key);
    return if (v != null) {
      v;
    } else {
      map.set(key, alt);
      alt;
    }
  }

/**
Returns true if the map is empty (no key/value pairs).
**/
  inline public static function isEmpty<TKey, TValue>(map : Map<TKey, TValue>)
    return !map.iterator().hasNext();

/**
Returns true if a value is of any type of Map. Equivalent to `Std.is(v, IMap)`.
**/
  inline public static function isMap(v : Dynamic)
    return Std.is(v, IMap);

  public static function string<TKey, TValue>(m : IMap<TKey, TValue>) : String {
    return "[" + tuples(m).map(function(t : Tuple<TKey, TValue>) : String {
      return Dynamics.string(t._0) + ' => ' + Dynamics.string(t._1);
    }).join(", ") + "]";
  }

/**
Merges 0 or more maps of the same type into a destination map.  Successive source maps will overwrite values for
the same key from previous sources.  The destination map is modified in place, and the destination is also returned
from the function.  To merge into an empty map, pass a new empty map as the dest argument.

```
var result1 = map1.merge([map2, map3]); // result1 and map1 should be the same after this.  map2 and map3 are not modified.
var result2 = (new Map() : Map<String, Int>).merge(map1, map2); // map1 and map2 not modified
```
**/
  public static function merge<TKey, TValue>(dest : IMap<TKey, TValue>, sources: Array<IMap<TKey, TValue>>) : IMap<TKey, TValue> {
    return sources.reduce(function(result : IMap<TKey, TValue>, source) {
      return source.keys().reduce(function(result : IMap<TKey, TValue>, key) {
        result.set(key, source.get(key));
        return result;
      }, result);
    }, dest);
  }

  /**
   * The way that Haxe specializes maps inhibits us from defining a Monoid
   * instance for maps. The recommended way to reduce an array of maps
   * is `Nel.nel(new Map(), maps).fold(Maps.semigroup())`
   */
  @:generic
  public static function semigroup<K, V>(): Semigroup<IMap<K, V>> {
    return function(m0: IMap<K, V>, m1: IMap<K, V>) {
      return merge(m0, [m1]);
    }
  }
}
