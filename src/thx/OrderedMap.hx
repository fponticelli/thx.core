package thx;

import haxe.Constraints.IMap;
import thx.Tuple;

@:forward(length, set, insert, exists, remove, keys, iterator, tuples, toArray, toString, keyAt, keyIndex, valueIndex, removeAt)
abstract OrderedMap<K, V>(OrderedMapImpl<K, V>) to IMap<K, V> {
  inline public static function createString<K : String, V>() : OrderedMap<K, V>
    return new OrderedMap(new StringOrderedMap());

#if !cs
  // C# doesn't really like this, if you have a solution please make a PR
  inline public static function createInt<K : Int, V>() : OrderedMap<K, V>
    return new OrderedMap(new IntOrderedMap());
#end

  inline public static function createObject<K : {}, V>() : OrderedMap<K, V>
    return new OrderedMap(new ObjectOrderedMap());

  inline public static function createEnum<K : EnumValue, V>() : OrderedMap<K, V>
    return new OrderedMap(new EnumValueOrderedMap());

  inline function new(inst : OrderedMapImpl<K, V>)
    this = inst;

  inline public function getOption(key : K)
    return Options.ofValue(get(key));

  inline public function empty() : OrderedMap<K, V>
    return new OrderedMap(this.empty());

  inline public function copyTo(that : OrderedMap<K, V>) : OrderedMap<K, V> {
    for(key in this.keys())
      that.set(key, this.get(key));
    return that;
  }

  inline public function clone() : OrderedMap<K, V>
    return copyTo(empty());

  inline public function clear()
    this = this.empty();

  @:arrayAccess public inline function get(key : K)
    return this.get(key);

  @:arrayAccess public inline function at(index : Int) : Null<V>
    return this.at(index);

  @:arrayAccess @:noCompletion inline public function arrayWrite(k : K, v : V) : V
    return this.setValue(k, v);

  public inline function self() : OrderedMapImpl<K, V>
    return this;
}

class EnumValueOrderedMap<K : EnumValue, V> extends OrderedMapImpl<K, V> {
  public function new()
    super(new haxe.ds.EnumValueMap<K, V>());

  override public function empty() : OrderedMapImpl<K, V>
    return new EnumValueOrderedMap();
}

class IntOrderedMap<K : Int, V> extends OrderedMapImpl<K, V> {
  public function new()
    super(cast new haxe.ds.IntMap());

  override public function empty() : OrderedMapImpl<K, V>
    return new IntOrderedMap();
}

class ObjectOrderedMap<K : {}, V> extends OrderedMapImpl<K, V> {
  public function new()
    super(new haxe.ds.ObjectMap<K, V>());

  override public function empty() : OrderedMapImpl<K, V>
    return new ObjectOrderedMap();
}

class StringOrderedMap<K : String, V> extends OrderedMapImpl<K, V> {
  public function new()
    super(new Map<K,V>());

  override public function empty() : OrderedMapImpl<K, V>
    return new StringOrderedMap();

  public static function fromArray<T, K : String, V>(array : ReadonlyArray<T>, toKey : T -> K, toVal : T -> V) : OrderedMap<K, V>
    return Arrays.reduce(array, function (acc : OrderedMap<K, V>, curr : T) {
      acc.set(toKey(curr), toVal(curr));
      return acc;
    }, OrderedMap.createString());

  public static inline function fromValueArray<K : String, V>(array : ReadonlyArray<V>, toKey : V -> K) : OrderedMap<K, V>
    return fromArray(array, toKey, function (val) return val);

  public static inline function fromTuples<K : String, V>(array : ReadonlyArray<Tuple<K, V>>) : OrderedMap<K, V>
    return fromArray(array, function (t) return t.left, function (t) return t.right);
}

class OrderedMapImpl<K, V> implements IMap<K, V> {
  var map : IMap<K, V>;
  var arr : Array<K>;

  public var length(default, null) : Int;

  function new(map : IMap<K, V>) {
    this.map = map;
    this.arr = [];
    this.length = 0;
  }

  public function clear() {
    this.map.clear();
    this.arr = [];
    this.length = 0;
  }

  public function get(k : K) : Null<V>
    return map.get(k);

  public function keyAt(index : Int) : Null<K>
    return arr[index];

  public function keyIndex(k : K) : Int {
    for(i in 0...arr.length)
      if(arr[i] == k)
        return i;
    return -1;
  }

  public function valueIndex(v : V) : Int {
    for(i in 0...arr.length)
      if(map.get(arr[i]) == v)
        return i;
    return -1;
  }

  public function at(index : Int) : Null<V>
    return map.get(keyAt(index));

  public function set(k : K, v : V) : Void {
    if(!map.exists(k)) {
      arr.push(k);
      length++;
    }
    map.set(k, v);
  }

  public function empty() : OrderedMapImpl<K, V>
    return throw new thx.error.AbstractMethod();

  @:noCompletion
  public function setValue(k : K, v : V) : V {
    set(k, v);
    return v;
  }

  public function insert(index : Int, k : K, v : V) : Void {
    remove(k);
    arr.insert(index, k);
    map.set(k, v);
    length++;
  }

  public function exists(k : K) : Bool
    return map.exists(k);

  public function remove(k : K) : Bool {
    if(!map.exists(k)) return false;
    map.remove(k);
    arr.remove(k);
    length--;
    return true;
  }

  public function removeAt(index : Int) : Bool {
    var key = arr[index];
    if (key == null)
      return false;
    map.remove(key);
    arr.remove(key);
    length--;
    return true;
  }

  public function keys() : Iterator<K>
    return arr.iterator();

  public function iterator() : Iterator<V>
    return toArray().iterator();

  public function tuples() : Array<Tuple2<K, V>>
    return arr.map(function (key)
      return new Tuple2(key, map.get(key)));

  public function keyValueIterator ():KeyValueIterator<K, V>
    return arr.map((key) -> {key:key, value: map.get(key)}).iterator();

  public function toString() : String {
    var s = "";
    s += "[";
    var it = keys();
    for(k in it) {
      s += k;
      s += " => ";
      s += map.get(k);
      if(it.hasNext())
        s += ", ";
    }
    s += "]";
    return s;
  }

  public function toArray() : Array<V> {
    var values : Array<V> = [];
    for(k in arr)
      values.push(map.get(k));
    return values;
  }

  public function copy() : OrderedMapImpl<K, V> {
    var target = empty();
    for(k in keys())
      target.set(k, get(k));
    return target;
  }
}
