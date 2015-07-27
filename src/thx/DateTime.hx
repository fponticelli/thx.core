package thx;

using haxe.Int64;
import thx.Month;
import thx.Weekday;
using thx.Ints;

abstract DateTime(Int64) {
  static var ticksMask = Int64.make(0x3FFFFFFF, 0xFFFFFFFF);

  static var ticksPerMillisecond : Int = 10000;
  static var ticksPerSecond : Int = ticksPerMillisecond * 1000;
  static var ticksPerMinute : Int = ticksPerSecond * 60;
  static var ticksPerHour : Int = ticksPerMinute * 60;
  static var ticksPerDay : Int = ticksPerHour * 24;

  static var ticksPerMillisecondI64 : Int64 = Int64.ofInt(10000);
  static var ticksPerSecondI64 : Int64 = ticksPerMillisecondI64 * 1000;
  static var ticksPerMinuteI64 : Int64 = ticksPerSecondI64 * 60;
  static var ticksPerHourI64 : Int64 = ticksPerMinuteI64 * 60;
  static var ticksPerDayI64 : Int64 = ticksPerHourI64 * 24;

  static var daysPerYear : Int = 365;
  static var daysPer4Years : Int = daysPerYear * 4 + 1;       // 1461
  static var daysPer100Years : Int = daysPer4Years * 25 - 1;  // 36524
  static var daysPer400Years : Int = daysPer100Years * 4 + 1; // 146097

  static var daysTo1601 : Int = daysPer400Years * 4;          // 584388
  static var daysTo1899 : Int = daysPer400Years * 4 + daysPer100Years * 3 - 367;
  static var daysTo1970 : Int = daysPer400Years * 4 + daysPer100Years * 3 + daysPer4Years * 17 + daysPerYear; // 719,162
  static var daysTo10000 : Int = daysPer400Years * 25 - 366;  // 3652059

  static var DATE_PART_YEAR = 0;
  static var DATE_PART_DAY_OF_YEAR = 1;
  static var DATE_PART_MONTH = 2;
  static var DATE_PART_DAY = 3;

  static var daysToMonth365 = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
  static var daysToMonth366 = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];

  public static function create(year : Int, month : Int, day : Int, hour : Int, minute : Int, second : Int, millisecond : Int) {
    var ticks = dateToTicks(year, month, day) +
                timeToTicks(hour, minute, second) +
                (millisecond * ticksPerMillisecond);

    return new DateTime(ticks);
  }

  public static function isLeapYear(year : Int) : Bool
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

  public static function dateToTicks(year : Int, month : Int, day : Int) : Int64 {
    var days = isLeapYear(year) ? daysToMonth366: daysToMonth365;
    if(day >= 1 && day <= days[month] - days[month - 1]) {
      var y = year - 1;
      var n = y * 365 + Std.int(y / 4) - Std.int(y / 100) + Std.int(y / 400) + days[month - 1] + day - 1;
      return n * ticksPerDayI64;
    }
    return throw new Error('bad year/month $year/$month');
  }

  public static function timeToTicks(hour : Int, minute : Int, second : Int) : Int64 {
    if(hour >= 0 && hour < 24 && minute >= 0 && minute < 60 && second >=0 && second < 60) {
      var totalSeconds = (hour * 3600 : Int64) + minute * 60 + second;
      return totalSeconds * ticksPerSecondI64;
    }
    return throw new Error('invalid time range $hour:$minute:$second');
  }

  public static function daysInMonth(year : Int, month : Int) : Int {
    var days = isLeapYear(year)? daysToMonth366 : daysToMonth365;
    return days[month] - days[month - 1];
  }

  private function getDatePart(part : Int) {
    var ticks = internalTicks;
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

  public var year(get, never) : Int;
  public var month(get, never) : Month;
  public var day(get, never) : Int;

  public var hour(get, never) : Int;
  public var minute(get, never) : Int;
  public var second(get, never) : Int;

  public var dayOfWeek(get, never) : Weekday;
  public var dayOfYear(get, never) : Int;
  public var millisecond(get, never) : Int;

  var internalTicks(get, never) : Int64;

  inline public function new(ticks : Int64)
    this = ticks;

  inline function get_internalTicks() : Int64
    return this & ticksMask;

  inline function get_year() : Int
    return getDatePart(DATE_PART_YEAR);

  inline function get_month() : Month
    return getDatePart(DATE_PART_MONTH);

  inline function get_day() : Int
    return getDatePart(DATE_PART_DAY);

  inline function get_hour() : Int
    return internalTicks.div(ticksPerHourI64).mod(24).toInt();

  inline function get_minute() : Int
    return internalTicks.div(ticksPerMinuteI64).mod(60).toInt();

  inline function get_dayOfWeek() : Weekday
    return internalTicks.div(ticksPerDayI64).add(1).mod(7).toInt();

  inline function get_dayOfYear() : Int
    return getDatePart(DATE_PART_DAY_OF_YEAR);

  inline function get_millisecond() : Int
    return internalTicks.div(ticksPerMillisecondI64).mod(1000).toInt();

  inline function get_second() : Int
    return internalTicks.div(ticksPerSecondI64).mod(60).toInt();

  inline public function toString() : String
    return '$year-${month.lpad(2)}-${day.lpad(2)} ${hour.lpad(2)}:${minute.lpad(2)}:${second.lpad(2)}.$millisecond';
}