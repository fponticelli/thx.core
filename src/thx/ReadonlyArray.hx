package thx;

@:forward(length, copy, filter, indexOf, iterator, join, lastIndexOf,
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

  inline public function concat(that : ReadonlyArray<T>) : ReadonlyArray<T>
    return this.concat(that.unsafe());

  inline public function insertAt(pos : Int, el : T) : ReadonlyArray<T>
    return this.slice(0, pos).concat([el]).concat(this.slice(pos));

  inline public function replaceAt(pos : Int, el : T) : ReadonlyArray<T>
    return this.slice(0, pos).concat([el]).concat(this.slice(pos + 1));
}
