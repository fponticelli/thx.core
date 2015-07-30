package thx;

using haxe.Int64;

abstract Time(Int64) {
  public var ticks(get, never) : Int64;

  public static function timeToTicks(hours : Int, minutes : Int, seconds : Int) : Int64 {
    var totalSeconds = (hours * 3600 : Int64) + minutes * 60 + seconds;
    return totalSeconds * ticksPerSecondI64;
  }

  inline public function new(ticks : Int64)
    this = ticks;

  @:to inline function get_ticks() : Int64
    return this;
}
