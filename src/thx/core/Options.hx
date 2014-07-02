package thx.core;

import haxe.ds.Option;

class Options {
	public static function toValue<T>(option : Option<T>) : Null<T>
		return switch option {
			case None: null;
			case Some(v) : v;
		}

	public static function toBool<T>(option : Option<T>) : Bool
		return switch option {
			case None: false;
			case Some(_) : true;
		}

	public static function toOption<T>(value : T) : Option<T>
		return null == value ? None : Some(value);

	public static function equals<T>(a : Option<T>, b : Option<T>, ?eq : T -> T -> Bool) {
		return switch [a, b] {
			case [None, None]: true;
			case [Some(a), Some(b)]:
				if(null == eq)
					eq = function(a, b) return a == b;
				eq(a,b);
			case [_, _]:
				false;
		}
	}

	public static function equalsValue<T>(a : Option<T>, b : Null<T>, ?eq : T -> T -> Bool) {
		return equals(a, toOption(b));
	}
}