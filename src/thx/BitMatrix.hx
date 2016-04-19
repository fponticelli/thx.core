package thx;

import thx.BitSet;
import thx.Error;
using thx.Arrays;
using thx.Functions;
using thx.Ints;

abstract BitMatrix(Array<BitSet>) from Array<BitSet> {
  public var bitSetCount(get, never) : Int;
  public var length(get, never) : Int;

  public function new(?bitSetCount : Int = 0, ?length : Int = 0) {
    return empty(bitSetCount, length);
  }

  public static function empty(?bitSetCount : Int = 0, ?length : Int = 0) : BitMatrix {
    var bitMatrix : BitMatrix = [];
    for (bitSetIndex in 0...bitSetCount) {
      bitMatrix.setBitSetAt(bitSetIndex, new BitSet(length));
    }
    return bitMatrix;
  }

  public static function fromBitSets(bitSets : Array<BitSet>) {
    var bitMatrix = new BitMatrix();
    for (bitSetIndex in 0...bitSets.length) {
      bitMatrix.setBitSetAt(bitSetIndex, bitSets[bitSetIndex]);
    }
    return bitMatrix;
  }

  @:from
  public static function fromBools(input : Array<Array<Bool>>) : BitMatrix {
    var bitSets = input.map.fn(BitSet.fromBools(_));
    return fromBitSets(bitSets);
  }

  public static function fromString(input : String, ?delimiter : String = ",") : BitMatrix {
    var bitSetStrings = input.split(delimiter);
    var bitSets = bitSetStrings.map(BitSet.fromString);
    return fromBitSets(bitSets);
  }

  @:to
  public function toBools() : Array<Array<Bool>> {
    return this.map(function(bitSet) {
      return bitSet.toBools();
    });
  }

  public function bitAt(bitSetIndex : Int, bitIndex : Int) : Bool {
    var bitSet = bitSetAt(bitSetIndex);
    return bitSet[bitIndex];
  }

  public function setBitAt(bitSetIndex : Int, bitIndex : Int, value : Bool) : Bool {
    if (bitIndex >= length) {
      for (bitSet in this) {
        bitSet.setAt(bitIndex, false);
      }
    }
    var bitSet = bitSetAt(bitSetIndex);
    return bitSet[bitIndex] = value;
  }

  public function clone() : BitMatrix {
    return Arrays.reduce(bitSetCount.range(), function(acc : BitMatrix, i) {
      acc.setBitSetAt(i, bitSetAt(i).clone());
      return acc;
    }, new BitMatrix());
  }

  public function concat(right : BitMatrix) : BitMatrix {
    var left : BitMatrix = this;
    if (left.bitSetCount != right.bitSetCount) {
      throw new Error('cannot concat bit matrices with different bit set counts');
    }
    var bitSets = left.bitSetCount.range().reduce(function(bitSets : Array<BitSet>, bitSetIndex) {
      bitSets[bitSetIndex] = left.bitSetAt(bitSetIndex).concat(right.bitSetAt(bitSetIndex));
      return bitSets;
    }, []);
    return fromBitSets(bitSets);
  }

  public function expand(count : Int) : BitMatrix {
    return fromBitSets(this.map(function(bitSet) {
      return bitSet.expand(count);
    }));
  }

  public function toString(?delimiter : String = ",") : String {
    return this.map.fn(_.toString()).join(delimiter);
  }

/**
  ANDs together this BitMatrix with another BitMatrix.
  No changes are made to this BitMatrix.
**/
  #if (haxe_ver >= 3.300) @:op(A & B) #end
  public function and(right : BitMatrix) : BitMatrix {
    return combine(right, function(l, r) return l && r);
  }

/**
  ORs together this BitMatrix with another BitMatrix.
  No changes are made to this BitMatrix.
**/
  #if (haxe_ver >= 3.300) @:op(A | B) #end
  public function or(right : BitMatrix) : BitMatrix {
    return combine(right, function(l, r) return l || r);
  }

/**
  XORs together this BitMatrix with another BitMatrix.
  No changes are made to this BitMatrix.
**/
  #if (haxe_ver >= 3.300) @:op(A ^ B) #end
  public function xor(right : BitMatrix) : BitMatrix {
    return combine(right, function(l, r) return (l && !r) || (!l && r));
  }

/**
  Returns a new BitMatrix that is the negation of this BitMatrix.
  No changes are made to this BitMatrix.
**/
  #if (haxe_ver >= 3.300) @:op(~A) #end
  public function negate() : BitMatrix {
    var bits : BitMatrix = this;
    return Arrays.reduce(bitSetCount.range(), function(acc : BitMatrix, bitSetIndex) {
      return Arrays.reduce(length.range(), function(acc : BitMatrix, bitIndex) {
        acc.setBitAt(bitSetIndex, bitIndex, !bits.bitAt(bitSetIndex, bitIndex));
        return acc;
      }, acc);
    }, new BitMatrix(bitSetCount, length));
  }

  @:op(A == B)
  public function equals(right : BitMatrix) : Bool {
    var left : BitMatrix = this;
    if (left.bitSetCount != right.bitSetCount) return false;
    if (left.length != right.length) return false;
    for (i in 0...bitSetCount) {
      if (!left.bitSetAt(i).equals(right.bitSetAt(i))) return false;
    }
    return true;
  }

  @:op(A != B)
  public function notEquals(right : BitMatrix) : Bool {
    var left : BitMatrix = this;
    return !left.equals(right);
  }

  function get_bitSetCount() : Int {
    return this.length;
  }

  function get_length() : Int {
    if (bitSetCount == 0) return 0;
    return this[0].length;
  }

  function bitSetAt(index : Int) : BitSet {
    if (index < 0 || index >= bitSetCount) {
      throw new Error('BitMatrix: index $index is out of bounds');
    }
    return this[index];
  }

  function setBitSetAt(index : Int, bitSet : BitSet) : BitSet {
    if (bitSetCount > 0 && (length != bitSet.length)) {
      throw new Error('BitMatrix: added BitSet must have same length as BitMatrix length $length');
    }
    return this[index] = bitSet;
  }

  function combine(right : BitMatrix, combiner : Bool -> Bool -> Bool) : BitMatrix {
    var left : BitMatrix = this;
    if (left.bitSetCount != right.bitSetCount) throw new Error('cannot "and" BitMatrices of different BitSet counts');
    if (left.length != right.length) throw new Error('cannot "and" BitMatrices of different lengths');
    return Arrays.reduce(bitSetCount.range(), function(acc : BitMatrix, bitSetIndex) {
      return Arrays.reduce(length.range(), function(acc : BitMatrix, bitIndex) {
        acc.setBitAt(bitSetIndex, bitIndex, combiner(left.bitAt(bitSetIndex, bitIndex), right.bitAt(bitSetIndex, bitIndex)));
        return acc;
      }, acc);
    }, new BitMatrix(left.bitSetCount, left.length));
  }
}
