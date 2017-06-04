package thx;

using haxe.Int64;
import thx.TimePeriod;
import thx.Weekday;
using thx.Ints;
using thx.Int64s;
using thx.Strings;

/**
`DateTimeUtc` represents a UTC instant between `-29228-09-14T02:48:05.4775807Z`
and `29228-09-14T02:48:05.4775807Z`.

`DateTimeUtc` represents a moment in time with no time-zone offset and it is
relative to UTC (Coordinated Universal Time).
*/
abstract DateTimeUtc(Int64) {
  static var millisPerSecond = 1000;
  static var millisPerMinute = millisPerSecond * 60;
  static var millisPerHour = millisPerMinute * 60;
  static var millisPerDay = millisPerHour * 24;

  static var tenI64 : Int64 = 10;
  static var hundredI64 : Int64 = 100;
  static var thousandI64 : Int64 = 1000;
  static var tenThousandI64 : Int64 = 10000;
  static var millionI64 : Int64 = 1000000;
  static var ticksPerMicrosecondI64 : Int64 = tenI64;
  static var ticksPerMillisecond : Int = 10000;
  static var ticksPerMillisecondI64 : Int64 = Int64.ofInt(ticksPerMillisecond);
  static var ticksPerSecondI64 : Int64 = ticksPerMillisecondI64 * 1000;
  static var ticksPerMinuteI64 : Int64 = ticksPerSecondI64 * 60;
  static var ticksPerHourI64 : Int64 = ticksPerMinuteI64 * 60;
  static var ticksPerDayI64 : Int64 = ticksPerHourI64 * 24;

  static var daysPerYear : Int = 365;
  static var daysPer4Years : Int = daysPerYear * 4 + 1;       // 1461
  static var daysPer100Years : Int = daysPer4Years * 25 - 1;  // 36524
  static var daysPer400Years : Int = daysPer100Years * 4 + 1; // 146097

  static var daysTo1970 : Int = daysPer400Years * 4 + daysPer100Years * 3 + daysPer4Years * 17 + daysPerYear; // 719,162
  static var unixEpochTicks : Int64 = ticksPerDayI64 * daysTo1970;

  static var DATE_PART_YEAR = 0;
  static var DATE_PART_DAY_OF_YEAR = 1;
  static var DATE_PART_MONTH = 2;
  static var DATE_PART_DAY = 3;

  static var daysToMonth365 = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
  static var daysToMonth366 = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];

/**
Returns the system date/time relative to UTC.
*/
  public static function now() : DateTimeUtc
// Date.getTime() in C# is broken hence the special case
#if cs // because of issue https://github.com/HaxeFoundation/haxe/issues/4452
    return new DateTimeUtc(cs.system.DateTime.Now.ToUniversalTime().Ticks);
#else
    return fromDate(Date.now());
#end

/**
Returns a date/time from an `Int64` value. The value is the number of ticks
(tenth of microseconds) since 1 C.E. (A.D.).
*/
  public static function fromInt64(ticks : Int64) : DateTimeUtc
    return new DateTimeUtc(ticks);

/**
Transforms a Haxe native `Date` instance into `DateTimeUtc`.
*/
  @:from public static function fromDate(date : Date) : DateTimeUtc
#if cs // because of issue https://github.com/HaxeFoundation/haxe/issues/4452
    return new DateTimeUtc(untyped date.date.Ticks);
#else
    return fromTime(date.getTime());
#end

/**
Transforms an epoch time value in milliconds into `DateTimeUtc`.
*/
  @:from public static function fromTime(timestamp : Float) : DateTimeUtc
    return new DateTimeUtc(Int64s.fromFloat(timestamp).mul(ticksPerMillisecondI64).add(unixEpochTicks));

/**
Parses a string into a `DateTimeUtc` value. If parsing is not possible an
exception is thrown.
*/
  @:from public static function fromString(s : String) : DateTimeUtc
    return DateTime.fromString(s).utc;

/**
Checks if a dynamic value is an instance of DateTimeUtc.
Note: because thx.DateTimeUtc is an abstract of haxe.Int64, any haxe.Int64 will be considered to be a thx.DateTimeUtc
**/
  public static function is(v : Dynamic) : Bool {
    return haxe.Int64.is(v);
  }

