package thx.bigint;

class Bigs {
  public static var BASE(default, null) : Int = 10000000; // 1e7
  public static var DOUBLE_BASE(default, null) = 100000000000000.0; // 1e14
  public static var LOG_BASE(default, null) : Int = 7; // 1e7
  public static var MAX_INT(default, null) : Int = 2147483647; //9007199254740992; // 2147483648
  public static var MAX_INT_ARR(default, null) = smallToArray(MAX_INT);
  public static var LOG_MAX_INT(default, null) = Math.log(MAX_INT);

  // TODO excluded boundary values?
  public static function isPrecise(value : Int)
    return -MAX_INT < value && value < MAX_INT;

  public static function smallToArray(n : Int) : Array<Int> { // For performance reasons doesn't reference BASE, need to change this function if BASE changes
    if(n < BASE)
      return [n];
    if(n < DOUBLE_BASE) // TODO not cross friendly
      return [n % BASE, Math.floor(n / BASE)];
    return [n % BASE, Math.floor(n / BASE) % BASE, Math.floor(n / DOUBLE_BASE)];
  }

  public static function arrayToSmall(arr : Array<Int>) : Null<Int> { // If BASE changes this function may need to change
    trim(arr);
    var length = arr.length;
    if(length < 4 && compareAbs(arr, MAX_INT_ARR) < 0) {
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
    while(v.length > 0) {
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

  public static function add(a : Array<Int>, b : Array<Int>) : Array<Int> { // assumes a and b are arrays with a.length >= b.length
    var l_a = a.length,
        l_b = b.length,
        r = #if js untyped __js__("new Array")(l_a) #else [] #end,
        carry = 0,
        base = BASE,
        sum, i = 0;
    while(i < l_b) {
      sum = a[i] + b[i] + carry;
      carry = sum >= base ? 1 : 0;
      r[i++] = sum - carry * base;
    }
    while(i < l_a) {
      sum = a[i] + carry;
      carry = sum == base ? 1 : 0;
      r[i++] = sum - carry * base;
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
        base = BASE,
        sum, i = 0;
    while(i < l) {
      sum = a[i] - base + carry;
      carry = Math.floor(sum / base);
      r[i++] = sum - carry * base;
      carry += 1;
    }
    while(carry > 0) {
      r[i++] = carry % base;
      carry = Math.floor(carry / base);
    }
    return r;
  }

  public static function compareAbs(a : Array<Int>, b : Array<Int>) : Int {
    if(a.length != b.length) {
      return a.length > b.length ? 1 : -1;
    }
    var i = a.length;
    while(--i >= 0) {
    //for(var i = a.length - 1; i >= 0; i--) {
      if(a[i] != b[i]) return a[i] > b[i] ? 1 : -1;
    }
    return 0;
  }

  public static function subtract(a : Array<Int>, b : Array<Int>) : Array<Int> { // assumes a and b are arrays with a >= b
    var a_l = a.length,
        b_l = b.length,
        r = #if js untyped __js__("new Array")(a_l) #else [] #end,
        borrow = 0,
        base = BASE,
        i = 0, difference;
    while(i < b_l) {
      difference = a[i] - borrow - b[i];
      if(difference < 0) {
        difference += base;
        borrow = 1;
      } else borrow = 0;
      r[i++] = difference;
    }
    while(i < a_l) {
    //for(i in b_l; i < a_l; i++) {
      difference = a[i] - borrow;
      if(difference < 0) difference += base;
      else {
        r[i++] = difference;
        break;
      }
      r[i++] = difference;
    }
    while(i < a_l) {
    //for(; i < a_l; i++) {
      r[i] = a[i];
      i++;
    }
    trim(r);
    return r;
  }

  public static function subtractAny(a : Array<Int>, b : Array<Int>, sign : Bool) : BigIntImpl {
    var value;
    if(compareAbs(a, b) >= 0) {
      value = subtract(a,b);
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
        base = BASE,
        i, difference;
    for(i in 0...l) {
      difference = a[i] + carry;
      carry = Math.floor(difference / base);
      r[i] = difference < 0 ? difference % base + base : difference;
    }
    var n = arrayToSmall(r);
    if(null != n) {
      if(sign) n = -n;
      return new Small(n);
    }
    return new Big(r, sign);
  }

  public static function multiplyLong(a : Array<Int>, b : Array<Int>) : Array<Int> {
    var a_l = a.length,
        b_l = b.length,
        l = a_l + b_l,
        r = createArray(l),
        base = BASE,
        product, carry, i, a_i, b_j;
    for(i in 0...a_l) {
      a_i = a[i];
      for(j in 0...b_l) {
        b_j = b[j];
        product = a_i * b_j + r[i + j];
        carry = Math.floor(product / base);
        r[i + j] = product - carry * base;
        r[i + j + 1] += carry;
      }
    }
    trim(r);
    return r;
  }

  public static function multiplySmall(a : Array<Int>, b : Int) : Array<Int> { // assumes a is array, b is number with |b| < BASE
    var l = a.length,
        r = #if js untyped __js__("new Array")(l) #else [] #end,
        base = BASE,
        carry = 0,
        product, i = 0;
    while(i < l) {
      product = a[i] * b + carry;
      carry = Math.floor(product / base);
      r[i++] = product - carry * base;
    }
    while(carry > 0) {
      r[i++] = carry % base;
      carry = Math.floor(carry / base);
    }
    return r;
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

/*
  public static function square(a) {
      var l = a.length,
          r = createArray(l + l),
          base = BASE,
          product, carry, i, a_i, a_j;
      for(i = 0; i < l; i++) {
          a_i = a[i];
          for(var j = 0; j < l; j++) {
              a_j = a[j];
              product = a_i * a_j + r[i + j];
              carry = Math.floor(product / base);
              r[i + j] = product - carry * base;
              r[i + j + 1] += carry;
          }
      }
      trim(r);
      return r;
  }
*/
  public static function divMod1(a : Array<Int>, b : Array<Int>) : Array<{ small : Null<Int>, big : Array<Int> }> { // Left over from previous version. Performs faster than divMod2 on smaller input sizes.
    var a_l = a.length,
        b_l = b.length,
        base = BASE,
        result = createArray(b.length),
        divisorMostSignificantDigit = b[b_l - 1],
        // normalization
        lambda = Math.ceil(base / (2 * divisorMostSignificantDigit)),
        remainder = multiplySmall(a, lambda),
        divisor = multiplySmall(b, lambda),
        quotientDigit, shift, carry, borrow, i, l, q;
    if(remainder.length <= a_l) remainder.push(0);
    divisor.push(0);
    divisorMostSignificantDigit = divisor[b_l - 1];
    shift = a_l - b_l;
    while(shift >= 0) {
    //for(shift = a_l - b_l; shift >= 0; shift--) {
      quotientDigit = base - 1;
      quotientDigit = Math.floor((remainder[shift + b_l] * base + remainder[shift + b_l - 1]) / divisorMostSignificantDigit);
      carry = 0;
      borrow = 0;
      l = divisor.length;
      for(i in 0...l) {
        carry += quotientDigit * divisor[i];
        q = Math.floor(carry / base);
        borrow += remainder[shift + i] - (carry - q * base);
        carry = q;
        if(borrow < 0) {
          remainder[shift + i] = borrow + base;
          borrow = -1;
        } else {
          remainder[shift + i] = borrow;
          borrow = 0;
        }
      }
      while(borrow != 0) {
        quotientDigit -= 1;
        carry = 0;
        for(i in 0...l) {
          carry += remainder[shift + i] - base + divisor[i];
          if(carry < 0) {
            remainder[shift + i] = carry + base;
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
    remainder = divModSmall(remainder, lambda).q;
    return [{
        small : arrayToSmall(result),
        big : result
      }, {
        small : arrayToSmall(remainder),
        big : remainder
      }];
  }

  public static function divMod2(a : Array<Int>, b : Array<Int>) : Array<{ small : Null<Int>, big : Array<Int> }> { // Implementation idea shamelessly stolen from Silent Matt's library http://silentmatt.com/biginteger/
    // Performs faster than divMod1 on larger input sizes.
    var a_l = a.length,
        b_l = b.length,
        result = [],
        part = [],
        base = BASE,
        guess, xlen, highx, highy, check;
    while(a_l != 0) {
      part.unshift(a[--a_l]);
      if(compareAbs(part, b) < 0) {
        result.push(0);
        continue;
      }
      xlen = part.length;
      highx = part[xlen - 1] * base + part[xlen - 2];
      highy = b[b_l - 1] * base + b[b_l - 2];
      if(xlen > b_l) {
        highx = (highx + 1) * base;
      }
      guess = Math.ceil(highx / highy);
      do {
        check = multiplySmall(b, guess);
        if(compareAbs(check, part) <= 0) break;
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
        base = BASE,
        i, q, remainder, divisor;
    remainder = 0;
    i = length - 1;
    while(i >= 0) {
    //for(i = length - 1; i >= 0; --i) {
      divisor = remainder * base + value[i];
      q = Floats.trunc(divisor / lambda);
      remainder = divisor - q * lambda;
      quotient[i] = q | 0;
      --i;
    }
    return { q : quotient, r : Std.int(remainder) };
  }
/*
  public static function divModAny(self, v) {
    var value, n = parseValue(v);
    var a = self.value, b = n.value;
    var quotient;
    if(b == 0) throw new Error("Cannot divide by zero");
    if(n.isSmall) {
        if(b == 1) return [self, Small.zero];
        if(b == -1) return [self.negate(), Small.zero];
        var abs = Math.abs(b);
        if(abs < BASE) {
          value = divModSmall(a, abs);
          quotient = arrayToSmall(value[0]);
          var remainder = value[1];
          if(self.sign) remainder = -remainder;
          if(typeof quotient == "number") {
            if(self.sign != n.sign) quotient = -quotient;
            return [new Small(quotient), new Small(remainder)];
          }
          return [new Big(quotient, self.sign != n.sign), new Small(remainder)];
        }
        b = smallToArray(abs);
    }
    var comparison = compareAbs(a, b);
    if(comparison == -1) return [Small.zero, self];
    if(comparison == 0) return [CACHE[self.sign == n.sign ? 1 : -1], Small.zero];

    // divMod1 is faster on smaller input sizes
    if(a.length + b.length <= 200)
      value = divMod1(a, b);
    else value = divMod2(a, b);

    quotient = value[0];
    var qSign = self.sign != n.sign,
        mod = value[1],
        mSign = self.sign;
    if(typeof quotient == "number") {
      if(qSign) quotient = -quotient;
      quotient = new Small(quotient);
    } else
      quotient = new Big(quotient, qSign);
    if(typeof mod == "number") {
      if(mSign) mod = -mod;
      mod = new Small(mod);
    } else
      mod = new Big(mod, mSign);
    return [quotient, mod];
  }
  */
/*
  public static function compareAbs(a, b) {
      if(a.length != b.length) {
          return a.length > b.length ? 1 : -1;
      }
      for(var i = a.length - 1; i >= 0; i--) {
          if(a[i] != b[i]) return a[i] > b[i] ? 1 : -1;
      }
      return 0;
  }

  public static function shift_isSmall(n) {
      return ((typeof n == "number" || typeof n == "string") && +Math.abs(n) <= BASE) ||
          (n instanceof Big && n.value.length <= 1);
  }



  public static function bitwise(x, y, fn) {
      y = parseValue(y);
      var xSign = x.isNegative(), ySign = y.isNegative();
      var xRem = xSign ? x.not() : x,
          yRem = ySign ? y.not() : y;
      var xBits = [], yBits = [];
      var xStop = false, yStop = false;
      while(!xStop || !yStop) {
          if(xRem.isZero()) { // virtual sign extension for simulating two's complement
              xStop = true;
              xBits.push(xSign ? 1 : 0);
          }
          else if(xSign) xBits.push(xRem.isEven() ? 1 : 0); // two's complement for negative numbers
          else xBits.push(xRem.isEven() ? 0 : 1);

          if(yRem.isZero()) {
              yStop = true;
              yBits.push(ySign ? 1 : 0);
          }
          else if(ySign) yBits.push(yRem.isEven() ? 1 : 0);
          else yBits.push(yRem.isEven() ? 0 : 1);

          xRem = xRem.over(2);
          yRem = yRem.over(2);
      }
      var result = [];
      for(var i = 0; i < xBits.length; i++) result.push(fn(xBits[i], yBits[i]));
      var sum = bigInt(result.pop()).negate().times(bigInt(2).pow(result.length));
      while(result.length) {
          sum = sum.add(bigInt(result.pop()).times(bigInt(2).pow(result.length)));
      }
      return sum;



              function max(a, b) {
                  a = parseValue(a);
                  b = parseValue(b);
                  return a.greater(b) ? a : b;
              }
              function min(a,b) {
                  a = parseValue(a);
                  b = parseValue(b);
                  return a.lesser(b) ? a : b;
              }
              function gcd(a, b) {
                  a = parseValue(a).abs();
                  b = parseValue(b).abs();
                  if(a.equals(b)) return a;
                  if(a.isZero()) return b;
                  if(b.isZero()) return a;
                  if(a.isEven()) {
                      if(b.isOdd()) {
                          return gcd(a.divide(2), b);
                      }
                      return gcd(a.divide(2), b.divide(2)).multiply(2);
                  }
                  if(b.isEven()) {
                      return gcd(a, b.divide(2));
                  }
                  if(a.greater(b)) {
                      return gcd(a.subtract(b).divide(2), b);
                  }
                  return gcd(b.subtract(a).divide(2), a);
              }
              function lcm(a, b) {
                  a = parseValue(a).abs();
                  b = parseValue(b).abs();
                  return a.multiply(b).divide(gcd(a, b));
              }
              function randBetween(a, b) {
                  a = parseValue(a);
                  b = parseValue(b);
                  var low = min(a, b), high = max(a, b);
                  var range = high.subtract(low);
                  if(range.isSmall) return low.add(Math.random() * range);
                  var length = range.value.length - 1;
                  var result = [], restricted = true;
                  for(var i = length; i >= 0; i--) {
                      var top = restricted ? range.value[i] : BASE;
                      var digit = Floats.trunc(Math.random() * top);
                      result.unshift(digit);
                      if(digit < top) restricted = false;
                  }
                  result = arrayToSmall(result);
                  return low.add(new Big(result, false, typeof result == "number"));
              }
                  // Pre-define numbers in range [-999,999]
                  var CACHE = function(v, radix) {
                      if(typeof v == "undefined") return Small.zero;
                      if(typeof radix != "undefined") return +radix == 10 ? parseValue(v) : parseBase(v, radix);
                      return parseValue(v);
                  };
                  for(var i = 0; i < 1000; i++) {
                      CACHE[i] = new Small(i);
                      if(i > 0) CACHE[-i] = new Small(-i);
                  }
                  // Backwards compatibility
                  CACHE.one = Small.one;
                  CACHE.zero = Small.zero;
                  CACHE.minusOne = CACHE[-1];
                  CACHE.max = max;
                  CACHE.min = min;
                  CACHE.gcd = gcd;
                  CACHE.lcm = lcm;
                  CACHE.isInstance = function(x) { return x instanceof Big || x instanceof Small; };
                  CACHE.randBetween = randBetween;
                  return CACHE;
*/

  public static function parseBase(text : String, base : Int) : BigIntImpl {
    var val : BigIntImpl = Small.zero,
        pow : BigIntImpl = Small.one,
        bigBase = new Small(base),
        length = text.length;
    if(2 >= base || base > 36)
      throw new Error('base ($base) must be a number between 2 and 36');

    if(length <= LOG_MAX_INT / Math.log(base))
      return new Small(Ints.parse(text, base));

    var digits : Array<Small> = [];
    var i;
    var isNegative = text.substring(0, 1) == "-";
    text = text.toLowerCase();
    for(i in (isNegative ? 1 : 0)...text.length) {
      var charCode = text.charCodeAt(i);
      if(48 <= charCode && charCode <= 57)
        digits.push(new Small(charCode - 48));
      else if(97 <= charCode && charCode <= 122)
        digits.push(new Small(charCode - 87));
      // TODO
      /*
      else if(charCode == "<".code) {
        var start = i;
        do { i++; } while(text.charCodeAt(i) != ">".code);
        digits.push(parseValue(text.substring(start + 1, i)));
      }
      */
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
/*
  public static function stringify(digit) {
    var v = digit.value;
    if(typeof v == "number") v = [v];
    if(v.length == 1 && v[0] <= 36) {
        return "0123456789abcdefghijklmnopqrstuvwxyz".charAt(v[0]);
    }
    return "<" + v + ">";
  }

  public static function toBase(n, base) {
    base = bigInt(base);
    if(base.isZero()) {
        if(n.isZero()) return "0";
        throw new Error("Cannot convert nonzero numbers to base 0.");
    }
    if(base.equals(-1)) {
        if(n.isZero()) return "0";
        if(n.isNegative()) return new Array(1 - n).join("10");
        return "1" + new Array(+n).join("01");
    }
    var minusSign = "";
    if(n.isNegative() && base.isPositive()) {
        minusSign = "-";
        n = n.abs();
    }
    if(base.equals(1)) {
        if(n.isZero()) return "0";
        return minusSign + new Array(+n + 1).join(1);
    }
    var out = [];
    var left = n, divmod;
    while(left.isNegative() || left.compareAbs(base) >= 0) {
        divmod = left.divmod(base);
        left = divmod.quotient;
        var digit = divmod.remainder;
        if(digit.isNegative()) {
            digit = base.minus(digit).abs();
            left = left.next();
        }
        out.push(stringify(digit));
    }
    out.push(stringify(left));
    return minusSign + out.reverse().join("");
  }

  public static function parseValue(v) {
        if(v instanceof Big || v instanceof Small) return v;
        if(typeof v == "number") {
            if(isPrecise(v)) return new Small(v);
            v = String(v);
        }
        if(typeof v == "string") {
            if(isPrecise(+v)) {
                var x = +v;
                if(x == Floats.trunc(x))
                    return new Small(x);
                throw "Invalid integer: " + v;
            }
            var sign = v[0] == "-";
            if(sign) v = v.slice(1);
            var split = v.split(/e/i);
            if(split.length > 2) throw new Error("Invalid integer: " + text.join("e"));
            if(split.length == 2) {
                var exp = split[1];
                if(exp[0] == "+") exp = exp.slice(1);
                exp = +exp;
                if(exp != Floats.trunc(exp) || !isPrecise(exp)) throw new Error("Invalid integer: " + exp + " is not a valid exponent.");
                var text = split[0];
                var decimalPlace = text.indexOf(".");
                if(decimalPlace >= 0) {
                    exp -= text.length - decimalPlace;
                    text = text.slice(0, decimalPlace) + text.slice(decimalPlace + 1);
                }
                if(exp < 0) throw new Error("Cannot include negative exponent part for integers");
                text += (new Array(exp + 1)).join("0");
                v = text;
            }
            var isValid = /^([0-9][0-9]*)$/.test(v);
            if(!isValid) throw new Error("Invalid integer: " + v);
            var r = [], max = v.length, l = LOG_BASE, min = max - l;
            while(max > 0) {
                r.push(+v.slice(min, max));
                min -= l;
                if(min < 0) min = 0;
                max -= l;
            }
            trim(r);
            return new Big(r, sign);
        }
    }
*/
}
