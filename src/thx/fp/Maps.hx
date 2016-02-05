package thx.fp;

import haxe.ds.Option;
using thx.Ord;
using thx.Options;
#if (haxe_ver >= 3.200)
import haxe.Constraints.IMap;
#else
import Map.IMap;
#end
import Map as M;

class StringMap {
  inline static public function exists<V>(map : Map<String, V>, key : String) : Bool
    return map.lookup(key, Strings.order).toBool();

  inline static public function get<V>(map : Map<String, V>, key : String) : Option<V>
    return map.lookup(key, Strings.order);

  inline static public function getAlt<V>(map : Map<String, V>, key : String, alt : V) : V
    return map.lookup(key, Strings.order).getOrElse(alt);

  inline static public function set<V>(map : Map<String, V>, key : String, value : V) : Map<String, V>
    return map.insert(key, value, Strings.order);

  inline static public function remove<V>(map : Map<String, V>, key : String) : Map<String, V>
    return map.delete(key, Strings.order);

  public static function fromNative<V>(map : IMap<String, V>) : Map<String, V>
    return Map.fromNative(map, Strings.order);

  public static function toNative<V>(map : Map<String, V>) : M<String, V>
    return map.foldLeftTuples(new M(), function(acc, t) {
      acc.set(t.left, t.right);
      return acc;
    });

  public static function merge<V>(a : Map<String, V>, b : Map<String, V>) : Map<String, V>
    return b.foldLeftTuples(a, function(acc, t) return acc.insert(t._0, t._1, Strings.order));
}

class FloatMap {
  inline static public function exists<V>(map : Map<Float, V>, key : Float) : Bool
    return map.lookup(key, Floats.order).toBool();

  inline static public function get<V>(map : Map<Float, V>, key : Float) : Option<V>
    return map.lookup(key, Floats.order);

  inline static public function getAlt<V>(map : Map<Float, V>, key : Float, alt : V) : V
    return map.lookup(key, Floats.order).getOrElse(alt);

  inline static public function set<V>(map : Map<Float, V>, key : Float, value : V) : Map<Float, V>
    return map.insert(key, value, Floats.order);

  inline static public function remove<V>(map : Map<Float, V>, key : Float) : Map<Float, V>
    return map.delete(key, Floats.order);

  public static function merge<V>(a : Map<Float, V>, b : Map<Float, V>) : Map<Float, V>
    return b.foldLeftTuples(a, function(acc, t) return acc.insert(t._0, t._1, Floats.order));
}

class IntMap {
  inline static public function exists<V>(map : Map<Int, V>, key : Int) : Bool
    return map.lookup(key, Ints.order).toBool();

  inline static public function get<V>(map : Map<Int, V>, key : Int) : Option<V>
    return map.lookup(key, Ints.order);

  inline static public function getAlt<V>(map : Map<Int, V>, key : Int, alt : V) : V
    return map.lookup(key, Ints.order).getOrElse(alt);

  inline static public function set<V>(map : Map<Int, V>, key : Int, value : V) : Map<Int, V>
    return map.insert(key, value, Ints.order);

  inline static public function remove<V>(map : Map<Int, V>, key : Int) : Map<Int, V>
    return map.delete(key, Ints.order);

  public static function fromNative<V>(map : IMap<Int, V>) : Map<Int, V>
    return Map.fromNative(map, Ints.order);

  public static function toNative<V>(map : Map<Int, V>) : M<Int, V>
    return map.foldLeftTuples(new M(), function(acc, t) {
      acc.set(t.left, t.right);
      return acc;
    });

  public static function merge<V>(a : Map<Int, V>, b : Map<Int, V>) : Map<Int, V>
    return b.foldLeftTuples(a, function(acc, t) return acc.insert(t._0, t._1, Ints.order));
}

class ComparableOrdMap {
  inline static public function exists<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T) : Bool
    return map.lookup(key, Ord.forComparableOrd()).toBool();

  inline static public function get<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T) : Option<V>
    return map.lookup(key, Ord.forComparableOrd());

  inline static public function getAlt<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T, alt : V) : V
    return map.lookup(key, Ord.forComparableOrd()).getOrElse(alt);

  inline static public function set<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T, value : V) : Map<T, V>
    return map.insert(key, value, Ord.forComparableOrd());

  inline static public function remove<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T) : Map<T, V>
    return map.delete(key, Ord.forComparableOrd());

  public static function fromNative<V, T : ComparableOrd<T>>(map : IMap<T, V>) : Map<T, V>
    return Map.fromNative(map, Ord.forComparableOrd());

  public static function merge<V, T : ComparableOrd<T>>(a : Map<T, V>, b : Map<T, V>) : Map<T, V>
    return b.foldLeftTuples(a, function(acc, t) return acc.insert(t._0, t._1, Ord.forComparableOrd()));
}

class ComparableMap {
  inline static public function exists<V, T : Comparable<T>>(map : Map<T, V>, key : T) : Bool
    return map.lookup(key, Ord.forComparable()).toBool();

  inline static public function get<V, T : Comparable<T>>(map : Map<T, V>, key : T) : Option<V>
    return map.lookup(key, Ord.forComparable());

  inline static public function getAlt<V, T : Comparable<T>>(map : Map<T, V>, key : T, alt : V) : V
    return map.lookup(key, Ord.forComparable()).getOrElse(alt);

  inline static public function set<V, T : Comparable<T>>(map : Map<T, V>, key : T, value : V) : Map<T, V>
    return map.insert(key, value, Ord.forComparable());

  inline static public function remove<V, T : Comparable<T>>(map : Map<T, V>, key : T) : Map<T, V>
    return map.delete(key, Ord.forComparable());

  public static function fromNative<V, T : Comparable<T>>(map : IMap<T, V>) : Map<T, V>
    return Map.fromNative(map, Ord.forComparable());

  public static function merge<V, T : Comparable<T>>(a : Map<T, V>, b : Map<T, V>) : Map<T, V>
    return b.foldLeftTuples(a, function(acc, t) return acc.insert(t._0, t._1, Ord.forComparable()));
}
