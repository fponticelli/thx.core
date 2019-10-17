package thx;

import haxe.PosInfos;
import utest.Assert;
import thx.Either;
import thx.Weekday;
using thx.Eithers;
using thx.Arrays;

class TestLocalYearMonth {
  public function new() {}

  public function testAroundZero() {
    var tests = [
      { expected : "-2-12", value : -13 },
      { expected : "-1-01", value : -12 },
      { expected : "-1-02", value : -11 },
      { expected : "-1-12", value : -1  },
      { expected : "1-01",  value : 0   },
      { expected : "1-02",  value : 1   },
      { expected : "1-12",  value : 11  },
      { expected : "2-01",  value : 12  }
    ];
    for(test in tests) {
      var s = LocalYearMonth.fromInt(test.value).toString();
      Assert.isTrue(test.expected == s, 'toString: expected ${test.expected} but got $s for ${test.value}');
      var p = LocalYearMonth.fromString(test.expected);
      Assert.isTrue(test.value == p.months, 'fromString: expected months to be ${test.value} but got $p (${p.month}) for ${test.expected}');
    }
  }
  var date = LocalYearMonth.create(2015, 7);
  var next = LocalYearMonth.create(2015, 8);

  public function testCreate() {
    Assert.equals(2015, date.year, 'expected 2015 but got ${date.year} for year');
    Assert.equals(7, date.month, 'expected 7 but got ${date.month} for month');

    var expectations = [
      // normal
      { expected : LocalYearMonth.fromString("2014-12"), test : LocalYearMonth.create(2014,12) },
      // month overflow
      { expected : LocalYearMonth.fromString("2015-03"), test : LocalYearMonth.create(2014,15) },
      { expected : LocalYearMonth.fromString("2013-11"), test : LocalYearMonth.create(2014,-1) },

      // day overflow
      { expected : LocalYearMonth.fromString("2014-03"), test : LocalYearMonth.create(2012,27) },
      { expected : LocalYearMonth.fromString("2013-12"), test : LocalYearMonth.create(2014,0) }
    ];

    expectations.each(function(o) {
      Assert.isTrue(o.expected == o.test, 'expected ${o.expected.toString()} but was  ${o.test.toString()}');
    });
  }

  public function testToString() {
    Assert.equals('2015-07', date.toString());
    Assert.equals('1-01', LocalYearMonth.fromInt(0).toString());
  }

  public function testFromString() {
    Assert.same(LocalYearMonth.create(2012, 2), LocalYearMonth.fromString("2012-02"));
    Assert.raises(function() LocalYearMonth.fromString("x"));
    Assert.raises(function() LocalYearMonth.fromString("2012"));
    Assert.raises(function() LocalYearMonth.fromString("2012-x"));
    Assert.raises(function() LocalYearMonth.fromString("2012-2"));
    Assert.raises(function() LocalYearMonth.fromString("2012-0x"));
    Assert.raises(function() LocalYearMonth.fromString("2012-100"));
  }

  public function testParse() {
    Assert.same(Right(LocalYearMonth.create(2012, 2)), LocalYearMonth.parse("2012-02"));
    Assert.isTrue(LocalYearMonth.parse("x").isLeft());
    Assert.isTrue(LocalYearMonth.parse("2012").isLeft());
    Assert.isTrue(LocalYearMonth.parse("2012-x").isLeft());
    Assert.isTrue(LocalYearMonth.parse("2012-2").isLeft());
    Assert.isTrue(LocalYearMonth.parse("2012-0x").isLeft());
    Assert.isTrue(LocalYearMonth.parse("2012-100").isLeft());
  }

  public function testEquals() {
    Assert.isTrue(date == date);
    Assert.isTrue(date != next);
  }

  public function testCompare() {
    Assert.isFalse(date > date);
    Assert.isTrue(date >= date);
    Assert.isFalse(date < date);
    Assert.isTrue(date <= date);

    Assert.isFalse(date > next);
    Assert.isFalse(date >= next);
    Assert.isTrue(date < next);
    Assert.isTrue(date <= next);

    Assert.isTrue(next > date);
    Assert.isTrue(next >= date);
    Assert.isFalse(next < date);
    Assert.isFalse(next <= date);
  }

// C# Date functions are broken in <= 3.2.1
#if (!cs || haxe_ver > 3.210)
  public function testFromToDate() {
    var d = LocalYearMonth.fromDate(date.toDate());
    Assert.isTrue((date.month) == d.month && date.year == d.year, 'expected $date but got ${(d : LocalYearMonth)}');
  }

