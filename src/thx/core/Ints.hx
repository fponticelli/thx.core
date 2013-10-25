package thx.core;

/**
 * ...
 * @author Franco Ponticelli
 */

class Ints
{
	public static inline function clamp(v : Int, min : Int, max : Int) : Int
	{
		return v < min ? min : (v > max ? max : v);
	}

	static var pattern_parse = ~/^[+-]?(\d+|0x[0-9A-F]+)$/i;
	public static function canParse(s : String)
	{
		return pattern_parse.match(s);
	}

	public inline static function min(a : Int, b : Int)
	{
		return a < b ? a : b;
	}

	public inline static function max(a : Int, b : Int)
	{
		return a > b ? a : b;
	}

	// TODO add proper octal/hex/exp support
	public static function parse(s : String)
	{
		if (s.substr(0, 1) == "+")
			s = s.substr(1);
		return Std.parseInt(s);
	}
}