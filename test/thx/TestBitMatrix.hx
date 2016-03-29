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
    bits[0][0] = true;
    bits[0][1] = true;
    bits[0][2] = true;
    bits[1][0] = false;
    bits[1][1] = false;
    bits[1][2] = false;
    bits[2][0] = true;
    bits[2][1] = false;
    bits[2][2] = true;
    Assert.equals('111', bits[0].toString());
    Assert.equals('000', bits[1].toString());
    Assert.equals('101', bits[2].toString());
  }
}
