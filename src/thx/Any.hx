package thx;

/**
  Safer version of Haxe Dynamic that prevents common issues with Dynamics by forcing
  you to explicitly convert it to the desired type before doing any operations on it.

  Taken from Haxe tink_core library by Juraj Kirchheim
  - https://github.com/haxetink/tink_core#any
  - https://github.com/haxetink/tink_core/blob/master/src/tink/core/Any.hx
**/
abstract Any(Dynamic) from Dynamic {
  @:noCompletion @:to inline function __promote<A>() : A return this;
}
