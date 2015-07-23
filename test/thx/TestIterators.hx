/**
 * @author Franco Ponticelli
 */

package thx;

import utest.Assert;
using thx.Iterators;
using thx.Functions;

class TestIterators {
  public function new() {}

  public function testEquals() {
    var a = [1,2,3],
        b = [1,2],
        c = [1,2,4];

    Assert.isTrue(a.iterator().equals(a.iterator()));
    Assert.isFalse(a.iterator().equals(b.iterator()));
    Assert.isFalse(a.iterator().equals(c.iterator()));
  }
}
