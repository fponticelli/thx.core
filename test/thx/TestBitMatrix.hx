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

  public function testClone() {
    var bits = new BitMatrix(2, 3);
    bits[0][0] = true;
    bits[0][1] = true;
    bits[0][2] = true;
    bits[1][0] = false;
    bits[1][1] = false;
    bits[1][2] = false;
    var clone = bits.clone();
    clone[0][1] = false;
    clone[1][1] = true;
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
}
