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
}