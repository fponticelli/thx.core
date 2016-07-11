package thx.fp;

import haxe.ds.StringMap;

import thx.DateTime;
import thx.DateTimeUtc;
import thx.Either;
using thx.Eithers;
import thx.Functions.*;
import thx.fp.Dynamics.*;

import utest.Assert;

class TestDynamics {
  public function new() {}

  public function testParseStringMap() {
    var sample = { t: 1, u: 2, v: 3 };
    var expected: StringMap<Int> = [ "t" => 1, "u" => 2, "v" => 3 ];

    Assert.same(Right(expected), parseStringMap(sample, function(v, _) return parseInt(v), identity));
  }

  public function testParseDateTime() {
    Assert.same(Right(DateTime.create(2012, 2, 3, 11, 30, 59, 66, Time.zero)), DateTime.parse("2012-02-03T11:30:59.066"));
    Assert.same(Right(DateTime.create(2012, 2, 3, 11, 30, 59, 66, Time.fromHours(-2))), DateTime.parse("2012-02-03T11:30:59.066-02:00"));
    Assert.same(Right(DateTime.create(2012, 2, 3, 11, 30, 59, 66, Time.zero)), DateTime.parse("2012-02-03T11:30:59.066Z"));
    Assert.isTrue(DateTime.parse("x").isLeft());
  }

  public function testParseDateTimeUtc() {
    Assert.same(Right(DateTimeUtc.create(2012, 2, 3, 11, 30, 59, 66)), DateTimeUtc.parse("2012-02-03T11:30:59.066"));
    Assert.same(Right(DateTimeUtc.create(2012, 2, 3, 13, 30, 59, 66)), DateTimeUtc.parse("2012-02-03T11:30:59.066-02:00"));
    Assert.same(Right(DateTimeUtc.create(2012, 2, 3, 11, 30, 59, 66)), DateTimeUtc.parse("2012-02-03T11:30:59.066Z"));
    Assert.isTrue(DateTime.parse("x").isLeft());
  }
}
