package thx.core;

import haxe.PosInfos;
import utest.Assert;
using thx.core.Dates;

class TestDates {
  public function new() {}

  public function testSnapNext() {
    assertSnapNext("2014-01-01 10:07:00", "2014-01-01 10:06:10", Minute);
    assertSnapNext("2014-01-01 10:06:00", "2014-01-01 10:05:50", Minute);
    assertSnapNext("2014-01-01 11:00:00", "2014-01-01 10:10:10", Hour);
    assertSnapNext("2014-01-01 10:00:00", "2014-01-01 09:50:10", Hour);
    assertSnapNext("2014-01-02 00:00:00", "2014-01-01 10:00:00", Day);
    assertSnapNext("2014-01-01 00:00:00", "2013-12-31 20:00:00", Day);
    assertSnapNext("2014-12-21 00:00:00", "2014-12-17 11:00:00", Week);
    assertSnapNext("2014-12-21 00:00:00", "2014-12-18 00:00:00", Week);
    assertSnapNext("2015-01-01 00:00:00", "2014-12-12 00:00:00", Month);
    assertSnapNext("2015-01-01 00:00:00", "2014-12-18 00:00:00", Month);
    assertSnapNext("2015-01-01 00:00:00", "2014-05-12 00:00:00", Year);
    assertSnapNext("2015-01-01 00:00:00", "2014-12-18 00:00:00", Year);
  }

  public function testSnapPrev() {
    assertSnapPrev("2014-01-01 10:06:00", "2014-01-01 10:06:10", Minute);
    assertSnapPrev("2014-01-01 10:05:00", "2014-01-01 10:05:50", Minute);
    assertSnapPrev("2014-01-01 10:00:00", "2014-01-01 10:10:10", Hour);
    assertSnapPrev("2014-01-01 09:00:00", "2014-01-01 09:50:10", Hour);
    assertSnapPrev("2014-01-01 00:00:00", "2014-01-01 10:00:00", Day);
    assertSnapPrev("2013-12-31 00:00:00", "2013-12-31 20:00:00", Day);
    assertSnapPrev("2014-12-14 00:00:00", "2014-12-17 11:00:00", Week);
    assertSnapPrev("2014-12-14 00:00:00", "2014-12-18 00:00:00", Week);
    assertSnapPrev("2014-12-01 00:00:00", "2014-12-12 00:00:00", Month);
    assertSnapPrev("2014-12-01 00:00:00", "2014-12-18 00:00:00", Month);
    assertSnapPrev("2014-01-01 00:00:00", "2014-05-12 00:00:00", Year);
    assertSnapPrev("2014-01-01 00:00:00", "2014-12-18 00:00:00", Year);
  }

  public function testSnapTo() {
    assertSnapTo("2014-01-01 10:06:00", "2014-01-01 10:06:10", Minute);
    assertSnapTo("2014-01-01 10:06:00", "2014-01-01 10:05:50", Minute);
    assertSnapTo("2014-01-01 10:00:00", "2014-01-01 10:10:10", Hour);
    assertSnapTo("2014-01-01 10:00:00", "2014-01-01 09:50:10", Hour);
    assertSnapTo("2014-01-01 00:00:00", "2014-01-01 10:00:00", Day);
    assertSnapTo("2014-01-01 00:00:00", "2013-12-31 20:00:00", Day);
    assertSnapTo("2014-12-14 00:00:00", "2014-12-17 11:00:00", Week);
    assertSnapTo("2014-12-21 00:00:00", "2014-12-18 00:00:00", Week);
    assertSnapTo("2014-12-01 00:00:00", "2014-12-12 00:00:00", Month);
    assertSnapTo("2015-01-01 00:00:00", "2014-12-18 00:00:00", Month);
    assertSnapTo("2014-01-01 00:00:00", "2014-05-12 00:00:00", Year);
    assertSnapTo("2015-01-01 00:00:00", "2014-12-18 00:00:00", Year);
  }

  function assertSnapTo(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = Dates.snapTo(Date.fromString(date), period);
    Assert.floatEquals(
      Date.fromString(expected).getTime(),
      t.getTime(),
      'expected $date to snap to $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapPrev(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = Dates.snapPrev(Date.fromString(date), period);
    Assert.floatEquals(
      Date.fromString(expected).getTime(),
      t.getTime(),
      'expected $date to snap before $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapNext(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = Dates.snapNext(Date.fromString(date), period);
    Assert.floatEquals(
      Date.fromString(expected).getTime(),
      t.getTime(),
      'expected $date to snap after $expected for $period but it is ${t.toString()}',
      pos
    );
  }
}