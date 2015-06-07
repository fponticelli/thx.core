package thx;

/**
A set is a list of unique values.
**/
@:forward(indexOf, iterator, lastIndexOf, length, map, pop, remove, reverse, shift, sort)
abstract Set<T>(Array<T>) {
/**
`arrayToSet` converts an `Array` into a `Set` removing all duplicated values.
**/
  @:from public static function arrayToSet<T>(arr : Array<T>) {
    var set = new Set([]);
    for(v in arr)
      set.push(v);
    return set;
  }

/**
Creates an empty Set if no argument is provided or it fallsback to `arrayToSet` otherwise.
**/
  public static function create<T>(?arr : Array<T>)
    return null == arr ? new Set<T>([]) : arrayToSet(arr);

  inline function new(arr : Array<T>)
    this = arr;

/**
`add` pushes a value onto the end of the `Set` if the value was not already present.

It returns a boolean value indicating if the `Set` was changed by operation or not.
**/
  public function add(v : T) : Bool
    return if(exists(v))
      false;
    else {
      this.push(v);
      true;
    }

/**
`copy` creates a new `Set` with copied elements.
**/
  inline public function copy()
    return new Set(this.copy());

/**
`difference` creates a new `Set` with elements from the first set excluding the elements
from the second.
**/
  @:op(A-B) inline public function difference(set : Set<T>) : Set<T> {
    var result = this.copy();
    for(item in set)
      result.remove(item);
    return new Set(result);
  }

/**
`exists` returns `true` if it contains an element that is equals to `v`.
**/
  public function exists(v : T) : Bool {
    for (t in this)
      if (t == v)
        return true;
    return false;
  }

/**
`get` returns the element at the specified position or `null` if the `index` is
outside the boundaries.
**/
  @:arrayAccess
  inline public function get(index : Int) : Null<T>
    return this[index];

/**
`intersection` returns a Set with elements that are presents in both sets
**/
  inline public function intersection(set : Set<T>) : Set<T> {
    var result = [];
    for(item in this)
      if(set.exists(item))
        result.push(item);
    return new Set(result);
  }

/**
Like `add` but doesn't notify if the addition was successful or not.
**/
  public function push(v : T) : Void
    add(v);

/**
Same operations as `Array.slice()` but it returns a new `Set` instead of an array.
**/
  inline public function slice(pos : Int, ?end : Int) : Set<T>
    return new Set(this.slice(pos, end));

/**
Same operations as `Array.splice()` but it returns a new `Set` instead of an array.
**/
  inline public function splice(pos : Int, len : Int) : Set<T>
    return new Set(this.splice(pos, len));

/**
Union creates a new Set with elements from bots sets.
**/
  @:op(A+B) inline public function union(set : Set<T>) : Set<T>
    return arrayToSet(this.concat(set.setToArray()));

/**
Converts a `Set<T>` into `Array<T>`. The returned array is a copy of the internal
array used by `Set`. This ensures that the set is not affected by unsafe operations
that might happen on the returned array.
**/
  @:to public function setToArray()
    return this.copy();

/**
Converts `Set` into `String`. To differentiate from normal `Array`s the output string
uses curly braces `{}` instead of square brackets `[]`.
**/
  @:to public function toString()
    return "{" + this.join(", ") + "}";
}