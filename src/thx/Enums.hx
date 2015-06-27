package thx;

/**
Helper class for enums.
**/
class Enums {
/**
Converts an enum value into a `String` representation.
**/
  public static function string(e : Dynamic) {
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
  public static function compare(a : Dynamic, b : Dynamic) {
    var v = Ints.compare(Type.enumIndex(a), Type.enumIndex(b));
    if (v != 0)
      return v;
    return Arrays.compare(Type.enumParameters(a), Type.enumParameters(b));
  }
}
