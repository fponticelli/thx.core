package thx;

using thx.Ints;
using thx.Strings;
import thx.DateConst.*;

/**
`LocalYearMonth` represents a date (without day of the month) without time-offset
information.
*/
abstract LocalYearMonth(Int) {
/**
Returns the system year/month.
*/
  public static function now() : LocalYearMonth
    return fromDate(Date.now());

/**
Returns a `LocalYearMonth` instance from an `Int` value. The value is the number
of months since 1 C.E. (A.D.).
*/
  inline public static function fromInt(months : Int) : LocalYearMonth
    return new LocalYearMonth(months);

/**
Transforms a Haxe native `Date` instance into `LocalYearMonth`.
*/
  @:from public static function fromDate(date : Date) : LocalYearMonth
    return LocalYearMonth.create(date.getFullYear(), date.getMonth() + 1);

/**
Transforms an epoch time value in milliconds into `LocalYearMonth`.
*/
  @:from public static function fromTime(timestamp : Float) : LocalYearMonth
    return fromDate(Date.fromTime(timestamp));

/**
Converts a string into a `LocalYearMonth` value. The accepted format looks like this:
```
2016-08
```
*/
  @:from public static function fromString(s : String) : LocalYearMonth {
    return switch parse(s) {
      case Left(error) : throw new thx.Error(error);
      case Right(v) : v;
    };
  }

/**
Alternative to fromString that returns the error/success values in an Either,
rather than throwing and Error.
*/
  public static function parse(s : String) : Either<String, LocalYearMonth> {
    return if (s == null) {
      Left('null String cannot be parsed to LocalYearMonth');
    } else {
      var pattern = ~/^([-])?(\d+)[-](\d{2})$/;
      if(!pattern.match(s)) {
        Left('unable to parse LocalYearMonth string: "$s"');
      } else {
        var years  = Std.parseInt(pattern.matched(2)),
            months = Std.parseInt(pattern.matched(3));
        return Right(create((pattern.matched(1) == "-" ? -1 : 1) * years, months));
      }
    }
  }

  inline public static function compare(a : LocalYearMonth, b : LocalYearMonth)
    return Ints.compare(a.months, b.months);

/**
Creates a LocalYearMonth instance from its components (year, month).
*/
  public static function create(year : Int, month : Int) {
    var months = dateToYearMonth(year, month);
    return new LocalYearMonth(months);
  }

  public static function dateToYearMonth(year : Int, month : Int) : Int {
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

    return rawDateToMonths(year, month);
  }

  static function rawDateToMonths(year : Int, month : Int) : Int {
    if(year == 0) {
      return dateToYearMonth(-1, month + 1);
    } else if(year < 0) {
      return (year + 1) * 12 - (13 - month);
    } else {
      return (year - 1) * 12 + month - 1;
    }
  }

/**
Creates an array of dates that begin at `start` and end at `end` included.
Time values are pick from the `start` value except for the last value that will
match `end`. No interpolation is made.
**/
  public static function monthsRange(start : LocalYearMonth, end : LocalYearMonth) : Array<LocalYearMonth> {
    if(less(end, start)) return [];
    var month = [];
    while(start.month != end.month) {
      month.push(start);
      start = start.nextMonth();
    }
    month.push(end);
    return month;
  }

  inline public function new(months : Int)
    this = months;

  public var months(get, never) : Int;

  public var year(get, never) : Int;
  public var month(get, never) : Int;

  public var isInLeapYear(get, never) : Bool;
  public var monthDays(get, never) : Int;

  public function min(other : LocalYearMonth) : LocalYearMonth
    return compareTo(other) <= 0 ? self() : other;

  public function max(other : LocalYearMonth) : LocalYearMonth
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
    return toLocalDate().jump(period, amount).toLocalYearMonth();
  }

/**
Tells how many days in the month of this date.

@return Int, the number of days in the month.
**/
  public function daysInThisMonth()
    return DateTimeUtc.daysInMonth(year, month);

/**
Returns a new date, exactly 1 year before the given year/month.
**/
  inline public function prevYear()
    return LocalYearMonth.create(year - 1, month);

/**
Returns a new date, exactly 1 year after the given year/month.
**/
  inline public function nextYear()
    return LocalYearMonth.create(year + 1, month);

/**
Returns a new date, exactly 1 month before the given year/month.
**/
  inline public function prevMonth()
    return LocalYearMonth.create(year, month - 1);

/**
Returns a new date, exactly 1 month after the given year/month.
**/
  inline public function nextMonth()
    return LocalYearMonth.create(year, month + 1);

