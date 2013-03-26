package thx.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

class Macros
{
	public static function getModulePath(type : String) : String
	{
		return switch(Context.getType(type)) {
			case TInst(t, _): Context.getPosInfos(t.get().pos).file;
			case _: throw 'invalid type $type';
		}
	}
}
#end