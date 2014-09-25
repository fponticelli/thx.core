package thx.core;

class Dates {
  public static function compare(a : Date, b : Date)
    return Floats.compare(a.getTime(), b.getTime());
}