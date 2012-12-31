/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

import utest.Assert;

class TestFloats 
{
	public function new() { }
	
	public function testNormalize()
	{
		Assert.floatEquals(0.0, Floats.normalize( 0.0));
		Assert.floatEquals(1.0, Floats.normalize( 1.0));
		Assert.floatEquals(0.5, Floats.normalize( 0.5));
		Assert.floatEquals(0.0, Floats.normalize(-1.0));
		Assert.floatEquals(1.0, Floats.normalize(10.0));
	}

	public function testClamp()
	{
		Assert.floatEquals(10, Floats.clamp(0, 10, 100));
		Assert.floatEquals(10, Floats.clamp(10, 10, 100));
		Assert.floatEquals(50, Floats.clamp(50, 10, 100));
		Assert.floatEquals(100, Floats.clamp(100, 10, 100));
		Assert.floatEquals(100, Floats.clamp(110, 10, 100));
	}

	public function testClampSym()
	{
		Assert.floatEquals( -10, Floats.clampSym( -100, 10));
		Assert.floatEquals( 10, Floats.clampSym( 100, 10));
		Assert.floatEquals( 0, Floats.clampSym( 0, 10));
	}
}