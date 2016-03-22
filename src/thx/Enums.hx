package thx;

/**
Helper class for enums.
**/
class Enums {
/**
Converts an enum value into a `String` representation.
**/
  public static function string<T : EnumValue>(e : T) {
    var cons = Type.enumConstructor(e);
    var params = [];
    for (param in Type.enumParameters(e))
      params.push(Dynamics.string(param));
    return cons + (params.length == 0 ? "" : "(" + params.join(", ") + ")");
  }

/**
Compares two enum values. Comparison is based on the constructor definition
index. If `a` and `b` are the same constructor and have parameters, parameters
are compared using the same rules applied for `thx.Arrays.compare`.
**/
  public static function compare<T : EnumValue>(a : T, b : T) : Int {
    var v = Ints.compare(Type.enumIndex(a), Type.enumIndex(b));
    if (v != 0)
      return v;
    return Arrays.compare(Type.enumParameters(a), Type.enumParameters(b));
  }

/**
Compares two enum instances for equality ignoring the constructor arguments.
**/
  inline public static function sameConstructor<T : EnumValue>(a : T, b : T) : Bool
    return Type.enumIndex(a) == Type.enumIndex(b);

/**
Returns the lower between two enum instances. Sequence is determined by their
index in the type definition.
**/
  public static function min<T : EnumValue>(a : T, b : T) : T {
    if(compare(a, b) < 0)
      return a;
    else
      return b;
  }

/**
Returns the higher between two enum instances. Sequence is determined by their
index in the type definition.
**/
  public static function max<T : EnumValue>(a : T, b : T) : T {
    if(compare(a, b) > 0)
      return a;
    else
      return b;
  }
}
