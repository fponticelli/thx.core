package thx;

import utest.Assert;
import thx.Nil;
import thx.Enums;
import thx.Tuple;

class TestEnums {
  public function new() { }

  public function testCompare() {
    Assert.same(
      [A, B(1), B(2)],
      thx.Arrays.order(
        [B(2), A, B(1)],
        Enums.compare)
    );
  }

  public function testString() {
    Assert.equals("A", Enums.string(A));
    Assert.equals("B(1)", Enums.string(B(1)));
  }
}

private enum Sample {
  A;
  B(v : Int);
}
