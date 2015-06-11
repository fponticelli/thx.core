package thx;
import utest.Assert;

using thx.Arrays;
using thx.Functions;

class TestLambdaStaticExtension {
  public function new() { }

  public function testFunctions() {
    Assert.same([2,3], [1,2].map.fn(_+1));
    Assert.same([2,3], [1,2,3].filter.fn(_>1));
    Assert.equals(16, [1,2,3].reduce.fn(_0 + _1, 10));
    Assert.same(["Test 1"], [1].map.fn('Test $_'));
  }

  public function testInStringInterpolation() {
    Assert.same(["1","2"], [1,2].map.fn("" + _));
    Assert.same(["1","2"], [1,2].map.fn('$_'));
    Assert.same(["X1","X2"], [1,2].map.fn('X$_'));
    Assert.same(["1X","2X"], [1,2].map.fn('${_}X'));
    Assert.same(["X2X","X4X"], [1,2].map.fn('X${_*2}X'));
  }

  public function testFillEmpty() {
    Assert.same([0,1,2], [1,2,3].mapi.fn(_1));
  }

  public function testOptionalArgs() {
    function f(callback : Int -> ?Int -> Int) : Int {
      return callback(2, 3);
    }

    Assert.equals(6, f.fn([_0, _1] => _0 * 3));
    Assert.equals(6, f.fn(_0 * _1));
  }
}
