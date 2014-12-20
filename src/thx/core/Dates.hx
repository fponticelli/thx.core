package thx.core;

/**
`Dates` provides additional extension methods on top of the `Date` type.

```
using Dates;
```

@author Jason O'Neil
@author Franco Ponticelli
**/
class Dates {
/**
It compares two dates.
**/
  public static function compare(a : Date, b : Date) : Int
    return Floats.compare(a.getTime(), b.getTime());

/**
Creates a Date by using the passed year, month, day, hour, minute, second.

Note that each argument can overflow its normal boundaries (e.g. a month value of `-33` is perfectly valid)
and the method will normalize that value by offsetting the other arguments by the right amount.
**/
  @:noUsing
  public static function create(year : Int, ?month : Int = 0, ?day : Int = 1, ?hour : Int = 0, ?minute : Int = 0, ?second : Int = 0) : Date {
    // Wrap values that are too large or negative
    minute += Math.floor(second / 60);
    second = second % 60;
    if(second < 0) second += 60;

    hour += Math.floor(minute / 60);
    minute = minute % 60;
    if(minute < 0) minute += 60;

    day += Math.floor(hour / 24);
    hour = hour % 24;
    if(hour < 0) hour += 24;

    if(day == 0) {
      month -=1;
      if(month < 0) {
        month = 11;
        year -=1;
      }
      day = numDaysInMonth(month, year);
    }

    year += Math.floor(month / 12);
    month = month % 12;
    if(month < 0) month += 12;

    var daysInMonth = numDaysInMonth(month,year);
    while (day > daysInMonth) {
        if (day > daysInMonth) {
            day -= daysInMonth;
            month++;
        }
        if (month > 11) {
            month -= 12;
            year++;
        }
        daysInMonth = numDaysInMonth(month,year);
    }

    return new Date(year, month, day, hour, minute, second);
  }

/**
Returns `true` if the passed dates are the same.
**/
  inline public static function equals(a : Date, b : Date) : Bool
    return a.getTime() == b.getTime();

/**
Tells if a year is a leap year.

@param year The year, represented as a 4 digit integer
@return True if a leap year, false otherwise.
**/
  public static function isLeapYear(year : Int) {
    // Only every 4th year
    if ((year % 4) != 0) return false;
    // Except every 100, unless it's the 400th year
    if ((year % 100) == 0)
      return ((year % 400) == 0);
    // It's divisible by 4, and it's not divisible by 100 - it's leap
    return true;
  }

/**
Tells if the given date is inside a leap year.

@param date The date object to check.
@return True if it is in a leap year, false otherwise.
**/
  inline public static function isInLeapYear(d : Date) return isLeapYear(d.getFullYear());

/**
Returns the number of days in a month.

@param month An integer representing the month. (Jan=0, Dec=11)
@param year An 4 digit integer representing the year.
@return Int, the number of days in the month.
@throws Error if the month is not between 0 and 11.
**/
  public static function numDaysInMonth(month : Int, year : Int)
    // 31: Jan, Mar, May, Jul, Aug, Oct, Dec
    // 30: Apr, Jun, Sep, Nov
    // 28or29 Feb
    return switch month {
      case 0, 2, 4, 6, 7, 9, 11: 31;
      case 3, 5, 8, 10: 30;
      case 1: isLeapYear(year) ? 29 : 28;
      default: throw 'Invalid month "$month".  Month should be a number, Jan=0, Dec=11';
    };

/**
Tells how many days in the month of the given date.

@param date The date representing the month we are checking.
@return Int, the number of days in the month.
@throws Error if the month is not between 0 and 11.
**/
  public static function numDaysInThisMonth(d : Date)
    return numDaysInMonth(d.getMonth(), d.getFullYear());

/**
Snaps a Date to the next second, minute, hour, day, week, month or year.

@param date The date to snap.  See Date.
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The snapped date.
**/
  inline public static function snapNext(date : Date, period : TimePeriod) : Date
    return Date.fromTime(Timestamps.snapNext(date.getTime(), period));

/**
Snaps a Date to the previous second, minute, hour, day, week, month or year.

@param date The date to snap.  See Date.
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The snapped date.
**/
  inline public static function snapPrev(date : Date, period : TimePeriod) : Date
    return Date.fromTime(Timestamps.snapPrev(date.getTime(), period));

/**
Snaps a Date to the nearest second, minute, hour, day, week, month or year.

@param date The date to snap.  See Date.
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The snapped date.
**/
  inline public static function snapTo(date : Date, period : TimePeriod) : Date
    return Date.fromTime(Timestamps.snapTo(date.getTime(), period));

/**
  Get a date relative to the current date, shifting by a set period of time.

  Please note this works by constructing a new date object, rather than using `DateTools.delta()`.
  The key difference is that this allows us to jump over a period that may not be a set number of seconds.
  For example, jumping between months (which have different numbers of days), leap years, leap seconds, daylight savings time changes etc.

  @param date The starting date.
  @param period The TimePeriod you wish to jump by, Seconds, Minutes, Hours, Days, Weeks, Months Years.
  @param amount The multiple of `period` that you wish to jump by. A positive amount moves forward in time, a negative amount moves backward.
**/
  public static function jump(date : Date, period : TimePeriod, amount : Int) {
    var sec   = date.getSeconds(),
        min   = date.getMinutes(),
        hour  = date.getHours(),
        day   = date.getDate(),
        month = date.getMonth(),
        year  = date.getFullYear();

    switch period {
      case Second: sec   += amount;
      case Minute: min   += amount;
      case Hour:   hour  += amount;
      case Day:    day   += amount;
      case Week:   day   += amount * 7;
      case Month:  month += amount;
      case Year:   year  += amount;
    }

    return create(year, month, day, hour, min, sec);
  }

/**
Returns a new date, exactly 1 year before the given date/time.
**/
  inline public static function prevYear(d : Date) : Date
    return jump(d,Year,-1);

/**
Returns a new date, exactly 1 year after the given date/time.
**/
  inline public static function nextYear(d : Date) : Date
    return jump(d,Year,1);

/**
Returns a new date, exactly 1 month before the given date/time.
**/
  inline public static function prevMonth(d : Date) : Date
    return jump(d,Month,-1);

/**
Returns a new date, exactly 1 month after the given date/time.
**/
  inline public static function nextMonth(d : Date) : Date
    return jump(d,Month,1);

/**
Returns a new date, exactly 1 week before the given date/time.
**/
  inline public static function prevWeek(d : Date) : Date
    return jump(d,Week,-1);

/**
Returns a new date, exactly 1 week after the given date/time.
**/
  inline public static function nextWeek(d : Date) : Date
    return jump(d,Week,1);

/**
Returns a new date, exactly 1 day before the given date/time.
**/
  inline public static function prevDay(d : Date) : Date
    return jump(d,Day,-1);

/**
Returns a new date, exactly 1 day after the given date/time.
**/
  inline public static function nextDay(d : Date) : Date
    return jump(d,Day,1);
}

