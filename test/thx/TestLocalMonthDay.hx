package thx;

import haxe.PosInfos;
import utest.Assert;
import thx.Either;
import thx.Weekday;
using thx.Eithers;
using thx.Arrays;

class TestLocalMonthDay {
  public function new() {}

  var first   = LocalMonthDay.create(1, 1);
  var last    = LocalMonthDay.create(12, 31);
  var feb28th = LocalMonthDay.create(2, 28);
  var feb29th = LocalMonthDay.create(2, 29);
  var mar1st  = LocalMonthDay.create(3, 1);
  var mar31st = LocalMonthDay.create(3, 31);

  public function testCreate() {
    Assert.equals(1, first.month, 'expected 1 but got ${first.month} for month');
    Assert.equals(1, first.day, 'expected 1 but got ${first.day} for day');

    var expectations = [
      // normal
      { expected : LocalMonthDay.fromString("--12-12"), test : LocalMonthDay.create(12,12) },
      { expected : LocalMonthDay.fromString("--01-01"), test : LocalMonthDay.create( 1, 1) },
      { expected : LocalMonthDay.fromString("--12-31"), test : LocalMonthDay.create(12,31) },
      { expected : LocalMonthDay.fromString("--02-28"), test : LocalMonthDay.create( 2,28) },
      { expected : LocalMonthDay.fromString("--02-29"), test : LocalMonthDay.create( 2,29) },
      { expected : LocalMonthDay.fromString("--03-01"), test : LocalMonthDay.create( 3, 1) },
      { expected : LocalMonthDay.fromString("--05-07"), test : LocalMonthDay.create( 5, 7) },
    ];

    expectations.each(function(o) {
      Assert.isTrue(o.expected == o.test, 'expected ${o.expected.toString()} but was  ${o.test.toString()}');
    });
  }

  public function testDayMonth() {
    var expectations = [
      { day: 1,  month: 1, test : 0 },
      { day: 31, month: 1, test : 30 },
      { day: 1,  month: 2, test : 31 },
      { day: 29, month: 2, test : 59 },
      { day: 1,  month: 3, test : 60 },
    ];

    expectations.each(function(o) {
      var d = LocalMonthDay.fromInt(o.test);
      Assert.isTrue(o.day == d.day && o.month == d.month, 'expected day ${o.day} == ${d.day} and month ${o.month} == ${d.month} for month/day ${o.test}');
    });
  }

  public function testToString() {
    Assert.equals('--02-28', feb28th.toString());
    Assert.equals('--01-01', LocalMonthDay.fromInt(-1).toString());
    Assert.equals('--01-01', LocalMonthDay.fromInt(0).toString());
    Assert.equals('--12-31', LocalMonthDay.fromInt(365).toString());
    Assert.equals('--12-31', LocalMonthDay.fromInt(366).toString());
  }

  public function testFromString() {
    Assert.same(LocalMonthDay.create(1, 1), LocalMonthDay.fromString("--00-00"));
    Assert.same(LocalMonthDay.create(2, 29), LocalMonthDay.fromString("--02-30"));
    Assert.raises(function() LocalMonthDay.fromString("x"));
    Assert.raises(function() LocalMonthDay.fromString("--x-01"));
    Assert.raises(function() LocalMonthDay.fromString("--01-xx"));
  }

  public function testParse() {
    Assert.same(Right(LocalMonthDay.create(1, 1)), LocalMonthDay.parse("--00-00"));
    Assert.same(Right(LocalMonthDay.create(2, 29)), LocalMonthDay.parse("--02-30"));
    Assert.isTrue(LocalMonthDay.parse("x").isLeft());
    Assert.isTrue(LocalMonthDay.parse("--x-01").isLeft());
    Assert.isTrue(LocalMonthDay.parse("--01-xx").isLeft());
  }

  public function testEquals() {
    Assert.isTrue(feb28th == feb28th);
    Assert.isTrue(feb28th != mar1st);
  }

  public function testCompare() {
    Assert.isFalse(feb28th > feb28th);
    Assert.isTrue(feb28th >= feb28th);
    Assert.isFalse(feb28th < feb28th);
    Assert.isTrue(feb28th <= feb28th);

    Assert.isFalse(feb28th > mar1st);
    Assert.isFalse(feb28th >= mar1st);
    Assert.isTrue(feb28th < mar1st);
    Assert.isTrue(feb28th <= mar1st);

    Assert.isTrue(mar1st > feb28th);
    Assert.isTrue(mar1st >= feb28th);
    Assert.isFalse(mar1st < feb28th);
    Assert.isFalse(mar1st <= feb28th);
  }

// C# Date functions are broken in <= 3.2.1
#if (!cs || haxe_ver > 3.210)
  public function testFromToDate() {
    var d = LocalMonthDay.fromDate(mar1st.toDate(2017));
    Assert.isTrue((mar1st.month) == d.month && mar1st.day == d.day, 'expected $mar1st but got ${(d : LocalMonthDay)}');
  }

