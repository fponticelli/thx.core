/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

class Arrays
{
	public static function cross<T>(a : Array<T>, b : Array<T>)
	{
		var r = [];
		for (va in a)
			for (vb in b)
				r.push([va, vb]);
		return r;
	}

	public static function crossMulti<T>(a : Array<Array<T>>)
	{
		var acopy  = a.copy(),
			result = acopy.shift().map(function(v) return [v]);
		while (acopy.length > 0)
		{
			var arr = acopy.shift(),
				tresult = result;
			result = [];
			for (v in arr)
			{
				for (ar in tresult)
				{
					var t = ar.copy();
					t.push(v);
					result.push(t);
				}
			}
		}
		return result;
	}

	public static function pushIf<T>(arr : Array<T>, cond : Bool, value : T)
	{
		if (cond)
			arr.push(value);
		return arr;
	}

	#if js inline #end
	public static function mapi<TIn, TOut>(arr : Array<TIn>, handler : TIn -> Int -> TOut) : Array<TOut>
	{
		#if js
			return (cast arr : { map : (TIn -> Int -> TOut) -> Array<TOut> }).map(handler);
		#else
			var r = [];
			for(i in 0...arr.length)
				r.push(handler(arr[i], i));
			return r;
		#end
	}

	inline public static function flatMap<TIn, TOut>(arr : Array<TIn>, callback : TIn -> Array<TOut>) : Array<TOut>
		return flatten(arr.map(callback));

	#if js inline #end
	public static function flatten<T>(arr : Array<Array<T>>) {
		#if js
			return untyped __js__('Array.prototype.concat.apply')([], arr);
		#else
			return reduce(arr, function(acc : Array<T>, item) return acc.concat(item), []);
		#end
	}

	inline public static function reduce<TItem, TAcc>(arr : Array<TItem>, callback : TAcc -> TItem -> TAcc, initial : TAcc) : TAcc {
		#if js
			return untyped arr.reduce(callback, initial);
		#else
			return Iterables.reduce(arr, callback, initial);
		#end
	}

	inline public static function reducei<TItem, TAcc>(arr : Array<TItem>, callback : TAcc -> TItem -> Int -> TAcc, initial : TAcc) : TAcc {
		#if js
			return untyped arr.reduce(callback, initial);
		#else
			return Iterable.reducei(arr, callback, initial);
		#end
	}

	public static function order<T>(arr : Array<T>, sort : T -> T -> Int)
	{
		var n = arr.copy();
		n.sort(sort);
		return n;
	}

	inline public static function isEmpty<T>(arr : Array<T>) : Bool
		return arr.length == 0;
}