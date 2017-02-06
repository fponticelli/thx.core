package thx;

import thx.Validation;
import thx.Validation.*;
import thx.Validation.VNel;
import thx.Validation.VNel.*;
using haxe.Int64;
using thx.Ints;
using thx.Int64s;
using thx.Strings;
import thx.DateTimeUtc.*;

/**
`DateTime` represents an instant in time since about year 29228 B.C.E. up to
29228 C.E. (A.D.).

`DateTime` supports a resolution up to 1e7th of second (a tick) and has no
precision issues since it is mapped internally to a `Int64`.

`DateTime` is an abstract and support some operator overloadings. Most notably
subtractions (to get a `Time` value), and addition/subtraction of a `Time` value.

`DateTime` also supports a time offset to describe time zone values.
*/
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

/**
Generates an instance of `DateTime` for the current instant and with an offset
as set on your local machine.

Note that PHP requires a configuration setting to setup a specific timezone or
it will default to UTC.
*/
  inline public static function now() : DateTime
    return new DateTime(DateTimeUtc.now(), localOffset());

/**
Same as `now` but it returns the current instant as if the time zone was set to
UTC.
*/
  inline public static function nowUtc() : DateTime
    return new DateTime(DateTimeUtc.now(), Time.zero);

/**
Converts a `Date` type into a `DateTime` type.

It uses the local server time offset.
*/
  @:from public static function fromDate(date : Date) : DateTime
    return new DateTime(DateTimeUtc.fromTime(date.getTime()), localOffset());

/**
Converts a `Date` type into a `DateTime` type with a given offset.
*/
  public static function fromDateWithOffset(date : Date, offset : Time) : DateTime
    return new DateTime(DateTimeUtc.fromTime(date.getTime()), offset);

/**
Converts a `Float` value representing the number of millisecond since Epoch into
a `DateTime` type.
*/
  @:from public static function fromTime(timestamp : Float) : DateTime
    return new DateTime(DateTimeUtc.fromTime(timestamp), Time.zero);

/**
Converts a string into a `DateTime` value. The accepted format looks like this:
```
2016-08-07T23:18:22.123Z
```

The decimals of seconds can be omitted (and so should be dot separator `.`).

`T` can also be replaced with a whitespace ` `. `Z` represents the `UTC`
timezone and can be replaced with a time offset in the format:

```
-06:00
```

In this case the sign (`+`/`-`) is not optional and seconds cannot be used.
*/
  @:from public static function fromString(s : String) : DateTime {
    if(s == null)
      throw new thx.Error('null String cannot be parsed to DateTime');
    var pattern = ~/^([-])?(\d+)[-](\d{2})[-](\d{2})(?:[T ](\d{2})[:](\d{2})[:](\d{2})(?:\.(\d+))?(Z|([+-]\d{2})[:](\d{2}))?)?$/;
    if(!pattern.match(s))
      throw new thx.Error('unable to parse DateTime string: "$s"');

    var smticks = pattern.matched(8),
        mticks = 0;
    if(null != smticks) {
      smticks = "1" + smticks.rpad("0", 7).substring(0, 7);
      mticks = Std.parseInt(smticks) - 10000000;
    }

    var time = Time.zero,
        timepart = pattern.matched(9);
    if(null != timepart && "Z" != timepart) {
      var hours = pattern.matched(10);
      if(hours.substring(0, 1) == "+")
        hours = hours.substring(1);
      time = Time.create(
        Std.parseInt(hours),
        Std.parseInt(pattern.matched(11)),
        0
      );
    }

    var date = create(
        Std.parseInt(pattern.matched(2)),
        Std.parseInt(pattern.matched(3)),
        Std.parseInt(pattern.matched(4)),
        Std.parseInt(pattern.matched(5)),
        Std.parseInt(pattern.matched(6)),
        Std.parseInt(pattern.matched(7)),
        0,
        time
      ) + mticks;
    if(pattern.matched(1) == "-")
      return new DateTime(DateTimeUtc.fromInt64(-date.utc.ticks), time);
    return date;
  }

/**
Checks if a Dynamic value is an instance of DateTime
Note: because thx.DateTime is an abstract of Array<haxe.Int64>, any array of exactly 2 haxe.Int64s will be considered to be a thx.DateTime
**/
  public static function is(v : Dynamic) : Bool {
    if (v == null) return false;
    if (!Std.is(v, Array)) return false;
    var vs : Array<Dynamic> = v;
    if (vs.length != 2) return false;
    return thx.Arrays.all(vs, haxe.Int64.is);
  }

