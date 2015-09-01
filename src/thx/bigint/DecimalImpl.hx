package thx.bigint;

using thx.Strings;

class DecimalImpl {
  public static var zero(default, null) = Decimals.fromInt(0);
  public static var one(default, null) = Decimals.fromInt(1);

  public var value(default, null) : BigIntImpl;
  public var scale(default, null) : Int;

  inline public function new(value : BigIntImpl, scale : Int) {
    this.value = value;
    this.scale = scale;
  }

  public function add(that : DecimalImpl) : DecimalImpl {
    var lhs = this.matchScale(that),
        rhs = that.matchScale(this);
    return new DecimalImpl(lhs.value.add(rhs.value), lhs.scale);
  }

  public function subtract(that : DecimalImpl) : DecimalImpl {
    var lhs = this.matchScale(that),
        rhs = that.matchScale(this);
    return new DecimalImpl(lhs.value.subtract(rhs.value), lhs.scale);
  }

  public function divMod(that : DecimalImpl) : { quotient : DecimalImpl, remainder : DecimalImpl } {
    return {
      quotient  : this,
      remainder : this
    };
  }

  public function divide(that : DecimalImpl) : DecimalImpl
    return divMod(that).quotient;

  public function multiply(that : DecimalImpl) : DecimalImpl {
    // TODO scale sum can overflow
    return new DecimalImpl(value.multiply(that.value), scale + that.scale);
  }

  public function modulo(that : DecimalImpl) : DecimalImpl
    return divMod(that).remainder;

  public function abs() : DecimalImpl
    return new DecimalImpl(value.abs(), scale);

  public function negate() : DecimalImpl
    return new DecimalImpl(value.negate(), scale);

  public function next() : DecimalImpl
    return add(one);

  public function prev() : DecimalImpl
    return subtract(one);

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
    return multiply(this);
  }

  public function isNegative() : Bool
    return value.sign;

  public function isEven() : Bool
    return value.isEven();

  public function isOdd() : Bool
    return value.isOdd();

  public function isZero() : Bool
    return value.isZero();

  public function isUnit() : Bool
    return false;

  public function compare(that : DecimalImpl) : Int {
    var lhs = this.matchScale(that),
        rhs = that.matchScale(this);
    return lhs.value.compare(rhs.value);
  }

  public function compareAbs(that : DecimalImpl) : Int {
    var lhs = this.matchScale(that),
        rhs = that.matchScale(this);
    return lhs.value.compareAbs(rhs.value);
  }

  // TODO needs better implementation
  public function trim() : DecimalImpl {
    var s = toString();
    if(s.indexOf(".") >= 0) {
      s = s.trimCharsRight("0");
      if(s.endsWith("."))
        s += "0";
      return Decimals.parse(s);
    } else {
      return this;
    }
  }

  // TODO
  public function toFloat() : Float {
    return Std.parseFloat(toString());
  }

  // TODO
  public function toInt() : Int
    return Std.int(toFloat());

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
