package thx;

import haxe.ds.HashMap;

/**
A set is a list of unique, hashable values.  Equality of items is determined using
a required `function hashCode():Int` on the item instances.
**/
abstract HashSet<T : { function hashCode(): Int; }>(HashMap<T, Bool>) {
/**
Gives the number of items in the HashSet
**/
  public var length(get, never) : Int;

/**
Constructor is private - use HashSet.create to create new instances
**/
  inline function new(map : HashMap<T, Bool>)
    this = map;

/**
Creates a new HashSet with optional intial values.
**/
  public static function create<T : { function hashCode(): Int; }>(?arr : Iterable<T>) : HashSet<T> {
    var map : HashMap<T, Bool> = new HashMap();
    var hashSet : HashSet<T> = new HashSet(map);
    if(null != arr)
      hashSet.pushMany(arr);
    return hashSet;
  }

/**
`add` pushes a value into `HashSet` if the value was not already present.

It returns a boolean value indicating if `HashSet` was changed by the operation or not.
**/
  public function add(v : T) : Bool
    return if(this.exists(v))
      false;
    else {
      this.set(v, true);
      true;
    }

/**
`copy` creates a new `HashSet` with copied elements.
**/
  public function copy() : HashSet<T> {
    var inst = empty();
    for(k in this.keys())
      inst.push(k);
    return inst;
  }

/**
`empty` creates an empty copy of the current HashSet.
**/
  public function empty() : HashSet<T> {
    var map : HashMap<T, Bool> = Type.createInstance(Type.getClass(this), []);
    return new HashSet(map);
  }

/**
`difference` creates a new `HashSet` with elements from the first set excluding the elements
from the second.
**/
  @:op(A-B) inline public function difference(set : HashSet<T>) : HashSet<T> {
    var result = copy();
    for(item in set)
      result.remove(item);
    return result;
  }

/**
`symmetricDifference` creates a new `HashSet` with elements that appear in either of the sets, but not in both.

Equivalent to: `s1.union(s2) - s1.intersection(s2)`
**/
  @:op(A-B) inline public function symmetricDifference(set : HashSet<T>) : HashSet<T> {
    var self = copy();
    return self.union(set) - self.intersection(set);
  }

/**
`exists` returns `true` if it contains an element that is equals to `v`.
**/
  inline public function exists(v : T) : Bool
    return this.exists(v);

/**
`remove` removes an item from the HashSet.
**/
  inline public function remove(v : T) : Bool
    return this.remove(v);

/**
`intersection` returns a HashSet with elements that are presents in both sets
**/
  inline public function intersection(set : HashSet<T>) : HashSet<T> {
    var result = empty();
    for(item in iterator())
      if(set.exists(item))
        result.push(item);
    return result;
  }

/**
Like `add` but doesn't notify if the addition was successful or not.
**/
  inline public function push(v : T) : Void
    this.set(v, true);

/**
Pushes many values to the set
**/
  public function pushMany(values : Iterable<T>) : Void
    for(value in values)
      push(value);

/**
Iterates the values of the HashSet.
**/
  public function iterator()
    return this.keys();

/**
Union creates a new HashSet with elements from both sets.
**/
  @:op(A+B) inline public function union(set : HashSet<T>) : HashSet<T> {
    var newset = copy();
    for(k in set.iterator())
      newset.push(k);
    return newset;
  }

/**
Converts a `HashSet<T>` into `Array<T>`. The returned array is a copy of the internal
array used by `HashSet`. This ensures that the set is not affected by unsafe operations
that might happen on the returned array.
**/
  @:to public function toArray() : Array<T> {
    var arr : Array<T> = [];
    for(k in this.keys())
      arr.push(k);
    return arr;
  }

/**
Converts `HashSet` to `String`. To differentiate from normal `Array`s the output string
uses curly braces `{}` instead of square brackets `[]`.
**/
  @:to public function toString()
    return "{" + toArray().join(", ") + "}";

  function get_length() {
    var l = 0;
    for(i in this)
      ++l;
    return l;
  }
}
