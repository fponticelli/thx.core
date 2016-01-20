package thx;

import thx.Functions;

@:forward(length, copy, filter, iterator, join, map, slice, toString)
abstract ReadonlyArray<T>(Array<T>) from Array<T> {
  inline public static function empty<T>() : ReadonlyArray<T>
    return [];

  #if js inline #end
  public static function flatten<T>(array : ReadonlyArray<ReadonlyArray<T>>) : ReadonlyArray<T>
    #if js
      return untyped __js__('Array.prototype.concat.apply')([], array);
    #else
      return Arrays.reduce(array, function(acc : ReadonlyArray<T>, element) return acc.concat(element), []);
    #end

  public function indexOf(el : T, ?eq : T -> T -> Bool) : Int {
    if(null == eq) eq = Functions.equality;
    for(i in 0...this.length)
      if(eq(el, this[i]))
        return i;
    return -1;
  }

  public function lastIndexOf(el : T, ?eq : T -> T -> Bool) : Int {
    if(null == eq) eq = Functions.equality;
    var len = this.length;
    for(i in 0...len)
      if(eq(el, this[len-i-1]))
        return i;
    return -1;
  }

  @:arrayAccess
  inline function get(index : Int)
    return this[index];

  inline public function head() : Null<T>
    return this[0];

  inline public function tail() : ReadonlyArray<T>
    return this.slice(1);

  public function reverse() : ReadonlyArray<T> {
    var arr = this.copy();
    arr.reverse();
    return arr;
  }

  inline public function toArray() : Array<T>
    return this.copy();

  inline public function unsafe() : Array<T>
    return this;

  inline public function concat(that : ReadonlyArray<T>) : ReadonlyArray<T>
    return this.concat(that.unsafe());

  inline public function insertAt(pos : Int, el : T) : ReadonlyArray<T>
    return this.slice(0, pos).concat([el]).concat(this.slice(pos));

  public function insertAfter(ref : T, el : T, ?eq : T -> T -> Bool) : ReadonlyArray<T> {
    var pos = indexOf(ref, eq);
    if(pos < 0)
      pos = this.length - 1;
    return insertAt(pos+1, el);
  }

  inline public function insertBefore(ref : T, el : T, ?eq : T -> T -> Bool) : ReadonlyArray<T>
    return insertAt(indexOf(ref, eq), el);

  public function replace(ref : T, el : T, ?eq : T -> T -> Bool) : ReadonlyArray<T> {
    var pos = indexOf(ref, eq);
    if(pos < 0) throw new thx.Error('unable to find reference element');
    return replaceAt(pos, el);
  }

  inline public function replaceAt(pos : Int, el : T) : ReadonlyArray<T>
    return this.slice(0, pos).concat([el]).concat(this.slice(pos + 1));

    inline public function remove(el : T, ?eq : T -> T -> Bool) : ReadonlyArray<T>
    return removeAt(indexOf(el, eq));

  inline public function removeAt(pos : Int) : ReadonlyArray<T>
    return this.slice(0, pos).concat(this.slice(pos + 1));

  inline public function prepend(el : T) : ReadonlyArray<T>
    return [el].concat(this);

  inline public function append(el : T) : ReadonlyArray<T>
    return this.concat([el]);
}
