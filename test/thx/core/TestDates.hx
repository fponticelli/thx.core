package thx.core;

import haxe.PosInfos;
import utest.Assert;
using thx.core.Dates;

class TestDates {
  public function new() {}

  public function testSnapTo() {
    assertSnap("2014-01-01 10:06:00", "2014-01-01 10:06:10", Minute);
    assertSnap("2014-01-01 10:06:00", "2014-01-01 10:05:50", Minute);
    assertSnap("2014-01-01 10:00:00", "2014-01-01 10:10:10", Hour);
    assertSnap("2014-01-01 10:00:00", "2014-01-01 09:50:10", Hour);
    assertSnap("2014-01-01 00:00:00", "2014-01-01 10:00:00", Day);
    assertSnap("2014-01-01 00:00:00", "2013-12-31 20:00:00", Day);
    assertSnap("2014-12-14 00:00:00", "2014-12-17 11:00:00", Week);
    assertSnap("2014-12-21 00:00:00", "2014-12-18 00:00:00", Week);
    assertSnap("2014-12-01 00:00:00", "2014-12-12 00:00:00", Month);
    assertSnap("2015-01-01 00:00:00", "2014-12-18 00:00:00", Month);
    assertSnap("2014-01-01 00:00:00", "2014-05-12 00:00:00", Year);
    assertSnap("2015-01-01 00:00:00", "2014-12-18 00:00:00", Year);
  }

  function assertSnap(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = Dates.snapTo(Date.fromString(date), period);
    Assert.floatEquals(
      Date.fromString(expected).getTime(),
      t.getTime(),
      'expected $date to snap to $expected for $period but it is ${t.toString()}',
      pos
    );
  }
}