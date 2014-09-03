/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

import utest.Assert;
using thx.core.Arrays;

class TestArrays {
  public function new() { }

  public function testMapField() {
    var arr  = [{a:1},{a:2},{a:3}],
        test = Arrays.mapField(arr, a);
    Assert.same([1,2,3], test);
  }

  public function testMapFieldOnFunction() {
    var test = Arrays.mapField([
          new Sample(2),
          new Sample(3),
          new Sample(4)
        ], multiply(2));
    Assert.same([4,6,8], test);
  }

  public function testUsingMapField() {
    var arr  = [{a:1},{a:2},{a:3}],
        test = arr.mapField(a);
    Assert.same([1,2,3], test);
  }

  public function testUsingMapFieldiOnFunction() {
    Assert.same(
        [0,3,8],
        [
          new Sample(2),
          new Sample(3),
          new Sample(4)
        ].mapFieldi(multiply(i))
      );
  }
}

private class Sample {
  var v : Int;
  public function new(v : Int)
    this.v = v;
  public function multiply(by : Int)
    return v * by;
}