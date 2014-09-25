package thx.core;

/**
`Dates` provides additional extension methods on top of the `Date` type.
**/
class Dates {
/**
It compares two dates.
**/
  public static function compare(a : Date, b : Date) : Int
    return Floats.compare(a.getTime(), b.getTime());
}