package thx.core;

/**
`Dates` provides additional extension methods on top of the `Date` type.

Helpers for working with Date objects or timestampts

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
  inline public static function snapAfter(date : Date, period : TimePeriod) : Date
    return Date.fromTime(Timestamps.snapAfter(date.getTime(), period));

/**
Snaps a Date to the previous second, minute, hour, day, week, month or year.

@param date The date to snap.  See Date.
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The snapped date.
**/
  inline public static function snapBefore(date : Date, period : TimePeriod) : Date
    return Date.fromTime(Timestamps.snapBefore(date.getTime(), period));

/**
Snaps a Date to the nearest second, minute, hour, day, week, month or year.

@param date The date to snap.  See Date.
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The snapped date.
**/
  inline public static function snapTo(date : Date, period : TimePeriod) : Date
    return Date.fromTime(Timestamps.snapTo(date.getTime(), period));
}

class Timestamps {
/**
Snaps a time to the next second, minute, hour, day, week, month or year.

@param time The unix time in milliseconds.  See date.getTime()
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The unix time of the snapped date (In milliseconds).
**/
  public static function snapAfter(time : Float, period : TimePeriod) : Float
    return switch period {
      case Second:
        c(time, 1000.0);
      case Minute:
        c(time, 60000.0);
      case Hour:
        c(time, 3600000.0);
      case Day:
        var d = Date.fromTime(time);
        new Date(d.getFullYear(), d.getMonth(), d.getDate() + 1, 0, 0, 0).getTime();
      case Week:
        var d = Date.fromTime(time),
            wd = d.getDay();
        new Date(d.getFullYear(), d.getMonth(), d.getDate() + 7 - wd, 0, 0, 0).getTime();
      case Month:
        var d = Date.fromTime(time);
        new Date(d.getFullYear(), d.getMonth() + 1, 1, 0, 0, 0).getTime();
      case Year:
        var d = Date.fromTime(time);
        new Date(d.getFullYear() + 1, 0, 1, 0, 0, 0).getTime();
    };

/**
Snaps a time to the previous second, minute, hour, day, week, month or year.

@param time The unix time in milliseconds.  See date.getTime()
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The unix time of the snapped date (In milliseconds).
**/
  public static function snapBefore(time : Float, period : TimePeriod) : Float
    return switch period {
      case Second:
        f(time, 1000.0);
      case Minute:
        f(time, 60000.0);
      case Hour:
        f(time, 3600000.0);
      case Day:
        var d = Date.fromTime(time);
        new Date(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0).getTime();
      case Week:
        var d = Date.fromTime(time),
            wd = d.getDay();
        new Date(d.getFullYear(), d.getMonth(), d.getDate() - wd, 0, 0, 0).getTime();
      case Month:
        var d = Date.fromTime(time);
        new Date(d.getFullYear(), d.getMonth(), 1, 0, 0, 0).getTime();
      case Year:
        var d = Date.fromTime(time);
        new Date(d.getFullYear(), 0, 1, 0, 0, 0).getTime();
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
        new Date(d.getFullYear(), d.getMonth(), d.getDate() + mod, 0, 0, 0).getTime();
      case Week:
        var d = Date.fromTime(time),
            wd = d.getDay(),
            mod = wd < 3 ? -wd : (wd > 3 ? 7 - wd : d.getHours() < 12 ? -wd : 7 - wd);
        new Date(d.getFullYear(), d.getMonth(), d.getDate() + mod, 0, 0, 0).getTime();
      case Month:
        var d = Date.fromTime(time),
            mod = d.getDate() > Math.round(DateTools.getMonthDays(d) / 2) ? 1 : 0;
        new Date(d.getFullYear(), d.getMonth() + mod, 1, 0, 0, 0).getTime();
      case Year:
        var d = Date.fromTime(time),
            mod = time > new Date(d.getFullYear(), 6, 2, 0, 0, 0).getTime() ? 1 : 0;
        new Date(d.getFullYear() + mod, 0, 1, 0, 0, 0).getTime();
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

/** Alias of `DateTools`, included so mixins work with `using thx.core.Dates;` **/
typedef HaxeDateTools = DateTools;