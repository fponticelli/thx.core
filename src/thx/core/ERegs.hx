package thx.core;

class ERegs
{
  static var ESCAPE_PATTERN = ~/([-[\]{}()*+?.,\\^$|#\s])/g;
  public static function escape(text : String) : String
  {
    return ESCAPE_PATTERN.replace(text, "\\$1");
  }
}