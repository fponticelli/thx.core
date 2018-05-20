package thx.bigint;

using thx.Strings;

class Bigs {
  inline public static var BASE : Int = 10000000; // 1e7
  inline public static var DOUBLE_BASE = 100000000000000.0; // 1e14
  inline public static var LOG_BASE : Int = 7;
  public static var MAX_INT(default, null) : Int = #if js untyped __js__("9007199254740992") #else 2147483647 #end;
  public static var MAX_INT_ARR(default, null) = smallToArray(MAX_INT);
  public static var LOG_MAX_INT(default, null) = Math.log(MAX_INT);

  public static var powersOfTwo(default, null) = (function() {
      var powers = [1];
      while (powers[powers.length - 1] <= BASE)
        powers.push(2 * powers[powers.length - 1]);
      return powers;
    })();
  public static var bigPowersOfTwo(default, null) : Array<BigIntImpl> = powersOfTwo.map(function(v) : BigIntImpl return new Small(v));
  public static var powers2Length(default, null) = powersOfTwo.length;
  public static var highestPower2(default, null) = powersOfTwo[powers2Length - 1];
  public static var bigHighestPower2(default, null) : BigIntImpl = new Small(highestPower2);

  public static function isPrecise(value : Int)
    return -MAX_INT < value && value < MAX_INT;

  public static function canMultiply(a : Int, b : Int) {
    if(a == 0 || b == 0) return true;
    var v = a * b;
    if(a != v / b) return false;
    return isPrecise(v);
  }

  public static function canPower(a : Int, b : Int) {
    if(a == 0 || b == 0) return true;
    var a = Math.abs(a);
    var b = Math.abs(b);
    var v;
    try {
      v = Std.int(Math.pow(a, b));
    } catch(e : Dynamic) {
      return false; // for Python
    }
    if(Std.int(Math.pow(v, 1.0 / b)) != a)
      return false;
    return isPrecise(v);
  }

  public static function canAdd(a : Int, b : Int) {
    var v = a + b;
    if (a > 0 && b > 0 && v < 0)
      return false;
    return isPrecise(v);
  }

  public static function smallToArray(n : Int) : Array<Int> {
    thx.Assert.isTrue(n >= 0, 'Bigs.smallToArray should always be non-negative: $n');
    if(n < BASE)
      return [n];
    if(n < DOUBLE_BASE)
      return [n % BASE, Math.floor(n / BASE)];
    return [n % BASE, Math.floor(n / BASE) % BASE, Math.floor(n / DOUBLE_BASE)];
  }

  public static function arrayToSmall(arr : Array<Int>) : Null<Int> {
    trim(arr);
    var length = arr.length;
    if(length < 4 && compareToAbs(arr, MAX_INT_ARR) < 0) {
      switch (length) {
        case 0: return 0;
        case 1: return arr[0];
        case 2: return arr[0] + arr[1] * BASE;
        default: return arr[0] + (arr[1] + arr[2] * BASE) * BASE;
      }
    }
    return null;
  }

  public static function trim(v : Array<Int>) {
    while(v.length > 1) {
      if(v[v.length - 1] != 0)
        break;
      v.pop();
    }
  }

  public static function createArray(length : Int) : Array<Int> {
    var x = #if js untyped __js__("new Array")(length) #else [] #end;
    for(i in 0...length)
      x[i] = 0;
    return x;
  }

  public static function createFloatArray(length : Int) : Array<Float> {
    var x = #if js untyped __js__("new Array")(length) #else [] #end;
    for(i in 0...length)
      x[i] = 0.0;
    return x;
  }

  public static function add(a : Array<Int>, b : Array<Int>) : Array<Int> { // assumes a and b are arrays with a.length >= b.length
    var l_a = a.length,
        l_b = b.length,
        r = #if js untyped __js__("new Array")(l_a) #else [] #end,
        carry = 0,
        sum, i = 0;
    while(i < l_b) {
      sum = a[i] + b[i] + carry;
      carry = sum >= BASE ? 1 : 0;
      r[i++] = sum - carry * BASE;
    }
    while(i < l_a) {
      sum = a[i] + carry;
      carry = sum == BASE ? 1 : 0;
      r[i++] = sum - carry * BASE;
    }
    if(carry > 0) r.push(carry);
    return r;
  }

