/**
 * ...
 * @author Franco Ponticelli
 */

package thx;

import utest.Assert;
import thx.ERegs;

class TestERegs extends utest.Test {
	public function testEscape() {
		Assert.equals("a\\.b", ERegs.escape("a.b"));
		Assert.equals("a\\.b\\.c", ERegs.escape("a.b.c"));
		Assert.equals("\\(\\[\\.\\]\\.\\)", ERegs.escape("([.].)"));
	}
}
