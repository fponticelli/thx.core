package thx;
import utest.Assert;
import thx.macro.lambda.Functions.*;

class TestLambda {
  public function new() { }

  public function testFunctions() {
    Assert.same([2,3], [1,2].map(fn(_+1)));
    Assert.equals(0, fn0((0))());
    Assert.equals(2, fn1((_1))(2));
    Assert.equals(3, fn2(_1+_2)(1,2));
    Assert.equals(6, fn3(_1+_2+_3)(1,2,3));
    Assert.equals(10, fn4(_1+_2+_3+_4)(1,2,3,4));
    Assert.equals(15, fn5(_1+_2+_3+_4+_5)(1,2,3,4,5));
    Assert.equals(6, fn5(_1+_2+_3)(1,2,3,4,5));
  }



}
