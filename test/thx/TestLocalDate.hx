package thx;

import haxe.PosInfos;
import utest.Assert;
import thx.Weekday;
using thx.Arrays;

class TestLocalDate {
  public function new() {}
  var date = LocalDate.create(2015, 7, 26);
  var tomorrow = LocalDate.create(2015, 7, 27);


  public function testCreate() {
    Assert.equals(2015, date.year, 'expected 2015 but got ${date.year} for year');
    Assert.equals(7, date.month, 'expected 7 but got ${date.month} for month');
    Assert.equals(26, date.day, 'expected 26 but got ${date.day} for day');

    Assert.equals(Sunday, date.dayOfWeek);

    var expectations = [
      // normal
      { expected : LocalDate.fromString("2014-12-01"), test : LocalDate.create(2014,12,1) },
      // month overflow
      { expected : LocalDate.fromString("2015-03-01"), test : LocalDate.create(2014,15,1) },
      { expected : LocalDate.fromString("2013-11-01"), test : LocalDate.create(2014,-1,1) },

      // day overflow
      { expected : LocalDate.fromString("2014-03-04"), test : LocalDate.create(2014,2,32) },
      { expected : LocalDate.fromString("2013-12-31"), test : LocalDate.create(2014,1,0) }
    ];

    expectations.each(function(o) {
      Assert.isTrue(o.expected == o.test, 'expected ${o.expected.toString()} but was  ${o.test.toString()}');
    });
  }

  public function testToString() {
    Assert.equals('2015-07-26', date.toString());
    Assert.equals('1-01-01', LocalDate.fromInt(0).toString());
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

// C# Date functions are broken in <= 3.2.1
#if (!cs || haxe_ver > 3.210)
  public function testFromToDate() {
    var d = LocalDate.fromDate(date.toDate());
    Assert.isTrue(date == d, 'expected $date but got ${(d : LocalDate)}');
  }

  public function testFromToTime() {
    var date2 : LocalDate = LocalDate.fromTime(date.toTime());
    Assert.isTrue(date == date2, 'expected $date but got $date2');
  }
#end

  public function testFromToString() {
    Assert.isTrue(date == LocalDate.fromString(date.toString()));

    Assert.equals("-1-07-27",    ("0-06-07" : LocalDate).toString());
    Assert.equals("-1-06-07",    ("-1-06-07" : LocalDate).toString());
    Assert.equals("1-06-07",     ("1-06-07" : LocalDate).toString());
    Assert.equals("-2014-01-01", ("-2014-01-01" : LocalDate).toString());
  }

  public function testAdd() {
    var d = date
              .addYears(2)
              .addMonths(9)
              .addDays(10),
        e = "2018-05-06";
    Assert.isTrue(d == e, 'expected $e but got $d');
  }

  public function testAddMonth() {
    var tests = [
      { t : date.addMonths(1), e : LocalDate.fromString("2015-08-26") },
      { t : date.addMonths(0), e : LocalDate.fromString("2015-07-26") },
      { t : date.addMonths(-1), e : LocalDate.fromString("2015-06-26") },

      { t : date.addMonths(7), e : LocalDate.fromString("2016-02-26") },
      { t : date.addMonths(-7), e : LocalDate.fromString("2014-12-26") },

      { t : date.addMonths(14), e : LocalDate.fromString("2016-09-26") },
      { t : date.addMonths(-14), e : LocalDate.fromString("2014-05-26") },
    ];
    for(test in tests) {
      Assert.isTrue(test.t == test.e, 'expexted ${test.e} but got ${test.t}');
    }
  }

  public function testSnapNext() {
    assertSnapNext("2014-01-01", "2014-01-01", Minute);
    assertSnapNext("2014-01-01", "2014-01-01", Hour);
    assertSnapNext("2014-01-02", "2014-01-01", Day);
    assertSnapNext("2014-01-01", "2013-12-31", Day);
    assertSnapNext("2014-12-21", "2014-12-17", Week);
    assertSnapNext("2014-12-21", "2014-12-18", Week);
    assertSnapNext("2015-01-01", "2014-12-12", Month);
    assertSnapNext("2015-01-01", "2014-12-18", Month);
    assertSnapNext("2015-01-01", "2014-05-12", Year);
    assertSnapNext("2015-01-01", "2014-12-18", Year);
  }

  public function testSnapPrev() {
    assertSnapPrev("2013-12-31", "2014-01-01", Minute);
    assertSnapPrev("2013-12-31", "2014-01-01", Hour);
    assertSnapPrev("2013-12-31", "2014-01-01", Day);
    assertSnapPrev("2013-12-30", "2013-12-31", Day);
    assertSnapPrev("2014-12-14", "2014-12-17", Week);
    assertSnapPrev("2014-12-14", "2014-12-18", Week);
    assertSnapPrev("2014-12-01", "2014-12-12", Month);
    assertSnapPrev("2014-12-01", "2014-12-01", Month);
    assertSnapPrev("2014-12-01", "2014-12-18", Month);
    assertSnapPrev("2014-01-01", "2014-05-12", Year);
    assertSnapPrev("2014-01-01", "2014-12-18", Year);
  }

  public function testSnapTo() {
    assertSnapTo("2014-01-01", "2014-01-01", Minute);
    assertSnapTo("2014-01-01", "2014-01-01", Hour);
    assertSnapTo("2014-01-01", "2014-01-01", Day);
    assertSnapTo("2013-12-31", "2013-12-31", Day);
    assertSnapTo("2014-12-14", "2014-12-17", Week);
    assertSnapTo("2014-12-21", "2014-12-18", Week);
    assertSnapTo("2014-12-01", "2014-12-12", Month);
    assertSnapTo("2015-01-01", "2014-12-18", Month);
    assertSnapTo("2014-01-01", "2014-05-12", Year);
    assertSnapTo("2015-01-01", "2014-12-18", Year);
  }

  function assertSnapTo(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = LocalDate.fromString(date).snapTo(period);
    Assert.isTrue(
      LocalDate.fromString(expected) == t,
      'expected $date to snap to $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapPrev(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = LocalDate.fromString(date).snapPrev(period);
    Assert.isTrue(
      LocalDate.fromString(expected) == t,
      'expected $date to snap before $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapNext(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = LocalDate.fromString(date).snapNext(period);
    Assert.isTrue(
      LocalDate.fromString(expected) == t,
      'expected $date to snap after $expected for $period but it is ${t.toString()}',
      pos
    );
  }
}
