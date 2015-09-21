package thx;

/**
A set is a list of unique values.
**/
@:forward(indexOf, iterator, lastIndexOf, length, map, pop, remove, reverse, shift, sort)
abstract OrderedSet<T>(Array<T>) {
/**
`arrayToOrderedSet` converts an `Array` into a `OrderedSet` removing all duplicated values.
**/
  @:from public static function toOrderedSet<T>(arr : Array<T>) {
    var set = new OrderedSet([]);
    for(v in arr)
      set.push(v);
    return set;
  }

  @:deprecated("use OrderedSet.toOrderedSet instead")
  public static function arrayToOrderedSet<T>(arr : Array<T>)
    return toOrderedSet(arr);

/**
Creates an empty OrderedSet if no argument is provided or it fallsback to `arrayToOrderedSet` otherwise.
**/
  public static function create<T>(?arr : Array<T>)
    return null == arr ? new OrderedSet<T>([]) : toOrderedSet(arr);

  inline function new(arr : Array<T>)
    this = arr;

/**
`add` pushes a value onto the end of the `OrderedSet` if the value was not already present.

It returns a boolean value indicating if `OrderedSet` was changed by the operation or not.
**/
  public function add(v : T) : Bool
    return if(exists(v))
      false;
    else {
      this.push(v);
      true;
    }

/**
`copy` creates a new `OrderedSet` with copied elements.
**/
  inline public function copy()
    return new OrderedSet(this.copy());

/**
`difference` creates a new `OrderedSet` with elements from the first set excluding the elements
from the second.
**/
  @:op(A-B) inline public function difference(set : OrderedSet<T>) : OrderedSet<T> {
    var result = this.copy();
    for(item in set)
      result.remove(item);
    return new OrderedSet(result);
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
`intersection` returns a OrderedSet with elements that are presents in both sets
**/
  inline public function intersection(set : OrderedSet<T>) : OrderedSet<T> {
    var result = [];
    for(item in this)
      if(set.exists(item))
        result.push(item);
    return new OrderedSet(result);
  }

/**
Like `add` but doesn't notify if the addition was successful or not.
**/
  public function push(v : T) : Void
    add(v);

/**
Pushes many values to the set
**/
  public function pushMany(values : Iterable<T>) : Void
    for(value in values)
      push(value);

/**
Same operations as `Array.slice()` but it returns a new `OrderedSet` instead of an array.
**/
  inline public function slice(pos : Int, ?end : Int) : OrderedSet<T>
    return new OrderedSet(this.slice(pos, end));

/**
Same operations as `Array.splice()` but it returns a new `OrderedSet` instead of an array.
**/
  inline public function splice(pos : Int, len : Int) : OrderedSet<T>
    return new OrderedSet(this.splice(pos, len));

/**
Union creates a new OrderedSet with elements from both sets.
**/
  @:op(A+B) inline public function union(set : OrderedSet<T>) : OrderedSet<T>
    return toOrderedSet(this.concat(set.toArray()));

/**
Union creates a new OrderedSet with elements from both sets.
**/
  @:op(A+B) inline public function unionArray(set : Array<T>) : OrderedSet<T>
    return toOrderedSet(this.concat(set));

/**
Converts a `OrderedSet<T>` into `Array<T>`. The returned array is a copy of the internal
array used by `OrderedSet`. This ensures that the set is not affected by unsafe operations
that might happen on the returned array.
**/
  @:to public function toArray()
    return this.copy();

  @:deprecated("use OrderedSet.toArray instead")
  public function setToArray()
    return toArray();

/**
Converts `OrderedSet` into `String`. To differentiate from normal `Array`s the output string
uses curly braces `{}` instead of square brackets `[]`.
**/
  @:to public function toString()
    return "{" + this.join(", ") + "}";
}
