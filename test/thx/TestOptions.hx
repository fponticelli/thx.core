package thx;

import utest.Assert;
import thx.Tuple;
using thx.Functions;
using thx.Floats;
import thx.Options.*;

import haxe.ds.Option;

class TestOptions {
  public function new() { }

  public function testHaxeCompilerError() {
    Assert.same(Some(new Tuple2("a", "b")), ap2(Tuple2.new, Some("a"), Some("b")));

  }
}

