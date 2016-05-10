package thx;

import thx.Either;

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
      day = daysInMonth(year, month);
    }

    year += Math.floor(month / 12);
    month = month % 12;
    if(month < 0) month += 12;

    var days = daysInMonth(year, month);
    while (day > days) {
        if (day > days) {
            day -= days;
            month++;
        }
        if (month > 11) {
            month -= 12;
            year++;
        }
        days = daysInMonth(year, month);
    }

    return new Date(year, month, day, hour, minute, second);
  }

/**
Creates an array of dates that begin at `start` and end at `end` included.

Time values are pick from the `start` value except for the last value that will
match `end`. No interpolation is made.
**/
  public static function daysRange(start : Date, end : Date) {
    if(less(end, start)) return [];
    var days = [];
    while(!sameDay(start, end)) {
      days.push(start);
      start = nextDay(start);
    }
    days.push(end);
    return days;
  }

/**
Returns `true` if the passed dates are the same.
**/
  inline public static function equals(self : Date, other : Date) : Bool
    return self.getTime() == other.getTime();

/**
Returns `true` if the dates are approximately equals. The amount of delta
allowed is determined by `units` and it spans that amount equally before and
after the `self` date. The default `unit` value is `1`.

The default `period` range is `Second`.
**/
  public static function nearEquals(self : Date, other : Date, ?units : Int = 1, ?period : TimePeriod) {
    if(null == period)
      period = Second;
    if(units < 0)
      units = -units;
    var min = jump(self, period, -units),
        max = jump(self, period, units);
    return lessEquals(min, other) && greaterEquals(max, other);
  }

/**
Returns `true` if the `self` date is greater than `other`.
**/
  inline public static function greater(self : Date, other : Date) : Bool
    return compare(self, other) > 0;

  @:deprecated("more is deprecated, use greater instead")
  inline public static function more(self : Date, other : Date) : Bool
    return greater(self, other);

/**
Returns `true` if the `self` date is lesser than `other`.
**/
  inline public static function less(self : Date, other : Date) : Bool
    return compare(self, other) < 0;

/**
Returns `true` if the `self` date is greater than or equal to `other`.
**/
  inline public static function greaterEquals(self : Date, other : Date) : Bool
    return compare(self, other) >= 0;

  @:deprecated("moreEqual is deprecated, use greaterEquals instead")
  inline public static function moreEqual(self : Date, other : Date) : Bool
    return greaterEquals(self, other);

/**
Returns `true` if the `self` date is lesser than or equal to `other`.
**/
  inline public static function lessEquals(self : Date, other : Date) : Bool
    return compare(self, other) <= 0;

  @:deprecated("lessEqual is deprecated, use lessEquals instead")
  inline public static function lessEqual(self : Date, other : Date) : Bool
    return lessEquals(self, other);

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
  public static function daysInMonth(year : Int, month : Int)
    // 31: Jan, Mar, May, Jul, Aug, Oct, Dec
    // 30: Apr, Jun, Sep, Nov
    // 28or29 Feb
    return switch month {
      case 0, 2, 4, 6, 7, 9, 11: 31;
      case 3, 5, 8, 10: 30;
      case 1: isLeapYear(year) ? 29 : 28;
      default: throw 'Invalid month "$month".  Month should be a number, Jan=0, Dec=11';
    };

  @:deprecated("Use daysIntMonth instead. Also notice that arguments are inverted now")
  public static function numDaysInMonth(month : Int, year : Int)
    return daysInMonth(year, month);

/**
Tells how many days in the month of the given date.

@param date The date representing the month we are checking.
@return Int, the number of days in the month.
**/
  public static function daysInThisMonth(d : Date)
    return daysInMonth(d.getFullYear(), d.getMonth());

  @:depreacated('use daysInThisMonth instead')
  public static function numDaysInThisMonth(d : Date)
    return daysInThisMonth(d);

/**
Returns true if the 2 dates share the same year.
**/
  public static function sameYear(self : Date, other : Date)
      return self.getFullYear() == other.getFullYear();

/**
Returns true if the 2 dates share the same year and month.
**/
  public static function sameMonth(self : Date, other : Date)
      return sameYear(self, other) && self.getMonth() == other.getMonth();

/**
Returns true if the 2 dates share the same year, month and day.
**/
  public static function sameDay(self : Date, other : Date)
    return sameMonth(self, other) && self.getDate() == other.getDate();

/**
Returns true if the 2 dates share the same year, month, day and hour.
**/
  public static function sameHour(self : Date, other : Date)
    return sameDay(self, other) && self.getHours() == other.getHours();

/**
Returns true if the 2 dates share the same year, month, day, hour and minute.
**/
  public static function sameMinute(self : Date, other : Date)
    return sameHour(self, other) && self.getMinutes() == other.getMinutes();

/**
Snaps a Date to the next second, minute, hour, day, week, month or year.

@param date The date to snap.  See Date.
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The snapped date.
**/
  inline public static function snapNext(date : Date, period : TimePeriod) : Date
    return (date : Timestamp).snapNext(period);

/**
Snaps a Date to the previous second, minute, hour, day, week, month or year.

@param date The date to snap.  See Date.
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The snapped date.
**/
  inline public static function snapPrev(date : Date, period : TimePeriod) : Date
    return (date : Timestamp).snapPrev(period);

