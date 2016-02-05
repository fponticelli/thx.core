package thx.fp;

import haxe.ds.Option;
import thx.Ord;
#if (haxe_ver >= 3.200)
import haxe.Constraints.IMap;
#else
import Map.IMap;
#end

abstract Map<K, V>(MapImpl<K, V>) from MapImpl<K, V> to MapImpl<K, V> {
  inline public static function empty<K, V>() : Map<K, V>
    return Tip;
  inline public static function singleton<K, V>(k : K, v : V) : Map<K, V>
    return Bin(1, k, v, Tip, Tip);
  inline public static function bin<K, V>(k : K, v : V, lhs : Map<K, V>, rhs : Map<K, V>) : Map<K, V>
    return Bin(lhs.size() + rhs.size() + 1, k, v, lhs, rhs);

  public static function fromNative<K, V>(map : IMap<K, V>, comparator : Ord<K>) : Map<K, V> {
    var r = empty();
    for(key in map.keys())
      r = r.insert(key, map.get(key), comparator);
    return r;
  }

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

  public function lookupTuple(key : K, comparator : Ord<K>) : Option<Tuple<K, V>> switch this {
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
  };

  public function delete(key : K, comparator : Ord<K>) : Map<K, V> return switch this {
    case Tip:
      Tip;
    case Bin(size, kx, x, lhs, rhs):
      switch comparator(key, kx) {
        case LT: balance(kx, x, lhs.delete(key, comparator), rhs);
        case GT: balance(kx, x, lhs, rhs.delete(key, comparator));
        case EQ: lhs.glue(rhs);
      }
  };

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

  public function map<B>(f: V -> B): Map<K, B> return switch this {
    case Tip: Tip;
    case Bin(sz, ky, y, lhs, rhs): Bin(sz, ky, f(y), lhs.map(f), rhs.map(f));
  };

  public function values(): Array<V>
    return foldLeft([], function(acc, v) { acc.push(v); return acc; });

  public function foldLeftKeys<B>(b : B, f : B -> K -> B) : B
    return switch this {
      case Tip:
        b;
      case Bin(_, kx, _, l, r):
        r.foldLeftKeys(l.foldLeftKeys(f(b, kx), f), f);
    };

  public function foldLeftAll<B>(b: B, f: B -> K -> V -> B): B
    return switch this {
      case Tip:
        b;
      case Bin(_, kx, x, l, r):
        r.foldLeftAll(l.foldLeftAll(f(b, kx, x), f), f);
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
  static function balance<K, V>(k : K, x : V, lhs : Map<K, V>, rhs : Map<K, V>) : Map<K, V> {
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

  function glue(that : Map<K, V>) : Map<K, V> return switch [this, that] {
    case [Tip, _]: that;
    case [_, Tip]: this;
    case [l, r] if((l : Map<K, V>).size() > (r : Map<K, V>).size()):
      var t = deleteFindMax(l);
      balance(t.k, t.x, t.t, r);
    case [l, r]:
      var t = deleteFindMin(r);
      balance(t.k, t.x, l, t.t);
  };

  static function deleteFindMin<K, V>(map : Map<K, V>) return switch map {
    case Bin(_, k, x, Tip, r):
      { k : k, x : x, t : r};
    case Bin(_, k, x, l, r):
      var t = deleteFindMin(l);
      { k : t.k, x : t.x, t : balance(k, x, t.t, r) }
    case Tip:
      throw new thx.Error('can not return the minimal element of an empty map');
  };

  static function deleteFindMax<K, V>(map : Map<K, V>) return switch map {
    case Bin(_, k, x, l, Tip):
      { k : k, x : x, t : l };
    case Bin(_, k, x, l, r):
      var t = deleteFindMax(r);
      { k : t.k, x : t.x, t : balance(k, x, l, t.t) }
    case Tip:
      throw new thx.Error('can not return the maximal element of an empty map');
  };

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

enum MapImpl<K, V> {
  Tip;
  Bin(size : Int, key : K, value : V, lhs : Map<K, V>, rhs : Map<K, V>);
}
