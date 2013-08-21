/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

class Set<T>
{
	public static function ofArray<T>(arr : Array<T>) : Set<T>
	{
		var set = new Set();
		for (item in arr)
			set.add(item);
		return set;
	}
	
	public var length : Int;
	var _v : Array<T>;
	public function new()
	{
		_v = [];
		length = 0;
	}
	
	public function add(v : T) : Void
	{
		_v.remove(v);
		_v.push(v);
		length = _v.length;
	}
	
	public function remove(v : T) : Bool
	{
		var t = _v.remove(v);
		length = _v.length;
		return t;
	}
	
	public function exists(v : T) : Bool
	{
		for (t in _v)
			if (t == v)
				return true;
		return false;
	}
	
	public function iterator()
	{
		return _v.iterator();
	}
	
	public function array()
	{
		return _v.copy();
	}
	
	public function toString()
	{
		return "{" + _v.join(", ") + "}";
	}
}