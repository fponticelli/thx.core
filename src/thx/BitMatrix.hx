package thx;

import thx.BitSet;
import thx.Error;
using thx.Arrays;
using thx.Functions;
using thx.Ints;

abstract BitMatrix(Array<BitSet>) {
  public var bitSetCount(get, never) : Int;
  public var length(get, never) : Int;

  public function new(?bitSetCount : Int = 0, ?length = 0) {
    this = [];
    for (i in 0...bitSetCount) {
      setBitSetAt(i, new BitSet(length));
    }
  }

  public static function fromBitSets(bitSets : Array<BitSet>) {
    var bitMatrix = new BitMatrix();
    for (i in 0...bitSets.length) {
      bitMatrix.setBitSetAt(i, bitSets[i]);
    }
    return bitMatrix;
  }

  public static function fromBools(input : Array<Array<Bool>>) : BitMatrix {
    var bitSets = input.map.fn(BitSet.fromBools(_));
    return fromBitSets(bitSets);
  }

  public static function fromString(input : String, ?delimiter : String = ",") : BitMatrix {
    var bitSetStrings = input.split(delimiter);
    var bitSets = bitSetStrings.map(BitSet.fromString);
    return fromBitSets(bitSets);
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

  public function clone() : BitMatrix {
    return Arrays.reduce(bitSetCount.range(), function(acc : BitMatrix, i) {
      acc.setBitSetAt(i, bitSetAt(i).clone());
      return acc;
    }, new BitMatrix());
  }

  public function toString(?delimiter : String = ",") : String {
    return this.map.fn(_.toString()).join(delimiter);
  }

  public function equals(other : BitMatrix) : Bool {
    if (bitSetCount != other.bitSetCount) return false;
    for (i in 0...bitSetCount) {
      if (!bitSetAt(i).equals(other.bitSetAt(i))) return false;
    }
    return true;
  }
}
