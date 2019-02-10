package thx;

using haxe.Int64;
using thx.Ints;
using thx.Strings;
import thx.DateTimeUtc.*;

@:access(thx.DateTimeUtc)
abstract Time(Int64) {
  public static var zero(default, null) = new Time(0);
  public static var oneDay(default, null) = new Time(24);

  inline public static function fromDays(days : Int)
    return create(24 * days, 0, 0, 0);
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

/**
Checks if a dynamic value is an instance of Time.
Note: because thx.Time is an abstract of haxe.Int64, any haxe.Int64 will be considered to be a thx.Time
**/
  public static function is(v : Dynamic) : Bool {
    return haxe.Int64.is(v);
  }

  @:from public static function fromString(s : String) : Time {
    var pattern = ~/^([-+])?(?:(\d+)[.](\d{1,2})|(\d+))[:](\d{2})(?:[:](\d{2})(?:\.(\d+))?)?$/;
    if(!pattern.match(s))
      throw new thx.Error('unable to parse Time string: "$s"');
    var smticks = pattern.matched(7),
        mticks = 0;
    if(null != smticks) {
      smticks = "1" + smticks.rpad("0", 7).substring(0, 7);
      mticks = Std.parseInt(smticks) - 10000000;
    }

    var days = 0,
        hours = 0,
        minutes = Std.parseInt(pattern.matched(5)),
        seconds = Std.parseInt(pattern.matched(6));
    if(null != pattern.matched(2)) {
      days = Std.parseInt(pattern.matched(2));
      hours = Std.parseInt(pattern.matched(3));
    } else {
      hours = Std.parseInt(pattern.matched(4));
    }

    var time = create(
            days * 24 + hours,
            minutes,
            seconds
          ) + mticks;

    if(pattern.matched(1) == "-") {
      return time.negate();
    } else {
      return time;
    }
  }

  inline public static function compare(a : Time, b : Time)
    return a.compareTo(b);

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
  public var microseconds(get, never) : Int;
  public var ticksInSecond(get, never) : Int;

  public var totalDays(get, never) : Int64;
  public var totalHours(get, never) : Int64;
  public var totalMinutes(get, never) : Int64;
  public var totalSeconds(get, never) : Int64;
  public var totalMilliseconds(get, never) : Int64;
  public var totalMicroseconds(get, never) : Int64;
  public var isNegative(get, never) : Bool;

  public function abs() : Time
    return ticks < 0 ? new Time(-ticks) : new Time(ticks);

  public function withHours(hours : Int)
    return create(hours, minutes, seconds, milliseconds);

  public function withMinutes(minutes : Int)
    return create(hours, minutes, seconds, milliseconds);

  public function withSeconds(seconds : Int)
    return create(hours, minutes, seconds, milliseconds);

  public function withMilliseconds(milliseconds : Int)
    return create(hours, minutes, seconds, milliseconds);

  @:op(-A) inline public function negate()
      return new Time(-ticks);

  @:op(A+B) inline public function add(that : Time)
    return new Time(ticks + that.ticks);

  @:op(A+B) inline public function addTicks(that : Int64)
    return new Time(ticks + that);

  @:op(A-B) inline public function subtract(that : Time)
    return new Time(ticks - that.ticks);

  inline public function compareTo(that : Time)
    return Int64s.compare(ticks, that.ticks);

  inline public function equalsTo(that : Time)
    return ticks == that.ticks;

  @:op(A==B)
  inline static public function equals(self : Time, that : Time)
    return self.ticks == that.ticks;

  @:op(A!=B)
  inline static public function notEqualsTo(self : Time, that : Time)
    return self.ticks != that.ticks;

  inline public function notEquals(that : Time)
    return ticks != that.ticks;

  @:op(A>B)
  inline static public function greaterThan(self : Time, that : Time) : Bool
    return self.ticks.compare(that.ticks) > 0;

  inline public function greater(that : Time) : Bool
    return compareTo(that) > 0;

  @:op(A>=B)
  inline static public function greaterEqualsTo(self : Time, that : Time) : Bool
    return self.ticks.compare(that.ticks) >= 0;

  inline public function greaterEquals(that : Time) : Bool
    return compareTo(that) >= 0;

  @:op(A<B)
  inline static public function lessThan(self : Time, that : Time) : Bool
    return self.ticks.compare(that.ticks) < 0;

  inline public function less(that : Time) : Bool
    return compareTo(that) < 0;

  @:op(A<=B)
  inline static public function lessEqualsTo(self : Time, that : Time) : Bool
    return self.ticks.compare(that.ticks) <= 0;

  inline public function lessEquals(that : Time) : Bool
    return compareTo(that) <= 0;

  public function toDateTimeUtc()
    return new DateTimeUtc(ticks);

  @:to public function toString() {
    var timeAbs = abs(),
        ticksInSecondAbs = timeAbs.ticksInSecond,
        decimals = ticksInSecondAbs != 0 ? ('.' + ticksInSecondAbs.lpad("0", 7).trimCharsRight("0")) : "";

    return (isNegative ? "-" : "") +
      '${timeAbs.totalHours}:${timeAbs.minutes.lpad("0", 2)}:${timeAbs.seconds.lpad("0", 2)}' +
      decimals;
  }

  public function toGmtString() {
    var h = totalHours.toInt().lpad("0", 2);
    if(ticks >= 0)
      h = '+$h';
    return '${h}:${minutes.lpad("0", 2)}';
  }

  @:to inline function get_ticks() : Int64
    return this;

  inline function get_days() : Int
    return (this / ticksPerDayI64).toInt();

  inline function get_hours() : Int
    return ((this / ticksPerHourI64) % 24).toInt();

  inline function get_minutes() : Int
    return ((this / ticksPerMinuteI64) % 60).toInt();

  inline function get_seconds() : Int
    return ((this / ticksPerSecondI64) % 60).toInt();

  inline function get_milliseconds() : Int
    return ((this / ticksPerMillisecondI64) % thousandI64).toInt();

  inline function get_microseconds() : Int
    return ((this / ticksPerMicrosecondI64) % tenThousandI64).toInt();

  inline function get_ticksInSecond() : Int
    return (this % ticksPerSecondI64).toInt();

  inline function get_totalDays() : Int64
    return this / ticksPerDayI64;

  inline function get_totalHours() : Int64
    return this / ticksPerHourI64;

  inline function get_totalMinutes() : Int64
    return this / ticksPerMinuteI64;

  inline function get_totalSeconds() : Int64
    return this / ticksPerSecondI64;

  inline function get_totalMilliseconds() : Int64
    return this / ticksPerMillisecondI64;

  inline function get_totalMicroseconds() : Int64
    return this / ticksPerMicrosecondI64;

  inline function get_isNegative() : Bool
    return ticks < 0;
}
