package thx.error;

import haxe.PosInfos;

class AssertError extends thx.Error {
  public function new(?msg : String, ?pos : haxe.PosInfos) {
    if (null == msg)
      msg = "expected true";
    super(msg, pos);
  }
}
