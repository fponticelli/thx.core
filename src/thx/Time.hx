package thx;

using haxe.Int64;
using thx.Ints;
using thx.Strings;
import thx.DateTimeUtc.*;

@:access(thx.DateTimeUtc)
abstract Time(Int64) {
  public static var zero(default, null) = new Time(0);

  inline public static function fromHours(hours : Int)
    return create(hours, 0, 0, 0);
  inline public static function fromMinutes(minutes : Int)
    return create(0, minutes, 0, 0);
  inline public static function fromSeconds(seconds : Int)
    return create(0, 0, seconds, 0);
  inline public static function fromMilliseconds(milliseconds : Int)
    return create(0, 0, 0, milliseconds);

  public static function timeToTicks(hours : Int, minutes : Int, seconds : Int) : Int64 {
    var totalSeconds = (hours * 3600 : Int64) + minutes * 60 + seconds;
    return totalSeconds * ticksPerSecondI64;
  }

  // TODO optimize
  @:from public static function fromString(s : String) : Time {
    var pattern = ~/^([-+])?(\d+)[:](\d{2})[:](\d{2})(?:\.(\d+))?$/;
    if(!pattern.match(s))
      throw new thx.Error('unable to parse Time string: "$s"');
    var smillis = pattern.matched(5),
        millis = 0;
    if(null != smillis) {
      smillis = "1" + smillis.rpad("0", 3).substring(0, 3);
      millis = Std.parseInt(smillis) - 1000;
    }

    var time = create(
        Std.parseInt(pattern.matched(2)),
        Std.parseInt(pattern.matched(3)),
        Std.parseInt(pattern.matched(4)),
        millis
      );

    if(pattern.matched(1) == "-") {
      return time.negate();
    } else {
      return time;
    }
  }

  public static function create(hours : Int, ?minutes : Int = 0, ?seconds : Int = 0, ?milliseconds : Int = 0)
    return new Time(timeToTicks(hours, minutes, seconds) + (milliseconds * ticksPerMillisecondI64));

  inline public static function createDays(days : Int, ?hours : Int = 0, ?minutes : Int = 0, ?seconds : Int = 0, ?milliseconds : Int = 0)
    return create(days * 24 + hours, minutes, seconds, milliseconds);

  inline public function new(ticks : Int64)
    this = ticks;

  public var ticks(get, never) : Int64;
  public var days(get, never) : Int;
  public var hours(get, never) : Int;
  public var minutes(get, never) : Int;
  public var seconds(get, never) : Int;
  public var milliseconds(get, never) : Int;

  public var totalDays(get, never) : Int64;
  public var totalHours(get, never) : Int64;
  public var totalMinutes(get, never) : Int64;
  public var totalSeconds(get, never) : Int64;
  public var totalMilliseconds(get, never) : Int64;

  public function abs() : Time
    return ticks < 0 ? new Time(-ticks) : new Time(ticks);

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

  public function toDateTimeUtc()
    return new DateTimeUtc(ticks);

  @:to public function toString()
    return '$totalHours:${minutes.lpad(2, "0")}:${seconds.lpad(2, "0")}${milliseconds != 0 ? "."+milliseconds.lpad(3, "0") : ""}';

  public function toGmtString() {
    var h = totalHours.toInt().lpad(2, "0");
    if(ticks >= 0)
      h = '+$h';
    return '${h}:${minutes.lpad(2, "0")}';
  }

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

  @:to inline function get_totalDays() : Int64
    return this / ticksPerDayI64;

  @:to inline function get_totalHours() : Int64
    return this / ticksPerHourI64;

  @:to inline function get_totalMinutes() : Int64
    return this / ticksPerMinuteI64;

  @:to inline function get_totalSeconds() : Int64
    return this / ticksPerSecondI64;

  @:to inline function get_totalMilliseconds() : Int64
    return this / ticksPerMillisecondI64;
}
