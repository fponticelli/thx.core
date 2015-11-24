package thx;

@:forward(length, concat, copy, filter, indexOf, iterator, join, lastIndexOf,
          map, slice, toString)
abstract ReadonlyArray<T>(Array<T>) from Array<T> {
  inline public static function empty<T>() : ReadonlyArray<T>
    return [];

  @:arrayAccess
  inline function get(index : Int)
    return this[index];

  inline public function toArray() : Array<T>
    return this.copy();

  inline public function unsafe() : Array<T>
    return this;
}
