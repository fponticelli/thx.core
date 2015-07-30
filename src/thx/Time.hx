package thx;

using haxe.Int64;
using thx.Strings;

abstract Time(Int64) {
  static var ticksPerMillisecond : Int = 10000;
  static var ticksPerMillisecondI64 : Int64 = Int64.ofInt(ticksPerMillisecond);
  static var ticksPerSecondI64 : Int64 = ticksPerMillisecondI64 * 1000;
  static var ticksPerMinuteI64 : Int64 = ticksPerSecondI64 * 60;
  static var ticksPerHourI64 : Int64 = ticksPerMinuteI64 * 60;
  static var ticksPerDayI64 : Int64 = ticksPerHourI64 * 24;

  public var ticks(get, never) : Int64;
  public var days(get, never) : Int;
  public var hours(get, never) : Int;
  public var minutes(get, never) : Int;
  public var seconds(get, never) : Int;
  public var milliseconds(get, never) : Int;

  public static function timeToTicks(hours : Int, minutes : Int, seconds : Int) : Int64 {
    var totalSeconds = (hours * 3600 : Int64) + minutes * 60 + seconds;
    return totalSeconds * ticksPerSecondI64;
  }

  inline public function new(ticks : Int64)
    this = ticks;

  @:to inline function get_ticks() : Int64
    return this;

  @:to inline function get_days() : Int
    return (this / ticksPerDayI64).toInt();

  @:to inline function get_hours() : Int
    return ((this / ticksPerHourI64) % 24).toInt();

  @:to inline function get_minutes() : Int
    return ((this / ticksPerMinuteI64) % 60).toInt();

  @:to inline function get_seconds() : Int
    return ((this / ticksPerSecondI64) % 60).toInt();

  @:to inline function get_milliseconds() : Int
    return ((this / ticksPerMillisecondI64) % 1000).toInt();
}
