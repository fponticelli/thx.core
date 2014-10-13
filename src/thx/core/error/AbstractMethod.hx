package thx.core.error;

import haxe.PosInfos;

class AbstractMethod extends thx.core.Error {
  public function new(?posInfo : PosInfos)
    super('method ${posInfo.className}.${posInfo.methodName}() is abstract', posInfo);
}