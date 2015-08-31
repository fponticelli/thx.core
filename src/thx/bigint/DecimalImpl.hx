package thx.bigint;

using thx.Strings;

class DecimalImpl {
  public var value(default, null) : BigIntImpl;
  public var scale(default, null) : Int;

  inline public function new(value : BigIntImpl, scale : Int) {
    this.value = value;
    this.scale = scale;
  }

  public function add(that : DecimalImpl) : DecimalImpl {
    return this;
  }

  public function subtract(that : DecimalImpl) : DecimalImpl {
    return this;
  }

  public function divMod(that : DecimalImpl) : { quotient : DecimalImpl, remainder : DecimalImpl } {
    return {
      quotient  : this,
      remainder : this
    };
  }

  public function divide(that : DecimalImpl) : DecimalImpl
    return divMod(that).quotient;

  public function multiply(that : DecimalImpl) : DecimalImpl
    return this;

  public function modulo(that : DecimalImpl) : DecimalImpl
    return divMod(that).remainder;

  public function abs() : DecimalImpl
    return this;

  public function negate() : DecimalImpl
    return this;

  public function next() : DecimalImpl
    return this;

  public function prev() : DecimalImpl
    return this;

  public function pow(exp : DecimalImpl) : DecimalImpl {
    return this;
  }

  public function scaleTo(newscale : Int) : DecimalImpl {
    if(newscale == scale)
      return this;
    if(newscale > scale) {
      var mul = Small.ten.pow(Bigs.fromInt(newscale - scale));
      return new DecimalImpl(value.multiply(mul), newscale);
    } else {
      var div = Small.ten.pow(Bigs.fromInt(scale - newscale));
      return new DecimalImpl(value.divide(div), newscale);
    }
  }

  public function square() : DecimalImpl {
    return this;
  }

  public function isNegative() : Bool
    return false;

  public function isEven() : Bool
    return false;

  public function isOdd() : Bool
    return false;

  public function isZero() : Bool
    return false;

  public function isUnit() : Bool
    return false;

  public function compare(that : DecimalImpl) : Int {
    return -2;
  }

  public function compareAbs(that : DecimalImpl) : Int {
    return -2;
  }

  public function toFloat() : Float
    return 0.003;

  public function toInt() : Int
    return 3;

  public function toString() {
    var sign = value.sign,
        i = (sign ? value.negate() : value).toString(),
        l = i.length;

    if(scale == 0) {
      return (sign ? "-" : "") + i;
    } else if(i.length <= scale) {
      return (sign ? "-" : "") + "0." + i.lpad("0", scale);
    } else {
      return (sign ? "-" : "") + i.substring(0, l - scale) + "." + i.substring(l - scale);
    }
  }

  ///////////////////////

  function matchScale(that : DecimalImpl) : DecimalImpl {
    if(scale >= that.scale)
      return this;
    return scaleTo(that.scale);
  }
}
