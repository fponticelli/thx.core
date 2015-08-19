package thx;

/**
Based on code realized by Mike Welsh: https://github.com/Herschel/hxmath/blob/master/src/hxmath/BigInt.hx
*/
abstract BigInt(Array<Int>) {
  static inline var CHUNK_SIZE = 30;
  static inline var CHUNK_MASK = (1 << CHUNK_SIZE) - 1;
  static inline var CHUNK_MAX_FLOAT = (1 << (CHUNK_SIZE-1)) * 2.0;
  static inline var MUL_BITS = Std.int(CHUNK_SIZE / 2);
  static inline var MUL_MASK = (1 << MUL_BITS) - 1;

  public static var zero(default, null) = new BigInt([0]);

  var sign(get, never) : Int;
  var chunks(get, never) : Int;

  @:from public static function fromInt(v : Int) {
    var arr;
    if(v < 0) {
      arr = [-1];
      v = -v;
    } else if(v > 0) {
      arr = [1];
    } else {
      arr = [0];
    }
    while(v != 0) {
      arr.push(v & CHUNK_MASK);
      v >>>= CHUNK_SIZE;
    }
    return new BigInt(arr);
  }

  @:from public static function fromFloat(v : Float) {
    var arr;
    v = v < 0 ? Math.fceil(v) : Math.ffloor(v);
    if(v < 0) {
      arr = [-1];
      v = -v;
    } else if(v > 0) {
      arr = [1];
    } else {
      arr = [0];
    }
    while(v != 0) {
      arr.push(Std.int(v % CHUNK_MAX_FLOAT));
      v = Math.ffloor(v / CHUNK_MAX_FLOAT);
    }
    return new BigInt(arr);
  }

  // TODO
  @:from public static function fromString(s : String)
    return fromInt(0);

  function new(arr : Array<Int>)
    this = arr;

  public function compare(that : BigInt) : Int
    return 0;

  @:op(A>B) public function greater(that : BigInt) : Bool
    return compare(that) > 0;

  @:op(A>=B) public function greaterEqual(that : BigInt) : Bool
    return compare(that) >= 0;

  @:op(A<B) public function less(that : BigInt) : Bool
    return compare(that) < 0;

  @:op(A<=B) public function lessEqual(that : BigInt) : Bool
    return compare(that) <= 0;

  // TODO
  @:op(-A) public function negate() : BigInt
    return fromInt(0);

  // TODO
  @:op(A/B) public function divide(that : BigInt) : BigInt
    return fromInt(0);

  // TODO
  @:op(A*B) public function multiply(that : BigInt) : BigInt
    return fromInt(0);

  // TODO
  @:op(A+B) public function add(that : BigInt) : BigInt
    return fromInt(0);

  // TODO
  @:op(A-B) public function subtract(that : BigInt) : BigInt
    return fromInt(0);

  // TODO
  @:op(A==B) public function equals(that : BigInt) : Bool {
    if(sign != that.sign || chunks != that.chunks) return false;
    var other = that.toArray();
    for(i in 1...chunks + 1)
      if(this[i] != other[i]) return false;
    return true;
  }

  @:op(A!=B) public function notEquals(that : BigInt) : Bool
    return !equals(that);

  inline function toArray() : Array<Int>
    return this;

  @:to public function toFloat() : Float {
    return reduceRightChunks(function(acc : Float, curr : Int) : Float {
      return acc * CHUNK_MAX_FLOAT + curr;
    }, 0.0) * sign;
  }

  // TODO explode on overflow?
  @:to public function toInt() : Int {
    return reduceRightChunks(function(acc : Int, curr : Int) : Int {
      acc <<= CHUNK_SIZE;
      acc |= curr;
      return acc;
    }, 0) * sign;
  }

  @:to public function toString() {
    return "0";
  }

  inline function reduceChunks<T>(f : T -> Int -> T, acc : T) : T {
    for(i in 0...chunks)
      acc = f(acc, this[i+1]);
    return acc;
  }

  // TODO this can probably be optimized with a Macro inlining the body
  inline function reduceRightChunks<T>(f : T -> Int -> T, acc : T) : T {
    var i = chunks - 1;
    while(i >= 0)
      acc = f(acc, this[(i--)+1]);
    return acc;
  }

  inline function get_sign()
    return this[0];

  inline function get_chunks() : Int
    return this.length - 1;


/*
  var sign(get, never) : Int;
  var chunks(get, never) : Array<Int>;
  var length(get, never) : Int;

  var isNegative(get, never) : Bool;
  var isZero(get, never) : Bool;

  @:from public static function fromInt(value : Int)
    return zero + value;

  inline function new(arr : Array<Int>)
    this = arr;

  @:op(A+B) function addInt(that : Int) : BigInt {

  }

  inline function get_sign()
    return this[0];

  inline function get_chunks()
    return this.slice(1);

  inline function get_length()
    return this.length - 1;

  @:to public function toString() {
    var s = "",
        v = new BigInt(this),
        p;
    //trace(v.toArray());
    while(!v.isZero) {
      //trace(v.toArray());
      p = v.intDivision(10);
      //trace(p.reminder);
      v = p.value;
      s = digits.substring(p.reminder, p.reminder + 1) + s;
    }
    if(s.length == 0)
      s = "0";
    return s;
  }

  function intDivision(that : Int) {
    var arr = this.copy(),
        i = arr.length - 1,
        r = 0, s;
    while(i >= 0) {
      s = r * radix + arr[i];
      arr[i] = Math.floor(s / that);
      r = s % that;
      i--;
    }
    return {
      value : new BigInt(arr),
      reminder : r
    };
  }

  inline function toArray()
    return this;

  inline function self() : BigInt
    return new BigInt(this);

  function get_isNegative()
    return ((this[this.length-1] >> (bpe - 1)) & 1) == 1;

  function get_isZero() {
    for(v in this)
      if(v != 0) return false;
    return true;
  }

  inline static function apply(arr : Array<Int>, len : Int, n : Int) {
    for(i in 0...len) {
      arr[i] = n & mask;
      n >>= bpe;
    }
  }

  static var bpe : Int;
  static var mask : Int;
  static var radix : Int;
  static var digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_=!@#$%^&*()[]{}|;:,.<>/?`~ \\\'\"+-';

  static function __init__() {
    bpe = 0;
    while((1<<(bpe+1)) > (1<<bpe))
      bpe++;
    bpe >>= 1;
    mask = (1 << bpe) - 1;
    radix = mask + 1;

    //trace('bpe: $bpe');
    //trace('mask: $mask');
    //trace('radix: $radix');
  }
*/
}
