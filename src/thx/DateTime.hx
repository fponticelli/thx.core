package thx;

using haxe.Int64;
using thx.Ints;
using thx.Int64s;
import thx.DateTimeUtc.*;

@:access(thx.DateTimeUtc)
abstract DateTime(Array<Int64>) {
  static public function localOffset() : Time {
// Date.getTime() in C# is broken hence the special case
#if cs
    var now = cs.system.DateTime.Now;
    return new Time(now.ToUniversalTime().Ticks - now.ToLocalTime().Ticks);
#else
    var now = DateTimeUtc.now(),
        local = new Date(now.year, now.month - 1, now.day, now.hour, now.minute, now.second),
        delta = Math.ffloor(now.toFloat() / 1000) * 1000 - local.getTime();

    return new Time(Int64s.fromFloat(delta) * ticksPerMillisecondI64);
#end
  }

  inline public static function now() : DateTime
    return create(DateTimeUtc.now(), localOffset());

  inline public static function nowUtc() : DateTime
    return create(DateTimeUtc.now(), Time.zero);

  inline static public function create(dateTime : DateTimeUtc, offset : Time)
    return new DateTime([dateTime.ticks, offset.ticks]);

  public var utc(get, never) : DateTimeUtc;
  public var offset(get, never) : Time;

  inline function new(parts : Array<Int64>)
    this = parts;

  public var ticks(get, never) : Int64;

  public var year(get, never) : Int;
  public var month(get, never) : Month;
  public var day(get, never) : Int;

  public var hour(get, never) : Int;
  public var minute(get, never) : Int;
  public var second(get, never) : Int;
  public var millisecond(get, never) : Int;

  public var dayOfWeek(get, never) : Weekday;
  public var dayOfYear(get, never) : Int;
  public var timeOfDay(get, never) : Time;

  @:to inline function get_utc() : DateTimeUtc
    return new DateTimeUtc(this[0]);

  @:to inline function get_offset() : Time
    return new Time(this[1]);

  inline public function withOffset(offset : Time)
    return create(utc, offset);

  @:to inline public function toUtc() : DateTimeUtc
    return utc;

  inline function clockDateTime() : DateTimeUtc
    return new DateTimeUtc(utc.ticks + offset.ticks);

  //1997-07-16T19:20:30+01:00
  public function toString()
    return '$year-${month.lpad(2)}-${day.lpad(2)}T${hour.lpad(2)}:${minute.lpad(2)}:${second.lpad(2)}${millisecond != 0 ? "."+millisecond.lpad(3, "0") : ""}${offset.toGmtString()}';

  @:to inline function get_ticks() : Int64
    return timeOfDay.ticks;

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
}
