package thx.fp;

import haxe.ds.Option;
import haxe.ds.StringMap;

import thx.DateTime;
import thx.DateTimeUtc;
import thx.Either;
using thx.Eithers;
import thx.Functions.*;
using thx.Options;
import thx.Nel;
import thx.Tuple;
import thx.Validation;
import thx.Validation.VNel;
import thx.fp.Dynamics.*;

import utest.Assert;

class TestDynamics {
  public function new() {}

  public function testParseStringMap() {
    Assert.same(Right(["t" => 1, "u" => 2, "v" => 3]), parseStringMap({ t: 1, u: 2, v: 3 }, function(v, _) return parseInt(v), identity));
    Assert.isTrue(parseStringMap([1, 2, 3], function(v, _) return parseInt(v), identity).either.isLeft());
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

  public function testParsePlainObject() {
    Assert.same(Right({ }), parsePlainObject({ }));
    Assert.same(Right({ a: "b" }), parsePlainObject({ a: "b" }));
    Assert.same(Left(Single("null is not a plain object")), parsePlainObject(null));
    Assert.same(Left(Single("hi is not a plain object")), parsePlainObject("hi"));
    Assert.same(Left(Single("[] is not a plain object")), parsePlainObject([]));
    Assert.same(Left(Single("true is not a plain object")), parsePlainObject(true));
#if js
    Assert.same(Left(Single("Error: message is not a plain object")), parsePlainObject(new js.lib.Error('message')));
#end
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

  public function testParseTuple2() {
    Assert.same(Right(Tuple.of("a", 1)), thx.fp.Dynamics.parseTuple2({ _0: "a", _1: 1}, parseString, parseInt, identity));
    Assert.isTrue(thx.fp.Dynamics.parseTuple2({}, parseString, parseInt, identity).either.isLeft());
  }

  public function testParseTuple3() {
    Assert.same(Right(Tuple3.of("a", 1, true)), thx.fp.Dynamics.parseTuple3({ _0: "a", _1: 1, _2: true}, parseString, parseInt, parseBool, identity));
    Assert.isTrue(thx.fp.Dynamics.parseTuple3({}, parseString, parseInt, parseBool, identity).either.isLeft());
  }

  public function testParseTuple4() {
    Assert.same(Right(Tuple4.of("a", 1, true, 0.1)), thx.fp.Dynamics.parseTuple4({ _0: "a", _1: 1, _2: true, _3: 0.1}, parseString, parseInt, parseBool, parseFloat, identity));
    Assert.isTrue(thx.fp.Dynamics.parseTuple4({}, parseString, parseInt, parseBool, parseFloat, identity).either.isLeft());
  }

  public function testParseTuple5() {
    Assert.same(Right(Tuple5.of("a", 1, true, 0.1, "B")), thx.fp.Dynamics.parseTuple5({ _0: "a", _1: 1, _2: true, _3: 0.1, _4: "B"}, parseString, parseInt, parseBool, parseFloat, parseString, identity));
    Assert.isTrue(thx.fp.Dynamics.parseTuple5({}, parseString, parseInt, parseBool, parseFloat, parseString, identity).either.isLeft());
  }

  public function testParseTuple6() {
    Assert.same(Right(Tuple6.of("a", 1, true, 0.1, "B", -1)), thx.fp.Dynamics.parseTuple6({ _0: "a", _1: 1, _2: true, _3: 0.1, _4: "B", _5: -1}, parseString, parseInt, parseBool, parseFloat, parseString, parseInt, identity));
    Assert.isTrue(thx.fp.Dynamics.parseTuple6({}, parseString, parseInt, parseBool, parseFloat, parseString, parseInt, identity).either.isLeft());
  }
}
