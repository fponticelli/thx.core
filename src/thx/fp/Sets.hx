package thx.fp;

using thx.Ord;

class StringSet {
  inline static public function exists(set : Set<String>, value : String) : Bool
    return set.member(value, Strings.compare.fromIntComparison());

  inline static public function set(set : Set<String>, value : String) : Set<String>
    return set.insert(value, Strings.compare.fromIntComparison());
}

class FloatSet {
  inline static public function exists(set : Set<Float>, value : Float) : Bool
    return set.member(value, Floats.compare.fromIntComparison());

  inline static public function set(set : Set<Float>, value : Float) : Set<Float>
    return set.insert(value, Floats.compare.fromIntComparison());
}

class IntSet {
  inline static public function exists(set : Set<Int>, value : Int) : Bool
    return set.member(value, Ints.compare.fromIntComparison());

  inline static public function set(set : Set<Int>, value : Int) : Set<Int>
    return set.insert(value, Ints.compare.fromIntComparison());
}

class ComparableOrdSet {
  inline static public function exists<X : ComparableOrd<X>>(set : Set<X>, value : X) : Bool
    return set.member(value, function(a, b) return a.compareTo(b));

  inline static public function set<X : ComparableOrd<X>>(set : Set<X>, value : X) : Set<X>
    return set.insert(value, function(a : X, b : X) return a.compareTo(b));
}

class ComparableSet {
  inline static public function exists<X : Comparable<X>>(set : Set<X>, value : X) : Bool
    return set.member(value, function(a, b) : Ordering return a.compareTo(b).fromInt());

  inline static public function set<X : Comparable<X>>(set : Set<X>, value : X) : Set<X>
    return set.insert(value, function(a : X, b : X) : Ordering return a.compareTo(b).fromInt());
}
