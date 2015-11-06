package thx.fp;

import haxe.ds.Option;
import thx.Tuple;
import thx.Ord;
using thx.Options;
import thx.Strings;
import thx.Ints;
import thx.Floats;

abstract Map<K, V>(MapImpl<K, V>) from MapImpl<K, V> to MapImpl<K, V> {
  inline public static function empty<K, V>() : Map<K, V>
    return Tip;
  inline public static function singleton<K, V>(k : K, v : V) : Map<K, V>
    return Bin(1, k, v, Tip, Tip);
  inline public static function bin<K, V>(k : K, v : V, lhs : Map<K, V>, rhs : Map<K, V>) : Map<K, V>
    return Bin(lhs.size() + rhs.size() + 1, k, v, lhs, rhs);

  public function lookup(key : K, comparator : Ord<K>) : Option<V> {
    switch this {
      case Tip:
        return None;
      case Bin(size, xkey, xvalue, lhs, rhs):
        var c = comparator(key, xkey);
        switch c {
          case LT:
            return lhs.lookup(key, comparator);
          case GT:
            return rhs.lookup(key, comparator);
          case EQ:
            return Some(xvalue);
        };
    }
  }

  public function lookupTuple(key : K, comparator : Ord<K>) : Option<Tuple<K, V>> {
    switch this {
      case Tip:
        return None;
      case Bin(size, xkey, xvalue, lhs, rhs):
        var c = comparator(key, xkey);
        switch c {
          case LT:
            return lhs.lookupTuple(key, comparator);
          case GT:
            return rhs.lookupTuple(key, comparator);
          case EQ:
            return Some(new Tuple(xkey, xvalue));
        }
    }
  }

  public function insert(kx : K, x : V, comparator : Ord<K>) : Map<K, V> return switch this {
    case Tip:
      singleton(kx, x);
    case Bin(sz, ky, y, lhs, rhs):
      switch comparator(kx, ky) {
        case LT: balance(ky, y, lhs.insert(kx, x, comparator), rhs);
        case GT: balance(ky, y, lhs, rhs.insert(kx, x, comparator));
        case EQ: Bin(sz, kx, x, lhs, rhs);
      };
  };

  public function foldLeft<B>(b : B, f : B -> V -> B) : B
    return switch this {
      case Tip:
        b;
      case Bin(_, _, x, l, r):
        r.foldLeft(l.foldLeft(f(b, x), f), f);
    };

  public function foldLeftKeys<B>(b : B, f : B -> K -> B) : B
    return switch this {
      case Tip:
        b;
      case Bin(_, kx, _, l, r):
        r.foldLeftKeys(l.foldLeftKeys(f(b, kx), f), f);
    };

  public function foldLeftTuples<B>(b : B, f : B -> Tuple<K, V> -> B) : B
    return switch this {
      case Tip:
        b;
      case Bin(_, kx, x, l, r):
        r.foldLeftTuples(l.foldLeftTuples(f(b, new Tuple(kx, x)), f), f);
    };

  public function size()
    return switch this {
      case Tip: 0;
      case Bin(size, _, _, _, _): size;
    };

  // utility methods
  inline static var delta = 5;
  inline static var ratio = 2;
  function balance(k : K, x : V, lhs : Map<K, V>, rhs : Map<K, V>) : Map<K, V> {
    var ls = lhs.size(),
        rs = rhs.size(),
        xs = ls + rs + 1;
    if(ls + rs <= 1)
      return Bin(xs, k, x, lhs, rhs);
    else if(rs >= delta * ls)
      return rotateLeft(k, x, lhs, rhs);
    else if(ls >= delta * rs)
      return rotateRight(k, x, lhs, rhs);
    else
      return Bin(xs, k, x, lhs, rhs);
  }

  static function rotateLeft<K, V>(k : K, x : V, lhs : Map<K, V>, rhs : Map<K, V>) : Map<K, V>
    return switch rhs {
      case Bin(_, _, _, ly, ry) if(ly.size() < ratio * ry.size()):
        singleLeft(k, x, lhs, rhs);
      case _:
        doubleLeft(k, x, lhs, rhs);
    };

  static function rotateRight<K, V>(k : K, x : V, lhs : Map<K, V>, rhs : Map<K, V>) : Map<K, V>
    return switch lhs {
      case Bin(_, _, _, ly, ry) if(ry.size() < ratio * ly.size()):
        singleRight(k, x, lhs, rhs);
      case _:
        doubleRight(k, x, lhs, rhs);
    };

  static function singleLeft<K, V>(k1 : K, x1 : V, t1 : Map<K, V>, rhs : Map<K, V>) : Map<K, V>
    return switch rhs {
      case Bin(_, k2, x2, t2, t3): bin(k2, x2, bin(k1, x1, t1, t2), t3);
      case _: throw new thx.Error("damn it, this should never happen");
    };

  static function singleRight<K, V>(k1 : K, x1 : V, lhs : Map<K, V>, t3 : Map<K, V>) : Map<K, V>
    return switch lhs {
      case Bin(_, k2, x2, t1, t2): bin(k2, x2, t1, bin(k1, x1, t2, t3));
      case _: throw new thx.Error("damn it, this should never happen");
    };

  static function doubleLeft<K, V>(k1 : K, x1 : V, t1 : Map<K, V>, rhs : Map<K, V>) : Map<K, V>
    return switch rhs {
      case Bin(_, k2, x2, Bin(_, k3, x3, t2, t3), t4):
        bin(k3, x3, bin(k1, x1, t1, t2), bin(k2, x2, t3, t4));
      case _: throw new thx.Error("damn it, this should never happen");
    };

  static function doubleRight<K, V>(k1 : K, x1 : V, lhs : Map<K, V>, t4 : Map<K, V>) : Map<K, V>
    return switch lhs {
      case Bin(_, k2, x2, t1, Bin(_, k3, x3, t2, t3)):
        bin(k3, x3, bin(k2, x2, t1, t2), bin(k1, x1, t3, t4));
      case _: throw new thx.Error("damn it, this should never happen");
    };
}

