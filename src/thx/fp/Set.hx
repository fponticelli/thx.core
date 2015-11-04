package thx.fp;

import thx.Ord;

abstract Set<T>(SetImpl<T>) from SetImpl<T> to SetImpl<T> {
  inline public static function empty<T>() : Set<T>
    return Tip;
  inline public static function singleton<T>(x : T) : Set<T>
    return Bin(1, x, Tip, Tip);
  inline public static function bin<T>(x : T, l : Set<T>, r : Set<T>) : Set<T>
    return Bin(l.size() + r.size() + 1, x, l, r);

  public function isEmpty() : Bool return switch this {
    case Tip: true;
    case Bin(_): false;
  };

  public function size() : Int return switch this {
    case Tip: 0;
    case Bin(sz, _): sz;
  };

  public function member(x : T, comparator : Ord<T>) : Bool return switch this {
    case Tip: false;
    case Bin(sz, y, l, r): switch comparator(x, y) {
      case LT: l.member(x, comparator);
      case GT: r.member(x, comparator);
      case EQ: true;
    };
  };

  public function insert(x : T, comparator : Ord<T>) : Set<T> return switch this {
    case Tip: singleton(x);
    case Bin(sz, y, l, r): switch comparator(x, y) {
      case LT: l.balance(y, l.insert(x, comparator), r);
      case GT: r.balance(y, l, r.insert(x, comparator));
      case EQ: Bin(sz, x, l, r);
    };
  }

  // helper functions
  inline static var delta = 4;
  inline static var ratio = 4;
  function balance(x : T, l : Set<T>, r : Set<T>) : Set<T> {
    var sl = l.size(),
        sr = r.size(),
        sx = sl + sr + 1;
    if(sl + sr <= 1) {
      return Bin(sx, x, l, r);
    } else if(sr >= delta * sl) {
      return rotateLeft(x, l, r);
    } else if(sl >= delta * sr) {
      return rotateRight(x, l, r);
    } else {
      return Bin(sx, x, l, r);
    }
  }

  static function rotateLeft<T>(x : T, l : Set<T>, r : Set<T>) : Set<T>
    return switch r {
      case Bin(_, _, ly, ry) if(ly.size() < ratio * ry.size()):
        singleLeft(x, l, r);
      case _:
        doubleLeft(x, l, r);
    };

  static function rotateRight<T>(x : T, l : Set<T>, r : Set<T>) : Set<T>
    return switch l {
      case Bin(_, _, ly, ry) if(ry.size() < ratio * ly.size()):
        singleRight(x, l, r);
      case _:
        doubleRight(x, l, r);
    };

  static function singleLeft<T>(x1 : T, t1 : Set<T>, r : Set<T>) : Set<T>
    return switch r {
      case Bin(_, x2, t2, t3): bin(x2, bin(x1, t1, t2), t3);
      case _: throw new thx.Error("damn it, this should never happen");
    };

  static function singleRight<T>(x1 : T, l : Set<T>, t3 : Set<T>) : Set<T>
    return switch l {
      case Bin(_, x2, t1, t2): bin(x2, t1, bin(x1, t2, t3));
      case _: throw new thx.Error("damn it, this should never happen");
    };

  static function doubleLeft<T>(x1 : T, t1 : Set<T>, r : Set<T>) : Set<T>
    return switch r {
      case Bin(_, x2, Bin(_, x3, t2, t3), t4):
        bin(x3, bin(x1, t1, t2), bin(x2, t3, t4));
      case _: throw new thx.Error("damn it, this should never happen");
    };

  static function doubleRight<T>(x1 : T, l : Set<T>, t4 : Set<T>) : Set<T>
    return switch l {
      case Bin(_, x2, t1, Bin(_, x3, t2, t3)):
        bin(x3, bin(x2, t1, t2), bin(x1, t3, t4));
      case _: throw new thx.Error("damn it, this should never happen");
    };
}

class StringSet {
  inline static public function exists(set : Set<String>, value : String) : Bool
    return set.member(value, Strings.compare);

  inline static public function set(set : Set<String>, value : String) : Set<String>
    return set.insert(value, Strings.compare);
}

class FloatSet {
  inline static public function exists(set : Set<Float>, value : Float) : Bool
    return set.member(value, Floats.compare);

  inline static public function set(set : Set<Float>, value : Float) : Set<Float>
    return set.insert(value, Floats.compare);
}

class IntSet {
  inline static public function exists(set : Set<Int>, value : Int) : Bool
    return set.member(value, Ints.compare);

  inline static public function set(set : Set<Int>, value : Int) : Set<Int>
    return set.insert(value, Ints.compare);
}

class ComparableOrdSet {
  inline static public function exists<T : ComparableOrd<T>>(set : Set<T>, value : T) : Bool
    return set.member(value, function(a, b) return a.compareTo(b));

  inline static public function set<T : ComparableOrd<T>>(set : Set<T>, value : T) : Set<T>
    return set.insert(value, function(a : T, b : T) return a.compareTo(b));
}

class ComparableSet {
  inline static public function exists<T : Comparable<T>>(set : Set<T>, value : T) : Bool
    return set.member(value, function(a, b) : Ordering return a.compareTo(b));

  inline static public function set<T : Comparable<T>>(set : Set<T>, value : T) : Set<T>
    return set.insert(value, function(a : T, b : T) : Ordering return a.compareTo(b));
}

enum SetImpl<T> {
  Tip;
  Bin(size : Int, x : T, l : Set<T>, r : Set<T>);
}
