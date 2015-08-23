package thx.bigint;

class Bigs {
  public static function createArray(length : Int) {
    var x = #if js untyped __js__("new Array")(length) #else [] #end;
    for(i in 0...length)
      x[i] = 0;
    return x;
  }
}
