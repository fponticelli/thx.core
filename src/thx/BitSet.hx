package thx;

import haxe.Int32;
using thx.Ints;

/**
  Stores a set of randomly-accessible bit values in a compact data structure.

  All bit values are defaulted to false unless explicitly set to true.

  Attemptiing to access an index which is < 0 or >= the BitSet length will result in
  an exception.
**/
abstract BitSet(Array<Int32>) from Array<Int32> {
  static inline var blockSize = 32;

/**
  Gives the number of bit values currently held in the BitSet
**/
  public var length(get, never) : Int;

/**
  Creates a new, empty BitSet
**/
  public function new(?length : Int = 0) {
    this = [length]; // store the bitset length at block index 0
  }

/**
  Converts an Array<Bool> to a BitSet
**/
  public static function fromBools(values : Array<Bool>) : BitSet {
    return Arrays.reducei(values, function(acc : BitSet, value, i) {
      acc.setAt(i, value);
      return acc;
    }, new BitSet());
  }

  public static function fromString(str : String) : BitSet {
    var chars = str.split("");
    return Arrays.reducei(chars, function(acc : BitSet, char, i) {
      acc.setAt(i, char == "1");
      return acc;
    }, new BitSet());
  }

  function get_length() {
    return this[0];
  }

/**
  Gets a bit value at the given index.  If the index is outside the BitSet size, an error is thrown.
**/
  @:arrayAccess
  public function at(index : Int) : Bool {
    if (index < 0 || index >= length) {
      throw new Error('BitSet: index $index out of bounds');
    }
    var blockIndex = Math.floor(index / blockSize) + 1;
    var block = this[blockIndex];
    var bitIndex = index % blockSize;
    return (block & (1 << bitIndex)) != 0;
  }

/**
  Sets a bit value at the given index
**/
  @:arrayAccess
  public function setAt(index : Int, value : Bool) : Bool {
    if ((index + 1) > length) this[0] = index + 1;
    var blockIndex = Math.floor(index / blockSize) + 1;
    var bitIndex = index % blockSize;
    if (value) {
      this[blockIndex] |= (1 << bitIndex);
    } else {
      this[blockIndex] &= ~(1 << bitIndex);
    }
    return value;
  }

/**
  Clones this BitSet
**/
  public function clone() : BitSet {
    return Arrays.reduce(length.range(), function(acc : BitSet, i) {
      acc.setAt(i, at(i));
      return acc;
    }, new BitSet());
  }

/**
  Sets all bits in the BitSet to true (does not change length)
**/
  public function setAll() : BitSet {
    for (i in 0...length) {
      setAt(i, true);
    }
    return this;
  }

/**
  Sets all bits in the BitSet to false (does not change length)
**/
  public function clearAll() : BitSet {
    for (i in 0...length) {
      setAt(i, false);
    }
    return this;
  }

/**
  Returns a string representation of the BitSet
**/
  public function toString() : String {
    return length.range().map(function(index) {
      return at(index) ? '1' : '0';
    }).join("");
  }

/**
  ANDs together this BitSet with another BitSet.
  No changes are made to this BitSet.
**/
  #if (haxe_ver >= 3.300) @:op(A & B) #end
  public function and(other : BitSet) : BitSet {
    var l = Ints.max(length, other.length);
    return Arrays.reduce(l.range(), function(acc : BitSet, i) {
      acc.setAt(i, at(i) && other.at(i));
      return acc;
    }, new BitSet());
  }

/**
  ORs together this BitSet with another BitSet.
  No changes are made to this BitSet.
**/
  #if (haxe_ver >= 3.300) @:op(A | B) #end
  public function or(other : BitSet) : BitSet {
    var l = Ints.max(length, other.length);
    return Arrays.reduce(l.range(), function(acc : BitSet, i) {
      acc.setAt(i, at(i) || other.at(i));
      return acc;
    }, new BitSet());
  }

/**
  XORs together this BitSet with another BitSet.
  No changes are made to this BitSet.
**/
  #if (haxe_ver >= 3.300) @:op(A ^ B) #end
  public function xor(other : BitSet) : BitSet {
    var l = Ints.max(length, other.length);
    return Arrays.reduce(l.range(), function(acc : BitSet, i) {
      var left = at(i);
      var right = other.at(i);
      acc.setAt(i, (left && !right) || (!left && right));
      return acc;
    }, new BitSet());
  }

/**
  Returns a new BitSet that is a bitwise negation of this BitSet.
  No changes are made to this BitSet.
**/
  #if (haxe_ver >= 3.200) @:op(~A) #end
  public function negate() : BitSet {
    return Arrays.reduce(length.range(), function(acc : BitSet, i) {
      acc.setAt(i, !at(i));
      return acc;
    }, new BitSet());
  }

  @:op(A == B)
  public function equals(other : BitSet) : Bool {
    if (length != other.length) return false;
    for (i in 0...length) {
      if (at(i) != other.at(i)) return false;
    }
    return true;
  }

  @:op(A != B)
  public function notEquals(other : BitSet) : Bool {
    return !equals(other);
  }
}
