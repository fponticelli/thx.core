package thx;

import thx.Either;
using thx.Ints;
import thx.DateConst.*;

/**
`Date` represents a date (without time) between 5879611-07-12 and -5879611-07-13
(the actual boundary values are platform specific and depend on the precision
of the `Int` type).
`Date` represents a moment in time with no time-offset information.
*/
abstract LocalDate(Int) {
  public inline static var DATE_PART_YEAR = 0;
  public inline static var DATE_PART_DAY_OF_YEAR = 1;
  public inline static var DATE_PART_MONTH = 2;
  public inline static var DATE_PART_DAY = 3;
/**
Returns the system date/time relative to UTC.
*/
  public static function now() : LocalDate
    return fromDate(Date.now());

/**
Returns a LocalDate instance from an `Int` value. The value is the number of days
since 1 C.E. (A.D.).
*/
  inline public static function fromInt(days : Int) : LocalDate
    return new LocalDate(days);

/**
Transforms a Haxe native `Date` instance into `LocalDate`.
*/
  @:from public static function fromDate(date : Date) : LocalDate
    return create(date.getFullYear(), date.getMonth() + 1, date.getDate());

/**
Transforms an epoch time value in milliconds into `LocalDate` assuming GMT time.
*/
  @:from public static function fromTime(timestamp : Float) : LocalDate
    return new LocalDate(Std.int(timestamp / millisPerDay) + unixEpochDays);

/**
Converts a string into a `LocalDate` value. The accepted format looks like this:
```
2016-08-07
```
*/
  @:from public static function fromString(s : String) : LocalDate {
    return switch parse(s)  {
      case Left(error): throw new thx.Error(error);
      case Right(d): d;
    };
  }

  public static function parse(s: String): Either<String, LocalDate> {
    return if (s == null) {
      Left('null String cannot be parsed to LocalDate');
    } else {
      var pattern = ~/^([-])?(\d+)[-](\d{2})[-](\d{2})$/;
      if (!pattern.match(s)) {
        Left('unable to parse DateTime string: "$s"');
      } else {
        var date = create(
            Std.parseInt(pattern.matched(2)),
            Std.parseInt(pattern.matched(3)),
            Std.parseInt(pattern.matched(4))
        );

        Right(if (pattern.matched(1) == "-") new LocalDate(-date.days) else date);
      }
    }
  }

  inline public static function compare(a : LocalDate, b : LocalDate)
    return Ints.compare(a.days, b.days);

/**
Creates a LocalDate instance from its components (year, month, day).
*/
  public static function create(year : Int, month : Int, day : Int) {
    var days = dateToDays(year, month, day);
    return new LocalDate(days);
  }

  public static function dateToDays(year : Int, month : Int, day : Int) : Int {
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
      day += DateTimeUtc.daysInMonth(year, month);
    }

    fixMonthYear();
    var days;
    while(day > (days = DateTimeUtc.daysInMonth(year, month))) {
      month++;
      fixMonthYear();
      day -= days;
    }

    if(day == 0) {
      month -= 1;
      fixMonthYear();
      day = DateTimeUtc.daysInMonth(year, month);
    }

    fixMonthYear();

    return rawDateToDays(year, month, day);
  }

  public static function rawDateToDays(year : Int, month : Int, day : Int) : Int {
    var days = DateTimeUtc.isLeapYear(year) ? daysToMonth366: daysToMonth365;
    if(day >= 1 && day <= days[month] - days[month - 1]) {
      var y = year - 1;
      var n = y * 365 + Std.int(y / 4) - Std.int(y / 100) + Std.int(y / 400) + days[month - 1] + day - 1;
      return n;
    }
    return throw new Error('bad year-month-day $year-$month-$day');
  }

/**
Creates an array of dates that begin at `start` and end at `end` included.
Time values are pick from the `start` value except for the last value that will
match `end`. No interpolation is made.
**/
  public static function daysRange(start : LocalDate, end : LocalDate) : Array<LocalDate> {
    if(less(end, start)) return [];
    var days = [];
    while(start.days != end.days) {
      days.push(start);
      start = start.nextDay();
    }
    days.push(end);
    return days;
  }

  private function getDatePart(part : Int) {
    var n = days;
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
        adays = leapYear ? daysToMonth366 : daysToMonth365,
        m = n >> 5 + 1;
    while(n >= adays[m])
      m++;
    if(part == DATE_PART_MONTH)
      return m;
    return n - adays[m - 1] + 1;
  }

  inline public function new(days : Int)
    this = days;

  public var days(get, never) : Int;

  public var year(get, never) : Int;
  public var month(get, never) : Int;
  public var day(get, never) : Int;

  public var isInLeapYear(get, never) : Bool;
  public var monthDays(get, never) : Int;
  public var dayOfWeek(get, never) : Weekday;
  public var dayOfYear(get, never) : Int;

  public function min(other : LocalDate) : LocalDate
    return compareTo(other) <= 0 ? self() : other;

  public function max(other : LocalDate) : LocalDate
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
    var sec = 0,
        min = 0,
        hr  = 0,
        day = day,
        mon = month,
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
    var time = Time.create(hr, min, sec),
        extraDays = Math.floor(time.days / 7);

    return create(yr, mon, day + extraDays);
  }

/**
Tells how many days in the month of this date.

@return Int, the number of days in the month.
**/
  public function daysInThisMonth()
    return DateTimeUtc.daysInMonth(year, month);

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
  public function snapNext(period : TimePeriod) : LocalDate
    return switch period {
      case Second, Minute, Hour:
        self();
      case Day:
        new LocalDate(days + 1);
      case Week:
        var wd : Int = dayOfWeek;
        new LocalDate(days + 7 - wd);
      case Month:
        create(year, month + 1, 1);
      case Year:
        create(year + 1, 1, 1);
    };