/**
Alternative to fromString that returns the result in an Either rather than
a value or a thrown error.
**/
  public static function parse(s : String) : Either<String, DateTime> {
    return try {
      Right(fromString(s));
    } catch (e : Dynamic) {
      Left(thx.Error.fromDynamic(e).message);
    }
  }

/**
Creates an array of dates that begin at `start` and end at `end` included.
Time values are pick from the `start` value except for the last value that will
match `end`. No interpolation is made.
**/
  public static function daysRange(start : DateTime, end : DateTime) {
    if(less(end, start)) return [];
    var days = [];
    while(!start.sameDay(end)) {
      days.push(start);
      start = start.nextDay();
    }
    days.push(end);
    return days;
  }

  inline public static function compare(a : DateTime, b : DateTime): Int
    return a.compareTo(b);

  inline public static function ord(): Ord<DateTime>
    return Ord.fromIntComparison(compare);

/**
Creates a DateTime instance from its components (year, month, day, hour, minute,
second, millisecond and time offset).

All time components are optionals.
*/
  inline static public function create(year : Int, month : Int, day : Int, ?hour : Int = 0, ?minute : Int = 0, ?second : Int = 0, ?millisecond : Int = 0, offset : Time)
    return new DateTime(
      DateTimeUtc.create(year, month, day, hour, minute, second, millisecond),
      offset
    ).subtract(offset);

/**
DateTime constructor, requires a utc value and an offset.
*/
  inline public function new(dateTime : DateTimeUtc, offset : Time)
    this = [dateTime.ticks, offset.ticks];

  public var utc(get, never) : DateTimeUtc;
  public var offset(get, never) : Time;

  public var year(get, never) : Int;
  public var month(get, never) : Int;
  public var day(get, never) : Int;

  public var hour(get, never) : Int;
  public var minute(get, never) : Int;
  public var second(get, never) : Int;
  public var millisecond(get, never) : Int;
  public var microsecond(get, never) : Int;
  public var tickInSecond(get, never) : Int;

  public var isInLeapYear(get, never) : Bool;
  public var monthDays(get, never) : Int;
  public var dayOfWeek(get, never) : Weekday;
  public var dayOfYear(get, never) : Int;
  public var timeOfDay(get, never) : Time;

  inline public function min(other : DateTime) : DateTime
    return utc.compareTo(other.utc) <= 0 ? self() : other;

  inline public function max(other : DateTime) : DateTime
    return utc.compareTo(other.utc) >= 0 ? self() : other;

/**
  Get a date relative to the current date, shifting by a set period of time.
  Please note this works by constructing a new date object, rather than using `DateTools.delta()`.
  The key difference is that this allows us to jump over a period that may not be a set number of seconds.
  For example, jumping between months (which have different numbers of days), leap years, leap seconds, daylight savings time changes etc.
  @param period The TimePeriod you wish to jump by, Second, Minute, Hour, Day, Week, Month or Year.
  @param amount The multiple of `period` that you wish to jump by. A positive amount moves forward in time, a negative amount moves backward.
**/
  public function jump(period : TimePeriod, amount : Int) {
    var sec = second,
        min = minute,
        hr  = hour,
        day = day,
        mon : Int = month,
        yr  = year;

    switch period {
      case Second: sec += amount;
      case Minute: min += amount;
      case Hour:   hr  += amount;
      case Day:    day += amount;
      case Week:   day += amount * 7;
      case Month:  mon += amount;
      case Year:   yr  += amount;
    }

    return create(yr, mon, day, hr, min, sec, millisecond, offset);
  }

/**
Tells how many days in the month of this date.

@return Int, the number of days in the month.
**/
  public function daysInThisMonth()
    return daysInMonth(year, month);

/**
Returns a new date, exactly 1 year before the given date/time.
**/
  inline public function prevYear()
    return jump(Year, -1);

/**
Returns a new date, exactly 1 year after the given date/time.
**/
  inline public function nextYear()
    return jump(Year, 1);

/**
Returns a new date, exactly 1 month before the given date/time.
**/
  inline public function prevMonth()
    return jump(Month, -1);

/**
Returns a new date, exactly 1 month after the given date/time.
**/
  inline public function nextMonth()
    return jump(Month, 1);

