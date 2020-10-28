package thx;

import utest.Assert;

using thx.Arrays;

class TestNothing extends utest.Test {
	public function testNothing() {
		var a:Array<Nothing> = [];
		Assert.isFalse(a.any(function(n:Nothing) return true));
	}
}
