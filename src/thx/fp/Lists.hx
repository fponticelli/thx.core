package thx.fp;

using thx.Functions;
import thx.Functions.*;

class StringList {
  inline public static function toString(l : List<String>) : String
    return "[" + l.intersperse(",").foldLeft("", fn(_0 + _1)) + "]";
}

class FloatList {
  inline public static function toString(l : List<Float>) : String
    return l.toStringWithShow(Floats.toString);
}

class IntList {
  inline public static function toString(l : List<Int>) : String
    return l.toStringWithShow(Ints.toString.bind(_, 10));
}

class ObjectList {
  inline public static function toString(l : List<{ toString : Void -> String }>) : String
    return l.toStringWithShow(function(o) return o.toString());
}