/**
Snaps a time to the previous second, minute, hour, day, week, month or year.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapPrev(period : TimePeriod) : LocalDate
    return switch period {
      case Second, Minute, Hour, Day:
        new LocalDate(days - 1);
      case Week:
        var wd : Int = dayOfWeek;
        new LocalDate(days - wd);
      case Month:
        create(year, month, 1);
      case Year:
        create(year, 1, 1);
    };

/**
Snaps a time to the nearest second, minute, hour, day, week, month or year.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapTo(period : TimePeriod) : LocalDate
    return switch period {
      case Second, Minute, Hour, Day:
        self();
      case Week:
        var wd : Int = dayOfWeek,
            mod = wd <= 3 ? -wd : 7 - wd;
        create(year, month, day + mod);
      case Month:
        var mod = day > Math.round(DateTimeUtc.daysInMonth(year, month) / 2) ? 1 : 0;
        create(year, month + mod, 1);
      case Year:
        var mod = self() > create(year, 6, 2) ? 1 : 0;
        create(year + mod, 1, 1);
    };

/**
Returns true if this date and the `other` date share the same year.
**/
  public function sameYear(other : LocalDate) : Bool
    return year == other.year;

/**
Returns true if this date and the `other` date share the same year and month.
**/
  public function sameMonth(other : LocalDate)
    return sameYear(other) && month == other.month;

  public function withYear(year : Int)
    return create(year, month, day);

  public function withMonth(month : Int)
    return create(year, month, day);

  public function withDay(day : Int)
    return create(year, month, day);

  @:op(A+B) inline function add(days : Int)
    return new LocalDate(this + days);

  @:op(A-B) inline function subtract(days : Int)
    return new LocalDate(this - days);

  @:op(A-B) inline function subtractDate(date : LocalDate) : Int
    return days - date.days;

  inline public function addDays(days : Int)
    return new LocalDate(this + days);

  public function addMonths(months : Int) {
    return create(year, month + months, day);
  }

  inline public function addYears(years : Int)
    return addMonths(years * 12);

  public function compareTo(other : LocalDate) : Int {
#if(js || php || neko || eval)
    if(null == other && this == null) return 0;
    if(null == this) return -1;
    else if(null == other) return 1;
#end
    return Ints.compare(days, other.days);
  }

  inline public function equalsTo(that : LocalDate)
    return days == that.days;

  @:op(A==B)
  inline static public function equals(self : LocalDate, that : LocalDate)
    return self.days == that.days;

  inline public function notEqualsTo(that : LocalDate)
    return days != that.days;

  @:op(A!=B)
  inline static public function notEquals(self : LocalDate, that : LocalDate)
    return self.days != that.days;

  public function nearEqualsTo(other : LocalDate, span : Time) {
    var days = Ints.abs(other.days - days);
    return days <= span.abs().days;
  }

  inline public function greaterThan(that : LocalDate) : Bool
    return days.compare(that.days) > 0;

  @:op(A>B)
  inline static public function greater(self : LocalDate, that : LocalDate) : Bool
    return self.days.compare(that.days) > 0;

  inline public function greaterEqualsTo(that : LocalDate) : Bool
    return days.compare(that.days) >= 0;

  @:op(A>=B)
  inline static public function greaterEquals(self : LocalDate, that : LocalDate) : Bool
    return self.days.compare(that.days) >= 0
    ;
  inline public function lessThan(that : LocalDate) : Bool
    return days.compare(that.days) < 0;

  @:op(A<B)
  inline static public function less(self : LocalDate, that : LocalDate) : Bool
    return self.days.compare(that.days) < 0;

  inline public function lessEqualsTo(that : LocalDate) : Bool
    return days.compare(that.days) <= 0;

  @:op(A<=B)
  inline static public function lessEquals(self : LocalDate, that : LocalDate) : Bool
    return self.days.compare(that.days) <= 0;

/**
Transforms a date to a timestamp assuming GMT time.
*/
  inline public function toTime() : Float
    return (this - unixEpochDays) * millisPerDay;

  inline public function toDate() : Date
    return new Date(year, month - 1, day, 0, 0, 0);
  inline public function toLocalYearMonth() : LocalYearMonth
    return LocalYearMonth.create(year, month);
  inline public function toDateTimeUtc() : DateTimeUtc
    return DateTimeUtc.create(year, month, day, 0, 0, 0);

  //1997-07-16
  public function toString() {
#if(js || php || neko || eval)
    if(null == this)
      return "";
#end
    var abs = LocalDate.fromInt(Ints.abs(days));
    var isneg = days < 0;
    return (isneg ? "-" : "") + '${abs.year}-${abs.month.lpad("0", 2)}-${abs.day.lpad("0", 2)}';
  }

  inline function get_days() : Int
    return this;

  inline function get_year() : Int
    return getDatePart(DATE_PART_YEAR);

  inline function get_month() : Int
    return getDatePart(DATE_PART_MONTH);

  inline function get_day() : Int
    return getDatePart(DATE_PART_DAY);

  function get_dayOfWeek() : Weekday
    return (days + 1) % 7;

  inline function get_dayOfYear() : Int
    return getDatePart(DATE_PART_DAY_OF_YEAR);

  inline function get_isInLeapYear() : Bool
    return DateTimeUtc.isLeapYear(year);

  inline function get_monthDays() : Int
    return DateTimeUtc.daysInMonth(year, month);

  inline function self() : LocalDate
    return cast this;
}