/**
Returns a new date, exactly 1 week before the given date/time.
**/
  inline public function prevWeek()
    return jump(Week, -1);

/**
Returns a new date, exactly 1 week after the given date/time.
**/
  inline public function nextWeek()
    return jump(Week, 1);

/**
Returns a new date, exactly 1 day before the given date/time.
**/
  inline public function prevDay()
    return jump(Day, -1);

/**
Returns a new date, exactly 1 day after the given date/time.
**/
  inline public function nextDay()
    return jump(Day, 1);

/**
Returns a new date, exactly 1 hour before the given date/time.
**/
  inline public function prevHour()
    return jump(Hour, -1);

/**
Returns a new date, exactly 1 hour after the given date/time.
**/
  inline public function nextHour()
    return jump(Hour, 1);

/**
Returns a new date, exactly 1 minute before the given date/time.
**/
  inline public function prevMinute()
    return jump(Minute, -1);

/**
Returns a new date, exactly 1 minute after the given date/time.
**/
  inline public function nextMinute()
    return jump(Minute, 1);

/**
Returns a new date, exactly 1 second before the given date/time.
**/
  inline public function prevSecond()
    return jump(Second, -1);

/**
Returns a new date, exactly 1 second after the given date/time.
**/
  inline public function nextSecond()
    return jump(Second, 1);

/**
Snaps a date to the given weekday inside the current week.  The time within the day will stay the same.
If you are already on the given day, the date will not change.
@param date The date value to snap
@param day Day to snap to.  Either `Sunday`, `Monday`, `Tuesday` etc.
@param firstDayOfWk The first day of the week.  Default to `Sunday`.
@return The date of the day you have snapped to.
**/
  public function snapToWeekDay(weekday : Weekday, ?firstDayOfWk : Weekday = Sunday) {
    var d : Int = dayOfWeek,
        s : Int = weekday;

    // get whichever occurence happened in the current week.
    if (s < (firstDayOfWk : Int)) s = s + 7;
    if (d < (firstDayOfWk : Int)) d = d + 7;
    return jump(Day, s - d);
  }

/**
Snaps a date to the next given weekday.  The time within the day will stay the same.
If you are already on the given day, the date will not change.
@param date The date value to snap
@param day Day to snap to.  Either `Sunday`, `Monday`, `Tuesday` etc.
@return The date of the day you have snapped to.
**/
  public function snapNextWeekDay(weekday : Weekday) {
    var d : Int = dayOfWeek,
        s : Int = weekday;

    // get the next occurence of that day (forward in time)
    if (s < d) s = s + 7;
    return jump(Day, s - d);
  }

/**
Snaps a date to the previous given weekday.  The time within the day will stay the same.
If you are already on the given day, the date will not change.
@param date The date value to snap
@param day Day to snap to.  Either `Sunday`, `Monday`, `Tuesday` etc.
@return The date of the day you have snapped to.
**/
  public function snapPrevWeekDay(weekday : Weekday) {
    var d : Int = dayOfWeek,
        s : Int = weekday;

    // get the previous occurence of that day (backward in time)
    if (s > d) s = s - 7;
    return jump(Day, s - d);
  }

