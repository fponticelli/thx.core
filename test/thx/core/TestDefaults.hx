/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

import utest.Assert;
using thx.core.Defaults;

class TestDefaults {
  public var withValue = "A";
  public var withoutValue : String;
  public function new() { }

  public function testFeatures() {
    var s : String = null;
    Assert.equals('B', s.or('B'));
    s = 'A';
    Assert.equals('A', s.or('B'));

    var s : String = null;
    Assert.equals('B', Defaults.or(s, 'B'));
    s = 'A';
    Assert.equals('A', Defaults.or(s, 'B'));

    Assert.equals('A', Defaults.or(withValue, 'B'));
    Assert.equals('A', withValue.or('B'));

    Assert.equals('B', Defaults.or(withoutValue, 'B'));
    Assert.equals('B', withoutValue.or('B'));

    var o = { a : "A", b : null };

    Assert.equals('A', Defaults.or(o.a, 'B'));
    Assert.equals('A', o.a.or('B'));

    Assert.equals('B', Defaults.or(o.b, 'B'));
    Assert.equals('B', o.b.or('B'));
  }
}