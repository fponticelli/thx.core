package thx.core;

class Iterables
{
	public inline static function map<T, S>(it : Iterable<T>, f : T -> S) : Array<S>
	{
		return Iterators.map(it.iterator());
	}
}