/**
Snaps a time to the next second, minute, hour, day, week, month or year.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapNext(period : TimePeriod) : DateTime
    return switch period {
      case Second:
        new DateTime(new DateTimeUtc(utc.ticks.divCeil(ticksPerSecondI64) * ticksPerSecondI64), offset);
      case Minute:
        new DateTime(new DateTimeUtc(utc.ticks.divCeil(ticksPerMinuteI64) * ticksPerMinuteI64), offset);
      case Hour:
        new DateTime(new DateTimeUtc(utc.ticks.divCeil(ticksPerHourI64) * ticksPerHourI64), offset);
      case Day:
        create(year, month, day + 1, 0, 0, 0, offset);
      case Week:
        var wd : Int = dayOfWeek;
        create(year, month, day + 7 - wd, 0, 0, 0, offset);
      case Month:
        create(year, month + 1, 1, 0, 0, 0, offset);
      case Year:
        create(year + 1, 1, 1, 0, 0, 0, offset);
    };

/**
Snaps a time to the previous second, minute, hour, day, week, month or year.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapPrev(period : TimePeriod) : DateTime
    return switch period {
      case Second:
        new DateTime(new DateTimeUtc(utc.ticks.divFloor(ticksPerSecondI64) * ticksPerSecondI64), offset);
      case Minute:
        new DateTime(new DateTimeUtc(utc.ticks.divFloor(ticksPerMinuteI64) * ticksPerMinuteI64), offset);
      case Hour:
        new DateTime(new DateTimeUtc(utc.ticks.divFloor(ticksPerHourI64) * ticksPerHourI64), offset);
      case Day:
        create(year, month, day, 0, 0, 0, offset);
      case Week:
        var wd : Int = dayOfWeek;
        create(year, month, day - wd, 0, 0, 0, offset);
      case Month:
        create(year, month, 1, 0, 0, 0, offset);
      case Year:
        create(year, 1, 1, 0, 0, 0, offset);
    };

/**
Snaps a time to the nearest second, minute, hour, day, week, month or year.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapTo(period : TimePeriod) : DateTime
    return switch period {
      case Second:
        new DateTime(new DateTimeUtc(utc.ticks.divRound(ticksPerSecondI64) * ticksPerSecondI64), offset);
      case Minute:
        new DateTime(new DateTimeUtc(utc.ticks.divRound(ticksPerMinuteI64) * ticksPerMinuteI64), offset);
      case Hour:
        new DateTime(new DateTimeUtc(utc.ticks.divRound(ticksPerHourI64) * ticksPerHourI64), offset);
      case Day:
        var mod = (hour >= 12) ? 1 : 0;
        create(year, month, day + mod, 0, 0, 0, offset);
      case Week:
        var wd : Int = dayOfWeek,
            mod = wd < 3 ? -wd : (wd > 3 ? 7 - wd : hour < 12 ? -wd : 7 - wd);
        create(year, month, day + mod, 0, 0, 0, offset);
      case Month:
        var mod = day > Math.round(daysInMonth(year, month) / 2) ? 1 : 0;
        create(year, month + mod, 1, 0, 0, 0, offset);
      case Year:
        var other = create(year, 6, 2, 0, 0, 0, offset),
            mod = self() > other ? 1 : 0;
        create(year + mod, 1, 1, 0, 0, 0, offset);
    };

/**
Returns true if this date and the `other` date share the same year.
**/
  public function sameYear(other : DateTime) : Bool
    return year == other.year;

/**
Returns true if this date and the `other` date share the same year and month.
**/
  public function sameMonth(other : DateTime) : Bool
    return sameYear(other) && month == other.month;

/**
Returns true if this date and the `other` date share the same year, month and day.
**/
  public function sameDay(other : DateTime) : Bool
    return sameMonth(other) && day == other.day;

/**
Returns true if this date and the `other` date share the same year, month, day and hour.
**/
  public function sameHour(other : DateTime) : Bool
    return sameDay(other) && hour == other.hour;

/**
Returns true if this date and the `other` date share the same year, month, day, hour and minute.
**/
  public function sameMinute(other : DateTime) : Bool
    return sameHour(other) && minute == other.minute;

