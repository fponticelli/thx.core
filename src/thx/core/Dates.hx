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
}

/** Alias of `DateTools`, included so mixins work with `using thx.core.Dates;` **/
typedef HaxeDateTools = DateTools;