/**
Alternative to fromString that returns the result in an Either, rather than
a value or a thrown error.
**/
  public static function parse(s : String) : Either<String, DateTimeUtc> {
    return try {
      Right(fromString(s));
    } catch (e : Dynamic) {
      Left(thx.Error.fromDynamic(e).message);
    }
  }

  inline public static function compare(a : DateTimeUtc, b : DateTimeUtc)
    return a.compareTo(b);

/**
Creates a DateTime instance from its components (year, month, day, hour, minute
second and millisecond).

All time components are optionals.
*/
  public static function create(year : Int, month : Int, day : Int, ?hour : Int = 0, ?minute : Int = 0, ?second : Int = 0, ?millisecond : Int = 0) {
    second += Math.floor(millisecond / 1000);
    millisecond = millisecond % 1000;
    if(millisecond < 0)
      millisecond += 1000;

    var ticks = dateToTicks(year, month, day) +
                Time.timeToTicks(hour, minute, second) +
                (millisecond * ticksPerMillisecondI64);

    return new DateTimeUtc(ticks);
  }

  public static function isLeapYear(year : Int) : Bool
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

  public static function dateToTicks(year : Int, month : Int, day : Int) : Int64 {
    function fixMonthYear() {
      if(month == 0) {
        year--;
        month = 12;
      } else if(month < 0) {
        month = -month;
        var years = Math.ceil(month / 12);
        year -= years;
        month = years * 12 - month;
      } else if(month > 12) {
        var years = Math.floor(month / 12);
        year += years;
        month = month - years * 12;
      }
    }

    while(day < 0) {
      month--;
      fixMonthYear();
      day += daysInMonth(year, month);
    }

    fixMonthYear();
    var days;
    while(day > (days = daysInMonth(year, month))) {
      month++;
      fixMonthYear();
      day -= days;
    }

    if(day == 0) {
      month -= 1;
      fixMonthYear();
      day = daysInMonth(year, month);
    }

    fixMonthYear();

    return rawDateToTicks(year, month, day);
  }

  public static function rawDateToTicks(year : Int, month : Int, day : Int) : Int64 {
    var days = isLeapYear(year) ? daysToMonth366: daysToMonth365;
    if(day >= 1 && day <= days[month] - days[month - 1]) {
      var y = year - 1;
      var n = y * 365 + Std.int(y / 4) - Std.int(y / 100) + Std.int(y / 400) + days[month - 1] + day - 1;
      return n * ticksPerDayI64;
    }
    return throw new Error('bad year/month/day $year/$month/$day');
  }

  public static function daysInMonth(year : Int, month : Int) : Int {
    var days = isLeapYear(year) ? daysToMonth366 : daysToMonth365;
    return days[month] - days[month - 1];
  }

