/**
 * ...
 * @author Franco Ponticelli
 */

package thx;

import utest.Assert;
using thx.Ints;

class TestInts {
  public function new() { }

  public function testRange() {
    var range = Ints.range(2, 7, 1);
    Assert.same([2,3,4,5,6], range);
    range = Ints.range(2, 7, 2);
    Assert.same([2,4,6], range);
    range = Ints.range(2, 7, 3);
    Assert.same([2,5], range);

    range = Ints.range(7, 2, -2);
    Assert.same([7,5,3], range);
  }

  public function testParse() {
    Assert.equals(-50, "-50".parse());
  }
}