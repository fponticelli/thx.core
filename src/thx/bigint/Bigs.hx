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
    if (n < BASE)
      return [n];
    if (n < DOUBLE_BASE) // TODO not cross friendly
      return [n % BASE, Math.floor(n / BASE)];
    return [n % BASE, Math.floor(n / BASE) % BASE, Math.floor(n / DOUBLE_BASE)];
  }

  public static function arrayToSmall(arr : Array<Int>) : Null<Int> { // If BASE changes this function may need to change
    trim(arr);
    var length = arr.length;
    if (length < 4 && compareAbs(arr, MAX_INT_ARR) < 0) {
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
    var i = v.length;
    while (v[--i] == 0){}
    v.splice(i, v.length);
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
        sum, i;
    for (i in 0...l_b) {
      sum = a[i] + b[i] + carry;
      carry = sum >= base ? 1 : 0;
      r[i] = sum - carry * base;
    }
    while (i < l_a) {
      sum = a[i] + carry;
      carry = sum == base ? 1 : 0;
      r[i++] = sum - carry * base;
    }
    if (carry > 0) r.push(carry);
    return r;
  }

  public static function addAny(a : Array<Int>, b : Array<Int>) : Array<Int> {
    if (a.length >= b.length) return add(a, b);
    return add(b, a);
  }

  public static function addSmall(a : Array<Int>, carry : Int) : Array<Int> { // assumes a is array, carry is number with 0 <= carry < MAX_INT
    var l = a.length,
        r = #if js untyped __js__("new Array")(l) #else [] #end,
        base = BASE,
        sum, i;
    for (i in 0...l) {
      sum = a[i] - base + carry;
      carry = Math.floor(sum / base);
      r[i] = sum - carry * base;
      carry += 1;
    }
    while (carry > 0) {
      r[i++] = carry % base;
      carry = Math.floor(carry / base);
    }
    return r;
  }

  public static function compareAbs(a : Array<Int>, b : Array<Int>) : Int {
    if (a.length != b.length) {
      return a.length > b.length ? 1 : -1;
    }
    var i = a.length;
    while(--i >= 0) {
    //for (var i = a.length - 1; i >= 0; i--) {
      if (a[i] != b[i]) return a[i] > b[i] ? 1 : -1;
    }
    return 0;
  }
}
