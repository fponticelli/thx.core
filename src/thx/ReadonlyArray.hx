package thx;

@:forward(length, concat, copy, filter, indexOf, iterator, join, lastIndexOf,
          map, slice, toString)
abstract ReadonlyArray<T>(Array<T>) from Array<T> {
  @:arrayAccess
  inline function get(index : Int)
    return this[index];
}
