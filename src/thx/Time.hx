package thx;

using haxe.Int64;

abstract Time(Int64) {
  public var ticks(get, never) : Int64;

  inline public function new(ticks : Int64)
    this = ticks;

  @:to inline function get_ticks() : Int64
    return this;
}