/**
Returns true if this date and the `other` date share the same year, month, day, hour, minute and second.
**/
  public function sameSecond(other : DateTime)
    return sameMinute(other) && second == other.second;

  public function withYear(year : Int) : DateTime
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withMonth(month : Int) : DateTime
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withDay(day : Int) : DateTime
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withHour(hour : Int) : DateTime
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withMinute(minute : Int) : DateTime
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withSecond(second : Int) : DateTime
    return create(year, month, day, hour, minute, second, millisecond, offset);

  public function withMillisecond(millisecond : Int) : DateTime
    return create(year, month, day, hour, minute, second, millisecond, offset);

  inline public function withOffset(offset : Time) : DateTime
    return new DateTime(utc, offset);

  @:op(A+B) inline function add(time : Time) : DateTime
    return new DateTime(DateTimeUtc.fromInt64(utc.ticks + time.ticks), offset);

  @:op(A+B) inline function addTicks(ticks : Int64) : DateTime
    return new DateTime(DateTimeUtc.fromInt64(utc.ticks + ticks), offset);

  @:op(A-B) inline function subtract(time : Time) : DateTime
    return new DateTime(DateTimeUtc.fromInt64(utc.ticks - time.ticks), offset);

  @:op(A-B) function subtractDate(date : DateTime) : Time {
    var base = DateTimeUtc.fromInt64(utc.ticks + date.utc.ticks),
        date = new DateTime(base, offset);
    return new Time(date.utc.ticks);
  }

  inline public function addDays(days : Float) : DateTime
    return new DateTime(utc.addDays(days), offset);

  inline public function addHours(hours : Float) : DateTime
    return new DateTime(utc.addHours(hours), offset);

  inline public function addMilliseconds(milliseconds : Int) : DateTime
    return new DateTime(utc.addMilliseconds(milliseconds), offset);

  inline public function addMinutes(minutes : Float) : DateTime
    return new DateTime(utc.addMinutes(minutes), offset);

  inline public function addMonths(months : Int) : DateTime
    return new DateTime(utc.addMonths(months), offset);

  inline public function addSeconds(seconds : Float) : DateTime
    return new DateTime(utc.addSeconds(seconds), offset);

  inline public function addYears(years : Int) : DateTime
    return new DateTime(utc.addYears(years), offset);

  // TODO should it consider offset?
  public function compareTo(other : DateTime) : Int {
    if(null == other && this == null) return 0;
    if(null == this) return -1;
    else if(null == other) return 1;
    return Int64s.compare(utc.ticks, other.utc.ticks);
  }

  inline public function equalsTo(that : DateTime) : Bool
    return utc.ticks == that.utc.ticks;
  // TODO should it consider offset?
  @:op(A==B)
  inline static public function equals(self : DateTime, that : DateTime) : Bool
    return self.utc.ticks == that.utc.ticks;

  // TODO should it consider offset?
  inline public function notEqualsTo(that : DateTime) : Bool
    return utc.ticks != that.utc.ticks;

  @:op(A!=B)
  inline static public function notEquals(self : DateTime, that : DateTime) : Bool
    return self.utc.ticks != that.utc.ticks;

  // TODO should it consider offset?
  public function nearEqualsTo(other : DateTime, span : Time) : Bool {
    var ticks = Int64s.abs(other.utc.ticks - utc.ticks);
    return ticks <= span.abs().ticks;
  }

  inline public function greaterThan(that : DateTime) : Bool
    return compareTo(that) > 0;

  @:op(A>B)
  inline static public function greater(self : DateTime, that : DateTime) : Bool
    return self.compareTo(that) > 0;

  inline public function greaterEqualsTo(that : DateTime) : Bool
    return compareTo(that) >= 0;

  @:op(A>=B)
  inline static public function greaterEquals(self : DateTime, that : DateTime) : Bool
    return self.compareTo(that) >= 0;

  inline public function lessTo(that : DateTime) : Bool
    return compareTo(that) < 0;

  @:op(A<B)
  inline static public function less(self : DateTime, that : DateTime) : Bool
    return self.compareTo(that) < 0;

  inline public function lessEqualsTo(that : DateTime) : Bool
    return compareTo(that) <= 0;

  @:op(A<=B)
  inline static public function lessEquals(self : DateTime, that : DateTime) : Bool
    return self.compareTo(that) <= 0;

  inline public function changeOffset(newoffset : Time) : DateTime
    return new DateTime(clockDateTime() - newoffset, newoffset);

  inline public function toUtc() : DateTimeUtc
    return utc;

  inline function clockDateTime() : DateTimeUtc
    return new DateTimeUtc(utc.ticks + offset.ticks);

  //1997-07-16T19:20:30+01:00
  public function toString() {
    if(null == this)
      return "";
    var abs = new DateTime(new DateTimeUtc(utc.ticks.abs()), offset);
    var decimals = abs.tickInSecond != 0 ? '.' + abs.tickInSecond.lpad("0", 7).trimCharsRight(")") : "";
    var isneg = utc.ticks < Int64s.zero;
    return (isneg ? "-" : "") + '${abs.year}-${abs.month.lpad("0", 2)}-${abs.day.lpad("0", 2)}T${abs.hour.lpad("0", 2)}:${abs.minute.lpad("0", 2)}:${abs.second.lpad("0", 2)}${decimals}${offset.toGmtString()}';
  }

  inline function get_utc() : DateTimeUtc
    return new DateTimeUtc(this[0]);

  inline function get_offset() : Time
    return new Time(this[1]);

  inline function get_year() : Int
    return clockDateTime().year;

  inline function get_month() : Int
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

  inline function get_microsecond() : Int
    return clockDateTime().microsecond;

  inline function get_tickInSecond() : Int
    return clockDateTime().tickInSecond;

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
