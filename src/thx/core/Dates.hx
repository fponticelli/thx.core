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

  public static function snapTo(date : Date, period : TimePeriod) : Date
    return Date.fromTime(Timestamps.snapTo(date.getTime(), period));
  
  /**
      Perform a delta by creating a new Date object, rather than incrementing a timestamp.

      This is important when the length of the delta is not a guaranteed number of seconds, for example:

      - a month may have a differing number of days,
      - a day may not be exactly 24 hours if Daylight Savings begins or ends during that day,
      - a year may be 365 or or 366 days depending on the year.
  **/
  public static function dateBasedDelta(d : Date, ?yearDelta : Int = 0, ?monthDelta : Int = 0, ?dayDelta : Int = 0, ?hourDelta : Int = 0, ?minDelta : Int = 0, ?secDelta : Int = 0, ?msDelta : Int = 0 ) : Date {
      var year = d.getFullYear()+yearDelta;
      var month = d.getMonth()+monthDelta;
      var day = d.getDate()+dayDelta;
      var hour = d.getHours()+hourDelta;
      var min = d.getMinutes()+minDelta;
      var sec = d.getSeconds()+secDelta;

      // Wrap values that are too large
      while (sec>60) { sec -= 60; min++; }
      while (min>60) { min -= 60; hour++; }
      while (hour>23) { hour -= 24; day++; }
      while (hour>23) { hour -= 24; day++; }

      var daysInMonth = numDaysInMonth(month,year);
      while (day>daysInMonth || month>11) {
          if (day>daysInMonth) {
              day -= daysInMonth;
              month++;
          }
          if (month>11) {
              month -= 12;
              year++;
          }
          daysInMonth = numDaysInMonth(month,year);
      }

      var d = new Date(year,month,day,hour,min,sec);
      return DateTools.delta(d,msDelta);
  }

  /** Return a new date, offset by `numSec` seconds */
  public inline static function deltaSec(d : Date, numSec : Int) : Date
    return DateTools.delta(d,numSec*1000);

  /** Return a new date, offset by `numMin` minutes */
  public inline static function deltaMin(d : Date, numMin : Int) : Date
    return DateTools.delta(d,numMin*60*1000);

  /** Return a new date, offset by `numHrs` hours */
  public inline static function deltaHour(d : Date, numHrs : Int) : Date
    return DateTools.delta(d,numHrs*60*60*1000);

  /** Return a new date, offset by `numDays` days */
  public static inline function deltaDay(d : Date, numDays : Int):Date
    return dateBasedDelta(d,0,0,numDays);

  /** Return a new date, offset by `numWks` weeks */
  public static inline function deltaWeek(d : Date, numWks : Int):Date
    return dateBasedDelta(d,0,0,numWks*7);

  /** Return a new date, offset by `numMonths` months */
  public static inline function deltaMonth(d : Date, numMonths : Int):Date
    return dateBasedDelta(d,0,numMonths);

  /** Return a new date, offset by `numYrs` years */
  public static inline function deltaYear(d : Date, numYrs : Int):Date
    return dateBasedDelta(d,numYrs);

  /** Returns a new date, exactly 1 year before the given date/time. */
  inline public static function prevYear(d : Date) : Date
    return deltaYear(d,-1);

  /** Returns a new date, exactly 1 year after the given date/time. */
  inline public static function nextYear(d : Date) : Date
    return deltaYear(d,1);

  /** Returns a new date, exactly 1 month before the given date/time. */
  inline public static function prevMonth(d : Date) : Date
    return deltaMonth(d,-1);

  /** Returns a new date, exactly 1 month after the given date/time. */
  inline public static function nextMonth(d : Date) : Date
    return deltaMonth(d,1);

  /** Returns a new date, exactly 1 week before the given date/time. */
  inline public static function prevWeek(d : Date) : Date
    return deltaWeek(d,-1);

  /** Returns a new date, exactly 1 week after the given date/time. */
  inline public static function nextWeek(d : Date) : Date
    return deltaWeek(d,1);

  /** Returns a new date, exactly 1 day before the given date/time. */
  inline public static function prevDay(d : Date) : Date
    return deltaDay(d,-1);

  /** Returns a new date, exactly 1 day after the given date/time. */
  inline public static function nextDay(d : Date) : Date
    return deltaDay(d,1);

}

class Timestamps {
  // 0 == Sunday
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
        var t = r(time, 7.0 * 24.0 * 3600000.0),
            d = time - t;
        t + (d < -5.0 * 3600000.0 ? -(17.0 + 3.0 * 24.0) * 3600000.0 : (7.0 + 3.0 * 24.0) * 3600000.0);
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