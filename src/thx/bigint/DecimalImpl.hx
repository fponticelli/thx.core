package thx.bigint;

using thx.Strings;
import thx.Error;

class DecimalImpl {
  public static var zero(default, null) = Decimals.fromInt(0);
  public static var one(default, null) = Decimals.fromInt(1);
  public static var ten(default, null) = Decimals.fromInt(10);

  public static function randomBetween(a : DecimalImpl, b : DecimalImpl) {
    var lhs = a.matchScale(b),
        rhs = b.matchScale(a);
    return new DecimalImpl(thx.BigInt.randomBetween(lhs.value, rhs.value), lhs.scale);
  }

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

  public function divide(that : DecimalImpl) : DecimalImpl
    return divideWithScale(that, Decimals.divisionExtraScale);

  public function divideWithScale(that : DecimalImpl, scale : Int) : DecimalImpl {
    if(that.isZero())
      throw new Error('division by zero');
    var lhs    = this.matchScale(that),
        rhs    = that.matchScale(this),
        pow    = Small.ten.pow(Bigs.fromInt(rhs.scale + scale)),
        qr     = lhs.value.multiply(pow).divMod(rhs.value),
        nscale = rhs.scale + scale;
    return new DecimalImpl(qr.quotient, nscale).trim(nscale);
  }

  public function moduloWithScale(that : DecimalImpl, scale : Int) : DecimalImpl {
    if(that.isZero())
      throw new Error('modulo by zero');
    var lhs    = this.matchScale(that),
        rhs    = that.matchScale(this),
        pow    = Small.ten.pow(Bigs.fromInt(scale)),
        qr     = lhs.value.multiply(pow).divMod(rhs.value.multiply(pow)),
        nscale = lhs.scale + scale;
    return new DecimalImpl(qr.remainder, nscale).trim(nscale);
  }

  public function multiply(that : DecimalImpl) : DecimalImpl {
    // TODO scale sum can overflow
    return new DecimalImpl(value.multiply(that.value), scale + that.scale);
  }

  public function modulo(that : DecimalImpl) : DecimalImpl {
    return moduloWithScale(that, Decimals.divisionExtraScale);
  }

  public function abs() : DecimalImpl
    return new DecimalImpl(value.abs(), scale);

  public function negate() : DecimalImpl
    return new DecimalImpl(value.negate(), scale);

  public function next() : DecimalImpl
    return add(one);

  public function prev() : DecimalImpl
    return subtract(one);

  public function pow(exp : Int) : DecimalImpl {
    if(exp < 0) {
      var i = value.pow(Bigs.fromInt(-exp));
      return Decimal.one.divideWithScale(Decimal.fromBigInt(i), (scale + 1) * -exp);
    } else {
      var i = value.pow(Bigs.fromInt(exp));
      return new DecimalImpl(i, scale * exp);
    }
  }

  public function ceilTo(newscale : Int) : DecimalImpl {
    if(isZero())
      return this;
    var scaled = scaleTo(newscale),
        f = (scaled.isZero() ? one : modulo(scaled)).multiply(ten.pow(newscale)).toFloat();
    if(f <= 0) {
      return scaled;
    } else {
      return new DecimalImpl(scaled.value.add(Small.one), scaled.scale);
    }
  }

  public function floorTo(newscale : Int) : DecimalImpl
    return scaleTo(newscale);

  public function roundTo(newscale : Int) : DecimalImpl {
    if(isZero())
      return this;
    var scaled = scaleTo(newscale),
        f = (scaled.isZero() ? one : modulo(scaled)).multiply(ten.pow(newscale)).toFloat();
    if(f < 0.5) {
      return scaled;
    } else {
      return new DecimalImpl(scaled.value.add(Small.one), scaled.scale);
    }
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

  public function compareTo(that : DecimalImpl) : Int {
    var lhs = this.matchScale(that),
        rhs = that.matchScale(this);
    return lhs.value.compareTo(rhs.value);
  }

  public function compareToAbs(that : DecimalImpl) : Int {
    var lhs = this.matchScale(that),
        rhs = that.matchScale(this);
    return lhs.value.compareToAbs(rhs.value);
  }

  // TODO needs better implementation
  public function trim(?min = 0) : DecimalImpl {
    if(scale == 0)
      return this;
    var s = toString(),
        parts = s.split("."),
        dec = parts[1].trimCharsRight("0").rpad("0", min);
    if(dec.length > 0)
      s = parts[0]+"."+dec;
    else
      s = parts[0];
    return Decimals.parse(s);
  }

  // TODO needs better implementation
  public function toFloat() : Float {
    return Std.parseFloat(toString());
  }

  public function toInt() : Int {
    var i = value.divide(Small.ten.pow(Bigs.fromInt(scale)));
    return i.toInt();
  }

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
