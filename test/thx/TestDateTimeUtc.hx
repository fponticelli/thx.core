package thx;

import haxe.PosInfos;
import utest.Assert;
using thx.DateTimeUtc;
import thx.Month;
import thx.Weekday;

class TestDateTimeUtc {
  var date = DateTimeUtc.create(2015, 7, 26, 21, 40, 30, 0);
  var tomorrow = DateTimeUtc.create(2015, 7, 27, 21, 40, 30, 0);
  // var future = DateTimeUtc.create(9999, 7, 26, 21, 40, 30, 0);
  // var past = DateTimeUtc.create(1, 7, 26, 21, 40, 30, 0);
  //var farFuture = DateTimeUtc.create(20600, 7, 26, 21, 40, 30, 0);
  //var longPast = DateTimeUtc.create(-10000, 7, 26, 21, 40, 30, 0);

  public function new() {}

  public function testCreate() {
    Assert.equals(2015, date.year, 'expected 2015 but got ${date.year} for year');
    Assert.equals(7, date.month, 'expected 7 but got ${date.month} for month');
    Assert.equals(26, date.day, 'expected 26 but got ${date.day} for day');

    Assert.equals(21, date.hour, 'expected 21 but got ${date.hour} for hour');
    Assert.equals(40, date.minute, 'expected 40 but got ${date.minute} for minute');
    Assert.equals(30, date.second, 'expected 30 but got ${date.second} for second');

    Assert.equals(Sunday, date.dayOfWeek);
  }

  public function testToString() {
    Assert.equals('2015-07-26 21:40:30.0', date.toString());
    // Assert.equals('2015-07-26 21:40:30.0', future.toString());
    // Assert.equals('2015-07-26 21:40:30.0', past.toString());
    //Assert.equals('2015-07-26 21:40:30.0', farFuture.toString());
    //Assert.equals('2015-07-26 21:40:30.0', longPast.toString());
  }

  public function testEquals() {
    Assert.isTrue(date == date);
    Assert.isTrue(date != tomorrow);
  }

  public function testCompare() {
    Assert.isFalse(date > date);
    Assert.isTrue(date >= date);
    Assert.isFalse(date < date);
    Assert.isTrue(date <= date);

    Assert.isFalse(date > tomorrow);
    Assert.isFalse(date >= tomorrow);
    Assert.isTrue(date < tomorrow);
    Assert.isTrue(date <= tomorrow);

    Assert.isTrue(tomorrow > date);
    Assert.isTrue(tomorrow >= date);
    Assert.isFalse(tomorrow < date);
    Assert.isFalse(tomorrow <= date);
  }
}
