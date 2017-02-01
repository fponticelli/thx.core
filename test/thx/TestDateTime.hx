package thx;

import utest.Assert;
import thx.DateTime;
import thx.Either;
using thx.Eithers;
import thx.Weekday;
import haxe.PosInfos;

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
    var d : String = date.toString();
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
    Assert.isTrue(d == e, 'expected $e but got $d');
  }

  public function testOffset() {
    var nyDate = date.withOffset(Time.fromHours(-4));
    Assert.equals("2015-07-26T23:40:30-04:00", nyDate.toString());
    nyDate = date.changeOffset(Time.fromHours(-4));
    Assert.equals("2015-07-26T21:40:30-04:00", nyDate.toString());
  }

  public function testFromString() {
    var d : DateTime = "2015-07-26T21:40:30-06:00";
    Assert.isTrue(date == d);
    var d : DateTime = "2014-01-01",
        d2 = DateTime.create(2014, 1, 1, Time.zero);
    Assert.isTrue(d2 == d);

    Assert.equals("-1-07-27T00:00:00+00:00",    ("0-06-07" : DateTime).toString());
    Assert.equals("-1-06-07T00:00:00+00:00",    ("-1-06-07" : DateTime).toString());
    Assert.equals("1-06-07T00:00:00+00:00",     ("1-06-07" : DateTime).toString());
    Assert.equals("-2014-01-01T00:00:00+00:00", ("-2014-01-01" : DateTime).toString());
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
    Assert.isTrue(date.nearEqualsTo(ref, Time.fromMinutes(10)), 'expected $ref but got $date');
  }

  public function testSnapNext() {
    assertSnapNext("2014-01-01 10:07:00-06:00", "2014-01-01 10:06:10-06:00", Minute);
    assertSnapNext("2014-01-01 10:06:00-06:00", "2014-01-01 10:05:50-06:00", Minute);
    assertSnapNext("2014-01-01 11:00:00-06:00", "2014-01-01 10:10:10-06:00", Hour);
    assertSnapNext("2014-01-01 10:00:00-06:00", "2014-01-01 09:50:10-06:00", Hour);
    assertSnapNext("2014-01-02 00:00:00-06:00", "2014-01-01 10:00:00-06:00", Day);
    assertSnapNext("2014-01-01 00:00:00-06:00", "2013-12-31 20:00:00-06:00", Day);
    assertSnapNext("2014-12-21 00:00:00-06:00", "2014-12-17 11:00:00-06:00", Week);
    assertSnapNext("2014-12-21 00:00:00-06:00", "2014-12-18 00:00:00-06:00", Week);
    assertSnapNext("2015-01-01 00:00:00-06:00", "2014-12-12 00:00:00-06:00", Month);
    assertSnapNext("2015-01-01 00:00:00-06:00", "2014-12-18 00:00:00-06:00", Month);
    assertSnapNext("2015-01-01 00:00:00-06:00", "2014-05-12 00:00:00-06:00", Year);
    assertSnapNext("2015-01-01 00:00:00-06:00", "2014-12-18 00:00:00-06:00", Year);
  }

  public function testSnapPrev() {
    assertSnapPrev("2014-01-01 10:06:00-06:00", "2014-01-01 10:06:10-06:00", Minute);
    assertSnapPrev("2014-01-01 10:05:00-06:00", "2014-01-01 10:05:50-06:00", Minute);
    assertSnapPrev("2014-01-01 10:00:00-06:00", "2014-01-01 10:10:10-06:00", Hour);
    assertSnapPrev("2014-01-01 09:00:00-06:00", "2014-01-01 09:50:10-06:00", Hour);
    assertSnapPrev("2014-01-01 00:00:00-06:00", "2014-01-01 10:00:00-06:00", Day);
    assertSnapPrev("2013-12-31 00:00:00-06:00", "2013-12-31 20:00:00-06:00", Day);
    assertSnapPrev("2014-12-14 00:00:00-06:00", "2014-12-17 11:00:00-06:00", Week);
    assertSnapPrev("2014-12-14 00:00:00-06:00", "2014-12-18 00:00:00-06:00", Week);
    assertSnapPrev("2014-12-01 00:00:00-06:00", "2014-12-12 00:00:00-06:00", Month);
    assertSnapPrev("2014-12-01 00:00:00-06:00", "2014-12-18 00:00:00-06:00", Month);
    assertSnapPrev("2014-01-01 00:00:00-06:00", "2014-05-12 00:00:00-06:00", Year);
    assertSnapPrev("2014-01-01 00:00:00-06:00", "2014-12-18 00:00:00-06:00", Year);
  }

  public function testSnapTo() {
    assertSnapTo("2014-01-01 10:06:00-06:00", "2014-01-01 10:06:10-06:00", Minute);
    assertSnapTo("2014-01-01 10:06:00-06:00", "2014-01-01 10:05:50-06:00", Minute);
    assertSnapTo("2014-01-01 10:00:00-06:00", "2014-01-01 10:10:10-06:00", Hour);
    assertSnapTo("2014-01-01 10:00:00-06:00", "2014-01-01 09:50:10-06:00", Hour);
    assertSnapTo("2014-01-01 00:00:00-06:00", "2014-01-01 10:00:00-06:00", Day);
    assertSnapTo("2014-01-01 00:00:00-06:00", "2013-12-31 20:00:00-06:00", Day);
    assertSnapTo("2014-12-14 00:00:00-06:00", "2014-12-17 11:00:00-06:00", Week);
    assertSnapTo("2014-12-21 00:00:00-06:00", "2014-12-18 00:00:00-06:00", Week);
    assertSnapTo("2014-12-01 00:00:00-06:00", "2014-12-12 00:00:00-06:00", Month);
    assertSnapTo("2015-01-01 00:00:00-06:00", "2014-12-18 00:00:00-06:00", Month);
    assertSnapTo("2014-01-01 00:00:00-06:00", "2014-05-12 00:00:00-06:00", Year);
    assertSnapTo("2015-01-01 00:00:00-06:00", "2014-12-18 00:00:00-06:00", Year);
  }

  function assertSnapTo(expected : DateTime, date : DateTime, period : TimePeriod, ?pos : PosInfos) {
    var t = date.snapTo(period);
    Assert.isTrue(
      expected == t,
      'expected $date to snap to $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapPrev(expected : DateTime, date : DateTime, period : TimePeriod, ?pos : PosInfos) {
    var t = date.snapPrev(period);
    Assert.isTrue(
      expected == t,
      'expected $date to snap before $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapNext(expected : DateTime, date : DateTime, period : TimePeriod, ?pos : PosInfos) {
    var t = date.snapNext(period);
    Assert.isTrue(
      expected == t,
      'expected $date to snap after $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  public function testIs() {
    Assert.isFalse(DateTime.is(null));
    Assert.isFalse(DateTime.is(""));
    Assert.isFalse(DateTime.is(42));
    Assert.isFalse(DateTime.is(42.5));
    Assert.isFalse(DateTime.is(true));
    Assert.isFalse(DateTime.is([]));
    Assert.isFalse(DateTime.is({}));
#if cpp
    Assert.isTrue(DateTime.is([1, 2]));
#else
    Assert.isFalse(DateTime.is([1, 2]));
#end
    Assert.isFalse(DateTime.is(DateTimeUtc.now()));
    Assert.isFalse(DateTime.is(Date.now()));
    Assert.isFalse(DateTime.is([haxe.Int64.ofInt(1)]));
    Assert.isFalse(DateTime.is([haxe.Int64.ofInt(1), haxe.Int64.ofInt(2), haxe.Int64.ofInt(3)]));
    Assert.isTrue(DateTime.is(DateTime.now()));
    Assert.isTrue(DateTime.is([haxe.Int64.ofInt(1), haxe.Int64.ofInt(2)])); // Array of exactly 2 Int64s is considered to be a DateTime
  }

  public function testParse() {
    assertParse(DateTime.create(2012, 2, 3, 11, 30, 59, 66, Time.zero), "2012-02-03T11:30:59.066");
    assertParse(DateTime.create(2012, 2, 3, 11, 30, 59, 66, Time.fromHours(-2)), "2012-02-03T11:30:59.066-02:00");
    assertParse(DateTime.create(2012, 2, 3, 11, 30, 59, 66, Time.zero), "2012-02-03T11:30:59.066Z");
    Assert.isTrue(DateTime.parse("x").isLeft());
  }

  function assertParse(expected: DateTime, test: String) {
    switch DateTime.parse(test) {
      case Left(_): Assert.fail('unable to parse DateTime: $test');
      case Right(t):
        Assert.isTrue(t.utc.ticks == expected.utc.ticks, 'DateTime.parse expected ${expected.toString()} but got ${t.toString()}');
    }
  }
}