  public static function addAny(a : Array<Int>, b : Array<Int>) : Array<Int> {
    if(a.length >= b.length) return add(a, b);
    return add(b, a);
  }

  public static function addSmall(a : Array<Int>, carry : Int) : Array<Int> { // assumes a is array, carry is number with 0 <= carry < MAX_INT
    var l = a.length,
        r = #if js untyped __js__("new Array")(l) #else [] #end,
        sum, i = 0;
    while(i < l) {
      sum = a[i] - BASE + carry;
      carry = Math.floor(sum / BASE);
      r[i++] = sum - carry * BASE;
      carry += 1;
    }
    while(carry > 0) {
      r[i++] = carry % BASE;
      carry = Math.floor(carry / BASE);
    }
    return r;
  }

  public static function compareToAbs(a : Array<Int>, b : Array<Int>) : Int {
    if(a.length != b.length)
      return a.length > b.length ? 1 : -1;
    var i = a.length;
    while(--i >= 0)
      if(a[i] != b[i]) return a[i] > b[i] ? 1 : -1;
    return 0;
  }

  public static function subtract(a : Array<Int>, b : Array<Int>) : Array<Int> { // assumes a and b are arrays with a >= b
    var a_l = a.length,
        b_l = b.length,
        r = #if js untyped __js__("new Array")(a_l) #else [] #end,
        borrow = 0,
        i = 0, difference;
    while(i < b_l) {
      difference = a[i] - borrow - b[i];
      if(difference < 0) {
        difference += BASE;
        borrow = 1;
      } else borrow = 0;
      r[i++] = difference;
    }
    while(i < a_l) {
      difference = a[i] - borrow;
      if(difference < 0) difference += BASE;
      else {
        r[i++] = difference;
        break;
      }
      r[i++] = difference;
    }
    while(i < a_l) {
      r[i] = a[i];
      i++;
    }
    trim(r);
    return r;
  }

  public static function subtractAny(a : Array<Int>, b : Array<Int>, sign : Bool) : BigIntImpl {
    var value;
    if(compareToAbs(a, b) >= 0) {
      value = subtract(a, b);
    } else {
      value = subtract(b, a);
      sign = !sign;
    }
    var n = arrayToSmall(value);
    if(null != n) {
      if(sign) n = -n;
      return new Small(n);
    }
    return new Big(value, sign);
  }

  public static function subtractSmall(a : Array<Int>, b : Int, sign : Bool) : BigIntImpl { // assumes a is array, b is number with 0 <= b < MAX_INT
    var l = a.length,
        r = #if js untyped __js__("new Array")(l) #else [] #end,
        carry = -b,
        i, difference, remainder;
    for(i in 0...l) {
      difference = a[i] + carry;
      carry = Math.floor(difference / BASE);
      // Chrome resolves -1 % 1 to -0 and -0 < 0 == true, Std.int fixes this with -0 | 0 = 0
      remainder = Std.int(difference % BASE); 
      r[i] = difference < -BASE ?  (remainder < 0 ? remainder + BASE : remainder) : difference;
    }

    var n = arrayToSmall(r);
    if(null != n) {
      if(sign) n = -n;
      return new Small(n);
    }
    return new Big(r, sign);
  }

  // TODO float conversion is not required in JS, optimize by typing as Int
  // and remove r.map
  public static function multiplyLong(a : Array<Int>, b : Array<Int>) : Array<Int> {
    var a_l = a.length,
        b_l = b.length,
        l = a_l + b_l,
        r : Array<Float> = createFloatArray(l),
        product : Float, carry, i, a_i : Float, b_j : Float;
    for(i in 0...a_l) {
      a_i = a[i] #if (neko || eval) + 0.0 #end;
      for(j in 0...b_l) {
        b_j = b[j] #if (neko || eval) + 0.0 #end;
        product = a_i * b_j + r[i + j];
        carry = Floats.ftrunc(product / BASE);
        r[i + j] = Floats.ftrunc(product - carry * BASE);
        r[i + j + 1] += carry;
      }
    }
    var arr = r.map(function(v) return Std.int(v));
    trim(arr);
    return arr;
  }

