package thx;

/**
Represents one Utf8 character stored as an integer value.
*/
abstract Char(Int)  {
/**
Retrieve a `Char` at the specified position `index` in string `s`.
*/
  public static function at(s : String, index : Int) : Char
    return s.charCodeAt(index);
    // return new UnicodeString(s).charCodeAt(index);

/**
Converts an `Int` value to `Char`.
*/
  @:from inline public static function fromInt(i : Int) : Char {
    Assert.isTrue(i >= 0, 'Char value should be greater than zero: $i');
    return new Char(i);
  }

/**
Converts a `String` into a `Char.` Only the first character in the string
is used in the conversion.
*/
  @:from inline public static function fromString(s : String) : Char
    return s.charCodeAt(0);
    // return new UnicodeString(s).charCodeAt(0);

  inline public static function compare(a : Char, b : Char)
    return a.compareTo(b);

  inline function new(i : Int)
    this = i;

/**
Compares two chars returning -1, 0 or 1.
*/
  inline public function compareTo(other : Char) : Int {
    return Ints.compare(this, other.toInt());
  }

/**
Returns true if a string is all breaking whitespace.
**/
  public function isBreakingWhitespace() : Bool
    return this == ' '.code || this == '\t'.code || this == '\n'.code || this == '\r'.code;

/**
Returns true if the character is a control character.
*/
  public function isControl() : Bool
    return (this >= 0x0000 && this <= 0x001F) || this == 0x007F || (this >= 0x0080 && this <= 0x009F);

/**
Checks if character is a valid unicode character.
**/
  public function isUnicode() : Bool
    return this <= 0xFFFD;

/**
Returns the next character incrementing its code by one.
*/
  public function next() : Char
    return this + 1;

/**
Returns the previous character decrementing its code by one.
*/
  public function prev() : Char
    return this - 1;

/**
Returns the upper case version if any of the character.
*/
  public function toUpperCase() : Char
    return toString().toUpperCase();

/**
Returns the lower case version if any of the character.
*/
  public function toLowerCase() : Char
    return toString().toLowerCase();

/**
Equality method.
*/
  inline public function equalsTo(other : Char)
    return compareTo(other) == 0;

  @:op(A==B)
  inline static public function equals(self : Char, other : Char)
    return self.compareTo(other) == 0;

  inline public function greaterThan(other : Char)
    return compareTo(other) > 0;

  @:op(A>B)
  inline static public function greater(self : Char, other : Char)
    return self.compareTo(other) > 0;

  inline public function greaterEqualsThan(other : Char)
    return compareTo(other) >= 0;

  @:op(A>=B)
  inline static public function greaterEquals(self : Char, other : Char)
    return self.compareTo(other) >= 0;

  inline public function lessEqualsTo(other : Char)
    return compareTo(other) <= 0;

  @:op(A<=B)
  inline static public function lessEquals(self : Char, other : Char)
    return self.compareTo(other) <= 0;

  inline public function lessThan(other : Char)
    return compareTo(other) < 0;

  @:op(A<B)
  inline static public function less(self : Char, other : Char)
    return self.compareTo(other) < 0;

/**
Returns the character `Int` code that is also the internal
representation of this type.
*/
  @:to inline public function toInt() : Int
    return this;

/**
Converts a `Char` to `String`.
*/
  @:to #if !(neko || php || cpp || eval) inline #end public function toString() : String {
    // #if (neko || php || cpp || eval)
    // var c = new UnicodeString();
    // c.addChar(this);
    // return c.toString();
    // #else
    return String.fromCharCode(this);
    // #end
  }

/**
Converts an array of `Char`s to `String`.
*/
  public static function arrayToString(arr : Array<Char>) : String
    return arr.map(function(c : Char) : String return c.toString()).join("");
}
