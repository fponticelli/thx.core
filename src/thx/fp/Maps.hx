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
  static var comparator = Strings.compare.fromIntComparison();
  inline static public function exists<V>(map : Map<String, V>, key : String) : Bool
    return map.lookup(key, comparator).toBool();

  inline static public function get<V>(map : Map<String, V>, key : String) : Option<V>
    return map.lookup(key, comparator);

  inline static public function getAlt<V>(map : Map<String, V>, key : String, alt : V) : V
    return map.lookup(key, comparator).getOrElse(alt);

  inline static public function set<V>(map : Map<String, V>, key : String, value : V) : Map<String, V>
    return map.insert(key, value, comparator);

  inline static public function remove<V>(map : Map<String, V>, key : String) : Map<String, V>
    return map.delete(key, comparator);

  public static function fromNative<V>(map : IMap<String, V>) : Map<String, V>
    return Map.fromNative(map, comparator);

  public static function toNative<V>(map : Map<String, V>) : M<String, V>
    return map.foldLeftTuples(new M(), function(acc, t) {
      acc.set(t.left, t.right);
      return acc;
    });

  public static function merge<V>(a : Map<String, V>, b : Map<String, V>) : Map<String, V>
    return b.foldLeftTuples(a, function(acc, t) {
      return acc.insert(t._0, t._1, comparator);
    });
}

class FloatMap {
  static var comparator = Floats.compare.fromIntComparison();
  inline static public function exists<V>(map : Map<Float, V>, key : Float) : Bool
    return map.lookup(key, comparator).toBool();

  inline static public function get<V>(map : Map<Float, V>, key : Float) : Option<V>
    return map.lookup(key, comparator);

  inline static public function getAlt<V>(map : Map<Float, V>, key : Float, alt : V) : V
    return map.lookup(key, comparator).getOrElse(alt);

  inline static public function set<V>(map : Map<Float, V>, key : Float, value : V) : Map<Float, V>
    return map.insert(key, value, Floats.compare.fromIntComparison());

  inline static public function remove<V>(map : Map<Float, V>, key : Float) : Map<Float, V>
    return map.delete(key, comparator);

  public static function merge<V>(a : Map<Float, V>, b : Map<Float, V>) : Map<Float, V>
    return b.foldLeftTuples(a, function(acc, t) {
      return acc.insert(t._0, t._1, comparator);
    });
}

class IntMap {
  static var comparator = Ints.compare.fromIntComparison();
  inline static public function exists<V>(map : Map<Int, V>, key : Int) : Bool
    return map.lookup(key, comparator).toBool();

  inline static public function get<V>(map : Map<Int, V>, key : Int) : Option<V>
    return map.lookup(key, comparator);

  inline static public function getAlt<V>(map : Map<Int, V>, key : Int, alt : V) : V
    return map.lookup(key, comparator).getOrElse(alt);

  inline static public function set<V>(map : Map<Int, V>, key : Int, value : V) : Map<Int, V>
    return map.insert(key, value, Ints.compare.fromIntComparison());

  inline static public function remove<V>(map : Map<Int, V>, key : Int) : Map<Int, V>
    return map.delete(key, comparator);

  public static function fromNative<V>(map : IMap<Int, V>) : Map<Int, V>
    return Map.fromNative(map, comparator);

  public static function toNative<V>(map : Map<Int, V>) : M<Int, V>
    return map.foldLeftTuples(new M(), function(acc, t) {
      acc.set(t.left, t.right);
      return acc;
    });

  public static function merge<V>(a : Map<Int, V>, b : Map<Int, V>) : Map<Int, V>
    return b.foldLeftTuples(a, function(acc, t) {
      return acc.insert(t._0, t._1, comparator);
    });
}

class ComparableOrdMap {
  inline static public function exists<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T) : Bool
    return map.lookup(key, function(a, b) return a.compareTo(b)).toBool();

  inline static public function get<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T) : Option<V>
    return map.lookup(key, function(a : T, b : T) return a.compareTo(b));

  inline static public function getAlt<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T, alt : V) : V
    return map.lookup(key, function(a : T, b : T) return a.compareTo(b)).getOrElse(alt);

  inline static public function set<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T, value : V) : Map<T, V>
    return map.insert(key, value, function(a : T, b : T) return a.compareTo(b));

  inline static public function remove<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T) : Map<T, V>
    return map.delete(key, function(a : T, b : T) return a.compareTo(b));

  public static function fromNative<V, T : ComparableOrd<T>>(map : IMap<T, V>) : Map<T, V>
    return Map.fromNative(map, function(a : T, b : T) return a.compareTo(b));

  public static function merge<V, T : ComparableOrd<T>>(a : Map<T, V>, b : Map<T, V>) : Map<T, V>
    return b.foldLeftTuples(a, function(acc, t) {
      return acc.insert(t._0, t._1, function(a : T, b : T) return a.compareTo(b));
    });
}

class ComparableMap {
  inline static public function exists<V, T : Comparable<T>>(map : Map<T, V>, key : T) : Bool
    return map.lookup(key, function(a, b) : Ordering return a.compareTo(b).fromInt()).toBool();

  inline static public function get<V, T : Comparable<T>>(map : Map<T, V>, key : T) : Option<V>
    return map.lookup(key, function(a : T, b : T) : Ordering return a.compareTo(b).fromInt());

  inline static public function getAlt<V, T : Comparable<T>>(map : Map<T, V>, key : T, alt : V) : V
    return map.lookup(key, function(a : T, b : T) : Ordering return a.compareTo(b).fromInt()).getOrElse(alt);

  inline static public function set<V, T : Comparable<T>>(map : Map<T, V>, key : T, value : V) : Map<T, V>
    return map.insert(key, value, function(a : T, b : T) : Ordering return a.compareTo(b).fromInt());

  inline static public function remove<V, T : Comparable<T>>(map : Map<T, V>, key : T) : Map<T, V>
    return map.delete(key, function(a : T, b : T) : Ordering return a.compareTo(b).fromInt());

  public static function fromNative<V, T : Comparable<T>>(map : IMap<T, V>) : Map<T, V>
    return Map.fromNative(map, function(a : T, b : T) return a.compareTo(b).fromInt());

  public static function merge<V, T : Comparable<T>>(a : Map<T, V>, b : Map<T, V>) : Map<T, V>
    return b.foldLeftTuples(a, function(acc, t) {
      return acc.insert(t._0, t._1, function(a : T, b : T) return a.compareTo(b).fromInt());
    });
}
