package thx;

using thx.Effects;
import utest.Assert;

class TestEffects {
  public function new() {}

  var logged : Dynamic;
  var oldLogger : Dynamic -> haxe.PosInfos -> Void;
  function logger(msg : Dynamic, ?infos : haxe.PosInfos) {
    logged = msg;
  }

  public function setup() {
    logged = null;
    oldLogger = Effects.logger;
    Effects.logger = logger;
  }

  public function teardown() {
    Effects.logger = oldLogger;
  }

  public function testEffectsLog() {
    Assert.isNull(logged);
    var value = 2;
    var out = value.log();
    Assert.equals(2, out);
    Assert.equals(2, logged);
  }
}
