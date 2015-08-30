package thx.bigint;

using thx.Strings;

class Decimals {
  public static function fromInt(value : Int)
    return new DecimalImpl(Bigs.fromInt(value), 0);

  // TODO
  public static function fromFloat(value : Float)
    return new DecimalImpl(Bigs.fromFloat(value), 0);

  // TODO
  public static function parse(value : String) {
    return new DecimalImpl(Bigs.fromInt(0), 0);
  }
}
