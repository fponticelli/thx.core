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

  // TODO optimize
  @:from public static function fromString(s : String) : Time {
    var pattern = ~/^(\d+)[:](\d{2})[:](\d{2})(?:\.(\d+))?$/;
    if(!pattern.match(s))
      throw new thx.Error('unable to parse Time string: "$s"');
    var smillis = pattern.matched(4),
        millis = 0;
    if(null != smillis) {
      smillis = "1" + smillis.rpad("0", 3).substring(0, 3);
      millis = Std.parseInt(smillis) - 1000;
    }

    return create(
        Std.parseInt(pattern.matched(1)),
        Std.parseInt(pattern.matched(2)),
        Std.parseInt(pattern.matched(3)),
        millis
      );
  }

  public static function create(hours : Int, ?minutes : Int = 0, ?seconds : Int = 0, ?milliseconds : Int = 0)
    return new Time(timeToTicks(hours, minutes, seconds) + (milliseconds * ticksPerMillisecondI64));

  inline public static function createDays(days : Int, ?hours : Int = 0, ?minutes : Int = 0, ?seconds : Int = 0, ?milliseconds : Int = 0)
    return create(days * 24 + hours, minutes, seconds, milliseconds);

  inline public function new(ticks : Int64)
    this = ticks;

  @:op(-A) inline public function negate()
      return new Time(-ticks);

  @:op(A+B) inline public function add(other : Time)
    return new Time(ticks + other.ticks);

  @:op(A-B) inline public function subtract(other : Time)
    return new Time(ticks - other.ticks);

  inline public function compare(other : Time)
    return Int64s.compare(ticks, other.ticks);

  @:op(A==B) inline public function equals(other : Time)
    return ticks == other.ticks;

  @:op(A>B) inline public function greater(other : Time) : Bool
    return compare(other.ticks) > 0;

  @:op(A>=B) inline public function greaterEquals(other : Time) : Bool
    return compare(other.ticks) >= 0;

  @:op(A<B) inline public function less(other : Time) : Bool
    return compare(other.ticks) < 0;

  @:op(A<=B) inline public function lessEquals(other : Time) : Bool
    return compare(other.ticks) <= 0;

  @:to public function toString()
    return '$totalHours:$minutes:$seconds.$milliseconds';

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
