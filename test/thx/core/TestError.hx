package thx.core;

import utest.Assert;

class TestError {
  public function new() { }

  public function testAbstract() {
    var error = new thx.core.error.AbstractMethod();

    Assert.notNull(error);
    Assert.stringContains('TestError', error.message);
    Assert.stringContains('testAbstract', error.message);
  }
}
