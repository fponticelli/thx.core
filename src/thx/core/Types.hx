/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

class Types {
	public static inline function isAnonymousObject(v : Dynamic) : Bool
		return Reflect.isObject(v) && null == Type.getClass(v);

	public static function sameType<A, B>(a : A, b : B) : Bool
		return ValueTypes.toString(Type.typeof(a)) == ValueTypes.toString(Type.typeof(b));
}

class ClassTypes {
	public inline static function toString(cls : Class<Dynamic>)
		return Type.getClassName(cls);

	static public #if !php inline #end function as<T1, T2>(value : T1, type : Class<T2>) : Null<T2>
		return (Std.is(value, type) ? cast value : null);
}

class ValueTypes {
	public static function typeAsString<T>(value : T)
		return toString(Type.typeof(value));

	public static function toString(type : Type.ValueType) {
		return switch type {
			case TInt:      "Int";
			case TFloat:    "Float";
			case TBool:     "Bool";
			case TObject:   "Dynamic"; // TODO ?
			case TFunction: "Function";
			case TClass(c): Type.getClassName(c);
			case TEnum(e):  Type.getEnumName(e);
			case _:         null;
		}
	}

	public static function typeInheritance(type : Type.ValueType) {
		return switch type {
			case TInt:      ["Int"];
			case TFloat:    ["Float"];
			case TBool:     ["Bool"];
			case TObject:   ["Dynamic"];
			case TFunction: ["Function"];
			case TClass(c):
				var classes = [];
				while (null != c) {
					classes.push(c);
					c = Type.getSuperClass(c);
				}
				classes.map(Type.getClassName);
			case TEnum(e):  [Type.getEnumName(e)];
			case _:         null;
		}
	}
}