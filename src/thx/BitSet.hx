package thx;

import haxe.Int32;
using thx.Ints;

/**
  Stores a set of randomly-accessible bit values in a compact data structure.

  All bit values are defaulted to false unless explicitly set to true.

  Attemptiing to access an index which is < 0 or >= the BitSet length will result in
  an exception.
**/
@:forward(setAll, clearAll, raw, toString)
abstract BitSet(BitSetImpl) from BitSetImpl {
/**
  Gives the number of bit values currently held in the BitSet
**/
  public var length(get, never) : Int;

/**
  Creates a new, empty BitSet
**/
  public function new(?length : Int = 0) {
    this = new BitSetImpl(length);
  }

  public function get_length() {
    return this.length;
  }

/**
  Gets a bit value at the given index
**/
  @:arrayAccess
  public function at(index : Int) : Bool {
    return this.at(index);
  }

/**
  Sets a bit value at the given index
**/
  @:arrayAccess
  public function setAt(index : Int, value : Bool) : Bool {
    return this.setAt(index, value);
  }
}

class BitSetImpl {
  static inline var blockSize = 32;
  public var length(get, null) : Int;
  var blocks : Array<Int32>;

  public function new(?length : Int = 0) {
    this.blocks = [];
    this.length = length;
  }

  public function get_length() {
    return length;
  }

  public function at(index : Int) : Bool {
    if (index < 0 || index > length) {
      throw new Error('BitSet index $index is out of bounds');
    }
    var blockIndex = Math.floor(index / blockSize);
    if (blocks[blockIndex] == null) {
      blocks[blockIndex] = 0;
    }
    var block = blocks[blockIndex];
    var bitIndex = index % blockSize;
    return (block & (1 << bitIndex)) != 0;
  }

  public function setAt(index : Int, value : Bool) : Bool {
    if ((index + 1) > length) length = index + 1;
    var blockIndex = Math.floor(index / blockSize);
    if (blocks[blockIndex] == null) {
      blocks[blockIndex] = 0;
    }
    var bitIndex = index % blockSize;
    blocks[blockIndex] |= (1 << bitIndex);
    return (blocks[blockIndex] & (1 << bitIndex)) != 0;
  }

  public function setAll() : BitSet {
    for (i in 0...length) {
      setAt(i, true);
    }
    return this;
  }

  public function clearAll() : BitSet {
    for (i in 0...length) {
      setAt(i, false);
    }
    return this;
  }

  public function raw() : Array<Int32> {
    return blocks;
  }

  public function toString() : String {
    return length.range().map(function(index) {
      return at(index);
    }).join("");
  }
}
