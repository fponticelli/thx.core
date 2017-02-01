package thx;

import haxe.PosInfos;
import utest.Assert;
using thx.DateTimeUtc;
import thx.Either;
using thx.Eithers;
import thx.Weekday;
import haxe.PosInfos;

class TestDateTimeUtc {
  var date = DateTimeUtc.create(2015, 7, 26, 21, 40, 30, 0);
  var tomorrow = DateTimeUtc.create(2015, 7, 27, 21, 40, 30, 123);

  public function new() {}

  public function testCreate() {
    Assert.equals(2015, date.year, 'expected 2015 but got ${date.year} for year');
    Assert.equals(7, date.month, 'expected 7 but got ${date.month} for month');
    Assert.equals(26, date.day, 'expected 26 but got ${date.day} for day');

    Assert.equals(21, date.hour, 'expected 21 but got ${date.hour} for hour');
    Assert.equals(40, date.minute, 'expected 40 but got ${date.minute} for minute');
    Assert.equals(30, date.second, 'expected 30 but got ${date.second} for second');

    Assert.equals(    123, tomorrow.millisecond, 'expected 123 but got ${tomorrow.millisecond} for millisecond');
    Assert.equals( 123000, tomorrow.microsecond, 'expected 123 but got ${tomorrow.microsecond} for microsecond');
    Assert.equals(1230000, tomorrow.tickInSecond, 'expected 123 but got ${tomorrow.tickInSecond} for tickInSecond');

    Assert.equals(Sunday, date.dayOfWeek);
  }

  public function testToString() {
    Assert.equals('2015-07-26T21:40:30Z', date.toString());
    Assert.equals('1-01-01T00:00:00Z', DateTimeUtc.fromInt64(0).toString());
  }

  public function testOverflowing() {
    Assert.equals("2014-12-01T00:00:00Z", DateTimeUtc.create(2014,12,1).toString());
    // month overflow
    Assert.equals("2015-04-01T00:00:00Z", DateTimeUtc.create(2014,16,1).toString());
    Assert.equals("2013-10-01T00:00:00Z", DateTimeUtc.create(2014,-2,1).toString());

    // day overflow
    Assert.equals("2014-03-04T00:00:00Z", DateTimeUtc.create(2014,2,32).toString());
    Assert.equals("2013-12-31T00:00:00Z", DateTimeUtc.create(2014,1,0).toString());

    // hour overflow
    Assert.equals("2014-02-02T02:00:00Z", DateTimeUtc.create(2014,2,1,26).toString());
    Assert.equals("2013-12-31T23:00:00Z", DateTimeUtc.create(2014,1,1,-1).toString());

    // minute overflow
    Assert.equals("2014-02-01T01:05:00Z", DateTimeUtc.create(2014,2,1,0,65).toString());
    Assert.equals("2013-12-31T23:59:00Z", DateTimeUtc.create(2014,1,1,0,-1).toString());

    // second overflow
    Assert.equals("2014-02-01T00:01:05Z", DateTimeUtc.create(2014,2,1,0,0,65).toString());
    Assert.equals("2013-12-31T23:59:59Z", DateTimeUtc.create(2014,1,1,0,0,-1).toString());
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
    var d : Date = date.toDate();
    Assert.isTrue(date == d, 'expected $date but got ${(d : DateTimeUtc)}');
  }

  public function testFromToTime() {
    var d : Float = date.toTime(),
        date2 : DateTimeUtc = d;
    Assert.isTrue(date == date2, 'expected $date but got $date2');
  }

  public function testFromToString() {
    var d : String = date.toString();
    Assert.isTrue(date == d);

    Assert.equals("-1-07-27T00:00:00Z",    ("0-06-07" : DateTimeUtc).toString());
    Assert.equals("-1-06-07T00:00:00Z",    ("-1-06-07" : DateTimeUtc).toString());
    Assert.equals("1-06-07T00:00:00Z",     ("1-06-07" : DateTimeUtc).toString());
    Assert.equals("-2014-01-01T00:00:00Z", ("-2014-01-01" : DateTimeUtc).toString());
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
    Assert.isTrue(date.nearEqualsTo(ref, Time.fromMinutes(10)), 'expected $ref but got $date');
  }

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

  function assertSnapTo(expected : DateTimeUtc, date : DateTimeUtc, period : TimePeriod, ?pos : PosInfos) {
    var t = date.snapTo(period);
    Assert.isTrue(
      expected == t,
      'expected $date to snap to $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapPrev(expected : DateTimeUtc, date : DateTimeUtc, period : TimePeriod, ?pos : PosInfos) {
    var t = date.snapPrev(period);
    Assert.isTrue(
      expected == t,
      'expected $date to snap before $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapNext(expected : DateTimeUtc, date : DateTimeUtc, period : TimePeriod, ?pos : PosInfos) {
    var t = date.snapNext(period);
    Assert.isTrue(
      expected == t,
      'expected $date to snap after $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  public function testIs() {
    Assert.isFalse(DateTimeUtc.is(null));
    Assert.isFalse(DateTimeUtc.is(""));
#if cpp
    Assert.isTrue(DateTimeUtc.is(42));
#else
    Assert.isFalse(DateTimeUtc.is(42));
#end
    Assert.isFalse(DateTimeUtc.is(42.5));
    Assert.isFalse(DateTimeUtc.is(true));
    Assert.isFalse(DateTimeUtc.is([]));
    Assert.isFalse(DateTimeUtc.is({}));
    Assert.isFalse(DateTimeUtc.is([1, 2]));
    Assert.isFalse(DateTimeUtc.is(DateTime.now()));
    Assert.isFalse(DateTimeUtc.is(Date.now()));
    Assert.isFalse(DateTimeUtc.is([haxe.Int64.ofInt(1)]));
    Assert.isFalse(DateTimeUtc.is([haxe.Int64.ofInt(1), haxe.Int64.ofInt(2)]));
    Assert.isFalse(DateTimeUtc.is([haxe.Int64.ofInt(1), haxe.Int64.ofInt(2), haxe.Int64.ofInt(3)]));
    Assert.isTrue(DateTimeUtc.is(DateTimeUtc.now()));
    Assert.isTrue(DateTimeUtc.is(haxe.Int64.ofInt(1))); // one Int64 is considered to be a DateTimeUtc
  }

  public function testParse() {
    assertParse(DateTimeUtc.create(2012, 2, 3, 11, 30, 59, 66), "2012-02-03T11:30:59.066");
    assertParse(DateTimeUtc.create(2012, 2, 3, 13, 30, 59, 66), "2012-02-03T11:30:59.066-02:00");
    assertParse(DateTimeUtc.create(2012, 2, 3, 11, 30, 59, 66), "2012-02-03T11:30:59.066Z");
    Assert.isTrue(DateTime.parse("x").isLeft());
  }

  function assertParse(expected: DateTimeUtc, test: String) {
    switch DateTimeUtc.parse(test) {
      case Left(_): Assert.fail('unable to parse DateTimeUtc: $test');
      case Right(t):
        Assert.isTrue(t.ticks == expected.ticks, 'DateTimeUtc.parse expected ${expected.toString()} but got ${t.toString()}');
    }
  }
}
