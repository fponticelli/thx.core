/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

import thx.core.Functions.Function in F;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
#end

class Arrays {
	public static function same<T>(a : Array<T>, b : Array<T>, ?eq : T -> T -> Bool) {
		if(a == null || b == null || a.length != b.length) return false;
		if(null == eq) eq = F.equality;
		for(i in 0...a.length)
			if(!eq(a[i], b[i]))
				return false;
		return true;
	}

	public static function cross<T>(a : Array<T>, b : Array<T>) {
		var r = [];
		for (va in a)
			for (vb in b)
				r.push([va, vb]);
		return r;
	}

	public static function crossMulti<T>(a : Array<Array<T>>) {
		var acopy  = a.copy(),
			result = acopy.shift().map(function(v) return [v]);
		while (acopy.length > 0) {
			var arr = acopy.shift(),
				tresult = result;
			result = [];
			for (v in arr) {
				for (ar in tresult) {
					var t = ar.copy();
					t.push(v);
					result.push(t);
				}
			}
		}
		return result;
	}

	public static function pushIf<T>(arr : Array<T>, cond : Bool, value : T) {
		if (cond)
			arr.push(value);
		return arr;
	}

	public static function eachPair<TIn, TOut>(arr : Array<TIn>, handler : TIn -> TIn -> Bool)
		for(i in 0...arr.length)
			for(j in i...arr.length)
				if(!handler(arr[i], arr[j]))
					return;

	#if js inline #end
	public static function mapi<TIn, TOut>(arr : Array<TIn>, handler : TIn -> Int -> TOut) : Array<TOut> {
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
	public static function flatten<T>(arr : Array<Array<T>>) : Array<T>
		#if js
			return untyped __js__('Array.prototype.concat.apply')([], arr);
		#else
			return reduce(arr, function(acc : Array<T>, item) return acc.concat(item), []);
		#end

	inline public static function reduce<TItem, TAcc>(arr : Array<TItem>, callback : TAcc -> TItem -> TAcc, initial : TAcc) : TAcc
		#if js
			return untyped arr.reduce(callback, initial);
		#else
			return Iterables.reduce(arr, callback, initial);
		#end

	inline public static function reducei<TItem, TAcc>(arr : Array<TItem>, callback : TAcc -> TItem -> Int -> TAcc, initial : TAcc) : TAcc
		#if js
			return untyped arr.reduce(callback, initial);
		#else
			return Iterables.reducei(arr, callback, initial);
		#end

	public static function order<T>(arr : Array<T>, sort : T -> T -> Int) {
		var n = arr.copy();
		n.sort(sort);
		return n;
	}

	inline public static function isEmpty<T>(arr : Array<T>) : Bool
		return arr.length == 0;

	public static function contains<T>(arr : Array<T>, element : T, ?eq : T -> T -> Bool) : Bool {
		if(null == eq) {
			return arr.indexOf(element) >= 0;
		} else {
			for(i in 0...arr.length)
				if(eq(arr[i], element))
					return true;
			return false;
		}
	}

	public static function shuffle<T>(a : Array<T>) : Array<T> {
		var t = Ints.range(a.length),
			arr = [];
		while (t.length > 0) {
			var pos = Std.random(t.length),
				index = t[pos];
			t.splice(pos, 1);
			arr.push(a[index]);
		}
		return arr;
	}

	macro public static function mapField<T>(a : ExprOf<Array<T>>, field : Expr) {
		var id = 'o.'+ExprTools.toString(field),
				expr = Context.parse(id, field.pos);
		return macro $e{a}.map(function(o) return ${expr});
	}

	macro public static function mapFieldi<T>(a : ExprOf<Array<T>>, field : Expr) {
		var id = 'o.'+ExprTools.toString(field),
				expr = Context.parse(id, field.pos);
		return macro thx.core.Arrays.mapi($e{a}, function(o, i) return ${expr});
	}
}