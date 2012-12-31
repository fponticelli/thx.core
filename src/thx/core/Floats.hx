/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

class Floats 
{
	public static inline function normalize(v : Float) : Float
	{
		return clamp(v, 0, 1);
	}

	public static inline function clamp(v : Float, min : Float, max : Float) : Float
	{
		return v < min ? min : (v > max ? max : v);
	}

	public static inline function clampSym(v : Float, max : Float) : Float
	{
		return clamp(v, -max, max);
	}
	
	public static function wrap(v : Float, min : Float, max : Float) : Float
	{
		var range = max - min + 1;
		if (v < min) v += range * ((min - v) / range + 1);
		return min + (v - min) % range;
	}
	
	public static function wrapCircular(v : Float, max : Float) : Float
	{
		v = v % max;
		if (v < 0)
			v += max;
		return v;
	}
}