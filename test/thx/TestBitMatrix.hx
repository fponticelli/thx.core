package thx;

import utest.Assert;

class TestBitMatrix {
  public function new() {}

  public function testNew() {
    var bits = new BitMatrix();
    Assert.same(0, bits.bitSetCount);
    Assert.same(0, bits.length);

    bits = new BitMatrix(5, 10);
    Assert.same(5, bits.bitSetCount);
    Assert.same(10, bits.length);
  }

  public function testBitMatrix() {
    var bits = new BitMatrix(3, 3);
    bits.setBitAt(0, 0, true);
    bits.setBitAt(0, 1, true);
    bits.setBitAt(0, 2, true);
    bits.setBitAt(1, 0, false);
    bits.setBitAt(1, 1, false);
    bits.setBitAt(1, 2, false);
    bits.setBitAt(2, 0, true);
    bits.setBitAt(2, 1, false);
    bits.setBitAt(2, 2, true);
    Assert.equals('111,000,101', bits.toString());

    // Can't set bit in non-existent BitSet
    Assert.raises(function() { bits.setBitAt(3, 0, true); });

    // Can set bits beyond length
    bits.setBitAt(0, 3, true);
    Assert.equals('1111,0000,1010', bits.toString());
    Assert.same(4, bits.length);

    bits.setBitAt(1, 4, true);
    Assert.equals('11110,00001,10100', bits.toString());
    Assert.same(5, bits.length);

    bits.setBitAt(2, 5, true);
    Assert.equals('111100,000010,101001', bits.toString());
    Assert.same(6, bits.length);
  }

  public function testClone() {
    var bits = new BitMatrix(2, 3);
    bits.setBitAt(0, 0, true);
    bits.setBitAt(0, 1, true);
    bits.setBitAt(0, 2, true);
    bits.setBitAt(1, 0, false);
    bits.setBitAt(1, 1, false);
    bits.setBitAt(1, 2, false);
    var clone = bits.clone();
    clone.setBitAt(0, 1, false);
    clone.setBitAt(1, 1, true);
    Assert.same('111,000', bits.toString());
    Assert.same('101,010', clone.toString());
  }

  public function testFromToString() {
    var bits = BitMatrix.fromString('000,111,101,010');
    Assert.same('000,111,101,010', bits.toString());
  }

  public function testFromToBools() {
    var bits = BitMatrix.fromBools([[true, true], [false, false], [true, false], [false, true]]);
    Assert.same([[true, true], [false, false], [true, false], [false, true]], bits.toBools());
  }

  public function testConcat() {
    var b1 = BitMatrix.fromString('000,111,101,010');
    var b2 = BitMatrix.fromString('111,000,111,000');
    var b3 = b1.concat(b2);
    Assert.same('000,111,101,010', b1.toString());
    Assert.same('111,000,111,000', b2.toString());
    Assert.same('000111,111000,101111,010000', b3.toString());
    Assert.same(4, b1.bitSetCount);
    Assert.same(4, b2.bitSetCount);
    Assert.same(4, b3.bitSetCount);
    Assert.same(3, b1.length);
    Assert.same(3, b2.length);
    Assert.same(6, b3.length);

    Assert.raises(function(){
      var b1 = BitMatrix.fromString('000,111');
      var b2 = BitMatrix.fromString('000,111,000');
      b1.concat(b2);
    });
  }

  public function testExpand() {
    var b1 = BitMatrix.fromString('000,111,101,010');
    var b2 = b1.expand(1);
    var b3 = b1.expand(3);
    Assert.same('000,111,101,010', b1.toString());
    Assert.same('000000,111111,110011,001100', b2.toString());
    Assert.same('000000000000,111111111111,111100001111,000011110000', b3.toString());
  }

  public function testAnd() {
    var b1 = BitMatrix.fromString('11,00');
    var b2 = BitMatrix.fromString('10,10');
    var actual = b1.and(b2);
    var expected = BitMatrix.fromString('10,00');
    Assert.isTrue(expected.equals(actual));
  }

  public function testOr() {
    var b1 = BitMatrix.fromString('11,00');
    var b2 = BitMatrix.fromString('10,10');
    var actual = b1.or(b2);
    var expected = BitMatrix.fromString('11,10');
    Assert.isTrue(expected.equals(actual));
  }

  public function testXor() {
    var b1 = BitMatrix.fromString('11,00');
    var b2 = BitMatrix.fromString('10,10');
    var actual = b1.xor(b2);
    var expected = BitMatrix.fromString('01,10');
    Assert.isTrue(expected.equals(actual));
  }

  public function testNegate() {
    var b1 = BitMatrix.fromString('11,00');
    var actual = b1.negate();
    var expected = BitMatrix.fromString('00,11');
    Assert.isTrue(expected.equals(actual));
  }
}