  public static function multiplySmall(a : Array<Int>, b : Int) : Array<Int> { // assumes a is array, b is number with |b| < BASE
    var l = a.length,
        r : Array<Float> = #if js untyped __js__("new Array")(l) #else [] #end,
        carry  : Float = 0.0,
        product : Float, i = 0,
        a_i : Float,
        bf : Float = b #if (neko || eval) + 0.0 #end;
    while(i < l) {
      a_i = a[i];
      product = carry + a[i] * bf;
      carry = Floats.ftrunc(product / BASE);
      r[i++] = product - carry * BASE;
    }
    while(carry > 0) {
      r[i++] = carry % BASE;
      carry = Floats.ftrunc(carry / BASE);
    }
    var arr = r.map(function(v) return Std.int(v));
    trim(arr);
    return arr;
  }

  public static function shiftLeft(x : Array<Int>, n : Int) : Array<Int> {
    var r = [];
    while(n-- > 0) r.push(0);
    return r.concat(x);
  }

  public static function multiplyKaratsuba(x : Array<Int>, y : Array<Int>) : Array<Int> {
    var n = Ints.max(x.length, y.length);

    if(n <= 400)
      return multiplyLong(x, y);
    n = Math.ceil(n / 2);

    var b = x.slice(n),
        a = x.slice(0, n),
        d = y.slice(n),
        c = y.slice(0, n);

    var ac = multiplyKaratsuba(a, c),
        bd = multiplyKaratsuba(b, d),
        abcd = multiplyKaratsuba(addAny(a, b), addAny(c, d));

    return addAny(addAny(ac, shiftLeft(subtract(subtract(abcd, ac), bd), n)), shiftLeft(bd, 2 * n));
  }

  public static function fromInt(value : Int) : BigIntImpl {
    var abs = Ints.abs(value);
    if(abs < BASE)
      return new Small(value);
    else
      return new Big(smallToArray(abs), value < 0);
  }

  // TODO needs better implementation
  public static function fromInt64(value : haxe.Int64) : BigInt
    return Bigs.parseBase(haxe.Int64.toStr(value), 10);

  // TODO needs better implementation
  public static function toInt64(value : BigIntImpl) : haxe.Int64
    return thx.Int64s.parse(value.toString());

  public static function fromFloat(value : Float) : BigIntImpl {
    if(Math.isNaN(value) || !Math.isFinite(value))
      throw new Error("Conversion to BigInt failed. Number is NaN or Infinite");

    var noFractions = value - (value % 1),
        result : BigIntImpl = Small.zero,
        neg    = noFractions < 0.0,
        rest   = neg ? -noFractions : noFractions,
        i = 0, curr;
    while (rest >= 1) {
      curr = rest % 2;
      rest = rest / 2;
      if(curr >= 1)
        result = result.add(Small.one.shiftLeft(i));
      i++;
    }

    if(neg)
      return result.negate();
    else
      return result;
  }

  // TODO float conversion is not required in JS, optimize by typing as Int
  // and remove r.map
  public static function square(a : Array<Int>) : Array<Int> {
    var l = a.length,
        r = createFloatArray(l + l),
        product : Float, carry, i, a_i : Float, a_j : Float;
    for(i in 0...l) {
      a_i = a[i] #if (neko || eval) + 0.0 #end;
      for(j in 0...l) {
        a_j = a[j] #if (neko || eval) + 0.0 #end;
        product = a_i * a_j + r[i + j];
        carry = Floats.ftrunc(product / BASE);
        r[i + j] = Floats.ftrunc(product - carry * BASE);
        r[i + j + 1] += carry;
      }
    }
    var arr = r.map(function(v) return Std.int(v));
    trim(arr);
    return arr;
  }

