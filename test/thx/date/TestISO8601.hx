/**
 * ...
 * @author Franco Ponticelli
 */

package thx.date;

import utest.Assert;
import thx.core.ERegs;

class TestISO8601
{
  public function new() { }

  public function testFull()
  {
    Assert.equals(
      Date.fromString("2013-10-11 13:18:13").getTime(),
      ISO8601.parseDateTime("20131011T131813.000-0600").getTime()
    );
  }
}