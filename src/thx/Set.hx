package thx;

/**
A set is a list of unique values.  Value equality is determined using `==`.

See thx.HashSet for an alternative set implementation that uses a hash code to determine item equality.
**/
abstract Set<T>(Map<T, Bool>) {
/**
Creates a Set of Strings with optional initial values.
**/
  public static function createString(?it : Iterable<String>) {
    var map = new Map<String, Bool>();
    var set = new Set<String>(map);
    if(null != it)
      set.pushMany(it);
    return set;
  }

/**
Creates a Set of Ints with optional initial values.
**/
  public static function createInt(?it : Iterable<Int>) {
    var map = new Map<Int, Bool>();
    var set = new Set<Int>(map);
    if(null != it)
      set.pushMany(it);
    return set;
  }

/**
Creates a Set of anonymous objects with optional initial values.
**/
  public static function createObject<T: {}>(?it : Iterable<T>) {
    var map = new Map<T, Bool>();
    var set = new Set<T>(map);
    if(null != it)
      set.pushMany(it);
    return set;
  }

/**
Creates a Set of EnumValue, with optional initial values.
**/
  public static function createEnum<T: EnumValue>(?arr : Iterable<T>) {
    var map = new Map<T, Bool>();
    var set = new Set<T>(map);
    if(null != arr)
      set.pushMany(arr);
    return set;
  }

  public var length(get, never) : Int;

  inline function new(map : Map<T, Bool>)
    this = map;

/**
`add` pushes a value into `Set` if the value was not already present.

It returns a boolean value indicating if `Set` was changed by the operation or not.
**/
  public function add(v : T) : Bool
    return if(this.exists(v))
      false;
    else {
      this.set(v, true);
      true;
    }

/**
`copy` creates a new `Set` with copied elements.
**/
  public function copy() : Set<T> {
    var inst = empty();
    for(k in this.keys())
      inst.push(k);
    return inst;
  }

/**
Creates an empty copy of the current set.
**/
  public function empty() : Set<T> {
    var inst : Map<T, Bool> = Type.createInstance(Type.getClass(this), []);
    return new Set(inst);
  }

/**
`difference` creates a new `Set` with elements from the first set excluding the elements
from the second.
**/
  @:op(A-B) inline public function difference(set : Set<T>) : Set<T> {
    var result = copy();
    for(item in set)
      result.remove(item);
    return result;
  }

  public function filter(predicate : T -> Bool) : Set<T>
    return reduce(function(acc : Set<T>, v : T) {
      if(predicate(v))
        acc.add(v);
      return acc;
    }, empty());

  public function map<TOut>(f : T -> TOut) : Array<TOut>
    return reduce(function(acc : Array<TOut>, v : T) {
      acc.push(f(v));
      return acc;
    }, []);

/**
`exists` returns `true` if it contains an element that is equals to `v`.
**/
  inline public function exists(v : T) : Bool
    return this.exists(v);

  inline public function remove(v : T) : Bool
    return this.remove(v);

/**
`intersection` returns a Set with elements that are presents in both sets
**/
  inline public function intersection(set : Set<T>) : Set<T> {
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

  public function reduce<TOut>(handler :  TOut -> T -> TOut, acc : TOut) : TOut {
    for(v in iterator()) {
      acc = handler(acc, v);
    }
    return acc;
  }

/**
Iterates the values of the Set.
**/
  public function iterator()
    return this.keys();

/**
Union creates a new Set with elements from both sets.
**/
  @:op(A+B) inline public function union(set : Set<T>) : Set<T> {
    var newset = copy();
    newset.pushMany(set);
    return newset;
  }

/**
Converts a `Set<T>` into `Array<T>`. The returned array is a copy of the internal
array used by `Set`. This ensures that the set is not affected by unsafe operations
that might happen on the returned array.
**/
  @:to public function toArray() : Array<T> {
    var arr : Array<T> = [];
    for(k in this.keys())
      arr.push(k);
    return arr;
  }

/**
Converts `Set` into `String`. To differentiate from normal `Array`s the output string
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
