package thx;
import utest.Assert;

using Lambda;
using thx.Functions;

class TestLambdaStaticExtension {
  public function new() { }

  public function testFunctions() {
    Assert.same([2,3], [1,2].map.fn(_+1));
    Assert.same([2,3], [1,2,3].filter.fn(_>1));
    Assert.equals(16, [1,2,3].fold.fn(_1+_2, 10));
    Assert.same(["Test 1"], [1].map.fn('Test $_'));
  }
}
