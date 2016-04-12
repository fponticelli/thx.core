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
    Assert.same('11,00,10,01', bits.toString());
  }

  public function testAnd() {
    var b1 = BitMatrix.fromString('11,00');
    var b2 = BitMatrix.fromString('10,10');
    var actual = b1 & b2;
    var expected = BitMatrix.fromString('10,00');
    Assert.isTrue(expected.equals(actual));
  }

  public function testOr() {
    var b1 = BitMatrix.fromString('11,00');
    var b2 = BitMatrix.fromString('10,10');
    var actual = b1 | b2;
    var expected = BitMatrix.fromString('11,10');
    Assert.isTrue(expected.equals(actual));
  }

  public function testXor() {
    var b1 = BitMatrix.fromString('11,00');
    var b2 = BitMatrix.fromString('10,10');
    var actual = b1 ^ b2;
    var expected = BitMatrix.fromString('01,10');
    Assert.isTrue(expected.equals(actual));
  }

  public function testNegate() {
    var b1 = BitMatrix.fromString('11,00');
    var actual = ~b1;
    var expected = BitMatrix.fromString('00,11');
    Assert.isTrue(expected.equals(actual));
  }
}
