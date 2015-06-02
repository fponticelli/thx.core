package thx.macro.lambda;
import thx.macro.Macros;

class MacroHelper {
  public static function replace_() return Macros.replaceSymbol.bind(_,'_',macro __tmp1);
  public static function replace1() return Macros.replaceSymbol.bind(_,'_1',macro __tmp1);
  public static function replace2() return Macros.replaceSymbol.bind(_,'_2',macro __tmp2);
  public static function replace3() return Macros.replaceSymbol.bind(_,'_3',macro __tmp3);
  public static function replace4() return Macros.replaceSymbol.bind(_,'_4',macro __tmp4);
  public static function replace5() return Macros.replaceSymbol.bind(_,'_5',macro __tmp5);
}
