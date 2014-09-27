package thx.core;

/**
A set is a list of unique values.
**/
@:forward(indexOf, iterator, lastIndexOf, length, map, pop, remove, reverse, shift, sort)
abstract Set<T>(Array<T>) {
  @:from public static function arrayToSet(arr : Array<T>) {
    var set = new Set([]);
    for(v in arr)
      set.push(v);
    return set;
  }

  inline function new(arr : Array<T>)
    this = arr;

  public function add(v : T) : Bool
    return if(exists(v))
      false;
    else {
      this.push(v);
      true;
    }

  inline public function copy()
    return new Set(this.copy());

  public function exists(v : T) : Bool {
    for (t in this)
      if (t == v)
        return true;
    return false;
  }

  @:arrayAccess
  inline public function get(index : Int)
    return this[index];

  inline public function push(v : T) : Void
    add(v);

  inline public function slice(pos : Int, ?end : Int) : Set<T>
    return new Set(this.slice(pos, end));

  inline public function splice(pos : Int, len : Int) : Set<T>
    return new Set(this.splice(pos, len));

  @:to public function setToArray()
    return this.copy();

  @:to public function toString()
    return "{" + this.join(", ") + "}";
}