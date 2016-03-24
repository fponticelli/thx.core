package thx;

import utest.Assert;
import thx.BitSet;

class TestBitSet {
  public function new() {}

  public function testBitSet() {
    var bits = new BitSet();
    Assert.same(0, bits.length);
    Assert.same([], bits.raw());

    Assert.raises(function() { var bit = bits[0]; });
    Assert.raises(function() { var bit = bits[-1]; });
    Assert.raises(function() { var bit = bits[1]; });
    Assert.raises(function() { var bit = bits[4]; });

    bits[0] = true;
    Assert.same(1, bits.length);
    Assert.same([1], bits.raw());

    bits[1] = true;
    Assert.same(2, bits.length);
    Assert.same([3], bits.raw());

    bits[2] = true;
    Assert.same(3, bits.length);
    Assert.same([7], bits.raw());

    bits[32] = true;
    Assert.same(33, bits.length);
    Assert.same([7, 1], bits.raw());

    for (i in 0...bits.length) {
      if (Arrays.contains([0, 1, 2, 32], i)) {
        Assert.isTrue(bits[i]);
      } else {
        Assert.isFalse(bits[i]);
      }
    }

    Assert.raises(function() { var bit = bits[bits.length + 1]; });
  }

  public function testPresetLength() {
    var bits1 = new BitSet(35);
    Assert.same(35, bits1.length);
    for (i in 0...35) {
      Assert.isFalse(bits1[i]);
    }
    Assert.raises(function( ) { var bit = bits1[35]; });

    var bits2 = new BitSet(35).setAll();
    Assert.same(35, bits2.length);
    for (i in 0...35) {
      Assert.isTrue(bits2[i]);
    }
    Assert.raises(function( ) { var bit = bits2[35]; });
  }
}
