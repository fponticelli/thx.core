package thx;

import haxe.PosInfos;

class Effects {
  public static var logger : Dynamic -> PosInfos -> Void = haxe.Log.trace;

  inline public static function tap<T, TAny>(input : T, f : T -> TAny) : T {
    f(input);
    return input;
  }

  inline public static function traced<T, TAny>(input: T, f: T -> String): T {
    trace(f(input));
    return input;
  }

  inline public static function log<T>(input : T, ?pos : PosInfos) : T
    return tap(input, logger.bind(_, pos));
}
