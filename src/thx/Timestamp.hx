package thx;

import thx.Dates;

/**
`Timestamp` provides additional methods on top of the `Float` as well as
automatic casting from and to Date/String.

```
import thx.Timestamp;
```

@author Jason O'Neil
@author Franco Ponticelli
**/
abstract Timestamp(Float) from Float to Float {
/**
Creates a timestamp by using the passed year, month, day, hour, minute, second.

Note that each argument can overflow its normal boundaries (e.g. a month value of `-33` is perfectly valid)
and the method will normalize that value by offsetting the other arguments by the right amount.
**/
  inline public static function create(year : Int, ?month : Int, ?day : Int, ?hour : Int, ?minute : Int, ?second : Int) : Timestamp
    return Dates.create(year, month, day, hour, minute, second).getTime();

  inline public static function now()
    return fromDate(Date.now());

  @:from inline public static function fromDate(d : Date) : Timestamp
    return d.getTime();

  @:from inline public static function fromString(s : String) : Timestamp
    return Date.fromString(s).getTime();

  @:to inline public function toDate() : Date
    return Date.fromTime(this);

  @:to inline public function toString() : String
    return toDate().toString();

/**
Snaps a time to the next second, minute, hour, day, week, month or year.

@param time The unix time in milliseconds.  See date.getTime()
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The unix time of the snapped date (In milliseconds).
**/
  public function snapNext(period : TimePeriod) : Timestamp
    return switch period {
      case Second:
        c(this, 1000.0);
      case Minute:
        c(this, 60000.0);
      case Hour:
        c(this, 3600000.0);
      case Day:
        var d = toDate();
        create(d.getFullYear(), d.getMonth(), d.getDate() + 1, 0, 0, 0);
      case Week:
        var d = toDate(),
            wd = d.getDay();
        create(d.getFullYear(), d.getMonth(), d.getDate() + 7 - wd, 0, 0, 0);
      case Month:
        var d = toDate();
        create(d.getFullYear(), d.getMonth() + 1, 1, 0, 0, 0);
      case Year:
        var d = toDate();
        create(d.getFullYear() + 1, 0, 1, 0, 0, 0);
    };

/**
Snaps a time to the previous second, minute, hour, day, week, month or year.

@param time The unix time in milliseconds.  See date.getTime()
@param period Either: Second, Minute, Hour, Day, Week, Month or Year
@return The unix time of the snapped date (In milliseconds).
**/
  public function snapPrev(period : TimePeriod) : Timestamp
    return switch period {
      case Second:
        f(this, 1000.0);
      case Minute:
        f(this, 60000.0);
      case Hour:
        f(this, 3600000.0);
      case Day:
        var d = toDate();
        create(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0);
      case Week:
        var d = toDate(),
            wd = d.getDay();
        create(d.getFullYear(), d.getMonth(), d.getDate() - wd, 0, 0, 0);
      case Month:
        var d = toDate();
        create(d.getFullYear(), d.getMonth(), 1, 0, 0, 0);
      case Year:
        var d = toDate();
        create(d.getFullYear(), 0, 1, 0, 0, 0);
    };

/**
Snaps a time to the nearest second, minute, hour, day, week, month or year.

@param period Either: Second, Minute, Hour, Day, Week, Month or Year
**/
  public function snapTo(period : TimePeriod) : Timestamp
    return switch period {
      case Second:
        r(this, 1000.0);
      case Minute:
        r(this, 60000.0);
      case Hour:
        r(this, 3600000.0);
      case Day:
        var d = toDate(),
            mod = (d.getHours() >= 12) ? 1 : 0;
        create(d.getFullYear(), d.getMonth(), d.getDate() + mod, 0, 0, 0);
      case Week:
        var d = toDate(),
            wd = d.getDay(),
            mod = wd < 3 ? -wd : (wd > 3 ? 7 - wd : d.getHours() < 12 ? -wd : 7 - wd);
        create(d.getFullYear(), d.getMonth(), d.getDate() + mod, 0, 0, 0);
      case Month:
        var d = toDate(),
            mod = d.getDate() > Math.round(DateTools.getMonthDays(d) / 2) ? 1 : 0;
        create(d.getFullYear(), d.getMonth() + mod, 1, 0, 0, 0);
      case Year:
        var d = toDate(),
            mod = this > new Date(d.getFullYear(), 6, 2, 0, 0, 0).getTime() ? 1 : 0;
        create(d.getFullYear() + mod, 0, 1, 0, 0, 0);
    };

  inline static function r(t : Float, v : Float)
    return Math.fround(t / v) * v;
  inline static function f(t : Float, v : Float)
    return Math.ffloor(t / v) * v;
  inline static function c(t : Float, v : Float)
    return Math.fceil(t / v) * v;
}
