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

  function get_length() {
    return this[0];
  }

/**
  Gets a bit value at the given index.  If the index is outside the BitSet size, an error is thrown.
**/
  @:arrayAccess
  public function at(index : Int) : Bool {
    if (index < 0 || index > length) {
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
}
