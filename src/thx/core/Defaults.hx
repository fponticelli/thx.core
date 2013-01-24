package thx.core;

#if macro
import haxe.macro.Expr;
#end

class Defaults
{
	macro public static function def(expr : Expr, alt : Expr)
	{
		return macro null == $expr ? ($expr = $alt) : $expr;
	}
}