package thx.bigint;

using thx.Strings;

class Decimals {
  public static function fromInt(value : Int)
    return new DecimalImpl(Bigs.fromInt(value), 0);

  // TODO
  public static function fromFloat(value : Float) {
    return parse('$value');
  }

  // TODO
  public static function parse(value : String) {
    var pdec = value.indexOf(".");
    if(pdec < 0)
      return new DecimalImpl(BigInt.fromString(value), 0);

    var i = value.substring(0, pdec) + value.substring(pdec + 1);
    return new DecimalImpl(Bigs.parseBase(i, 10), value.length - pdec - 1);
  }
}
