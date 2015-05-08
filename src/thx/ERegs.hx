package thx;

/**
`ERegs` provides helper methods to use together with `EReg`.
**/
class ERegs {
  static var ESCAPE_PATTERN = ~/([-\[\]{}()*+?\.,\\^$|# \t\r\n])/g;

/**
It escapes any characer in a string that has a special meaning when used in a regular expression.
**/
  public static function escape(text : String) : String
    return ESCAPE_PATTERN.map(text , function(ereg)
      return '\\' + ereg.matched(1));
// The following should be the right solution but it works inconsistently in Java
//    return ESCAPE_PATTERN.replace(text, "\\\\$1");
}