  public static function divMod1(a : Array<Int>, b : Array<Int>) : Array<{ small : Null<Int>, big : Array<Int> }> { // Left over from previous version. Performs faster than divMod2 on smaller input sizes.
    var a_l = a.length,
        b_l = b.length,
        result = createFloatArray(b.length),
        divisorMostSignificantDigit : Float = b[b_l - 1] #if (neko || eval) + 0.0 #end,
        // normalization
        lambda = Math.ceil(BASE / (2 * divisorMostSignificantDigit)),
        remainder : Array<Float> = multiplySmall(a, lambda).map(function(v) : Float return v),
        divisor = multiplySmall(b, lambda),
        quotientDigit : Float, shift, carry : Float, borrow : Float, i, l, q : Float;
    if(remainder.length <= a_l)
      remainder.push(0.0);
    divisor.push(0);
    divisorMostSignificantDigit = divisor[b_l - 1];
    shift = a_l - b_l;
    while(shift >= 0) {
      quotientDigit = BASE - 1.0;
      quotientDigit = Math.ffloor(((remainder[shift + b_l] #if (neko || eval) + 0.0000000001 #end) * BASE + remainder[shift + b_l - 1]) / divisorMostSignificantDigit);
      carry = 0.0;
      borrow = 0.0;
      l = divisor.length;
      for(i in 0...l) {
        carry += quotientDigit * (divisor[i] : Float);
        q = Floats.ftrunc(carry / BASE);
        borrow += remainder[shift + i] - (carry - q * BASE);
        carry = q;
        if(borrow < 0.0) {
          remainder[shift + i] = borrow + BASE;
          borrow = -1.0;
        } else {
          remainder[shift + i] = borrow;
          borrow = 0.0;
        }
      }
      while(borrow != 0) {
        quotientDigit -= 1;
        carry = 0;
        for(i in 0...l) {
          carry += remainder[shift + i] - BASE + divisor[i];
          if(carry < 0) {
            remainder[shift + i] = carry + BASE;
            carry = 0;
          } else {
            remainder[shift + i] = carry;
            carry = 1;
          }
        }
        borrow += carry;
      }
      result[shift] = quotientDigit;
      shift--;
    }
    // denormalization
    var arr : Array<Int> = remainder.map(function(v) : Int return Std.int(v));
    var remainder = divModSmall(arr, lambda).q;
    var arr : Array<Int> = result.map(function(v) : Int return Std.int(v));
    trim(arr);

    var q = {
          small : arrayToSmall(arr),
          big : arr
        },
        r = {
          small : arrayToSmall(remainder),
          big : remainder
        };
    return [q, r];
  }

  public static function divMod2(a : Array<Int>, b : Array<Int>) : Array<{ small : Null<Int>, big : Array<Int> }> { // Implementation idea shamelessly stolen from Silent Matt's library http://silentmatt.com/biginteger/
    // Performs faster than divMod1 on larger input sizes.
    var a_l = a.length,
        b_l = b.length,
        result = [],
        part = [],
        guess, xlen, highx, highy, check;
    while(a_l != 0) {
      part.unshift(a[--a_l]);
      if(compareToAbs(part, b) < 0) {
        result.push(0);
        continue;
      }
      xlen = part.length;
      highx = part[xlen - 1] * BASE + part[xlen - 2];
      highy = b[b_l - 1] * BASE + b[b_l - 2];
      if(xlen > b_l) {
        highx = (highx + 1) * BASE;
      }
      guess = Math.ceil(highx / highy);
      do {
        check = multiplySmall(b, guess);
        if(compareToAbs(check, part) <= 0) break;
        guess--;
      } while(guess != 0);
      result.push(guess);
      part = subtract(part, check);
    }
    result.reverse();
    return [{
        small : arrayToSmall(result),
        big : result
      }, {
        small : arrayToSmall(part),
        big : part
      }];
  }

  public static function divModSmall(value : Array<Int>, lambda : Int) : { q : Array<Int>, r : Int } {
    var length = value.length,
        quotient = createArray(length),
        i, q : Float, remainder : Float, divisor;
    remainder = 0;
    i = length - 1;
    while(i >= 0) {
      divisor = remainder * BASE + value[i];
      q = Floats.ftrunc(divisor / lambda);
      remainder = divisor - q * lambda;
      quotient[i--] = Std.int(q);
    }
    return { q : quotient, r : Floats.trunc(remainder) };
  }

  public static function parseBase(text : String, base : Int) : BigIntImpl {
    var val : BigIntImpl = Small.zero,
        pow : BigIntImpl = Small.one,
        bigBase = new Small(base),
        isNegative = text.substring(0, 1) == "-";
    if(2 > base || base > 36)
      throw new Error('base ($base) must be a number between 2 ad 36');
    if(isNegative) {
      text = text.substring(1);
    }
    text = text.trimCharsLeft("0").toLowerCase();
    if(text.length == 0)
      text = "0";

    var e;
    if(base == 10 && (e = text.indexOf("e")) > 0) {
      var sexp = text.substring(e + 1);
      text = text.substring(0, e);
      var exp = sexp.startsWith("+") ? Std.parseInt(sexp.substring(1)) : Std.parseInt(sexp);
      var decimalPlace = text.indexOf(".");
      if(decimalPlace >= 0) {
        exp -= text.length - decimalPlace;
        text = text.substring(0, decimalPlace) + text.substring(1 + decimalPlace);
      }
      //if(exp < 0) throw new Error("Cannot include negative exponent part for integers");

      text = text.rpad("0", text.length + exp);
    }
    var length = text.length;

    if(length <= LOG_MAX_INT / Math.log(base))
      return new Small(Ints.parse(text, base) * (isNegative ? -1 : 1));

    var digits : Array<Small> = [];
    for(i in 0...length) {
      var charCode = text.charCodeAt(i);
      if(48 <= charCode && charCode <= 57)
        digits.push(new Small(charCode - 48));
      else if(97 <= charCode && charCode <= 122)
        digits.push(new Small(charCode - 87));
      else throw new Error('$text is not a valid string');
    }
    digits.reverse();
    var mul;
    for(i in 0...digits.length) {
      mul = digits[i].multiply(pow);
      val = val.add(mul);
      pow = pow.multiply(bigBase);
    }
    return isNegative ? val.negate() : val;
  }

  public static function bitwise(x : BigIntImpl, y : BigIntImpl, fn : Int -> Int -> Int) {
    var xSign = x.sign,
        ySign = y.sign;
    var xRem = xSign ? x.not() : x,
        yRem = ySign ? y.not() : y;
    var xBits = [],
        yBits = [];
    var xStop = false,
        yStop = false;
    while(!xStop || !yStop) {
      if(xRem.isZero()) { // virtual sign extension for simulating two's complement
        xStop = true;
        xBits.push(xSign ? 1 : 0);
      } else if(xSign)
        xBits.push(xRem.isEven() ? 1 : 0); // two's complement for negative numbers
      else
        xBits.push(xRem.isEven() ? 0 : 1);

      if(yRem.isZero()) {
        yStop = true;
        yBits.push(ySign ? 1 : 0);
      } else if(ySign)
        yBits.push(yRem.isEven() ? 1 : 0);
      else
        yBits.push(yRem.isEven() ? 0 : 1);

      xRem = xRem.divide(Small.two);
      yRem = yRem.divide(Small.two);
    }
    var result = [];
    for(i in 0...xBits.length)
      result.push(fn(xBits[i], yBits[i]));

    var a = Bigs.fromInt(result.pop()),
        p = Small.two.pow(Bigs.fromInt(result.length)),
        sum = a.negate().multiply(p);
    while(result.length > 0) {
      a = Bigs.fromInt(result.pop());
      p = Small.two.pow(Bigs.fromInt(result.length));
      sum = sum.add(a.multiply(p));
    }
    return sum;
  }
}
