package thx;

import utest.Assert;
import thx.DateTime;
import thx.Weekday;

class TestDateTime {
  var offset : Time;
  var date : DateTime;
  var tomorrow : DateTime;
  var dateutc : DateTime;

  public function new() {
    offset = Time.fromHours(-6);
    date = DateTime.create(2015, 7, 26, 21, 40, 30, 0, offset);
    tomorrow = DateTime.create(2015, 7, 27, 16, 40, 30, 0, offset);
    dateutc = DateTime.create(2015, 7, 27, 3, 40, 30, 0, Time.zero);
  }

  public function testCreate() {
    Assert.equals(2015, date.year, 'expected 2015 but got ${date.year} for year');
    Assert.equals(7, date.month, 'expected 7 but got ${date.month} for month');
    Assert.equals(26, date.day, 'expected 26 but got ${date.day} for day');

    Assert.equals(21, date.hour, 'expected 21 but got ${date.hour} for hour');
    Assert.equals(40, date.minute, 'expected 40 but got ${date.minute} for minute');
    Assert.equals(30, date.second, 'expected 30 but got ${date.second} for second');

    Assert.equals(Sunday, date.dayOfWeek);

    Assert.equals(-6, date.offset.hours);
  }

  public function testEquals() {
    Assert.isTrue(date == date);
    Assert.isTrue(date != tomorrow);
    Assert.isTrue(date == dateutc);
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

  public function testToString() {
    var d : String = date;
    Assert.equals("2015-07-26T21:40:30-06:00", d);
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
        e = "2018-05-07T04:50:37.007-06:00";
    Assert.isTrue(d == "2018-05-07T04:50:37.007-06:00", 'expected $e but got $d');
  }

  public function testOffset() {
    var nyDate = date.withOffset(Time.fromHours(-4));
    Assert.equals("2015-07-26T23:40:30-04:00", nyDate.toString());
    nyDate = date.changeOffset(Time.fromHours(-4));
    Assert.equals("2015-07-26T21:40:30-04:00", nyDate.toString());
  }

  public function testFromString() {
    var d : DateTime = "2015-07-26T21:40:30-06:00";
    Assert.isTrue(date.equals(d));
  }
#if !php
  public function testLocalOffset() {
    var ref   = DateHelper.localOffset(),
        delta = DateTime.localOffset();
    Assert.isTrue(ref == delta, 'expected $ref but got $delta');
  }
#end

  public function testNow() {
    var ref = DateHelper.now(),
        date = DateTime.now();
    Assert.isTrue(date.nearEquals(ref, Time.fromMinutes(1)), 'expected $ref but got $date');
  }
}
