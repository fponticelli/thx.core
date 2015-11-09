package thx.fp;

import haxe.ds.Option;
using thx.Ord;
using thx.Options;

class StringMap {
  inline static public function exists<V>(map : Map<String, V>, key : String) : Bool
    return map.lookup(key, Strings.compare.fromIntComparison()).toBool();

  inline static public function get<V>(map : Map<String, V>, key : String) : Option<V>
    return map.lookup(key, Strings.compare.fromIntComparison());

  inline static public function getAlt<V>(map : Map<String, V>, key : String, alt : V) : V
    return map.lookup(key, Strings.compare.fromIntComparison()).getOrElse(alt);

  inline static public function set<V>(map : Map<String, V>, key : String, value : V) : Map<String, V>
    return map.insert(key, value, Strings.compare.fromIntComparison());
}

class FloatMap {
  inline static public function exists<V>(map : Map<Float, V>, key : Float) : Bool
    return map.lookup(key, Floats.compare.fromIntComparison()).toBool();

  inline static public function get<V>(map : Map<Float, V>, key : Float) : Option<V>
    return map.lookup(key, Floats.compare.fromIntComparison());

  inline static public function getAlt<V>(map : Map<Float, V>, key : Float, alt : V) : V
    return map.lookup(key, Floats.compare.fromIntComparison()).getOrElse(alt);

  inline static public function set<V>(map : Map<Float, V>, key : Float, value : V) : Map<Float, V>
    return map.insert(key, value, Floats.compare.fromIntComparison());
}

class IntMap {
  inline static public function exists<V>(map : Map<Int, V>, key : Int) : Bool
    return map.lookup(key, Ints.compare.fromIntComparison()).toBool();

  inline static public function get<V>(map : Map<Int, V>, key : Int) : Option<V>
    return map.lookup(key, Ints.compare.fromIntComparison());

  inline static public function getAlt<V>(map : Map<Int, V>, key : Int, alt : V) : V
    return map.lookup(key, Ints.compare.fromIntComparison()).getOrElse(alt);

  inline static public function set<V>(map : Map<Int, V>, key : Int, value : V) : Map<Int, V>
    return map.insert(key, value, Ints.compare.fromIntComparison());
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
}
