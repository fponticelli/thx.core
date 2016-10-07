package thx;

/**
Helper methods to use on values, types and classes.
**/
class Types {
/**
`isAnonymousObject` returns true if `v` is an object and it is not an instance of any custom class.
**/
  public static inline function isAnonymousObject(v : Dynamic) : Bool
    return Reflect.isObject(v) && null == Type.getClass(v);

/**
Returns `true` if the passed value is an anonymous object or class instance but it is not any of the primitive types.
**/
  public static function isObject(v : Dynamic) : Bool
    return Reflect.isObject(v) && !isPrimitive(v);

/**
Returns `true` if `v` is any of the following types: Int, Float, Bool, Date or String.
**/
  public static function isPrimitive(v : Dynamic)
    return switch Type.typeof(v) {
      case TInt, TFloat, TBool: true;
      case TNull, TFunction, TEnum(_), TObject, TUnknown : false;
      case TClass(c) if(Type.getClassName(c) == "String"): true;
      case TClass(c) if(Type.getClassName(c) == "Date"): true;
      case TClass(_): false;
    };

/**
Returns `true` if `v` is an instance of any Enum type.
**/
  public static function isEnumValue(v : Dynamic)
    return switch Type.typeof(v) {
      case TEnum(_): true;
      case _: false;
    };

/**
Returns `true` if `cls` extends `sup` or one of its children.

It also returns `true` if `cls` and `sup` are the same.
**/
  public static function hasSuperClass(cls : Class<Dynamic>, sup : Class<Dynamic>) {
    while(null != cls) {
      if(cls == sup)
        return true;
      cls = Type.getSuperClass(cls);
    }
    return false;
  }

/**
`sameType` returns true if the arguments `a` and `b` share exactly the same type.
**/
  public static function sameType<A, B>(a : A, b : B) : Bool
    return valueTypeToString(a) == valueTypeToString(b);

/**
`typeInheritance` returns an array of string describing the entire inheritance
chain of the passed `ValueType`.
**/
  public static function typeInheritance(type : Type.ValueType) : Array<String> {
    return switch type {
      case TInt:      ["Int"];
      case TFloat:    ["Float"];
      case TBool:     ["Bool"];
      case TObject:   ["{}"];
      case TFunction: ["Function"];
      case TClass(c):
        var classes = [];
        while (null != c) {
          classes.push(c);
          c = Type.getSuperClass(c);
        }
        classes.map(Type.getClassName);
      case TEnum(e):  [Type.getEnumName(e)];
      case _:         throw 'invalid type $type';
    }
  }

/**
Returns a string representation of a `ValueType`.
**/
  public static function toString(type : Type.ValueType) {
    return switch type {
      case TNull:     "Null";
      case TInt:      "Int";
      case TFloat:    "Float";
      case TBool:     "Bool";
      case TObject:   "{}";
      case TFunction: "Function";
      case TClass(c): Type.getClassName(c);
      case TEnum(e):  Type.getEnumName(e);
      case _:         throw 'invalid type $type';
    }
  }

/**
`valueTypeInheritance` returns an array of string describing the entire inheritance
chain of the passed `value`.
**/
  inline public static function valueTypeInheritance<T>(value : T) : Array<String>
    return typeInheritance(Type.typeof(value));

/**
Returns a string describing the type of any `value`.
**/
  inline public static function valueTypeToString<T>(value : T)
    return toString(Type.typeof(value));

/**
Returns a string describing the type of any `value`.
**/
  inline public static function anyValueToString(value : Dynamic) {
    if(Std.is(value, Type.ValueType))
      return toString(value);
    if(Std.is(value, Class))
      return Type.getClassName(value);
    if(Std.is(value, Enum))
      return Type.getEnumName(value);
    return valueTypeToString(value);
  }
}
