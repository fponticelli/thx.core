package thx;

#if (haxe_ver >= 3.200)
import haxe.Constraints.IMap;
#else
import Map.IMap;
#end
using thx.Iterators;

/**
`IMap` wrapper for anonymous objects. It allows to use anonymous objects
as sources for IMap without the need of explicitely extracting all of its values.

```haxe
var map = new AnonymousMap({ a : "A", b : "B" });
trace(map.get("a"));
```

The API is exactly the same for `Map<TKey, TValue>`.
**/
class AnonymousMap<V> implements IMap<String, V> {
  var o : {};

/**
Creates an instance of `IMap<String, V>` (`AnonymousMap<V>`) out of an anonymous object.

Note that using this class any operation that is expected to change the state of the `Map`
is going to change the state of the underlying anonymous object.
**/
  public function new(o : {})
    this.o = o;

  public function clear()
    this.o = {};

/**
It gets the value at the specified key.
**/
  public function get(k : String) : Null<V>
    return Reflect.field(o, k);

/**
Null-safe get
**/
  public function getOption(k : String) : haxe.ds.Option<V>
    return Options.ofValue(get(k));

/**
`getObject` returns the undetlying anonymous object.
**/
  public inline function getObject() : {}
    return o;

/**
It sets the value at the specified key.
**/
  public function set(k : String, v : V) : Void
    Reflect.setField(o, k, v);

/**
It returns true if the object contains a field with key `k`.
**/
  public function exists(k : String) : Bool
    return Reflect.hasField(o, k);

/**
It removes the field `k` from the underlying obejct. The function returns `true`
if the removal was successful.
**/
  public function remove(k : String) : Bool
    return Reflect.deleteField(o, k);

/**
It returns an iterator of strings containing all the field keys in the object.
**/
  public function keys() : Iterator<String>
    return Reflect.fields(o).iterator();

/**
It returns an iterator of values in the object.
**/
  public function iterator() : Iterator<V>
    return keys().fmap(Reflect.field.bind(o, _));

/**
It returns a string representation of the object.
**/
  public function toString() : String
    return
      '{ '
      + Maps.tuples(this)
        .map(function(t) return t._0 + " => " + t._1)
        .join(", ")
      + ' }';

  public function copy() : AnonymousMap<V> {
    var target: AnonymousMap<V> = new AnonymousMap({});
    for(k in keys())
      target.set(k, get(k));
    return target;
  }

	public function keyValueIterator():KeyValueIterator<String, V> {
		var a = [];
		for (key in keys()) {
			a.push({key: key, value: get(key)});
		}
		a.sort((a, b) -> Reflect.compare(a.key, b.key));
		return a.iterator();
	}
}