/**
Creates an array of dates that begin at `start` and end at `end` included.
Time values are pick from the `start` value except for the last value that will
match `end`. No interpolation is made.
**/
  public static function daysRange(start : DateTimeUtc, end : DateTimeUtc) {
    if(less(end, start)) return [];
    var days = [];
    while(!start.sameDay(end)) {
      days.push(start);
      start = start.nextDay();
    }
    days.push(end);
    return days;
  }

  private function getDatePart(part : Int) {
    var n = ticks.div(ticksPerDayI64).toInt();
    var y400 = Std.int(n / daysPer400Years);
    n -= y400 * daysPer400Years;
    var y100 = Std.int(n / daysPer100Years);
    if(y100 == 4)
      y100 = 3;
    n -= y100 * daysPer100Years;
    var y4 = Std.int(n / daysPer4Years);
    n -= y4 * daysPer4Years;
    var y1 = Std.int(n / daysPerYear);
    if(y1 == 4)
      y1 = 3;
    if(part == DATE_PART_YEAR) {
      return y400 * 400 + y100 * 100 + y4 * 4 + y1 + 1;
    }
    n -= y1 * daysPerYear;
    if(part == DATE_PART_DAY_OF_YEAR)
      return n + 1;
    var leapYear = y1 == 3 && (y4 != 24 || y100 == 3),
        days = leapYear ? daysToMonth366 : daysToMonth365,
        m = n >> 5 + 1;
    while(n >= days[m])
      m++;
    if(part == DATE_PART_MONTH)
      return m;
    return n - days[m - 1] + 1;
  }

  inline public function new(ticks : Int64)
    this = ticks;

  public var ticks(get, never) : Int64;

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

  public function min(other : DateTimeUtc) : DateTimeUtc
    return compareTo(other) <= 0 ? self() : other;

  public function max(other : DateTimeUtc) : DateTimeUtc
    return compareTo(other) >= 0 ? self() : other;

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

    return create(yr, mon, day, hr, min, sec, millisecond);
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
  public function snapNext(period : TimePeriod) : DateTimeUtc
    return switch period {
      case Second:
        new DateTimeUtc(ticks.divCeil(ticksPerSecondI64) * ticksPerSecondI64);
      case Minute:
        new DateTimeUtc(ticks.divCeil(ticksPerMinuteI64) * ticksPerMinuteI64);
      case Hour:
        new DateTimeUtc(ticks.divCeil(ticksPerHourI64) * ticksPerHourI64);
      case Day:
        create(year, month, day + 1, 0, 0, 0);
      case Week:
        var wd : Int = dayOfWeek;
        create(year, month, day + 7 - wd, 0, 0, 0);
      case Month:
        create(year, month + 1, 1, 0, 0, 0);
      case Year:
        create(year + 1, 1, 1, 0, 0, 0);
    };

/**
Snaps a time to the previous second, minute, hour, day, week, month or year.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapPrev(period : TimePeriod) : DateTimeUtc
    return switch period {
      case Second:
        new DateTimeUtc(ticks.divFloor(ticksPerSecondI64) * ticksPerSecondI64);
      case Minute:
        new DateTimeUtc(ticks.divFloor(ticksPerMinuteI64) * ticksPerMinuteI64);
      case Hour:
        new DateTimeUtc(ticks.divFloor(ticksPerHourI64) * ticksPerHourI64);
      case Day:
        create(year, month, day, 0, 0, 0);
      case Week:
        var wd : Int = dayOfWeek;
        create(year, month, day - wd, 0, 0, 0);
      case Month:
        create(year, month, 1, 0, 0, 0);
      case Year:
        create(year, 1, 1, 0, 0, 0);
    };

/**
Snaps a time to the nearest second, minute, hour, day, week, month or year.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapTo(period : TimePeriod) : DateTimeUtc
    return switch period {
      case Second:
        new DateTimeUtc(ticks.divRound(ticksPerSecondI64) * ticksPerSecondI64);
      case Minute:
        new DateTimeUtc(ticks.divRound(ticksPerMinuteI64) * ticksPerMinuteI64);
      case Hour:
        new DateTimeUtc(ticks.divRound(ticksPerHourI64) * ticksPerHourI64);
      case Day:
        var mod = (hour >= 12) ? 1 : 0;
        create(year, month, day + mod, 0, 0, 0);
      case Week:
        var wd : Int = dayOfWeek,
            mod = wd < 3 ? -wd : (wd > 3 ? 7 - wd : hour < 12 ? -wd : 7 - wd);
        create(year, month, day + mod, 0, 0, 0);
      case Month:
        var mod = day > Math.round(daysInMonth(year, month) / 2) ? 1 : 0;
        create(year, month + mod, 1, 0, 0, 0);
      case Year:
        var mod = self() > create(year, 6, 2, 0, 0, 0) ? 1 : 0;
        create(year + mod, 1, 1, 0, 0, 0);
    };

/**
Returns true if this date and the `other` date share the same year.
**/
  public function sameYear(other : DateTimeUtc) : Bool
    return year == other.year;

/**
Returns true if this date and the `other` date share the same year and month.
**/
  public function sameMonth(other : DateTimeUtc)
    return sameYear(other) && month == other.month;

