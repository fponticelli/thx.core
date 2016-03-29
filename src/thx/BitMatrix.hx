package thx;

import thx.BitSet;
import thx.Error;

abstract BitMatrix(Array<BitSet>) {
  public var bitSetCount(get, never) : Int;
  public var length(get, never) : Int;

  public function new(?bitSetCount : Int = 0, ?length = 0) {
    this = [];
    for (i in 0...bitSetCount) {
      setBitSetAt(i, new BitSet(length));
    }
  }

  function get_bitSetCount() : Int {
    return this.length;
  }

  function get_length() : Int {
    if (bitSetCount == 0) return 0;
    return this[0].length;
  }

  @:arrayAccess
  public function bitSetAt(index : Int) : BitSet {
    if (index < 0 || index >= bitSetCount) {
      throw new Error('BitMatrix: index $index is out of bounds');
    }
    return this[index];
  }

  @:arrayAccess
  public function setBitSetAt(index : Int, bitSet : BitSet) : BitSet {
    if (bitSetCount > 0 && (length != bitSet.length)) {
      throw new Error('BitMatrix: added BitSet must have same length as BitMatrix length $length');
    }
    return this[index] = bitSet;
  }

  public function bitAt(bitSetIndex : Int, bitIndex : Int) : Bool {
    var bitSet = bitSetAt(bitSetIndex);
    return bitSet[bitIndex];
  }

  public function setBitAt(bitSetIndex : Int, bitIndex : Int, value : Bool) : Bool {
    var bitSet = bitSetAt(bitSetIndex);
    return bitSet[bitIndex] = value;
  }
}
