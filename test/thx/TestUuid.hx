package thx;

import haxe.PosInfos;
import utest.Assert;

class TestUuid {
  public function new() { }

  public function testValidate() {
    for(i in 1...1000) {
      var uuid = Uuid.create();
      Assert.isTrue(Uuid.isValid(uuid));
    }

    Assert.isFalse(Uuid.isValid("some-value"));
    Assert.isFalse(Uuid.isValid("-6B909ADC-D628-411A-8894-16CFDD296073"));
    Assert.isFalse(Uuid.isValid("6B909ADC-D628-411A-8894-16CFDD296073-"));
    Assert.isFalse(Uuid.isValid("A6B909ADC-D628-411A-8894-16CFDD296073"));
    Assert.isFalse(Uuid.isValid("6B909ADC-D628-411A-8894-16CFDD2960732"));
    Assert.isFalse(Uuid.isValid("AAAAAAAA-0000-3333-8888-1111111111111"));
    Assert.isFalse(Uuid.isValid("AAAAAAAA-0000-4333-1888-1111111111111"));
  }
}
