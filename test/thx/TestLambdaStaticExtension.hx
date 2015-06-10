package thx;
import utest.Assert;

using Lambda;
using thx.Functions;

class TestLambdaStaticExtension {
  public function new() { }
/*
  public function testFunctions() {
    Assert.same([2,3], [1,2].map.fn(_+1));
    Assert.same([2,3], [1,2,3].filter.fn(_>1));
    Assert.equals(16, [1,2,3].fold.fn(_1+_2, 10));
  }
*/
  public function testInStringInterpolation() {
//    Assert.same(["1","2"], [1,2].map.fn("" + _));
    Assert.same(["1","2"], [1,2].map.fn('$_'));
//    Assert.same(["X1","X2"], [1,2].map.fn('X$_'));
//    Assert.same(["1X","2X"], [1,2].map.fn('${_}X'));
//    Assert.same(["X2X","X4X"], [1,2].map.fn('X${_*2}X'));
  }
}
