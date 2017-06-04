package thx;

using thx.Ints;
using thx.Strings;
import thx.DateConst.*;

/**
`Date` represents a date (without time) between 5879611-07-12 and -5879611-07-13
(the actual boundary values are platform specific and depend on the precision
of the `Int` type).
`Date` represents a moment in time with no time-offset information.
*/
abstract LocalMonthDay(Int) {
/**
Returns the system month/day relative to UTC.
*/
  public static function now() : LocalMonthDay
    return fromDate(Date.now());

/**
Returns a LocalMonthDay instance from an `Int` value. The value is the number of
days since --01-01 (`zero` is the first of January).
*/
  inline public static function fromInt(days : Int) : LocalMonthDay {
    if(days < 0)
      days = 0;
    else if(days > 365)
      days = 365;
    return new LocalMonthDay(days);
  }

/**
Transforms a Haxe native `Date` instance into `LocalMonthDay`.
*/
  @:from public static function fromDate(date : Date) : LocalMonthDay
    return LocalMonthDay.create(date.getMonth() + 1, date.getDate());

/**
Transforms an epoch time value in milliconds into `LocalMonthDay`.
*/
  @:from public static function fromTime(timestamp : Float) : LocalMonthDay
    return fromDate(Date.fromTime(timestamp));

/**
Converts a string into a `LocalMonthDay` value. The accepted format looks like this:
```
2016-08
```
*/
  @:from public static function fromString(s : String) : LocalMonthDay {
    return switch parse(s) {
      case Left(error) : throw new thx.Error(error);
      case Right(v) : v;
    };
  }

/**
Alternative to fromString that returns the error/success values in an Either,
rather than throwing and Error.
*/
  public static function parse(s : String) : Either<String, LocalMonthDay> {
    return if (s == null) {
      Left('null String cannot be parsed to LocalMonthDay');
    } else {
      var pattern = ~/^[-]{2}(\d{1,2})[-](\d{2})$/;
      if(!pattern.match(s)) {
        Left('unable to parse LocalMonthDay string: "$s"');
      } else {
        var month = Std.parseInt(pattern.matched(1)),
            day   = Std.parseInt(pattern.matched(2));
        return Right(create(month, day));
      }
    }
  }

  inline public static function compare(a : LocalMonthDay, b : LocalMonthDay)
    return Ints.compare(a.days, b.days);

/**
Creates a LocalMonthDay instance from its components (month, day).
If month is negative the date is snapped to `--01-01`.
If month is above the date is snapped to `--12-31`.
If day is zero or less it is corrected to `01`.
If day is above the available number of days in `month`, then it is snapped to
the highest date allowed for that month (eg: `--02-30` is changed to `--02-29`).
*/
  public static function create(month : Int, day : Int) {
    var days = dateToMonthDay(month, day);
    return new LocalMonthDay(days);
  }

  public static function dateToMonthDay(month : Int, day : Int) : Int {
    if(month < 1)
      return 0;
    if(month > 12)
      return 365;
    var max = DAYS[month];
    if(day > max)
      day = max;
    if(day < 0)
      day = 1;
    return rawDateToDays(month, day);
  }

  static function rawDateToDays(month : Int, day : Int) : Int {
    return DAYS_ACC[month] + day - 1;
  }

/**
Creates an array of dates that begin at `start` and end at `end` included.
Time values are pick from the `start` value except for the last value that will
match `end`. No interpolation is made.
**/
  public static function daysRange(start : LocalMonthDay, end : LocalMonthDay) : Array<LocalMonthDay> {
    if(less(end, start)) return [];
    var days = [];
    while(start.days != end.days) {
      days.push(start);
      start = start.nextDay();
    }
    days.push(end);
    return days;
  }

  inline function new(days : Int)
    this = days;

  public var days(get, never) : Int;

  public var day(get, never) : Int;
  public var month(get, never) : Int;

  public function min(other : LocalMonthDay) : LocalMonthDay
    return compareTo(other) <= 0 ? self() : other;

  public function max(other : LocalMonthDay) : LocalMonthDay
    return compareTo(other) >= 0 ? self() : other;

/**
  Get a date relative to the current date, shifting by a set period of time.
  Please note this works by constructing a new date object, rather than using `DateTools.delta()`.
  The key difference is that this allows us to jump over a period that may not be a set number of seconds.
  For example, jumping between days (which have different numbers of days), leap days, leap seconds, daylight savings time changes etc.
  @param period The TimePeriod you wish to jump by, Second, Minute, Hour, Day, Week, Month or Year.
  @param amount The multiple of `period` that you wish to jump by. A positive amount moves forward in time, a negative amount moves backward.
**/
  public function jump(period : TimePeriod, amount : Int): LocalMonthDay {
    return switch period {
      case Year:
        self();
      case Month:
        create(month + amount, day);
      case Week:
        fromInt(days + 7 * amount);
      case Day:
        fromInt(days + amount);
      case Hour:
        fromInt(days + Math.floor(amount / 24));
      case Minute:
        fromInt(days + Math.floor(amount / 1440));
      case Second:
        fromInt(days + Math.floor(amount / 86400));
    };
  }

/**
Tells how many days in the month of this date.

@return Int, the number of days in the month.
**/
  public function daysInThisMonth(year: Int)
    return DateTimeUtc.daysInMonth(year, month);

/**
Returns a new date, exactly 1 month before the given month/day.
**/
  inline public function prevMonth()
    return jump(Month, -1);

/**
Returns a new date, exactly 1 month after the given month/day.
**/
  inline public function nextMonth()
    return jump(Month, 1);

/**
Returns a new date, exactly 1 day before the given month/day.
**/
  inline public function prevDay()
    return jump(Day, -1);

/**
Returns a new date, exactly 1 day after the given month/day.
**/
  inline public function nextDay()
    return jump(Day, 1);

/**
Snaps a time to the next second, minute, hour, day, week, month or day.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapNext(period : TimePeriod) : LocalMonthDay
    return jump(period, 1);

/**
Snaps a time to the previous second, minute, hour, day, week, month or day.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapPrev(period : TimePeriod) : LocalMonthDay
    return jump(period, -1);

/**
Snaps a time to the nearest second, minute, hour, day, week, month or day.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapTo(period : TimePeriod) : LocalMonthDay {
    return switch period {
      case Second, Minute, Hour, Day, Week, Year:
        self();
        case Month if(day <= Math.round(DAYS[month] / 2)):
          create(month, 1);
        case Month:
          create(month+1, 1);
        };
  }

/**
Returns true if this date and the `other` date share the same day.
**/
  public function sameDay(other : LocalMonthDay) : Bool
    return day == other.day;

/**
Returns true if this date and the `other` date share the same month.
**/
  public function sameMonth(other : LocalMonthDay)
    return month == other.month;

  public function withDay(day : Int)
    return create(month, day);

  public function withMonth(month : Int)
    return create(month, day);

  @:op(A+B) inline public function add(days : Int)
    return fromInt(this + days);

  @:op(A-B) inline public function subtract(days : Int)
    return fromInt(this - days);

  @:op(A-B) inline function subtractDate(date : LocalMonthDay) : Int
    return days - date.days;

  public function addDays(days : Int)
    return fromInt(this + days);

  public function addMonths(months : Int)
    return create(month + months, day);

  public function compareTo(other : LocalMonthDay) : Int {
#if(js || php || neko || eval)
    if(null == other && this == null) return 0;
    if(null == this) return -1;
    else if(null == other) return 1;
#end
    return Ints.compare(days, other.days);
  }

  inline public function equalsTo(that : LocalMonthDay)
    return days == that.days;

  @:op(A==B)
  inline static public function equals(self : LocalMonthDay, that : LocalMonthDay)
    return self.days == that.days;

  inline public function notEqualsTo(that : LocalMonthDay)
    return days != that.days;

  @:op(A!=B)
  inline static public function notEquals(self : LocalMonthDay, that : LocalMonthDay)
    return self.days != that.days;

  inline public function greaterThan(that : LocalMonthDay) : Bool
    return days.compare(that.days) > 0;

  @:op(A>B)
  inline static public function greater(self : LocalMonthDay, that : LocalMonthDay) : Bool
    return self.days.compare(that.days) > 0;

  inline public function greaterEqualsTo(that : LocalMonthDay) : Bool
    return days.compare(that.days) >= 0;

  @:op(A>=B)
  inline static public function greaterEquals(self : LocalMonthDay, that : LocalMonthDay) : Bool
    return self.days.compare(that.days) >= 0
    ;
  inline public function lessThan(that : LocalMonthDay) : Bool
    return days.compare(that.days) < 0;

  @:op(A<B)
  inline static public function less(self : LocalMonthDay, that : LocalMonthDay) : Bool
    return self.days.compare(that.days) < 0;

  inline public function lessEqualsTo(that : LocalMonthDay) : Bool
    return days.compare(that.days) <= 0;

  @:op(A<=B)
  inline static public function lessEquals(self : LocalMonthDay, that : LocalMonthDay) : Bool
    return self.days.compare(that.days) <= 0;

  inline public function toDate(year: Int) : Date
    return new Date(year, month - 1, day, 0, 0, 0);
  inline public function toDateTimeUtc(year: Int) : DateTimeUtc
    return DateTimeUtc.create(year, month, day, 0, 0, 0);
  inline public function toLocalDate(year: Int) : LocalDate
    return LocalDate.create(year, month, day);

  //1997-07-16
  public function toString() {
#if(js || php || neko || eval)
    if(null == this)
      return "";
#end
    return '--${month.lpad("0", 2)}-${day.lpad("0", 2)}';
  }

  inline function get_days() : Int
    return this;

  function get_day() : Int
    return 1 + days - DAYS_ACC[month];

  function get_month() : Int {
    var d = days;
    for(i in 1...12) {
      var len = DAYS[i];
      if(d < len)
        return i;
      d -= len;
    }
    if(d <= 31)
      return 12;
    trace(days, d);
    return throw 'Unexpected result, this should never happen';
  }

  static var DAYS = [0,31,29,31,30,31,30,31,31,30,31,30,31];
  static var DAYS_ACC = [0,0,31,60,91,121,152,182,213,244,274,305,335];

  inline function self() : LocalMonthDay
    return cast this;
}
