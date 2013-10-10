package thx.core;

class Iterators
{
	public static function map<T, S>(it : Iterator<T>, f : T -> S) : Array<S>
	{
		var acc = [];
		for(v in it)
			acc.push(f(v));
		return acc;
	}

  public static function toArray<T>(it : Iterator<T>) : Array<T>
  {
    var items = [];
    for(item in it)
      items.push(item);
    return items;
  }

  public static function order<T>(it : Iterator<T>, sort : T -> T -> Int)
  {
    var n = Iterators.toArray(it);
    n.sort(sort);
    return n;
  }
}