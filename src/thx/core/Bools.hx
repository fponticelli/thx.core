package thx.core;

class Bools {
/**
Returns a comparison value (`Int`) from two boolean values.
*/
  public static function compare(a : Bool, b : Bool)
    return a == b ? 0 : (a ? -1 : 1);

/**
Converts a boolean to an integer value (`true` => `1`, `false` => `0`).
*/
  public static function toInt(v : Bool)
    return v ? 1 : 0;
}