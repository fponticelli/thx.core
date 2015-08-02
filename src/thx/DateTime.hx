package thx;

using haxe.Int64;
using thx.Ints;
using thx.Int64s;
using thx.Strings;
import thx.DateTimeUtc.*;

@:access(thx.DateTimeUtc)
abstract DateTime(Array<Int64>) {
  static public function localOffset() : Time {
// Date.getTime() in C# is broken hence the special case
#if cs
    var now = cs.system.DateTime.Now;
    return new Time(now.ToLocalTime().Ticks - now.ToUniversalTime().Ticks);
#else
    var now = DateTimeUtc.now(),
        local = new Date(now.year, now.month - 1, now.day, now.hour, now.minute, now.second),
        delta = Math.ffloor(now.toTime() / 1000) * 1000 - local.getTime();
    return new Time(Int64s.fromFloat(delta) * ticksPerMillisecondI64);
#end
  }

  inline public static function now() : DateTime
    return new DateTime(DateTimeUtc.now(), localOffset());

  inline public static function nowUtc() : DateTime
    return new DateTime(DateTimeUtc.now(), Time.zero);

  @:from public static function fromString(s : String) : DateTime {
    var pattern = ~/^(\d+)[-](\d{2})[-](\d{2})[T ](\d{2})[:](\d{2})[:](\d{2})(?:\.(\d+))?(Z|([+-]\d{2})[:](\d{2}))?$/;
    if(!pattern.match(s))
      throw new thx.Error('unable to parse DateTime string: "$s"');
    var smillis = pattern.matched(7),
        millis = 0;
    if(null != smillis) {
      smillis = "1" + smillis.rpad("0", 3).substring(0, 3);
      millis = Std.parseInt(smillis) - 1000;
    }

    var time = Time.zero,
        timepart = pattern.matched(8);
    if(null != timepart && "Z" != timepart) {
      var hours = pattern.matched(9);
      if(hours.substring(0, 1) == "+")
        hours = hours.substring(1);
      time = Time.create(
        Std.parseInt(hours),
        Std.parseInt(pattern.matched(10)),
        0
      );
    }

    return create(
        Std.parseInt(pattern.matched(1)),
        Std.parseInt(pattern.matched(2)),
        Std.parseInt(pattern.matched(3)),
        Std.parseInt(pattern.matched(4)),
        Std.parseInt(pattern.matched(5)),
        Std.parseInt(pattern.matched(6)),
        millis,
        time
      );
  }

  inline static public function create(year : Int, month : Int, day : Int, ?hour : Int = 0, ?minute : Int = 0, ?second : Int = 0, ?millisecond : Int = 0, offset : Time)
    return new DateTime(
      DateTimeUtc.create(year, month, day, hour, minute, second, millisecond),
      offset
    ).subtract(offset);

  inline function new(dateTime : DateTimeUtc, offset : Time)
    this = [dateTime.ticks, offset.ticks];

  public var utc(get, never) : DateTimeUtc;
  public var offset(get, never) : Time;

  public var year(get, never) : Int;
  public var month(get, never) : Month;
  public var day(get, never) : Int;

  public var hour(get, never) : Int;
  public var minute(get, never) : Int;
  public var second(get, never) : Int;
  public var millisecond(get, never) : Int;

  public var isInLeapYear(get, never) : Bool;
  public var monthDays(get, never) : Int;
  public var dayOfWeek(get, never) : Weekday;
  public var dayOfYear(get, never) : Int;
  public var timeOfDay(get, never) : Time;

  inline public function min(other : DateTime) : DateTime
    return utc.compare(other.utc) <= 0 ? self() : other;

  inline public function max(other : DateTime) : DateTime
    return utc.compare(other.utc) >= 0 ? self() : other;

/**
Returns true if this date and the `other` date share the same year.
**/
  public function sameYear(other : DateTime) : Bool
    return year == other.year;

/**
Returns true if this date and the `other` date share the same year and month.
**/
  public function sameMonth(other : DateTime)
    return sameYear(other) && month == other.month;

/**
Returns true if this date and the `other` date share the same year, month and day.
**/
  public function sameDay(other : DateTime)
    return sameMonth(other) && day == other.day;

/**
Returns true if this date and the `other` date share the same year, month, day and hour.
**/
  public function sameHour(other : DateTime)
    return sameDay(other) && hour == other.hour;

/**
Returns true if this date and the `other` date share the same year, month, day, hour and minute.
**/
  public function sameMinute(other : DateTime)
    return sameHour(other) && minute == other.minute;

/**
Returns true if this date and the `other` date share the same year, month, day, hour, minute and second.
**/
  public function sameSecond(other : DateTime)
    return sameMinute(other) && second == other.second;

  public function withYear(year : Int)
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withMonth(month : Int)
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withDay(day : Int)
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withHour(hour : Int)
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withMinute(minute : Int)
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withSecond(second : Int)
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withMillisecond(millisecond : Int)
    return create(year, month, day, hour, minute, second, millisecond, offset);

  inline public function withOffset(offset : Time)
    return new DateTime(utc, offset);

  @:op(A+B) inline function add(time : Time)
    return new DateTime(DateTimeUtc.fromInt64(utc.ticks + time.ticks), offset);

  @:op(A-B) inline function subtract(time : Time)
    return new DateTime(DateTimeUtc.fromInt64(utc.ticks - time.ticks), offset);

  @:op(A-B) inline function subtractDate(date : DateTime) : Time
    return new DateTime(DateTimeUtc.fromInt64(utc.ticks + date.utc.ticks), offset);

  inline public function addDays(days : Float)
    return new DateTime(utc.addDays(days), offset);

  inline public function addHours(hours : Float)
    return new DateTime(utc.addHours(hours), offset);

  inline public function addMilliseconds(milliseconds : Int)
    return new DateTime(utc.addMilliseconds(milliseconds), offset);

  inline public function addMinutes(minutes : Float)
    return new DateTime(utc.addMinutes(minutes), offset);

  inline public function addMonths(months : Int)
    return new DateTime(utc.addMonths(months), offset);

  inline public function addSeconds(seconds : Float)
    return new DateTime(utc.addSeconds(seconds), offset);

  inline public function addYears(years : Int)
    return new DateTime(utc.addYears(years), offset);

  // TODO should it consider offset?
  inline public function compare(other : DateTime) : Int
    return Int64s.compare(utc.ticks, other.utc.ticks);

  // TODO should it consider offset?
  @:op(A==B) inline public function equals(other : DateTime)
    return utc.ticks == other.utc.ticks;

  // TODO should it consider offset?
  @:op(A!=B) inline public function notEquals(other : DateTime)
    return utc.ticks != other.utc.ticks;

  // TODO should it consider offset?
  public function nearEquals(other : DateTime, span : Time) {
    var ticks = Int64s.abs(other.utc.ticks - utc.ticks);
    return ticks <= span.abs().ticks;
  }

  @:op(A>B) inline public function greater(other : DateTime) : Bool
    return compare(other) > 0;

  @:op(A>=B) inline public function greaterEquals(other : DateTime) : Bool
    return compare(other) >= 0;

  @:op(A<B) inline public function less(other : DateTime) : Bool
    return compare(other) < 0;

  @:op(A<=B) inline public function lessEquals(other : DateTime) : Bool
    return compare(other) <= 0;

  inline public function changeOffset(newoffset : Time)
    return new DateTime(clockDateTime() - newoffset, newoffset);

  @:to inline public function toUtc() : DateTimeUtc
    return utc;

  inline function clockDateTime() : DateTimeUtc
    return new DateTimeUtc(utc.ticks + offset.ticks);

  //1997-07-16T19:20:30+01:00
  @:to public function toString()
    return '$year-${month.lpad(2)}-${day.lpad(2)}T${hour.lpad(2)}:${minute.lpad(2)}:${second.lpad(2)}${millisecond != 0 ? "."+millisecond.lpad(3, "0") : ""}${offset.toGmtString()}';

  @:to inline function get_utc() : DateTimeUtc
    return new DateTimeUtc(this[0]);

  @:to inline function get_offset() : Time
    return new Time(this[1]);

  inline function get_year() : Int
    return clockDateTime().year;

  inline function get_month() : Month
    return clockDateTime().month;

  inline function get_day() : Int
    return clockDateTime().day;

  inline function get_hour() : Int
    return clockDateTime().hour;

  inline function get_minute() : Int
    return clockDateTime().minute;

  inline function get_dayOfWeek() : Weekday
    return clockDateTime().dayOfWeek;

  inline function get_dayOfYear() : Int
    return clockDateTime().dayOfYear;

  inline function get_millisecond() : Int
    return clockDateTime().millisecond;

  inline function get_second() : Int
    return clockDateTime().second;

  inline function get_timeOfDay() : Time
    return clockDateTime().timeOfDay;

  inline function get_isInLeapYear() : Bool
    return isLeapYear(year);

  inline function get_monthDays() : Int
    return daysInMonth(year, month);

  inline function self() : DateTime
    return cast this;
}