/**
`Timestamps` provides additional extension methods on top of the `Float`
type representing date values.

```
using Dates;
```

@author Jason O'Neil
@author Franco Ponticelli
**/
class Timestamps {
/**
Creates a date (timestamp/float format) by using the passed year, month, day, hour, minute, second.

Note that each argument can overflow its normal boundaries (e.g. a month value of `-33` is perfectly valid)
and the method will normalize that value by offsetting the other arguments by the right amount.
**/
    @:noUsing
    inline public static function create(year : Int, ?month : Int, ?day : Int, ?hour : Int, ?minute : Int, ?second : Int) : Float
      return Dates.create(year, month, day, hour, minute, second).getTime();
/**
Snaps a time to the next second, minute, hour, day, week, month or year.

@param time The unix time in milliseconds.  See date.getTime()
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The unix time of the snapped date (In milliseconds).
**/
  public static function snapNext(time : Float, period : TimePeriod) : Float
    return switch period {
      case Second:
        c(time, 1000.0);
      case Minute:
        c(time, 60000.0);
      case Hour:
        c(time, 3600000.0);
      case Day:
        var d = Date.fromTime(time);
        create(d.getFullYear(), d.getMonth(), d.getDate() + 1, 0, 0, 0);
      case Week:
        var d = Date.fromTime(time),
            wd = d.getDay();
        create(d.getFullYear(), d.getMonth(), d.getDate() + 7 - wd, 0, 0, 0);
      case Month:
        var d = Date.fromTime(time);
        create(d.getFullYear(), d.getMonth() + 1, 1, 0, 0, 0);
      case Year:
        var d = Date.fromTime(time);
        create(d.getFullYear() + 1, 0, 1, 0, 0, 0);
    };

/**
Snaps a time to the previous second, minute, hour, day, week, month or year.

@param time The unix time in milliseconds.  See date.getTime()
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The unix time of the snapped date (In milliseconds).
**/
  public static function snapPrev(time : Float, period : TimePeriod) : Float
    return switch period {
      case Second:
        f(time, 1000.0);
      case Minute:
        f(time, 60000.0);
      case Hour:
        f(time, 3600000.0);
      case Day:
        var d = Date.fromTime(time);
        create(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0);
      case Week:
        var d = Date.fromTime(time),
            wd = d.getDay();
        create(d.getFullYear(), d.getMonth(), d.getDate() - wd, 0, 0, 0);
      case Month:
        var d = Date.fromTime(time);
        create(d.getFullYear(), d.getMonth(), 1, 0, 0, 0);
      case Year:
        var d = Date.fromTime(time);
        create(d.getFullYear(), 0, 1, 0, 0, 0);
    };

/**
Snaps a time to the nearest second, minute, hour, day, week, month or year.

@param time The unix time in milliseconds.  See date.getTime()
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The unix time of the snapped date (In milliseconds).
**/
  public static function snapTo(time : Float, period : TimePeriod) : Float
    return switch period {
      case Second:
        r(time, 1000.0);
      case Minute:
        r(time, 60000.0);
      case Hour:
        r(time, 3600000.0);
      case Day:
        var d = Date.fromTime(time),
            mod = (d.getHours() >= 12) ? 1 : 0;
        create(d.getFullYear(), d.getMonth(), d.getDate() + mod, 0, 0, 0);
      case Week:
        var d = Date.fromTime(time),
            wd = d.getDay(),
            mod = wd < 3 ? -wd : (wd > 3 ? 7 - wd : d.getHours() < 12 ? -wd : 7 - wd);
        create(d.getFullYear(), d.getMonth(), d.getDate() + mod, 0, 0, 0);
      case Month:
        var d = Date.fromTime(time),
            mod = d.getDate() > Math.round(DateTools.getMonthDays(d) / 2) ? 1 : 0;
        create(d.getFullYear(), d.getMonth() + mod, 1, 0, 0, 0);
      case Year:
        var d = Date.fromTime(time),
            mod = time > new Date(d.getFullYear(), 6, 2, 0, 0, 0).getTime() ? 1 : 0;
        create(d.getFullYear() + mod, 0, 1, 0, 0, 0);
    };

    inline static function r(t : Float, v : Float)
      return Math.fround(t / v) * v;
    inline static function f(t : Float, v : Float)
      return Math.ffloor(t / v) * v;
    inline static function c(t : Float, v : Float)
      return Math.fceil(t / v) * v;
}

enum TimePeriod {
  Second;
  Minute;
  Hour;
  Day;
  Week;
  Month;
  Year;
}

@:enum
abstract Weekday(Int) from Int to Int {
  var Sunday = 0;
  var Monday = 1;
  var Tuesday = 2;
  var Wednesday = 3;
  var Thursday = 4;
  var Friday = 5;
  var Saturday = 6;
}

@:enum
abstract Month(Int) from Int to Int {
  var January = 0;
  var February = 1;
  var March = 2;
  var April = 3;
  var May = 4;
  var June = 5;
  var July = 6;
  var August = 7;
  var September = 8;
  var October = 9;
  var November = 10;
  var December = 11;
}

/** Alias of `DateTools`, included so mixins work with `using thx.core.Dates;` **/
typedef HaxeDateTools = DateTools;