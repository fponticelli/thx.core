package thx;

import haxe.PosInfos;
import utest.Assert;
using thx.DateTimeUtc;
import thx.Month;
import thx.Weekday;

class TestDateTimeUtc {
  var date = DateTimeUtc.create(2015, 7, 26, 21, 40, 30, 0);
  var tomorrow = DateTimeUtc.create(2015, 7, 27, 21, 40, 30, 0);

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
    Assert.equals('2015-07-26T21:40:30Z', date.toString());
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

  public function testFromToDate() {
    var d : Date = date;
    Assert.isTrue(date == d, 'expected $date but got ${(d : DateTimeUtc)}');
  }

  public function testFromToTime() {
    var d : Float = date,
        date2 : DateTimeUtc = d;
    Assert.isTrue(date == date2, 'expected $date but got $date2');
  }

  public function testFromToString() {
    var d : String = date;
    Assert.isTrue(date == d);
  }

  public function testAdd() {
    var d = date
              .addYears(2)
              .addMonths(9)
              .addDays(10)
              .addHours(7)
              .addMinutes(10)
              .addSeconds(7)
              .addMilliseconds(7),
        e = "2018-05-07 04:50:37.007";
    Assert.isTrue(d == "2018-05-07 04:50:37.007", 'expected $e but got $d');
  }

  public function testNow() {
    var ref = DateHelper.nowUtc(),
        date = DateTimeUtc.now();
    Assert.isTrue(date.nearEquals(ref, Time.fromMinutes(1)), 'expected $ref but got $date');
  }
}
