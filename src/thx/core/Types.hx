/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

class Types
{

}

class ValueTypes
{
	public static function toString(type : Type.ValueType)
	{
		return switch(type)
		{
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
	
	public static function typeInheritance(type : Type.ValueType)
	{
		return switch(type)
		{
			case TInt:      ["Int"];
			case TFloat:    ["Float"];
			case TBool:     ["Bool"];
			case TObject:   ["Dynamic"];
			case TFunction: ["Function"];
			case TClass(c):
				var classes = [];
				while (null != c)
				{
					classes.push(c);
					c = Type.getSuperClass(c);
				}
				classes.map(Type.getClassName);
			case TEnum(e):  [Type.getEnumName(e)];
			case _:         null;
		}
	}
}