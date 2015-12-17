package thx;

import utest.Assert;
import thx.Nil;
import thx.Enums;
import thx.Tuple;
using thx.Strings;

class TestEnums {
  public function new() { }

  public function testIssue20151201() {
    var o = { oldId: "1", newId: "2" },
        e = Test(o),
        s = Enums.string(e);
    Assert.stringContains('oldId : "1"', s);
    Assert.stringContains('newId : "2"', s);
    Assert.stringContains(', ', s);
    Assert.isTrue(s.startsWith("Test({"));
    Assert.isTrue(s.endsWith("})"));
  }

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

enum Enum20151201 {
  Test(obj : { oldId: String, newId : String });
  None;
}
