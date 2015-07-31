package thx;

using haxe.Int64;
import thx.Month;
import thx.Weekday;
using thx.Ints;
using thx.Int64s;
using thx.Strings;

abstract DateTimeUtc(Int64) {
  static var millisPerSecond = 1000;
  static var millisPerMinute = millisPerSecond * 60;
  static var millisPerHour = millisPerMinute * 60;
  static var millisPerDay = millisPerHour * 24;

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

  public static function now() : DateTimeUtc
    return fromDate(Date.now());

  @:from public static function fromDate(date : Date) : DateTimeUtc
    return fromTime(date.getTime());

  @:from public static function fromTime(timestamp : Float) : DateTimeUtc
    return new DateTimeUtc(Int64s.fromFloat(timestamp).mul(ticksPerMillisecondI64).add(unixEpochTicks));

  @:from public static function fromString(s : String) : DateTimeUtc {
    var pattern = ~/^(\d+)[-](\d{2})[-](\d{2}) (\d{2})[:](\d{2})[:](\d{2})(?:\.(\d+))?$/;
    if(!pattern.match(s))
      throw new thx.Error('unable to parse DateTimeUtc string: "$s"');
    var smillis = pattern.matched(7),
        millis = 0;
    if(null != smillis) {
      smillis = "1" + smillis.rpad("0", 3).substring(0, 3);
      millis = Std.parseInt(smillis) - 1000;
    }

    return create(
        Std.parseInt(pattern.matched(1)),
        Std.parseInt(pattern.matched(2)),
        Std.parseInt(pattern.matched(3)),
        Std.parseInt(pattern.matched(4)),
        Std.parseInt(pattern.matched(5)),
        Std.parseInt(pattern.matched(6)),
        millis
      );
  }

  public static function create(year : Int, month : Int, day : Int, ?hour : Int = 0, ?minute : Int = 0, ?second : Int = 0, ?millisecond : Int = 0) {
    var ticks = dateToTicks(year, month, day) +
                Time.timeToTicks(hour, minute, second) +
                (millisecond * ticksPerMillisecondI64);

    return new DateTimeUtc(ticks);
  }

  public static function isLeapYear(year : Int) : Bool
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

  // TODO remove validation and allow for overflowing values
  public static function dateToTicks(year : Int, month : Int, day : Int) : Int64 {
    var days = isLeapYear(year) ? daysToMonth366: daysToMonth365;
    if(day >= 1 && day <= days[month] - days[month - 1]) {
      var y = year - 1;
      var n = y * 365 + Std.int(y / 4) - Std.int(y / 100) + Std.int(y / 400) + days[month - 1] + day - 1;
      return n * ticksPerDayI64;
    }
    return throw new Error('bad year/month/day $year/$month/$day');
  }

  public static function daysInMonth(year : Int, month : Int) : Int {
    var days = isLeapYear(year)? daysToMonth366 : daysToMonth365;
    return days[month] - days[month - 1];
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

  public var ticks(get, never) : Int64;

  public var year(get, never) : Int;
  public var month(get, never) : Month;
  public var day(get, never) : Int;

  public var hour(get, never) : Int;
  public var minute(get, never) : Int;
  public var second(get, never) : Int;

  public var dayOfWeek(get, never) : Weekday;
  public var dayOfYear(get, never) : Int;
  public var millisecond(get, never) : Int;

  inline public function new(ticks : Int64)
    this = ticks;

  @:to inline function get_ticks() : Int64
    return this;

  inline function get_year() : Int
    return getDatePart(DATE_PART_YEAR);

  inline function get_month() : Month
    return getDatePart(DATE_PART_MONTH);

  inline function get_day() : Int
    return getDatePart(DATE_PART_DAY);

  inline function get_hour() : Int
    return ticks.div(ticksPerHourI64).mod(24).toInt();

  inline function get_minute() : Int
    return ticks.div(ticksPerMinuteI64).mod(60).toInt();

  inline function get_dayOfWeek() : Weekday
    return ticks.div(ticksPerDayI64).add(1).mod(7).toInt();

  inline function get_dayOfYear() : Int
    return getDatePart(DATE_PART_DAY_OF_YEAR);

  inline function get_millisecond() : Int
    return ticks.div(ticksPerMillisecondI64).mod(1000).toInt();

  inline function get_second() : Int
    return ticks.div(ticksPerSecondI64).mod(60).toInt();

  // nanosecond
  // timeticks
  // now
  // today
  // timeOfDay

  // add
  // addNanoseconds
  // addTicks
  // addMonths
  // addYears
  // operators: + (timespan)

  @:op(A+B) inline function add(time : Time)
    return new DateTimeUtc(ticks + time.ticks);

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

  inline public function compare(other : DateTimeUtc) : Int
    return Int64s.compare(ticks, other.ticks);

  @:op(A==B) inline public function equals(other : DateTimeUtc)
    return ticks == other.ticks;

  public function nearEquals(other : DateTimeUtc, span : Time) {
    var ticks = Int64s.abs(other.ticks - ticks);
    return ticks <= span.abs().ticks;
  }

  @:op(A>B) inline public function greater(other : DateTimeUtc) : Bool
    return compare(other.ticks) > 0;

  @:op(A>=B) inline public function greaterEquals(other : DateTimeUtc) : Bool
    return compare(other.ticks) >= 0;

  @:op(A<B) inline public function less(other : DateTimeUtc) : Bool
    return compare(other.ticks) < 0;

  @:op(A<=B) inline public function lessEquals(other : DateTimeUtc) : Bool
    return compare(other.ticks) <= 0;

  @:to inline public function toFloat() : Float
    return toDate().getTime();

  // TODO this requires proper Int64.toDouble to work ...
  // values are currently rounded to the second
  @:to inline public function toDate() : Date
    return Date.fromTime(((ticks - unixEpochTicks) / ticksPerMillisecondI64).toFloat());

  @:to inline public function toString() : String
    return '$year-${month.lpad(2)}-${day.lpad(2)} ${hour.lpad(2)}:${minute.lpad(2)}:${second.lpad(2)}.$millisecond';
}
