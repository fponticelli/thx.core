package thx.error;

import haxe.PosInfos;
import haxe.CallStack;

class ErrorWrapper extends thx.Error {
  public var innerError : Dynamic;
  public function new(message : String, innerError : Dynamic, ?stack : Array<StackItem>, ?pos : PosInfos) {
    super(message, stack, pos);

    this.innerError = innerError;
  }
}