  public function testFromToTime() {
    var d : LocalMonthDay = LocalMonthDay.fromTime(mar1st.toDate(2017).getTime());
    Assert.isTrue(mar1st.month == d.month && mar1st.day == d.day, 'expected $mar1st but got ${(d : LocalMonthDay)}');
  }
#end

  public function testAdd() {
    var d = first
              .addDays(2)
              .addMonths(9),
        e = "--10-03";
    Assert.isTrue(d.toString() == e, 'expected $e but got $d');
  }

  public function testAddMonths() {
    var tests = [
      { t : mar1st.addMonths(1),   e : LocalMonthDay.fromString("--04-01") },
      { t : mar1st.addMonths(0),   e : LocalMonthDay.fromString("--03-01") },
      { t : mar1st.addMonths(-1),  e : LocalMonthDay.fromString("--02-01") },
      { t : mar31st.addMonths(-1), e : LocalMonthDay.fromString("--02-29") },

      { t : mar1st.addMonths(9),  e : LocalMonthDay.fromString("--12-01") },
      { t : mar1st.addMonths(20), e : LocalMonthDay.fromString("--12-31") },
      { t : mar31st.addMonths(-2), e : LocalMonthDay.fromString("--01-31") },
      { t : mar1st.addMonths(-2), e : LocalMonthDay.fromString("--01-01") },
      { t : mar1st.addMonths(20), e : LocalMonthDay.fromString("--12-31") },
    ];
    for(test in tests) {
      Assert.isTrue(test.t == test.e, 'expexted ${test.e} but got ${test.t}');
    }
  }

  public function testAddDays() {
    var tests = [
      { t : mar1st.addDays(1),   e : LocalMonthDay.fromString("--03-02") },
      { t : mar1st.addDays(0),   e : LocalMonthDay.fromString("--03-01") },
      { t : mar1st.addDays(-1),  e : LocalMonthDay.fromString("--02-29") },
      { t : mar31st.addDays(-1), e : LocalMonthDay.fromString("--03-30") },

      { t : mar1st.addDays(366),   e : LocalMonthDay.fromString("--12-31") },
      { t : mar1st.addDays(-366),  e : LocalMonthDay.fromString("--01-01") },
    ];
    for(test in tests) {
      Assert.isTrue(test.t == test.e, 'expexted ${test.e} but got ${test.t}');
    }
  }

  public function testSnapNext() {
    assertSnapNext("--01-01", "--01-01", Minute);
    assertSnapNext("--01-01", "--01-01", Hour);
    assertSnapNext("--02-29", "--02-28", Day);
    assertSnapNext("--03-01", "--02-29", Day);
    assertSnapNext("--03-06", "--02-28", Week);
    assertSnapNext("--03-28", "--02-28", Month);
    assertSnapNext("--02-29", "--01-31", Month);
    assertSnapNext("--01-01", "--01-01", Year);
    assertSnapNext("--06-17", "--06-17", Year);
    assertSnapNext("--03-07", "--03-07", Year);
  }

  public function testSnapPrev() {
    assertSnapPrev("--01-01", "--01-01", Minute);
    assertSnapPrev("--01-01", "--01-01", Hour);
    assertSnapPrev("--02-27", "--02-28", Day);
    assertSnapPrev("--02-28", "--02-29", Day);
    assertSnapPrev("--02-29", "--03-01", Day);

    assertSnapPrev("--02-21", "--02-28", Week);
    assertSnapPrev("--01-01", "--01-31", Month);
    assertSnapPrev("--11-30", "--12-31", Month);
    assertSnapPrev("--01-01", "--01-01", Year);
  }

  public function testSnapTo() {
    assertSnapTo("--01-01", "--01-01", Minute);
    assertSnapTo("--01-01", "--01-01", Hour);
    assertSnapTo("--02-28", "--02-28", Day);
    assertSnapTo("--02-29", "--02-29", Day);
    assertSnapTo("--02-29", "--02-29", Week);
    assertSnapTo("--02-01", "--02-01", Month);
    assertSnapTo("--02-01", "--02-14", Month);
    assertSnapTo("--03-01", "--02-29", Month);
    assertSnapTo("--02-29", "--02-29", Year);
  }

  function assertSnapTo(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = LocalMonthDay.fromString(date).snapTo(period);
    Assert.isTrue(
      LocalMonthDay.fromString(expected) == t,
      'expected $date to snap to $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapPrev(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = LocalMonthDay.fromString(date).snapPrev(period);
    Assert.isTrue(
      LocalMonthDay.fromString(expected) == t,
      'expected $date to snap before $expected for $period but it is ${t.toString()}',
      pos
    );
  }

  function assertSnapNext(expected : String, date : String, period : TimePeriod, ?pos : PosInfos) {
    var t = LocalMonthDay.fromString(date).snapNext(period);
    Assert.isTrue(
      LocalMonthDay.fromString(expected) == t,
      'expected $date to snap after $expected for $period but it is ${t.toString()}',
      pos
    );
  }
}