/**
Returns true if this date and the `other` date share the same year, month and day.
**/
  public function sameDay(other : DateTimeUtc)
    return sameMonth(other) && day == other.day;

/**
Returns true if this date and the `other` date share the same year, month, day and hour.
**/
  public function sameHour(other : DateTimeUtc)
    return sameDay(other) && hour == other.hour;

/**
Returns true if this date and the `other` date share the same year, month, day, hour and minute.
**/
  public function sameMinute(other : DateTimeUtc)
    return sameHour(other) && minute == other.minute;

/**
Returns true if this date and the `other` date share the same year, month, day, hour, minute and second.
**/
  public function sameSecond(other : DateTimeUtc)
    return sameMinute(other) && second == other.second;

  public function withYear(year : Int)
    return create(year, month, day, hour, minute, second, millisecond);

  public function withMonth(month : Int)
    return create(year, month, day, hour, minute, second, millisecond);

  public function withDay(day : Int)
    return create(year, month, day, hour, minute, second, millisecond);

  public function withHour(hour : Int)
    return create(year, month, day, hour, minute, second, millisecond);

  public function withMinute(minute : Int)
    return create(year, month, day, hour, minute, second, millisecond);

  public function withSecond(second : Int)
    return create(year, month, day, hour, minute, second, millisecond);

  public function withMillisecond(millisecond : Int)
    return create(year, month, day, hour, minute, second, millisecond);

  @:op(A+B) inline function add(time : Time)
    return new DateTimeUtc(ticks + time.ticks);

  @:op(A+B) inline function addTicks(tickstoadd : Int64)
    return new DateTimeUtc(ticks + tickstoadd);

  @:op(A-B) inline function subtract(time : Time)
    return new DateTimeUtc(ticks - time.ticks);

  @:op(A-B) inline function subtractDate(date : DateTimeUtc) : Time
    return new Time(ticks - date.ticks);

  function addScaled(value : Float, scale : Int) {
    var millis : Int64 = Std.int(value * scale + (value >= 0? 0.5: -0.5));
    return new DateTimeUtc(ticks + millis * ticksPerMillisecondI64);
  }

  inline public function addDays(days : Float)
    return addScaled(days, millisPerDay);

  inline public function addHours(hours : Float)
    return addScaled(hours, millisPerHour);

  inline public function addMilliseconds(milliseconds : Int)
    return addScaled(milliseconds, 1);

  inline public function addMinutes(minutes : Float)
    return addScaled(minutes, millisPerMinute);

  public function addMonths(months : Int) {
    var y = getDatePart(DATE_PART_YEAR),
        m = getDatePart(DATE_PART_MONTH),
        d = getDatePart(DATE_PART_DAY),
        i = m - 1 + months;
    if(i >= 0) {
      m = Std.int(i % 12 + 1);
      y = Std.int(y + i / 12);
    } else {
      m = Std.int(12 + (i + 1) % 12);
      y = Std.int(y + (i - 11) / 12);
    }
    var days = daysInMonth(y, m);
    if(d > days)
      d = days;
    return new DateTimeUtc(dateToTicks(y, m, d) + ticks % ticksPerDayI64);
  }

  inline public function addSeconds(seconds : Float)
    return addScaled(seconds, millisPerSecond);

  inline public function addYears(years : Int)
    return addMonths(years * 12);

  public function compareTo(other : DateTimeUtc) : Int {
#if(js || php || neko || eval)
    if(null == other && this == null) return 0;
    if(null == this) return -1;
    else if(null == other) return 1;
#end
    return Int64s.compare(ticks, other.ticks);
  }

  inline public function equalsTo(that : DateTimeUtc)
    return ticks == that.ticks;

  @:op(A==B)
  inline static public function equals(self : DateTimeUtc, that : DateTimeUtc)
    return self.ticks == that.ticks;

  inline public function notEqualsTo(that : DateTimeUtc)
    return ticks != that.ticks;

  @:op(A!=B)
  inline static public function notEquals(self : DateTimeUtc, that : DateTimeUtc)
    return self.ticks != that.ticks;

  public function nearEqualsTo(other : DateTimeUtc, span : Time) {
    var ticks = Int64s.abs(other.ticks - ticks);
    return ticks <= span.abs().ticks;
  }

  inline public function greaterThan(that : DateTimeUtc) : Bool
    return ticks.compare(that.ticks) > 0;

  @:op(A>B)
  inline static public function greater(self : DateTimeUtc, that : DateTimeUtc) : Bool
    return self.ticks.compare(that.ticks) > 0;

  inline public function greaterEqualsTo(that : DateTimeUtc) : Bool
    return ticks.compare(that.ticks) >= 0;

  @:op(A>=B)
  inline static public function greaterEquals(self : DateTimeUtc, that : DateTimeUtc) : Bool
    return self.ticks.compare(that.ticks) >= 0
    ;
  inline public function lessThan(that : DateTimeUtc) : Bool
    return ticks.compare(that.ticks) < 0;

  @:op(A<B)
  inline static public function less(self : DateTimeUtc, that : DateTimeUtc) : Bool
    return self.ticks.compare(that.ticks) < 0;

  inline public function lessEqualsTo(that : DateTimeUtc) : Bool
    return ticks.compare(that.ticks) <= 0;

  @:op(A<=B)
  inline static public function lessEquals(self : DateTimeUtc, that : DateTimeUtc) : Bool
    return self.ticks.compare(that.ticks) <= 0;

  inline public function toTime() : Float
    return ticks.sub(unixEpochTicks).div(ticksPerMillisecondI64).toFloat();

  inline public function toDate() : Date
