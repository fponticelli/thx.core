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

	public static function mapi<TIn, TOut>(arr : Array<TIn>, handler : TIn -> Int -> TOut) : Array<TOut>
	{
		var r = [];
		for(i in 0...arr.length)
			r.push(handler(arr[i], i));
		return r;
	}
}