/**
Snaps a time to the next second, minute, hour, day, week, month or year.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapNext(period : TimePeriod) : LocalYearMonth
    return switch period {
      case Second, Minute, Hour, Day, Week:
        self();
      case Month:
        new LocalYearMonth(this + 1);
      case Year:
        LocalYearMonth.create(year + 1, 1);
    };

/**
Snaps a time to the previous second, minute, hour, day, week, month or year.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapPrev(period : TimePeriod) : LocalYearMonth
    return switch period {
      case Second, Minute, Hour, Day, Week, Month:
        new LocalYearMonth(this - 1);
      case Year:
        LocalYearMonth.create(year - 1, 1);
    };

/**
Snaps a time to the nearest second, minute, hour, day, week, month or year.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapTo(period : TimePeriod) : LocalYearMonth
    return switch period {
      case Second, Minute, Hour, Day, Week, Month:
        self();
      case Year if(month <= 6):
        LocalYearMonth.create(year, 1);
      case Year:
        LocalYearMonth.create(year + 1, 1);
    };

/**
Returns true if this date and the `other` date share the same year.
**/
  public function sameYear(other : LocalYearMonth) : Bool
    return year == other.year;

/**
Returns true if this date and the `other` date share the same month.
**/
  public function sameMonth(other : LocalYearMonth)
    return month == other.month;

  public function withYear(year : Int)
    return create(year, month);

  public function withMonth(month : Int)
    return create(year, month);

  @:op(A+B) inline function add(months : Int)
    return new LocalYearMonth(this + months);

  @:op(A-B) inline function subtract(months : Int)
    return new LocalYearMonth(this - months);

  @:op(A-B) inline function subtractDate(date : LocalYearMonth) : Int
    return months - date.months;

  inline public function addYears(years : Int)
    return new LocalYearMonth(this + years * 12);

  inline public function addMonths(months : Int)
    return new LocalYearMonth(this + months);

  public function compareTo(other : LocalYearMonth) : Int {
#if(js || php || neko || eval)
    if(null == other && this == null) return 0;
    if(null == this) return -1;
    else if(null == other) return 1;
#end
    return Ints.compare(months, other.months);
  }

  inline public function equalsTo(that : LocalYearMonth)
    return months == that.months;

  @:op(A==B)
  inline static public function equals(self : LocalYearMonth, that : LocalYearMonth)
    return self.months == that.months;

  inline public function notEqualsTo(that : LocalYearMonth)
    return months != that.months;

  @:op(A!=B)
  inline static public function notEquals(self : LocalYearMonth, that : LocalYearMonth)
    return self.months != that.months;

  inline public function greaterThan(that : LocalYearMonth) : Bool
    return months.compare(that.months) > 0;

  @:op(A>B)
  inline static public function greater(self : LocalYearMonth, that : LocalYearMonth) : Bool
    return self.months.compare(that.months) > 0;

  inline public function greaterEqualsTo(that : LocalYearMonth) : Bool
    return months.compare(that.months) >= 0;

  @:op(A>=B)
  inline static public function greaterEquals(self : LocalYearMonth, that : LocalYearMonth) : Bool
    return self.months.compare(that.months) >= 0
    ;
  inline public function lessThan(that : LocalYearMonth) : Bool
    return months.compare(that.months) < 0;

  @:op(A<B)
  inline static public function less(self : LocalYearMonth, that : LocalYearMonth) : Bool
    return self.months.compare(that.months) < 0;

  inline public function lessEqualsTo(that : LocalYearMonth) : Bool
    return months.compare(that.months) <= 0;

  @:op(A<=B)
  inline static public function lessEquals(self : LocalYearMonth, that : LocalYearMonth) : Bool
    return self.months.compare(that.months) <= 0;

  inline public function toDate() : Date
    return new Date(year, month - 1, 1, 0, 0, 0);
  inline public function toDateTimeUtc() : DateTimeUtc
    return DateTimeUtc.create(year, month, 1, 0, 0, 0);
  inline public function toLocalDate() : LocalDate
    return LocalDate.create(year, month, 1);

  //1997-07-16
  public function toString() {
#if(js || php || neko || eval)
    if(null == this)
      return "";
#end
    return '${year}-${month.lpad("0", 2)}';
  }

  inline function get_months() : Int
    return this;

  function get_year() : Int {
    if(this < 0) {
      return Math.floor(this / 12);
    } else {
      return 1 + Math.floor(this / 12);
    }
  }

  function get_month() : Int {
    if(this < 0) {
      return 12 + ((this + 1) % 12);
    } else {
      return (this % 12) + 1;
    }
  }

  inline function get_isInLeapYear() : Bool
    return DateTimeUtc.isLeapYear(year);

  inline function get_monthDays() : Int
    return DateTimeUtc.daysInMonth(year, month);

  inline function self() : LocalYearMonth
    return cast this;
}
