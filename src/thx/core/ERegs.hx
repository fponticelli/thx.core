package thx.core;

/**
`ERegs` provides helper methods to use together with `EReg`.
**/
class ERegs {
	static var ESCAPE_PATTERN = ~/([-[\]{}()*+?.,\\^$|#\s])/g;

/**
It escapes any characer in a string that has a special meaning when used in a regula expression.
**/
	public static function escape(text : String) : String
		return ESCAPE_PATTERN.replace(text, "\\$1");
}