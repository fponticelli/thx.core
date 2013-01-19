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
}