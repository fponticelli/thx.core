package thx;

#if (haxe_ver >= 3.200)
import haxe.Constraints.IMap;
#else
import Map.IMap;
#end
import thx.Tuple;
using thx.Iterators;
using thx.Arrays;

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
Extracts the values of a Map<TKey, TValue> into Array<TValue>
**/
  public static function values<TKey, TValue>(map: IMap<TKey, TValue>): Array<TValue>
    return map.keys().map(function(key)
      return map.get(key)
    );

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
Returns true if a value is of any type of Map. Equivalent to `Std.is(v, IMap)`.
**/
  inline public static function isMap(v : Dynamic)
    return Std.is(v, IMap);
}
