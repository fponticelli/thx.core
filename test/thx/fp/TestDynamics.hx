package thx.fp;

import haxe.ds.Option;
import haxe.ds.StringMap;

import thx.DateTime;
import thx.DateTimeUtc;
import thx.Either;
using thx.Eithers;
import thx.Functions.*;
using thx.Options;
import thx.fp.Dynamics.*;
import thx.Validation;
import thx.Validation.VNel;

import utest.Assert;

class TestDynamics {
  public function new() {}

  public function testParseStringMap() {
    var sample = { t: 1, u: 2, v: 3 };
    var expected: StringMap<Int> = [ "t" => 1, "u" => 2, "v" => 3 ];
    Assert.same(Right(expected), parseStringMap(sample, function(v, _) return parseInt(v), identity));
  }

  public function testParseString() {
    Assert.same(Right(""), thx.fp.Dynamics.parseString(""));
    Assert.same(Right("hi"), thx.fp.Dynamics.parseString("hi"));
    Assert.isTrue(thx.fp.Dynamics.parseString(null).either.isLeft());
    Assert.isTrue(thx.fp.Dynamics.parseString(123).either.isLeft());
    Assert.isTrue(thx.fp.Dynamics.parseString(true).either.isLeft());
    Assert.isTrue(thx.fp.Dynamics.parseString({}).either.isLeft());
    Assert.isTrue(thx.fp.Dynamics.parseString([]).either.isLeft());
  }

  public function testParseNonEmptyString() {
    Assert.same(Right("hi"), thx.fp.Dynamics.parseNonEmptyString("hi"));
    Assert.isTrue(thx.fp.Dynamics.parseNonEmptyString("").either.isLeft());
    Assert.isTrue(thx.fp.Dynamics.parseNonEmptyString(null).either.isLeft());
    Assert.isTrue(thx.fp.Dynamics.parseNonEmptyString(123).either.isLeft());
    Assert.isTrue(thx.fp.Dynamics.parseNonEmptyString(true).either.isLeft());
    Assert.isTrue(thx.fp.Dynamics.parseNonEmptyString({}).either.isLeft());
    Assert.isTrue(thx.fp.Dynamics.parseNonEmptyString([]).either.isLeft());
  }

  public function testParseOptional() {
    Assert.same(Right(None), parseOptional(null, parseString));
    Assert.same(Right(Some("")), parseOptional("", parseString));
    Assert.same(Right(Some("hi")), parseOptional("hi", parseString));
    Assert.isTrue(parseOptional(true, parseString).either.isLeft());
  }

  public function testParseOptionalOrElse() {
    Assert.same(Right("hi"), parseOptionalOrElse(null, parseString, "hi"));
    Assert.same(Right("bye"), parseOptionalOrElse("bye", parseString, "hi"));
    Assert.isTrue(parseOptionalOrElse(true, parseString, "hi").either.isLeft());
  }

  public function testParseOptionalProperty() {
    Assert.same(Right(None), parseOptionalProperty({}, "test", parseString));
    Assert.same(Right(None), parseOptionalProperty({ test: null }, "test", parseString));
    Assert.same(Right(Some("")), parseOptionalProperty({ test: "" }, "test", parseString));
    Assert.same(Right(Some("hi")), parseOptionalProperty({ test: "hi" }, "test", parseString));
    Assert.isTrue(parseOptionalProperty({ test: true }, "test", parseString).either.isLeft());
  }

  public function testParseOptionalPropertyOrElse() {
    Assert.same(Right("def"), parseOptionalPropertyOrElse({}, "test", parseString, "def"));
    Assert.same(Right("def"), parseOptionalPropertyOrElse({ test: null }, "test", parseString, "def"));
    Assert.same(Right(""), parseOptionalPropertyOrElse({ test: "" }, "test", parseString, "def"));
    Assert.same(Right("hi"), parseOptionalPropertyOrElse({ test: "hi" }, "test", parseString, "def"));
    Assert.isTrue(parseOptionalPropertyOrElse({ test: true }, "test", parseString, "def").either.isLeft());
  }
}