class StringMap {
  inline static public function exists<V>(map : Map<String, V>, key : String) : Bool
    return map.lookup(key, Strings.compare).toBool();

  inline static public function get<V>(map : Map<String, V>, key : String) : Option<V>
    return map.lookup(key, Strings.compare);

  inline static public function getAlt<V>(map : Map<String, V>, key : String, alt : V) : V
    return map.lookup(key, Strings.compare).toValueWithAlt(alt);

  inline static public function set<V>(map : Map<String, V>, key : String, value : V) : Map<String, V>
    return map.insert(key, value, Strings.compare);
}

class FloatMap {
  inline static public function exists<V>(map : Map<Float, V>, key : Float) : Bool
    return map.lookup(key, Floats.compare).toBool();

  inline static public function get<V>(map : Map<Float, V>, key : Float) : Option<V>
    return map.lookup(key, Floats.compare);

  inline static public function getAlt<V>(map : Map<Float, V>, key : Float, alt : V) : V
    return map.lookup(key, Floats.compare).toValueWithAlt(alt);

  inline static public function set<V>(map : Map<Float, V>, key : Float, value : V) : Map<Float, V>
    return map.insert(key, value, Floats.compare);
}

class IntMap {
  inline static public function exists<V>(map : Map<Int, V>, key : Int) : Bool
    return map.lookup(key, Ints.compare).toBool();

  inline static public function get<V>(map : Map<Int, V>, key : Int) : Option<V>
    return map.lookup(key, Ints.compare);

  inline static public function getAlt<V>(map : Map<Int, V>, key : Int, alt : V) : V
    return map.lookup(key, Ints.compare).toValueWithAlt(alt);

  inline static public function set<V>(map : Map<Int, V>, key : Int, value : V) : Map<Int, V>
    return map.insert(key, value, Ints.compare);
}

class ComparableOrdMap {
  inline static public function exists<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T) : Bool
    return map.lookup(key, function(a, b) return a.compareTo(b)).toBool();

  inline static public function get<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T) : Option<V>
    return map.lookup(key, function(a : T, b : T) return a.compareTo(b));

  inline static public function getAlt<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T, alt : V) : V
    return map.lookup(key, function(a : T, b : T) return a.compareTo(b)).toValueWithAlt(alt);

  inline static public function set<V, T : ComparableOrd<T>>(map : Map<T, V>, key : T, value : V) : Map<T, V>
    return map.insert(key, value, function(a : T, b : T) return a.compareTo(b));
}

class ComparableMap {
  inline static public function exists<V, T : Comparable<T>>(map : Map<T, V>, key : T) : Bool
    return map.lookup(key, function(a, b) : Ordering return a.compareTo(b)).toBool();

  inline static public function get<V, T : Comparable<T>>(map : Map<T, V>, key : T) : Option<V>
    return map.lookup(key, function(a : T, b : T) : Ordering return a.compareTo(b));

  inline static public function getAlt<V, T : Comparable<T>>(map : Map<T, V>, key : T, alt : V) : V
    return map.lookup(key, function(a : T, b : T) : Ordering return a.compareTo(b)).toValueWithAlt(alt);

  inline static public function set<V, T : Comparable<T>>(map : Map<T, V>, key : T, value : V) : Map<T, V>
    return map.insert(key, value, function(a : T, b : T) : Ordering return a.compareTo(b));
}

enum MapImpl<K, V> {
  Tip;
  Bin(size : Int, key : K, value : V, lhs : Map<K, V>, rhs : Map<K, V>);
}
