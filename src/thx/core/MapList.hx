package thx.core;

import haxe.Constraints.IMap;

abstract MapList<K, V>(MapListImpl<K, V>) to IMap<K, V> {
  inline public static function stringMap<V>() : MapList<String, V>
    return new MapList(new StringMapList());

  inline public static function intMap<V>() : MapList<Int, V>
    return new MapList(new IntMapList());

  inline public static function objectMap<K : {}, V>() : MapList<K, V>
    return new MapList(new ObjectMapList());

  inline public static function enumMap<K : EnumValue, V>() : MapList<K, V>
    return new MapList(new EnumValueMapList());

  inline function new(inst : MapListImpl<K, V>)
    this = inst;

  public inline function set(key : K, value : V) this.set(key, value);
  public inline function insert(index : Int, k : K, v : V) : Void this.insert(index, k, v);
  @:arrayAccess public inline function get(key : K) return this.get(key);
  @:arrayAccess public inline function at(index : Int) : Null<V> return this.at(index);
  public inline function exists(key : K) return this.exists(key);
  public inline function remove(key : K) return this.remove(key);
  public inline function keys():Iterator<K> return this.keys();
  public inline function iterator():Iterator<V> return this.iterator();
  public inline function toArray() : Array<V> return this.toArray();
  public inline function toString():String return this.toString();
  @:arrayAccess @:noCompletion inline public function arrayWrite(k : K, v : V) : V
    return this.setValue(k, v);
  public inline function keyAt(index : Int) : Null<K> return this.keyAt(index);
  public inline function keyIndex(k : K) : Int return this.keyIndex(k);
  public inline function valueIndex(v : V) : Int return this.valueIndex(v);
  public inline function removeAt(index : Int) : Bool return this.removeAt(index);

  public inline function self() : MapListImpl<K, V>
    return this;
}

class EnumValueMapList<K : EnumValue, V> extends MapListImpl<K, V> {
  public function new()
    super(new haxe.ds.EnumValueMap<K, V>());
}

class IntMapList<V> extends MapListImpl<Int, V> {
  public function new()
    super(new Map<Int,V>());
}

class ObjectMapList<K : {}, V> extends MapListImpl<K, V> {
  public function new()
    super(new haxe.ds.ObjectMap<K, V>());
}

class StringMapList<V> extends MapListImpl<String, V> {
  public function new()
    super(new Map<String,V>());
}

class MapListImpl<K, V> implements IMap<K, V> {
  var map : IMap<K, V>;
  var arr : Array<K>;

  public var length(default, null) : Int;

  function new(map : IMap<K, V>) {
    this.map = map;
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
    var values = [];
    for(k in arr)
      values.push(map.get(k));
    return values;
  }
}