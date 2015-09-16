package thx;

using Thx;
import utest.Assert;

class TestThx {
  public function new() {}

  public function testUsing() {
    Assert.equals("thx using", "ThxUsing".humanize());
  }
}
