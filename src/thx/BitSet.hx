package thx;

import haxe.Int32;
import thx.Arrays;
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
  Creates a new, empty BitSet, with the given `length`
**/
  public inline function new(length : Int) {
    this = [length]; // store the BitSet length at block index 0
#if !js // resizing is not needed in JS but might still be a good idea
    var size = Std.int(length / blockSize) + 1;
    Arrays.resize(this, size + 1, 0);
#end
  }

/**
  Creates a new, empty BitSet, with the given length
**/
  public static inline function empty(?length : Int = 0) : BitSet {
    return new BitSet(length);
  }

/**
  Converts an Array<Bool> to a BitSet
**/
  @:from
  public static inline function fromBools(values : Array<Bool>) : BitSet {
    return Arrays.reducei(values, function(acc : BitSet, value, i) {
      acc.setAt(i, value);
      return acc;
    }, new BitSet(0));
  }

/**
  Converts a string of 0s and 1s (e.g. "10101") to a BitSet
**/
  @:from
  public static inline function fromString(str : String) : BitSet {
    var chars = str.split("");
    return Arrays.reducei(chars, function(acc : BitSet, char, i) {
      acc.setAt(i, char == "1");
      return acc;
    }, new BitSet(0));
  }

/**
  Converts a BitSet into an Array<Bool>
**/
  @:to
  public inline function toBools() : Array<Bool> {
    return length.range().map(function(index) {
      return at(index);
    });
  }

  @:to
  public inline function toInt32s() : Array<Int32> {
    var parts = this.slice(1);
    // while(parts[parts.length-1] == 0)
    //   parts.pop();
    return parts;
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
    var blockIndex = Math.floor(index / blockSize) + 1;
    if (blockIndex >= this.length) {
      Arrays.resize(this, blockIndex + 1, 0);
    };
    if(this[0] <= index)
      this[0] = index + 1;
    var bitIndex : Int32 = index % blockSize;
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
  public inline function clone() : BitSet {
    return Arrays.reduce(length.range(), function(acc : BitSet, i) {
      acc.setAt(i, at(i));
      return acc;
    }, new BitSet(0));
  }

/**
  Sets all bits in the BitSet to true (does not change length)
**/
  public inline function setAll(?value : Bool = true) : BitSet {
    for (i in 0...length) {
      setAt(i, value);
    }
    return this;
  }

/**
  Sets all bits in the BitSet to false (does not change length)
**/
  public inline function clearAll() : BitSet {
    return setAll(false);
  }

/**
  Concatenates this BitSet with another BitSet
**/
  public inline function concat(right : BitSet) : BitSet {
    var left : BitSet = this;
    var result = BitSet.empty(left.length + right.length);
    var index = 0;
    for (leftIndex in 0...left.length) {
      result.setAt(index++, left.at(leftIndex));
    }
    for (rightIndex in 0...right.length) {
      result.setAt(index++, right.at(rightIndex));
    }
    return result;
  }

/**
  Expands the BitSet by internally copying each bit `count` times.  E.g. `('101' : BitSet).expand(3) => '111100001111'`
**/
  public function expand(count : Int) : BitSet {
    return fromBools(thx.Arrays.flatMap(length.range(), function(index) {
      return thx.Arrays.create(count + 1, at(index));
    }));
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
  public function and(right : BitSet) : BitSet {
    return combine(right, function(l, r) return l && r);
  }

/**
  ORs together this BitSet with another BitSet.
  No changes are made to this BitSet.
**/
  #if (haxe_ver >= 3.300) @:op(A | B) #end
  public function or(right : BitSet) : BitSet {
    return combine(right, function(l, r) return l || r);
  }

/**
  XORs together this BitSet with another BitSet.
  No changes are made to this BitSet.
**/
  #if (haxe_ver >= 3.300) @:op(A ^ B) #end
  public function xor(right : BitSet) : BitSet {
    return combine(right, function(l, r) return (l && !r) || (!l && r));
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
    }, new BitSet(0));
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

  function combine(right : BitSet, combiner : Bool -> Bool -> Bool) : BitSet {
    var left : BitSet = this;
    var length = Ints.max(left.length, right.length);
    return Arrays.reduce(length.range(), function(acc : BitSet, i) {
      var leftBit = left.at(i);
      var rightBit = right.at(i);
      acc.setAt(i, combiner(leftBit, rightBit));
      return acc;
    }, new BitSet(0));
  }

  function get_length() {
    return this[0];
  }
}