#if cs // because of issue https://github.com/HaxeFoundation/haxe/issues/4452
    return untyped Date.fromNative(new cs.system.DateTime(ticks));
#else
    return Date.fromTime(toTime());
#end

  inline public function toDateTime(?offset : Time) : DateTime
    return new DateTime(self(), null == offset ? Time.zero : offset);

  inline public function toLocalDateTime() : DateTime
    return new DateTime(self(), DateTime.localOffset());

  //1997-07-16T19:20:30Z
  public function toString() {
#if(js || php || neko || eval)
    if(null == this)
      return "";
#end
    var abs = DateTimeUtc.fromInt64(ticks.abs());
    var decimals = abs.tickInSecond != 0 ? '.' + abs.tickInSecond.lpad("0", 7).trimCharsRight(")") : "";
    var isneg = ticks < Int64s.zero;
    return (isneg ? "-" : "") + '${abs.year}-${abs.month.lpad("0", 2)}-${abs.day.lpad("0", 2)}T${abs.hour.lpad("0", 2)}:${abs.minute.lpad("0", 2)}:${abs.second.lpad("0", 2)}${decimals}Z';
  }

  inline function get_ticks() : Int64
    return this;

  inline function get_year() : Int
    return getDatePart(DATE_PART_YEAR);

  inline function get_month() : Int
    return getDatePart(DATE_PART_MONTH);

  inline function get_day() : Int
    return getDatePart(DATE_PART_DAY);

  function get_hour() : Int
    return ticks.div(ticksPerHourI64).mod(24).toInt();

  function get_minute() : Int
    return ticks.div(ticksPerMinuteI64).mod(60).toInt();

  function get_dayOfWeek() : Weekday
    return ticks.div(ticksPerDayI64).add(1).mod(7).toInt();

  inline function get_dayOfYear() : Int
    return getDatePart(DATE_PART_DAY_OF_YEAR);

  function get_millisecond() : Int
    return ticks.div(ticksPerMillisecondI64).mod(thousandI64).toInt();

  function get_microsecond() : Int
    return ticks.div(ticksPerMicrosecondI64).mod(millionI64).toInt();

  function get_tickInSecond() : Int
    return ticks.mod(10000000).toInt();

  function get_second() : Int
    return ticks.div(ticksPerSecondI64).mod(60).toInt();

  inline function get_timeOfDay() : Time
    return new Time(ticks % ticksPerDayI64);

  inline function get_isInLeapYear() : Bool
    return isLeapYear(year);

  inline function get_monthDays() : Int
    return daysInMonth(year, month);

  inline function self() : DateTimeUtc
    return cast this;
}
