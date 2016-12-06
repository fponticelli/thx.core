package thx;

/**
  Safer version of Haxe Dynamic that prevents common issues with Dynamics by forcing
  you to explicitly convert it to the desired type before doing any operations on it.

  Taken from Haxe tink_core library by Juraj Kirchheim
  - https://github.com/haxetink/tink_core#any
  - https://github.com/haxetink/tink_core/blob/master/src/tink/core/Any.hx
**/
#if haxe < 3.4
abstract Any(Dynamic) {
  @:noCompletion @:extern @:to inline function __promote<T>():T return this;
  @:noCompletion @:extern @:from inline static function __cast<T>(value:T):Any return cast value;
}
#else
import Any as HaxeAny;
typedef Any = HaxeAny;
#end
