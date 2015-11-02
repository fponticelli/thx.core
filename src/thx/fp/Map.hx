package thx.fp;

import haxe.ds.Option;
import thx.Tuple;
using thx.Options;

abstract Map<K, V>(MapImpl<K, V>) from MapImpl<K, V> to MapImpl<K, V> {
  inline public static function empty<K, V>() : Map<K, V>
    return Tip;
  inline public static function singleton<K, V>(k : K, v : V) : Map<K, V>
    return Bin(1, k, v, Tip, Tip);
  inline public static function bin<K, V>(k : K, v : V, lhs : Map<K, V>, rhs : Map<K, V>) : Map<K, V>
    return Bin(lhs.size() + 1 + rhs.size() + 1, k, v, lhs, rhs);

  public function get(key : K, comparator : K -> K -> Int) : Option<V> {
    switch this {
      case Tip:
        return None;
      case Bin(size, xkey, xvalue, lhs, rhs):
        var c = comparator(key, xkey);
        if(c < 0)
          return lhs.get(key, comparator);
        else if(c > 0)
          return rhs.get(key, comparator);
        else
          return Some(xvalue);
    }
  }

  public function getAlt(key : K, alt : V, comparator : K -> K -> Int) : V
    return get(key, comparator).toValueWithAlt(alt);

  public function getTuple(key : K, comparator : K -> K -> Int) : Option<Tuple<K, V>> {
    switch this {
      case Tip:
        return None;
      case Bin(size, xkey, xvalue, lhs, rhs):
        var c = comparator(key, xkey);
        if(c < 0)
          return lhs.getTuple(key, comparator);
        else if(c > 0)
          return rhs.getTuple(key, comparator);
        else
          return Some(new Tuple(xkey, xvalue));
    }
  }

  public function exists(key : K, ?comparator : K -> K -> Int) : Bool
    return get(key, comparator).toBool();

  public function size()
    return switch this {
      case Tip: 0;
      case Bin(size, _, _, _, _): size;
    };

  inline static var delta = 5;
  inline static var ratio = 2;
  function balance(key : K, value : V, lhs : Map<K, V>, rhs : Map<K, V>) : Map<K, V> {
    var ls = lhs.size(),
        rs = rhs.size();
    if(ls + rs <= 1)
      return Bin(ls + rs + 1, key, value, lhs, rhs);
    else if(rs >= delta * ls)
      return rotateLeft(key, value, lhs, rhs);
    else if(ls >= delta * rs)
      return rotateRight(key, value, lhs, rhs);
    else
      return Bin(ls + rs + 1, key, value, lhs, rhs);
  }

  static function rotateLeft<K, V>(key : K, value : V, lhs : Map<K, V>, rhs : Map<K, V>) : Map<K, V>
    return switch rhs {
      case Bin(_, _, _, ly, ry) if(ly.size() < ratio * ry.size()):
        singleLeft(key, value, lhs, rhs);
      case _:
        doubleLeft(key, value, lhs, rhs);
    };

  static function rotateRight<K, V>(key : K, value : V, lhs : Map<K, V>, rhs : Map<K, V>) : Map<K, V>
    return switch lhs {
      case Bin(_, _, _, ly, ry) if(ry.size() < ratio * ly.size()):
        singleRight(key, value, lhs, rhs);
      case _:
        doubleRight(key, value, lhs, rhs);
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

enum MapImpl<K, V> {
  Tip;
  Bin(size : Int, key : K, value : V, lhs : Map<K, V>, rhs : Map<K, V>);
}

/*
interface ImmutableMap<K, V> {
  public function get(key : K) : Option<V>;
  public function set(key : K, value : V) : ImmutableMap<K, V>;
}
*/
