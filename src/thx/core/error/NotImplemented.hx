package thx.core.error;

import haxe.PosInfos;

class NotImplemented extends thx.core.Error {
  public function new(?posInfo : PosInfos)
    super('method ${posInfo.className}.${posInfo.methodName}() needs to be implemented', posInfo);
}