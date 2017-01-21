package thx;

#if (haxe_ver >= 3.4)
import Any as HaxeAny;
#end


/**
  Safer version of Haxe Dynamic that prevents common issues with Dynamics by forcing
  you to explicitly convert it to the desired type before doing any operations on it.

  Note: this Any type differs from the Haxe Any type (in 3.4 or later) in how implicit
  conversions to and from Dynamic are handled.
**/
abstract Any(Dynamic) {
  @:from inline public static function ofValue<T>(value:T):Any return cast value;
  inline public function unsafeCast<T>():T return this;

#if (haxe_ver >= 3.4)
  @:from inline public static function fromHaxeAny(haxeAny : HaxeAny) : Any return cast haxeAny;
  inline public function toHaxeAny() : HaxeAny return cast this;
#end
}