  public function testFromToTime() {
    var d : LocalYearMonth = LocalYearMonth.fromTime(date.toDate().getTime());
    Assert.isTrue(date.month == d.month && date.year == d.year, 'expected $date but got ${(d : LocalYearMonth)}');
  }
#end

  public function testFromToString() {
    Assert.isTrue(date == LocalYearMonth.fromString(date.toString()));

    Assert.equals("-1-07",    ("0-06" : LocalYearMonth).toString());
    Assert.equals("-1-06",    ("-1-06" : LocalYearMonth).toString());
    Assert.equals("1-06",     ("1-06" : LocalYearMonth).toString());
    Assert.equals("-2014-01", ("-2014-01" : LocalYearMonth).toString());
  }

  public function testAdd() {
    var d = date
              .addYears(2)
              .addMonths(9),
        e = "2018-04";
    Assert.isTrue(d.toString() == e, 'expected $e but got $d');
  }

  public function testAddMonth() {
    var tests = [
      { t : date.addMonths(1), e : LocalYearMonth.fromString("2015-08") },
      { t : date.addMonths(0), e : LocalYearMonth.fromString("2015-07") },
      { t : date.addMonths(-1), e : LocalYearMonth.fromString("2015-06") },

      { t : date.addMonths(7), e : LocalYearMonth.fromString("2016-02") },
      { t : date.addMonths(-7), e : LocalYearMonth.fromString("2014-12") },

      { t : date.addMonths(14), e : LocalYearMonth.fromString("2016-09") },
      { t : date.addMonths(-14), e : LocalYearMonth.fromString("2014-05") },
    ];
    for(test in tests) {
      Assert.isTrue(test.t == test.e, 'expexted ${test.e} but got ${test.t}');
    }
  }

  public function testSnapNext() {
    assertSnapNext("2014-01", "2014-01", Minute);
    assertSnapNext("2014-01", "2014-01", Hour);
    assertSnapNext("2014-01", "2014-01", Day);
    assertSnapNext("2013-12", "2013-12", Day);
    assertSnapNext("2014-12", "2014-12", Week);
    assertSnapNext("2015-01", "2014-12", Month);
    assertSnapNext("2015-01", "2014-05", Year);
    assertSnapNext("2015-01", "2014-12", Year);
  }

  public function testSnapPrev() {
    assertSnapPrev("2013-12", "2014-01", Minute);
    assertSnapPrev("2013-12", "2014-01", Hour);
    assertSnapPrev("2013-12", "2014-01", Day);
    assertSnapPrev("2013-11", "2013-12", Day);
    assertSnapPrev("2014-11", "2014-12", Week);
    assertSnapPrev("2014-11", "2014-12", Month);
    assertSnapPrev("2013-01", "2014-05", Year);
    assertSnapPrev("2013-01", "2014-12", Year);
  }

  public function testSnapTo() {
    assertSnapTo("2014-01", "2014-01", Minute);
    assertSnapTo("2014-01", "2014-01", Hour);
    assertSnapTo("2014-01", "2014-01", Day);
    assertSnapTo("2013-12", "2013-12", Day);
    assertSnapTo("2014-12", "2014-12", Week);
    assertSnapTo("2014-12", "2014-12", Week);
    assertSnapTo("2014-12", "2014-12", Month);
    assertSnapTo("2014-12", "2014-12", Month);
    assertSnapTo("2014-01", "2014-05", Year);
    assertSnapTo("2015-01", "2014-12", Year);
  }

  function assertSnapTo(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = LocalYearMonth.fromString(date).snapTo(period);
    Assert.isTrue(
      LocalYearMonth.fromString(expected) == t,
      'expected $date to snap to $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapPrev(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = LocalYearMonth.fromString(date).snapPrev(period);
    Assert.isTrue(
      LocalYearMonth.fromString(expected) == t,
      'expected $date to snap before $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapNext(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = LocalYearMonth.fromString(date).snapNext(period);
    Assert.isTrue(
      LocalYearMonth.fromString(expected) == t,
      'expected $date to snap after $expected for $period but it is ${t.toString()}',
      pos
    );
  }
}
