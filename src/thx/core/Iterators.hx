package thx.core;

class Iterators {
	public static function map<T, S>(it : Iterator<T>, f : T -> S) : Array<S> {
		var acc = [];
		for(v in it)
			acc.push(f(v));
		return acc;
	}

	public static function mapi<T, S>(it : Iterator<T>, f : T -> Int -> S) : Array<S> {
		var acc = [],
			i = 0;
		for(v in it)
			acc.push(f(v, i++));
		return acc;
	}

	public static function toArray<T>(it : Iterator<T>) : Array<T> {
		var items = [];
		for(item in it)
			items.push(item);
		return items;
	}

	public static function order<T>(it : Iterator<T>, sort : T -> T -> Int) {
		var n = Iterators.toArray(it);
		n.sort(sort);
		return n;
	}

	public static function reduce<TItem, TAcc>(it : Iterator<TItem>, callback : TAcc -> TItem -> TAcc, initial : TAcc) : TAcc {
		map(it, function(v) initial = callback(initial, v));
		return initial;
	}

	public static function reducei<TItem, TAcc>(it : Iterator<TItem>, callback : TAcc -> TItem -> Int -> TAcc, initial : TAcc) : TAcc {
		mapi(it, function(v, i) initial = callback(initial, v, i));
		return initial;
	}

	inline public static function isEmpty<T>(it : Iterator<T>) : Bool
		return !it.hasNext();

	public static function filter<TItem>(it : Iterator<TItem>, predicate : TItem -> Bool) : Array<TItem>
		return reduce(it, function(acc : Array<TItem>, item) {
				if(predicate(item))
					acc.push(item);
				return acc;
			}, []);
}