/**
Snaps a Date to the nearest second, minute, hour, day, week, month or year.

@param date The date to snap.  See Date.
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The snapped date.
**/
  inline public static function snapTo(date : Date, period : TimePeriod) : Date
    return (date : Timestamp).snapTo(period);

/**
  Get a date relative to the current date, shifting by a set period of time.

  Please note this works by constructing a new date object, rather than using `DateTools.delta()`.
  The key difference is that this allows us to jump over a period that may not be a set number of seconds.
  For example, jumping between months (which have different numbers of days), leap years, leap seconds, daylight savings time changes etc.

  @param date The starting date.
  @param period The TimePeriod you wish to jump by, Second, Minute, Hour, Day, Week, Month or Year.
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
Finds and returns which of the two passed dates is the newest.
**/
  public static function max(self : Date, other : Date)
    return self.getTime() > other.getTime() ? self : other;

/**
Finds and returns which of the two passed dates is the oldest.
**/
  public static function min(self : Date, other : Date)
    return self.getTime() < other.getTime() ? self : other;

/**
Snaps a date to the given weekday inside the current week.  The time within the day will stay the same.

If you are already on the given day, the date will not change.

@param date The date value to snap
@param day Day to snap to.  Either `Sunday`, `Monday`, `Tuesday` etc.
@param firstDayOfWk The first day of the week.  Default to `Sunday`.
@return The date of the day you have snapped to.
**/
  public static function snapToWeekDay(date : Date, day : Weekday, ?firstDayOfWk : Weekday = Sunday) {
    var d = date.getDay(),
        s : Int = day;

    // get whichever occurence happened in the current week.
    if (s < (firstDayOfWk : Int)) s = s + 7;
    if (d < (firstDayOfWk : Int)) d = d + 7;
    return jump(date, Day, s - d);
  }

/**
Snaps a date to the next given weekday.  The time within the day will stay the same.

If you are already on the given day, the date will not change.

@param date The date value to snap
@param day Day to snap to.  Either `Sunday`, `Monday`, `Tuesday` etc.
@return The date of the day you have snapped to.
**/
  public static function snapNextWeekDay(date : Date, day : Weekday) {
    var d = date.getDay(),
        s : Int = day;

    // get the next occurence of that day (forward in time)
    if (s < d) s = s + 7;
    return jump(date, Day, s - d);
  }

/**
Snaps a date to the previous given weekday.  The time within the day will stay the same.

If you are already on the given day, the date will not change.

@param date The date value to snap
@param day Day to snap to.  Either `Sunday`, `Monday`, `Tuesday` etc.
@return The date of the day you have snapped to.
**/
  public static function snapPrevWeekDay(date : Date, day : Weekday) {
    var d = date.getDay(),
        s : Int = day;

    // get the previous occurence of that day (backward in time)
    if (s > d) s = s - 7;
    return jump(date, Day, s - d);
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

/**
Returns a new date, exactly 1 hour before the given date/time.
**/
  inline public static function prevHour(d : Date) : Date
    return jump(d,Hour,-1);

/**
Returns a new date, exactly 1 hour after the given date/time.
**/
  inline public static function nextHour(d : Date) : Date
    return jump(d,Hour,1);

/**
Returns a new date, exactly 1 minute before the given date/time.
**/
  inline public static function prevMinute(d : Date) : Date
    return jump(d,Minute,-1);

/**
Returns a new date, exactly 1 minute after the given date/time.
**/
  inline public static function nextMinute(d : Date) : Date
    return jump(d,Minute,1);

/**
Returns a new date, exactly 1 second before the given date/time.
**/
  inline public static function prevSecond(d : Date) : Date
    return jump(d,Second,-1);

/**
Returns a new date, exactly 1 second after the given date/time.
**/
  inline public static function nextSecond(d : Date) : Date
    return jump(d,Second,1);

/**
Returns a new date that is modified only by the year.
**/
  public static function withYear(date : Date, year : Int)
    return Dates.create(year, date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds());

/**
Returns a new date that is modified only by the month (remember that month indexes begin at zero).
**/
  public static function withMonth(date : Date, month : Int)
    return Dates.create(date.getFullYear(), month, date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds());

/**
Returns a new date that is modified only by the day.
**/
  public static function withDay(date : Date, day : Int)
    return Dates.create(date.getFullYear(), date.getMonth(), day, date.getHours(), date.getMinutes(), date.getSeconds());

/**
Returns a new date that is modified only by the hour.
**/
  public static function withHour(date : Date, hour : Int)
    return Dates.create(date.getFullYear(), date.getMonth(), date.getDate(), hour, date.getMinutes(), date.getSeconds());

/**
Returns a new date that is modified only by the minute.
**/
  public static function withMinute(date : Date, minute : Int)
    return Dates.create(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), minute, date.getSeconds());

/**
Returns a new date that is modified only by the second.
**/
  public static function withSecond(date : Date, second : Int)
    return Dates.create(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), second);

  /**
   * Safely parse a string value to a date.
   */
  public static function parseDate(s: String): Either<String, Date> {
    try {
      return Right(Date.fromString(s));
    } catch(e: Dynamic) {
      return Left('$s could not be parsed to a valid Date value.');
    }
  };

  public static var order(default, never): Ord<Date> = Ord.fromIntComparison(compare);
}

/** Alias of `DateTools`, included so mixins work with `using thx.Dates;` **/
typedef HaxeDateTools = DateTools;
